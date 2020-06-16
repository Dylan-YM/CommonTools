//
//  SHA256.h
//  CommonPlatform
//
//  Created by Liu, Carl on 31/07/2017.
//  Copyright © 2017 Honeywell. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SHA256 : NSObject

// Sha256加密
+ (NSString *)hash:(NSString *)input;

+ (NSString *)hashData:(NSData *)data;

@end
