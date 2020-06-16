//
//  SHA256.m
//  CommonPlatform
//
//  Created by Liu, Carl on 31/07/2017.
//  Copyright © 2017 Honeywell. All rights reserved.
//

#import "SHA256.h"
#import <CommonCrypto/CommonDigest.h>

static NSString * hashBytes(const char* str) {
    unsigned char result[CC_SHA256_DIGEST_LENGTH];
    CC_SHA256(str, (CC_LONG)strlen(str), result);
    
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH*2];
    for(int i = 0; i<CC_SHA256_DIGEST_LENGTH; i++)
    {
        [ret appendFormat:@"%02x",result[i]];
    }
    return ret;
}

@implementation SHA256

// Sha256加密
+ (NSString *)hash:(NSString *)input
{
    const char* str = [input UTF8String];
    return hashBytes(str);
}

+ (NSString *)hashData:(NSData *)data {
    char bytes[data.length];
    [data getBytes:bytes range:NSMakeRange(0, data.length)];
    return hashBytes(bytes);
}

@end
