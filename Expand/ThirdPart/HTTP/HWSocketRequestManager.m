//
//  HWSocketRequestManager.m
//  HTTPClient
//
//  Created by Honeywell on 2017/1/4.
//  Copyright © 2017年 Honeywell. All rights reserved.
//

#import "HWSocketRequestManager.h"
#import "GCDAsyncSocket.h"
#import "TimerUtil.h"

#define kPORT 80
#define kUSERAGENT @"HPlus 1.0"
#define kWriteTag 888
#define kReadTag 999
#define kTimerName @"SocketRequestTimerName"

/**
 Returns a percent-escaped string following RFC 3986 for a query string key or value.
 RFC 3986 states that the following characters are "reserved" characters.
 - General Delimiters: ":", "#", "[", "]", "@", "?", "/"
 - Sub-Delimiters: "!", "$", "&", "'", "(", ")", "*", "+", ",", ";", "="
 
 In RFC 3986 - Section 3.4, it states that the "?" and "/" characters should not be escaped to allow
 query strings to include a URL. Therefore, all "reserved" characters with the exception of "?" and "/"
 should be percent-escaped in the query string.
 - parameter string: The string to be percent-escaped.
 - returns: The percent-escaped string.
 */
NSString * HWPercentEscapedStringFromString(NSString *string) {
    static NSString * const kAFCharactersGeneralDelimitersToEncode = @":#[]@"; // does not include "?" or "/" due to RFC 3986 - Section 3.4
    static NSString * const kAFCharactersSubDelimitersToEncode = @"!$&'()*+,;=";
    
    NSMutableCharacterSet * allowedCharacterSet = [[NSCharacterSet URLQueryAllowedCharacterSet] mutableCopy];
    [allowedCharacterSet removeCharactersInString:[kAFCharactersGeneralDelimitersToEncode stringByAppendingString:kAFCharactersSubDelimitersToEncode]];
    
    // FIXME: https://github.com/AFNetworking/AFNetworking/pull/3028
    // return [string stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacterSet];
    
    static NSUInteger const batchSize = 50;
    
    NSUInteger index = 0;
    NSMutableString *escaped = @"".mutableCopy;
    
    while (index < string.length) {
        NSUInteger length = MIN(string.length - index, batchSize);
        NSRange range = NSMakeRange(index, length);
        
        // To avoid breaking up character sequences such as 👴🏻👮🏽
        range = [string rangeOfComposedCharacterSequencesForRange:range];
        
        NSString *substring = [string substringWithRange:range];
        NSString *encoded = [substring stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacterSet];
        [escaped appendString:encoded];
        
        index += range.length;
    }
    
    return escaped;
}

@interface HWSocketRequestManager ()

@property (nonatomic, strong) HWAPICallBack callBack;
@property (nonatomic, strong) NSString *host;
@property (nonatomic, strong) NSString *path;
@property (nonatomic, assign) RequestType requestType;
@property (nonatomic, strong) id param;
@property (nonatomic, strong) GCDAsyncSocket *asyncSocket;
@property (nonatomic, strong) NSMutableDictionary *dataDict;
@property (nonatomic, assign) HWRequestSerializer requestSerializer;

@end

@implementation HWSocketRequestManager
@synthesize timeout = _timeout;

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.timeout = 15;
    }
    return self;
}

- (void)sendRequestWithUrl:(NSString *)url params:(id)requestParams headerDict:(NSDictionary *)headerDict method:(RequestType)requestType requestSerializer:(HWRequestSerializer)requestSerializer useCert:(BOOL)useCert callBack:(HWAPICallBack)callBack {
    [self reset];
    
    self.callBack = callBack;
    self.requestType = requestType;
    self.param = requestParams;
    
    NSString *host = nil, *path = nil;
    NSNumber *port = @kPORT;
    [self parseUrl:url host:&host port:&port path:&path];
    self.host = host;
    self.path = path;
    self.requestSerializer = requestSerializer;
    
    self.dataDict = [NSMutableDictionary dictionary];
    
    [TimerUtil scheduledDispatchTimerWithName:kTimerName timeInterval:self.timeout repeats:NO action:^{
        [self requestTimeout];
    }];
    
    self.asyncSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    if (![self.asyncSocket connectToHost:self.host onPort:[port integerValue] withTimeout:self.timeout error:nil]) {
        [self callBackWithCode:NSURLErrorCannotConnectToHost object:nil success:NO];
    }
}

