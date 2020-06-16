//
//  AP20Manager.m
//  HomePlatform
//
//  Created by Honeywell on 13/03/2018.
//  Copyright © 2018 Honeywell. All rights reserved.
//

#import "AP20Manager.h"
#import "GCDAsyncSocket.h"
#import "TimerUtil.h"
#import "NetworkUtil.h"
#import "HWAPEncryptManager.h"
#import "AppConfig.h"
#import "AppMarco.h"
#import "LogUtil.h"

#define kTCPHeaderString @"\r\n\r\n"

#define kConnectToServerTimeout 15
#define kCommandTimeout 30

@interface AP20Manager () {
    NSInteger commandTimeout;
    NSInteger connectTimeout;
}

@property (nonatomic, strong) NSString *ipAddress;
@property (nonatomic, assign) NSInteger port;

@property (nonatomic, strong) GCDAsyncSocket *asyncSocket;
@property (assign, nonatomic) BOOL challenge;
@property (strong, nonatomic) NSMutableData *bufferData;
@property (strong, nonatomic) NSString *currentSSID;
@property (strong, nonatomic) HWAPICallBack callback;
@property (strong, nonatomic) HWAPICallBack connectServerCallback;

@property (strong, nonatomic) NSMutableArray *wifiList;

@end

@implementation AP20Manager

- (instancetype)init
{
    self = [super init];
    if (self) {
        _asyncSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
        _wifiList = [NSMutableArray array];
    }
    return self;
}

- (void)dealloc {
    [self resetStatus];
}

- (void)resetStatus {
    [self disconnect];
    self.challenge = NO;
    if (self.callback) {
        self.callback(nil, [NSError errorWithDomain:@"resest status" code:0 userInfo:nil]);
        self.callback = nil;
    }
    if (self.connectServerCallback) {
        self.connectServerCallback(nil, [NSError errorWithDomain:@"resest status" code:0 userInfo:nil]);
        self.connectServerCallback = nil;
    }
}

- (void)connectAPServerWithIpAddress:(NSString *)ipAddress port:(NSInteger)port callback:(HWAPICallBack)callback {
    [self resetStatus];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [LogUtil Debug:@"AP20" message:[NSString stringWithFormat:@"Connect to ip: %@, port: %ld", ipAddress, (long)port]];
        self.currentSSID = [NetworkUtil currentWifiSSID];
        self.connectServerCallback = callback;
        connectTimeout = 0;
        self.ipAddress = ipAddress;
        self.port = port;
        
        [TimerUtil scheduledDispatchTimerWithName:@"APConnectTimeOutUtil" timeInterval:1 repeats:YES action:^{
            connectTimeout++;
            if (connectTimeout >= kConnectToServerTimeout) {
                [LogUtil Debug:@"AP20" message:[NSString stringWithFormat:@"Connection Timeout"]];
                connectTimeout = 0;
                if (self.connectServerCallback) {
                    self.connectServerCallback(nil, [NSError errorWithDomain:@"ATWapiErrorDomain" code:10200 userInfo:@{ NSLocalizedDescriptionKey : @"Connect Timeout" }]);
                    self.connectServerCallback = nil;
                }
                [TimerUtil cancelTimerWithName:@"APConnectTimeOutUtil"];
            }
        }];
        
        [self connectWithHost:ipAddress port:port];
    });
}

