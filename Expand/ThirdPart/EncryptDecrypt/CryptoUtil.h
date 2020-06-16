//
//  CryptoUtil.h
//  AirTouch
//
//  Created by Devin on 1/16/15.
//  Copyright (c) 2015 Honeywell. All rights reserved.
//

/**EncryptString(@"devin"));  DecryptString( base64 );
 *
 */


#import <Foundation/Foundation.h>

#define EncryptString( text )          [CryptoUtil tripleDESEncryptString:text]

#define DecryptString( base64 )        [CryptoUtil tripleDESDecryptString:base64]

@interface CryptoUtil : NSObject

/**
 *  将普通文本3DES加密
 *
 *  @param inputString 要加密的文本
 *
 *  @return 加密后的文本
 */
+ (NSString *)tripleDESEncryptString:(NSString *)inputString;

/**
 *  将3DES加密文本解密
 *  @param  inputString 加密后的文本
 *
 *  @return 解密后的文本
 */
+ (NSString *)tripleDESDecryptString:(NSString *)inputString;

/**
 *  BCrypt Encrypt String
 *  pass = "98128712"
 *  salt = "$2a$10$d1Vv38u2ohMs9JLFYZhw1e";
 *
 *  @param  inputString 密码
 *  @param  salt 盐
 *
 *  @return 加密后的Hash值
 */
+ (NSString *)bcryptEncryptString:(NSString *)inputString salt:(NSString *)salt;

/**
 *  BCrypt Validate String
 *  pass = "98128712"
 *  hash = "$2a$10$d1Vv38u2ohMs9JLFYZhw1enpX.dl2.XvKl72ms.sHwDS11PFwKJQu"
 *
 *  @param  inputString 密码
 *  @param  hash 加密后的Hash值
 *
 *  @return 通过或失败
 */
+ (BOOL)bcryptValidatePassword:(NSString *)inputString hash:(NSString *)hash;

+ (uint32_t)randomInt;

@end
