//
//  ValidateUtil.h
//  AirTouch
//
//  Created by Eric Qin on 1/23/15.
//  Copyright (c) 2015 Honeywell. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSUInteger kMaxPlaceLength = 14;
static NSUInteger kMinPwdLength = 6;
static NSUInteger kMaxPwdLength = 30;
static NSUInteger kVerifyCodeLength = 6;

#define NICKNAME_MAX_LENGTH 80

@interface ValidateUtil : NSObject

+(BOOL)validateEmail:(NSString *) email;
//验证可选填的Email
+(BOOL)validateOptionalEmail:(NSString *) email;
+(BOOL)validatePassword:(NSString *) password;
+(BOOL)validateNewPassword:(NSString *) password;
//kenny add
+(BOOL)validateMobileNumber:(NSString *)mobileNumber byTelephoneCountryCode:(NSString *)telephoneCountryCode;
+(BOOL)validatePIN:(NSString *)pin;
+(BOOL)validateNickName:(NSString *)nickName;
+(BOOL)validateAsciiCode:(NSString *)ascii;
+(BOOL)validateHomeName:(NSString *)name;
+(BOOL)validateDeviceName:(NSString *)name;


+(long)validateStringLength:(NSString*)string;
+(BOOL)validateJustChineseCharacterNumberSpace:(NSString *)string;
+(BOOL)validateStringContainSpecialCharacter:(NSString *)string specialCharacter:(NSCharacterSet *)characterSet;
//+(BOOL)validateNoSpecialCharacter:(NSString *)place;
+(BOOL)validateAlphabet:(NSString *)string;
+(BOOL)validateNumber:(NSString *)string;
+(BOOL)validateAlphabetAndNumber:(NSString *)string;
+(BOOL)validateStringContainsEmoji:(NSString *)string;
@end