- (void)sendCommond:(NSDictionary *)command callBack:(HWAPICallBack)callBack {
    [LogUtil Debug:@"AP20" message:[NSString stringWithFormat:@"Send Command: %@", command]];
    if (![self isconnect] || !self.challenge) {
        if (callBack) {
            callBack(nil,[NSError errorWithDomain:@"ATWapiErrorDomain" code:10200 userInfo:@{ NSLocalizedDescriptionKey : @"Can't connect to server" }]);
        }
        [LogUtil Debug:@"AP20" message:[NSString stringWithFormat:@"Send Command With Connection Lost: %@, connection: %d, challenge: %d", command, [self isconnect], [self challenge]]];
        return;
    }
    [TimerUtil scheduledDispatchTimerWithName:@"APCommandTimeOutUtil" timeInterval:1 repeats:YES action:^{
        commandTimeout++;
        if (commandTimeout >= kCommandTimeout) {
            [LogUtil Debug:@"AP20" message:[NSString stringWithFormat:@"Command Timeout"]];
            commandTimeout = 0;
            if (self.callback) {
                self.callback(nil, [NSError errorWithDomain:@"ATWapiErrorDomain" code:10200 userInfo:@{ NSLocalizedDescriptionKey : @"Command Timeout" }]);
                self.callback = nil;
            }
            [TimerUtil cancelTimerWithName:@"APCommandTimeOutUtil"];
        }
    }];
    
    self.callback = callBack;
    NSData *data = [self toJSONData:command];
    NSData *writeData = [self addHeaderWithData:data];
    [self.asyncSocket writeData:writeData withTimeout:-1 tag:0];
}

//设置主机服务器和端口号，连接
- (BOOL)connectWithHost:(NSString *)host port:(NSInteger)port
{
    [LogUtil Debug:@"AP20" message:[NSString stringWithFormat:@"Connect to host: %@, port: %ld", host, (long)port]];
    return [self.asyncSocket connectToHost:host onPort:port withTimeout:kConnectToServerTimeout error:nil];
    
}

//重连
- (void)reconnectToServer {
    [LogUtil Debug:@"AP20" message:[NSString stringWithFormat:@"Reconnect"]];
    BOOL reconnect = (self.type == AP20TypeCubeC || (self.type == AP20TypeNormal && [self.currentSSID isEqualToString:[NetworkUtil currentWifiSSID]]));
    if (reconnect) {
        [self connectWithHost:self.ipAddress port:self.port];
    }
}

// 断开连接
- (void)disconnect {
    [LogUtil Debug:@"AP20" message:[NSString stringWithFormat:@"Disconnect"]];
    [_asyncSocket disconnect];
}

/** 连接状态*/
- (BOOL)isconnect {
    
    return [_asyncSocket isConnected];
    
}

#pragma mark - GSD代理

//socket断开连接会调用该函数
- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
    [LogUtil Debug:@"AP20" message:[NSString stringWithFormat:@"Socket Did Disconnect"]];
    self.challenge = NO;
    if (self.callback) {
        self.callback(nil, [NSError errorWithDomain:@"socketDidDisconnect" code:0 userInfo:nil]);
        self.callback = nil;
    }
    if (self.connectServerCallback) {
        self.connectServerCallback(nil, [NSError errorWithDomain:@"socketDidDisconnect" code:0 userInfo:nil]);
        self.connectServerCallback = nil;
    }
    if (err && err.code != 7) { //"Socket closed by remote peer"
//        [self reconnectToServer];
    }
}

