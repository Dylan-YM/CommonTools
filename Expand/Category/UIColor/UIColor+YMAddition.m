//
//  UIColor+YMAddition.m
//  thirdDemo
//
//  Created by Richard on 2018/3/13.
//  Copyright © 2018年 Richard. All rights reserved.
//

#import "UIColor+YMAddition.h"

@implementation UIColor (YMAddition)

+ (UIColor *)YM_colorFromHex:(NSInteger)hex {
    return [self YM_colorFromHex:hex alpha:1.0f];
}

+ (UIColor *)YM_colorWithHexString:(NSString *)stringToConvert {
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    // 判断前缀
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    // 从六位数值中找到RGB对应的位数并转换
    NSRange range;
    range.location = 0;
    range.length = 2;
    //R、G、B
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    // Scan values
    unsigned int R = 0;
    
    unsigned int G = 0;
    
    unsigned int B = 0;
    [[NSScanner scannerWithString:rString] scanHexInt:&R];
    [[NSScanner scannerWithString:gString] scanHexInt:&G];
    [[NSScanner scannerWithString:bString] scanHexInt:&B];
    
    return [UIColor colorWithRed:((float) R/ 255.0f) green:((float) G / 255.0f) blue:((float)B / 255.0f) alpha:1.0f];

}
+ (UIColor *)YM_colorFromHex:(NSInteger)hex alpha:(CGFloat)alpha {
    return [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16))/255.0
                           green:((float)((hex & 0xFF00) >> 8))/255.0
                            blue:((float)(hex & 0xFF))/255.0
                           alpha:alpha];
}

+ (UIColor *)YM_colorWithRed:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue {
    return [self YM_colorWithRed:red green:green blue:blue alpha:100];
}

+ (UIColor *)YM_colorWithRed:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue alpha:(NSInteger)alpha {
    return [UIColor colorWithRed:red / 255.0f green:green / 255.0f blue:blue / 255.0f alpha:alpha / 100.0f];
}

@end
