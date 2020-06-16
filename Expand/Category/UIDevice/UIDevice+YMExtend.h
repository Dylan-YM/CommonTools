//
//  UIDevice+YMExtend.h
//  thirdDemo
//
//  Created by Richard on 2018/3/13.
//  Copyright © 2018年 Richard. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIDevice (YMExtend)

+ (NSString *)deviceCode;
// 获取设备型号，如："iPhone4,1"
+ (NSString*) deviceModel;
+ (BOOL)isRetina4inch;

+ (BOOL)isPhone5;

+ (BOOL)isPhone6;

+ (BOOL)isPhone6p;

// 获取本地IP
+ (NSArray *)localIPAddresses;

+ (NSString *)getIpAddresses;

+ (NSString *)getClientIpAddress;

@end