- (void)socket:(GCDAsyncSocket *)sock didReceiveTrust:(SecTrustRef)trust completionHandler:(void (^)(BOOL))completionHandler {
    [LogUtil Debug:@"AP20" message:[NSString stringWithFormat:@"Socket Did Receive Trust"]];
    NSMutableArray *policies = [NSMutableArray array];
    // BasicX509 不验证域名是否相同（我们用的IP）
    SecPolicyRef policy = SecPolicyCreateBasicX509();
    [policies addObject:(__bridge_transfer id)policy];
    
    CFIndex certificateCount = SecTrustGetCertificateCount(trust);
    NSMutableString *commonNameList = [NSMutableString string];
    for (CFIndex i = 0; i < certificateCount; i++) {
        SecCertificateRef certificate = SecTrustGetCertificateAtIndex(trust, i);
        
        CFStringRef test = SecCertificateCopySubjectSummary(certificate);
        
        NSString *string = [NSString stringWithFormat:@"common: %@ \n",test];
        [commonNameList appendString:string];
    }
    
    SecTrustSetPolicies(trust, (__bridge CFArrayRef)policies);
    
    NSString *certName = @"wifi2.0-prod";
    
#ifdef DEBUG
    NSString *serverURL = [AppConfig getValueString:ServerLocaiton]?:BaseRequestUrl;
    NSInteger index = ServerTypeProduction+1;
    for (NSInteger i = ServerTypeQADevOps; i <= ServerTypeProduction; i++) {
        if ([serverURL isEqualToString:BaseHTTPRequestURL(i)]) {
            index = i;
            break;
        }
    }
    if (index != ServerTypeProduction) {
        certName = @"wifi2.0-qa";
    }
#endif
    
    
    [LogUtil Debug:@"AP20" message:[NSString stringWithFormat:@"Cert Name: %@", certName]];
    
    NSString *caCertPath = [[NSBundle mainBundle] pathForResource:certName ofType:@"cer"];
    NSData *caCertData = [NSData dataWithContentsOfFile:caCertPath];
    
    OSStatus status = -1;
    SecTrustResultType result = kSecTrustResultDeny;
    
    if(caCertData)
    {
        SecCertificateRef   cert1;
        cert1 = SecCertificateCreateWithData(NULL, (__bridge CFDataRef) caCertData);
        
        const void *ref[] = {cert1};
        CFArrayRef ary = CFArrayCreate(NULL, ref, 1, NULL);
        
        //注意：添加自己的证书作为可信列表
        SecTrustSetAnchorCertificates(trust, ary);
        
        //是否禁用系统可信列表
        SecTrustSetAnchorCertificatesOnly(trust, false);
        
        status = SecTrustEvaluate(trust, &result);
        
        [LogUtil Debug:@"AP20" message:[NSString stringWithFormat:@"Sec Trust Evaluate Status: %ld, Result: %ld", (long)status, (long)result]];
    }
    else
    {
        [LogUtil Debug:@"AP20" message:[NSString stringWithFormat:@"local certifacates could not be loaded"]];
        completionHandler(NO);
    }
    
    if ((status == noErr && (result == kSecTrustResultProceed || result == kSecTrustResultUnspecified)))
    {
        SecCertificateRef certRef = SecTrustGetCertificateAtIndex(trust, 0);
        CFStringRef commonNameRef = SecCertificateCopySubjectSummary(certRef);
        NSString *commonNameString = (__bridge NSString *)commonNameRef;
        
        [LogUtil Debug:@"AP20" message:[NSString stringWithFormat:@"Common Name: %@", commonNameString]];
        
        if ([commonNameString hasPrefix:@"device"]) {
            self.macID = [[commonNameString stringByReplacingOccurrencesOfString:@"device " withString:@""] lowercaseString];
        } else if ([commonNameString hasPrefix:@"wifi20"]) {
            self.macID = [[commonNameString stringByReplacingOccurrencesOfString:@"wifi20 " withString:@""] lowercaseString];
        } else if ([commonNameString hasPrefix:@"GLD"]) {
            self.macID = [[commonNameString stringByReplacingOccurrencesOfString:@"GLD " withString:@""] lowercaseString];
        }
        completionHandler(YES);
    }
    else
    {
        CFArrayRef arrayRefTrust = SecTrustCopyProperties(trust);
        
        [LogUtil Debug:@"AP20" message:[NSString stringWithFormat:@"error in connection occured\n%@", arrayRefTrust]];
        NSLog(@"error in connection occured\n%@", arrayRefTrust);
        
        completionHandler(NO);
    }
}

- (void)socketDidSecure:(GCDAsyncSocket *)sock {
    [LogUtil Debug:@"AP20" message:[NSString stringWithFormat:@"Socket Did Secure with type: %ld", (long)self.type]];
    if (self.type == AP20TypeCubeC) {
        self.challenge = YES;
        if (self.connectServerCallback) {
            self.connectServerCallback(nil, nil);
            self.connectServerCallback = nil;
        }
    } else {
        [sock readDataWithTimeout:-1 tag:0];
    }
}

