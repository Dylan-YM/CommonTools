//
//  ValidateUtil.m
//  AirTouch
//
//  Created by Eric Qin on 1/23/15.
//  Copyright (c) 2015 Honeywell. All rights reserved.
//

#import "ValidateUtil.h"

@implementation ValidateUtil


+(BOOL)validateEmail:(NSString *) email
{
    NSString *emailRegExp = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegExp];
    return [emailPredicate evaluateWithObject:email];
}

+(BOOL)validateOptionalEmail:(NSString *) email {
    NSString * trimedEmail = [email stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (trimedEmail.length == 0) {//填写了空字符串，验证通过
        return YES;
    }
    BOOL validated = [self validateEmail:trimedEmail];
    return validated;
}

/**
 * password rule
 *  (old)
 *  1.at least one uppercase letter
 *  2.at least one lowercase letter
 *  3.at least one digit
 *  4.length 8-30
 *  (new)
 *  alphabet or letter 
 *  length between 6-30
 */
+(BOOL)validatePassword:(NSString *) password
{
    NSString *pwdRegExp = [NSString stringWithFormat:@"^[A-z0-9]{%lu,%lu}+$", (unsigned long)kMinPwdLength, (unsigned long)kMaxPwdLength];
    NSPredicate *pwdPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pwdRegExp];
    return [pwdPredicate evaluateWithObject:password];
}

/**
 * password rule
 *  (new)
 *  1.at least one uppercase letter
 *  2.at least one lowercase letter
 *  3.at least one digit
 *  4.length 8-30
 */
+(BOOL)validateNewPassword:(NSString *) password
{
    NSString *pwdRegExp = @"(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])[a-zA-Z0-9]{8,30}";
    NSPredicate *pwdPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pwdRegExp];
    return [pwdPredicate evaluateWithObject:password];
}

+(BOOL)validateMobileNumber:(NSString *)mobileNumber byTelephoneCountryCode:(NSString *)telephoneCountryCode
{
    NSArray * regexArray;
    if ([telephoneCountryCode isEqualToString:@"91"]) {//印度手机号
        regexArray = @[@"^[0-9]{10}$"];
    } else {
        regexArray = @[@"^[0-9]{11}$"];
    }
    for (NSString * regex in regexArray) {
        NSPredicate* pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
        BOOL isMatch = [pred evaluateWithObject:mobileNumber];
        if (isMatch) {
            return isMatch;
        }
    }
    return NO;
}
/** kenny add
 * pin rule
 * length =4
 */
+(BOOL)validatePIN:(NSString *)pin
{
    if (pin.length == kVerifyCodeLength) {
        return YES;
    }
    else
    {
        return NO;
    }
}
/**kenny add
 * 昵称 规则
 * 字符串长度<=9位
 * 首字母是英文字母
 * 由英文字母，汉字和下划线组成
 */

+(BOOL)validateNickName:(NSString *)nickName
{
    NSString * regex = [NSString stringWithFormat:@"[a-zA-Z0-9\u4e00-\u9fa5\u278a-\u2792]{1,%d}", NICKNAME_MAX_LENGTH];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];

    return [pred evaluateWithObject:nickName] ;
}

/**
 *  @author Wang Lei, 15-12-21 15:12:36
 *
 *  @brief  返回字符串长度，中英文混合
 *
 *  @param string 要计算的字符串，eg: aaa length is 3 ; 中国 length is 4； aaa中国 length is 7
 *
 *  @return 返回字符串长度
 *
 *  @since 1.0
 */
+(long)validateStringLength:(NSString*)string
{
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData* da = [string dataUsingEncoding:enc];
    return[da length];
}

/*
 只允许中文字母数字空格
 */
+(BOOL)validateJustChineseCharacterNumberSpace:(NSString *)string
{
    NSString * regex = @"[a-zA-Z0-9\\s\u4e00-\u9fa5\u278a-\u2792]*";
    return [self validateString:string withRegex:regex];
}

+(BOOL)validateString:(NSString *)string withRegex:(NSString *)regex
{
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:string];
}

