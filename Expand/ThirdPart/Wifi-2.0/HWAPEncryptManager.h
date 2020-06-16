//
//  HWAPEncryptManager.h
//  APDemo
//
//  Created by Honeywell on 2017/6/15.
//  Copyright © 2017年 Honeywell. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HWAPEncryptManager : NSObject

+ (NSData *)getEncryptRandom:(NSData *)randomData macId:(NSString *)macId;

+ (NSData *)getEncryptSSID:(NSString *)ssid password:(NSString *)password;

@end
