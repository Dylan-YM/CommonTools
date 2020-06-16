//
//  HWRequestManager.m
//  AirTouch
//
//  Created by Honeywell on 9/14/16.
//  Copyright © 2016 Honeywell. All rights reserved.
//

#import "AFHTTPManager.h"
#import "AFHTTPSessionManager.h"


@interface AFHTTPManager ()

@property (nonatomic, strong) NSURLSessionDataTask *task;

@end

@implementation AFHTTPManager
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
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    if (requestSerializer == HWRequestSerializer_Json || [requestParams isKindOfClass:[NSArray class]]) {
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
    }
    
    manager.requestSerializer.HTTPMethodsEncodingParametersInURI = [NSSet setWithArray:@[@"GET", @"HEAD"]];
    [manager.requestSerializer setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    
    if (useCert) {
        manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModePublicKey];
    } else {
        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        securityPolicy.allowInvalidCertificates = YES;
        securityPolicy.validatesDomainName = NO;
        manager.securityPolicy = securityPolicy;
    }
    if (headerDict!=nil) {
        for (NSString *tempKey in [headerDict allKeys]) {
            NSString *tempValue=[headerDict objectForKey:tempKey];
            [manager.requestSerializer setValue:tempValue forHTTPHeaderField:tempKey];
        }
    }
    
    [manager.requestSerializer setHTTPShouldHandleCookies:YES];
    
    //设置超时秒数
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = self.timeout;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    switch (requestType) {
        case RequestType_Get:
        {
            self.task = [manager GET:url parameters:requestParams progress:^(NSProgress * _Nonnull downloadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                callBack(responseObject, nil);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                callBack(nil, [self handleError:task error:error]);
            }];
        }
            break;
        case RequestType_Post:
        {
            self.task = [manager POST:url parameters:requestParams progress:^(NSProgress * _Nonnull uploadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                callBack(responseObject, nil);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                callBack(nil, [self handleError:task error:error]);
            }];
        }
            break;
        case RequestType_Put:
        {
            self.task = [manager PUT:url parameters:requestParams success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                callBack(responseObject, nil);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                callBack(nil, [self handleError:task error:error]);
            }];
        }
            break;
        case RequestType_Delete:
        {
            self.task = [manager DELETE:url parameters:requestParams success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                callBack(responseObject, nil);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                callBack(nil, [self handleError:task error:error]);
            }];
        }
            break;
        default:
            break;
    }
}

- (NSError *)handleError:(NSURLSessionDataTask *)task error:(NSError *)error {
    NSHTTPURLResponse *requestResponse = (NSHTTPURLResponse *)task.response;
    NSInteger statusCode = [requestResponse statusCode];
    if (statusCode == 0) {
        return error;
    } else {
        return [NSError errorWithDomain:error.domain code:statusCode userInfo:error.userInfo];
    }
}

- (void)cancel {
    [self.task cancel];
    self.task = nil;
}

@end