//socket连接到主机会调用该函数
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
    [LogUtil Debug:@"AP20" message:[NSString stringWithFormat:@"Socket Did Connect to Host: %@, Port: %ld", host, (long)port]];
    // Configure SSL/TLS settings
    
    NSMutableDictionary *settings = [NSMutableDictionary dictionary];
    // 允许自签名证书
    [settings setObject:[NSNumber numberWithBool:YES] forKey:GCDAsyncSocketManuallyEvaluateTrust];
    [sock startTLS:settings];
}

//socket连接后收到数据
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    //    NSString *string = [self hexadecimalString:data];
    
    [self handleData:data];
    
    [sock readDataWithTimeout:-1 tag:0];
}

//socket写入数据
- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    [LogUtil Debug:@"AP20" message:[NSString stringWithFormat:@"Did Write Data"]];
    [sock readDataWithTimeout:-1 tag:tag];
}

- (void)handleData:(NSData *)data {
    [LogUtil Debug:@"AP20" message:[NSString stringWithFormat:@"Did Read Data: %@", data]];
    NSData *headerData = [kTCPHeaderString dataUsingEncoding:NSUTF8StringEncoding];
    NSRange headerRange = NSMakeRange(0, 4);
    NSRange lengthRange = NSMakeRange(4, 2);
    
    [self.bufferData appendData:data];
    NSInteger length = 6;
    while (self.bufferData.length > length) {
        if ([[self.bufferData subdataWithRange:headerRange] isEqualToData:headerData]) {
            NSData *lengthData = [self.bufferData subdataWithRange:lengthRange];
            NSInteger length = [self dataToLong:lengthData];
            if (length == self.bufferData.length-6) {
                NSData *contentData = [self.bufferData subdataWithRange:NSMakeRange(6, length)];
                [self handleContentData:contentData];
                [self.bufferData replaceBytesInRange:NSMakeRange(0, self.bufferData.length) withBytes:NULL length:0];
                break;
            } else if (length < self.bufferData.length-6) {
                NSData *contentData = [self.bufferData subdataWithRange:NSMakeRange(6, length)];
                [self handleContentData:contentData];
                [self.bufferData replaceBytesInRange:NSMakeRange(0, 6+length) withBytes:NULL length:0];
            } else {
                break;
            }
        } else {
            [self.bufferData replaceBytesInRange:NSMakeRange(0, self.bufferData.length) withBytes:NULL length:0];
            break;
        }
    }
}

- (void)handleContentData:(NSData *)data {
    NSDictionary *dict = [self jsonToArrayOrNSDictionary:data];
    if (!dict) {
        return;
    }
    [LogUtil Debug:@"AP20" message:[NSString stringWithFormat:@"Did Analyze Data: %@", dict]];
    if ([dict objectForKey:@"msgType"] && [dict[@"msgType"] isEqualToString:@"challenge"]) {
        NSString *ranString = [dict objectForKey:@"data"];
        NSString *deviceToken = @"";
        if (ranString.length >= 32) {
            deviceToken = [ranString substringWithRange:NSMakeRange(0, 32)];
        }
        self.deviceToken = deviceToken;
        NSData *ranData = [self hexStringToData:ranString];
        if (ranData) {
            NSData *verifyData = [HWAPEncryptManager getEncryptRandom:ranData macId:self.macID];
            NSString *verifyString = [self hexadecimalString:verifyData];
            NSData *writeData = [self toJSONData:@{@"msgType":@"response",@"data":verifyString}];
            [self.asyncSocket writeData:[self addHeaderWithData:writeData] withTimeout:-1 tag:0];
        }
    } else if ([[dict objectForKey:@"msgType"] isEqualToString:@"verify"]) {
        if ([[dict objectForKey:@"data"] isEqualToString:@"success"]) {
            self.challenge = YES;
            if (self.connectServerCallback) {
                self.connectServerCallback(nil, nil);
                self.connectServerCallback = nil;
            }
        }
    } else if ([[dict objectForKey:@"msgType"] isEqualToString:@"putssid"]) {
        NSDictionary *data = dict[@"data"];
        NSArray *list = data[@"list"];
        if ([[data objectForKey:@"part_group_num"] integerValue] == 1) {
            [self.wifiList removeAllObjects];
        }
        [self.wifiList addObjectsFromArray:list];
        if ([[data objectForKey:@"part_group_num"] integerValue] == [[data objectForKey:@"total_group_num"] integerValue]) {
            if (self.callback) {
                self.callback(self.wifiList, nil);
                self.callback = nil;
            }
        }
    } else {
        if (self.callback) {
            self.callback(dict, nil);
            self.callback = nil;
        }
    }
}