#pragma mark - get url param
- (void)parseUrl:(NSString *)url host:(NSString **)host port:(NSNumber **)port path:(NSString **)path {
    NSURL *u = [NSURL URLWithString:url];
    if (host) {
        *host = u.host;
    }
    if (u.port && port) {
        *port = u.port;
    }
    if (path) {
        NSString *pathString = u.path;
        NSString *parameterString = u.parameterString;
        NSString *queryString = u.query;
        NSMutableString *pathMutableString = [NSMutableString string];
        if (pathString) {
            [pathMutableString appendString:pathString];
        }
        if (parameterString) {
            [pathMutableString appendString:@";"];
            [pathMutableString appendString:parameterString];
        }
        if (queryString) {
            [pathMutableString appendString:@"?"];
            [pathMutableString appendString:queryString];
        }
        *path = pathMutableString;
    }
}

#pragma mark - call back
- (void)callBackWithCode:(NSInteger)errorCode object:(id)object success:(BOOL)success {
    if (self.callBack) {
        if (success) {
            self.callBack(object, nil);
        } else {
            NSError *error = [NSError errorWithDomain:@"" code:errorCode userInfo:nil];
            self.callBack(nil, error);
        }
    }
    [self reset];
}

- (void)requestTimeout {
    [self callBackWithCode:NSURLErrorTimedOut object:nil success:NO];
}

- (void)cancel {
    [self reset];
}

- (void)reset {
    self.callBack = nil;
    
    self.asyncSocket.delegate = nil;
    [self.asyncSocket disconnect];
    self.asyncSocket = nil;
    self.path = nil;
    self.param = nil;
    self.host = nil;
    self.dataDict = nil;
    [TimerUtil cancelTimerWithName:kTimerName];
}

#pragma mark - delegate
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port {
    NSString *requestStr = [self getRequestStringWithType:self.requestType serializer:self.requestSerializer path:self.path host:host params:self.param];
    NSData *requestData = [requestStr dataUsingEncoding:NSUTF8StringEncoding];
    
    [sock writeData:requestData withTimeout:self.timeout tag:kWriteTag];
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
    if (tag >= kReadTag) {
        [self.dataDict setObject:data forKey:@(tag)];
        [sock readDataWithTimeout:self.timeout tag:++tag];
    }
}

- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag {
    if (tag == kWriteTag) {
        [sock readDataWithTimeout:self.timeout tag:kReadTag];
    }
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err {
    if ([[self.dataDict allKeys] count] > 0) {
        NSData *resultData = [self resultDataWithDict:self.dataDict];
        NSString *result = [[NSString alloc] initWithData:resultData encoding:NSUTF8StringEncoding];
        NSArray *separatedArray = [result componentsSeparatedByString:@" "];
        NSInteger resultCode = 0;
        if (separatedArray.count > 1) {
            resultCode = [separatedArray[1] integerValue];
        }
        
        resultCode = (resultCode == 0) ? NSURLErrorTimedOut : resultCode;
        
        NSArray *separatedResultArray = [result componentsSeparatedByString:@"\r\n\r\n"];
        if (separatedResultArray.count > 1) {
            result = separatedResultArray[1];
        }
        BOOL success = (resultCode >= 200 && resultCode < 300);
        [self callBackWithCode:resultCode object:[result dataUsingEncoding:NSUTF8StringEncoding] success:success];
    } else {
        [self callBackWithCode:NSURLErrorNetworkConnectionLost object:nil success:NO];
    }
}

#pragma mark - tool
- (NSData *)resultDataWithDict:(NSDictionary *)dict {
    NSArray *allKeys = [dict allKeys];
    allKeys = [allKeys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSInteger tag1 = [obj1 integerValue];
        NSInteger tag2 = [obj2 integerValue];
        if (tag1 > tag2) {
            return NSOrderedDescending;
        }
        else if (tag1 < tag2){
            return NSOrderedAscending;
        }
        else {
            return NSOrderedSame;
        }
    }];
    
    NSMutableData *data = [NSMutableData data];
    for (NSInteger i = 0; i < allKeys.count; i++) {
        [data appendData:[dict objectForKey:allKeys[i]]];
    }
    return data;
}

- (NSString *)parseJsonBodyWithData:(id)data {
    NSString *body = @"";
    if ([data isKindOfClass:[NSDictionary class]]
        || [data isKindOfClass:[NSArray class]]) {
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data options:NSJSONWritingPrettyPrinted error:nil];
        body = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    } else if ([data isKindOfClass:[NSString class]]) {
        body = data;
    }
    return body;
}

