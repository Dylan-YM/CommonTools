//
//  HWAPEncryptManager.m
//  APDemo
//
//  Created by Honeywell on 2017/6/15.
//  Copyright © 2017年 Honeywell. All rights reserved.
//

#import "HWAPEncryptManager.h"
#import <CommonCrypto/CommonDigest.h>

@implementation HWAPEncryptManager

+ (NSData *)getEncryptRandom:(NSData *)randomData macId:(NSString *)macId {
    NSData *macIdData = [macId dataUsingEncoding:NSUTF8StringEncoding];
    Byte *macIdByte = (Byte *)[macIdData bytes];
    Byte *randomByte = (Byte *)[randomData bytes];
    NSInteger resultByteLength = [randomData length] + [macIdData length];
    Byte resultByte[resultByteLength];
    for (NSInteger i = 0; i < 16; i++) {
        resultByte[i] = randomByte[i];
    }
    for (NSInteger i = 16; i < (16+macIdData.length); i++) {
        resultByte[i] = macIdByte[i-16];
    }
    for (NSInteger i = 16+macIdData.length; i < resultByteLength; i++) {
        resultByte[i] = randomByte[i-macIdData.length];
    }
    NSData *resultData = [NSData dataWithBytes:resultByte length:sizeof(resultByte)];
    NSData *shaResultData = [self getSha256String:resultData];
    
    return shaResultData;
}

+ (NSData *)getEncryptSSID:(NSString *)ssid password:(NSString *)password {
    NSDictionary *infoDict = [NSDictionary dictionaryWithObjectsAndKeys:ssid?:@"",@"ssid",password?:@"",@"password", nil];
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:infoDict
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    if (!jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    return jsonData;
}

+ (NSData *)getSha256String:(NSData *)data {
    
    uint8_t digest[CC_SHA256_DIGEST_LENGTH];
    
    CC_SHA256(data.bytes, (CC_LONG)data.length, digest);
    
    NSMutableString* result = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA256_DIGEST_LENGTH; i++) {
        [result appendFormat:@"%02x", digest[i]];
    }
    
    NSData *resultData = [NSData dataWithBytes:(const void *)digest length:CC_SHA256_DIGEST_LENGTH];
    
    return resultData;
}

@end