- (NSData *)addHeaderWithData:(NSData *)data {
    NSInteger length = data.length;
    NSData *lengthData = [self longToData:length type:2];
    NSData *header = [kTCPHeaderString dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableData *mutableData = [NSMutableData data];
    [mutableData appendData:header];
    [mutableData appendData:lengthData];
    [mutableData appendData:data];
    return mutableData;
}

- (NSString *)hexadecimalString:(NSData *)data
{
    /* Returns hexadecimal string of NSData. Empty string if data is empty.   */
    const unsigned char *dataBuffer = (const unsigned char *)[data bytes];
    if (!dataBuffer) {
        return [NSString string];
    }
    NSUInteger          dataLength  = [data length];
    NSMutableString     *hexString  = [NSMutableString stringWithCapacity:(dataLength * 2)];
    for (int i = 0; i < dataLength; ++i) {
        [hexString appendFormat:@"%02x", (unsigned int)dataBuffer[i]];
    }
    return [NSString stringWithString:hexString];
}

- (NSData *)hexStringToData:(NSString *)hexString{
    hexString = [hexString stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSMutableData *commandToSend= [[NSMutableData alloc] init];
    unsigned char whole_byte;
    char byte_chars[3] = {'\0','\0','\0'};
    int i;
    for (i=0; i < [hexString length]/2; i++) {
        byte_chars[0] = [hexString characterAtIndex:i*2];
        byte_chars[1] = [hexString characterAtIndex:i*2+1];
        whole_byte = strtol(byte_chars, NULL, 16);
        [commandToSend appendBytes:&whole_byte length:1];
    }
    return commandToSend;
}

// Long型转换成Data
- (NSData *)longToData:(long)input type:(int)type {
    Byte input_byte[type];
    if (type == 4) {
        long value = ntohl(input);
        memcpy(input_byte, &value, type);
    } else if (type == 2) {
        short value = input;
        value = ntohs(value);
        memcpy(input_byte, &value, type);
    }
    
    return [NSData dataWithBytes:input_byte length:type];
}

// Data型转换成Long
- (long)dataToLong:(NSData *)data {
    int type = (int)data.length;
    Byte input_byte[type];
    [data getBytes:input_byte length:type];
    if (type == 4) {
        long value;
        memcpy(&value, input_byte, type);
        value = ntohl(value);
        return value;
    } else if (type == 2) {
        short value;
        memcpy(&value, input_byte, type);
        value = ntohs(value);
        return value;
    }
    return 0;
}

// 将JSON串转化为字典或者数组
- (id)jsonToArrayOrNSDictionary:(NSData *)jsonData {
    NSError *error = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData
                                                    options:NSJSONReadingAllowFragments
                                                      error:&error];
    if (jsonObject != nil && error == nil) {
        return jsonObject;
    }else {
        // 解析错误
        return nil;
    }
}

// 将字典或者数组转化为JSON串
- (NSData *)toJSONData:(id)theData {
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:theData
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    if ([jsonData length] > 0 && error == nil) {
        return jsonData;
    } else{
        return nil;
    }
}

#pragma mark - Getter
- (NSMutableData *)bufferData {
    if (!_bufferData) {
        _bufferData = [[NSMutableData alloc] init];
    }
    return _bufferData;
}

@end