+(BOOL)validateAsciiCode:(NSString *)ascii {
    NSString *regex = @"[ -~]*";
    return [self validateString:ascii withRegex:regex];
}

+(BOOL)validateHomeName:(NSString *)name {
    NSString *trimed = [name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    BOOL notEmpty = (trimed.length > 0 && trimed.length < 30);
    BOOL noSpecial = ![self validateStringContainSpecialCharacter:trimed specialCharacter:[NSCharacterSet characterSetWithCharactersInString:@"<=>%#^&|\\/"]];
    return notEmpty && noSpecial ;
}

+(BOOL)validateDeviceName:(NSString *)name
{
    return [self validateHomeName:name];
}


/**
 *  @author Wang Lei, 15-08-11 16:08:41
 *
 *  @brief  check if string contain special character
 *
 *  @param string       string
 *  @param characterSet special character set
 *         NSCharacterSet *charSet=[NSCharacterSet characterSetWithCharactersInString:@"<=>%#^&|\\/"];
 *
 *  @return return YES if string contain special character
 *
 *  @since 1670
 */
+(BOOL)validateStringContainSpecialCharacter:(NSString *)string specialCharacter:(NSCharacterSet *)characterSet
{
    if ([[string componentsSeparatedByCharactersInSet:characterSet] count]> 1) {
        return YES;
    }else
    {
        return NO;
    }
}
/**
 *  @rule: length <=14
 *         Not contain special character
 *
 *  @return YES if conditions up are satisfied
 */
/*
+(BOOL)validateNoSpecialCharacter:(NSString *)place
{
    return ![ValidateUtil validateStringContainSpecialCharacter:place specialCharacter:[NSCharacterSet characterSetWithCharactersInString:@"<=>%#^&|\\/"]];
}
*/
/**
 *  check if a string is composed of alplabets
 *
 *  @param string valided string
 *
 *  @return bool
 */
+(BOOL)validateAlphabet:(NSString *)string
{
    NSString * regex = @"^[A-z]+$";
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:string];
}
/**
 *  check if a string is composed of numbers
 *
 *  @param string validated string
 *
 *  @return bool
 */
+(BOOL)validateNumber:(NSString *)string {
    NSString * regex = @"^[0-9]+$";
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:string];
}
/**
 *  check if a string is composed of alplabets and numbers
 *
 *  @param string string
 *
 *  @return bool
 */
+(BOOL)validateAlphabetAndNumber:(NSString *)string {
    if ([ValidateUtil validateStringContainsEmoji:string]) {
        return NO;
    }
    NSArray * specialStringArray = @[@"^", @"[", @"_", @"]", @"/", @"\\"];
    for (NSString * specialString in specialStringArray) {
        if ([string rangeOfString:specialString].length > 0) {
            return NO;
        }
    }
    NSString * regex = @"^[A-z0-9]+$";
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:string];
}

// 过滤所有表情  https://gist.github.com/cihancimen/4146056
+(BOOL)validateStringContainsEmoji:(NSString *)string
{
    __block BOOL returnValue = NO;
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
     ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
         
         const unichar hs = [substring characterAtIndex:0];
         // surrogate pair
         if (0xd800 <= hs && hs <= 0xdbff) {
             if (substring.length > 1) {
                 const unichar ls = [substring characterAtIndex:1];
                 const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                 if (0x1d000 <= uc && uc <= 0x1f77f) {
                     returnValue = YES;
                 }
             }
         } else if (substring.length > 1) {
             const unichar ls = [substring characterAtIndex:1];
             if (ls == 0x20e3) {
                 returnValue = YES;
             }
             
         } else {
             // non surrogate
             if ((0x2100 <= hs && hs <= 0x27ff)
                 || (0x2B05 <= hs && hs <= 0x2b07)
                 || (0x2934 <= hs && hs <= 0x2935)
                 || (0x3297 <= hs && hs <= 0x3299)
                 || (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50)) {
                 returnValue = YES;
             }
         }
     }];
    
    return returnValue;
}



@end
