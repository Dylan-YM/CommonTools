//
//  AES128.h
//  Utils
//
//  Created by WanquanJi on 26/04/2017.
//  Copyright © 2017 Honeywell. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AES128 : NSObject

+ (NSData *)AES128Encrypt:(NSData *)plainData withKey:(NSData *)aesKey;

+ (NSData *)AES128Decrypt:(NSData *)encrypData withKey:(NSData *)aesKey;
@end
