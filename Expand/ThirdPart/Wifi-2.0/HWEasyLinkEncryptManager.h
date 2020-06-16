//
//  ABS128CBC.h
//  MICO
//
//  Created by Honeywell on 2017/4/11.
//  Copyright © 2017年 MXCHIP Co;Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HWEasyLinkEncryptManager : NSObject

@property (nonatomic, strong) NSString *randString; //16位随机数
@property (nonatomic, strong) NSData *ivData;
@property (nonatomic, strong) NSData *randKey;
@property (nonatomic, strong) NSData *ssidKey;
@property (nonatomic, strong) NSString *macId;

- (void)reset;

- (NSData *)randStringEncryptWithSSid:(NSString *)ssidString password:(NSString *)password;

- (NSData *)SSIDInfoEncrypt:(NSString *)info;

- (NSString *)randStringDecrypt:(NSData *)data;

- (NSString *)SSIDInfoDecrypt:(NSData *)info;

- (NSData *)hmac:(NSData *)plainData withKey:(NSData *)keyData;

@end
