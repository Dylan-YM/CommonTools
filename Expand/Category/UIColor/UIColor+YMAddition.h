//
//  UIColor+YMAddition.h
//  thirdDemo
//
//  Created by Richard on 2018/3/13.
//  Copyright © 2018年 Richard. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (YMAddition)
#define YMRGB(RED, GREEN, BLUE)             [UIColor YM_colorWithRed:RED green:GREEN blue:BLUE]
#define YMRGBA(RED, GREEN, BLUE, ALPHA)     [UIColor YM_colorWithRed:RED green:GREEN blue:BLUE alpha:ALPHA]
#define YMRGBFromHex(HEX)                   [UIColor YM_colorFromHex:HEX]


+ (UIColor *)YM_colorFromHex:(NSInteger)hex;
+ (UIColor *)YM_colorWithHexString:(NSString *)stringToConvert;
+ (UIColor *)YM_colorFromHex:(NSInteger)hex alpha:(CGFloat)alpha;

+ (UIColor *)YM_colorWithRed:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue;

/**
 red:0-255
 green:0-255
 blue:0-255
 alpha:0-100
 */
+ (UIColor *)YM_colorWithRed:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue alpha:(NSInteger)alpha;

@end