- (NSString *)parseFormPathWithPath:(NSString *)path data:(id)data {
    NSMutableString *query = [NSMutableString stringWithString:path];
    if (data && [data isKindOfClass:[NSDictionary class]]) {
        NSArray *keys = [data allKeys];
        if (keys.count > 0) {
            for (NSInteger i = 0; i < keys.count; i++) {
                if ([query containsString:@"?"]) {
                    [query appendString:@"&"];
                } else {
                    [query appendString:@"?"];
                }
                [query appendString:[self URLEncodedStringKey:keys[i] value:[data objectForKey:keys[i]]]];
            }
        }
    }
    return query;
}

- (void)handlePath:(NSString **)path body:(NSString **)body params:(id)params requestType:(RequestType)type serializer:(HWRequestSerializer)serializer {
    switch (type) {
        case RequestType_Get:
            if (path) {
                *path = [self parseFormPathWithPath:*path data:params];
            }
            break;
        case RequestType_Put:
        case RequestType_Post:
        case RequestType_Delete:
        {
            if ([params isKindOfClass:[NSDictionary class]]) {
                switch (serializer) {
                    case HWRequestSerializer_Json:
                        if (body) {
                            *body = [self parseJsonBodyWithData:params];
                        }
                        break;
                    case HWRequestSerializer_Form:
                        if (path) {
                            *path = [self parseFormPathWithPath:*path data:params];
                        }
                        break;
                    default:
                        break;
                }
            } else {
                if (body) {
                    *body = [self parseJsonBodyWithData:params];
                }
            }
        }
            break;
        default:
            break;
    }
}

- (NSString *)getRequestStringWithType:(RequestType)type serializer:(HWRequestSerializer)serializer path:(NSString *)path host:(NSString *)host params:(id)params {
    NSString *body = @"";
    [self handlePath:&path body:&body params:params requestType:type serializer:serializer];
    NSString *methodString = @"";
    NSString *contentType = @"";
    NSString *contentLength = [NSString stringWithFormat:@"%lu",(unsigned long)body.length];
    NSArray *requestConfig = nil;
    switch (serializer) {
        case HWRequestSerializer_Json:
            contentType = @"application/json";
            break;
        case HWRequestSerializer_Form:
            contentType = @"application/x-www-form-urlencoded";
            break;
        default:
            break;
    }
    switch (type) {
        case RequestType_Get:
        {
            methodString = @"GET";
            requestConfig = @[@{@"Host":host},
                              @{@"User-Agent":kUSERAGENT}];
        }
            break;
        case RequestType_Put:
        {
            methodString = @"PUT";
            requestConfig = @[@{@"Host":host},
                              @{@"Content-Type":contentType},
                              @{@"Content-Length":contentLength},
                              @{@"User-Agent":kUSERAGENT}];
        }
            break;
        case RequestType_Post:
        {
            methodString = @"POST";
            requestConfig = @[@{@"Host":host},
                              @{@"Content-Type":contentType},
                              @{@"Content-Length":contentLength},
                              @{@"User-Agent":kUSERAGENT}];
        }
            break;
        case RequestType_Delete:
        {
            methodString = @"DELETE";
            requestConfig = @[@{@"Host":host},
                              @{@"Content-Length":contentLength},
                              @{@"User-Agent":kUSERAGENT}];
        }
            break;
            
        default:
            break;
    }
    
    //build request string
    NSMutableString *requestString = [NSMutableString string];
    //build request string
    [requestString appendString:methodString];
    [requestString appendString:@" "];
    if (![self.path hasPrefix:@"/"]) {
        [requestString appendString:@"/"];
    }
    [requestString appendString:self.path];
    [requestString appendString:@" "];
    [requestString appendString:@"HTTP/1.0"];
    
    for (NSInteger i = 0; i < requestConfig.count; i++) {
        NSDictionary *config = [requestConfig objectAtIndex:i];
        NSString *key = [[config allKeys] firstObject];
        NSString *value = [config objectForKey:key];
        [requestString appendFormat:@"\r\n%@: %@",key,value];
    }
    [requestString appendFormat:@"\r\n\r\n%@",body];
    return requestString;
}

- (NSString *)URLEncodedStringKey:(NSString *)key value:(NSString *)value {
    if (!value || [value isEqual:[NSNull null]]) {
        return HWPercentEscapedStringFromString([key description]);
    } else {
        return [NSString stringWithFormat:@"%@=%@", HWPercentEscapedStringFromString([key description]), HWPercentEscapedStringFromString([value description])];
    }
}

@end
