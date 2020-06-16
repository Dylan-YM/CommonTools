//
//  StringUtil.h
//  AirTouch
//
//  Created by huangfujun on 15/2/4.
//  Copyright (c) 2015年 Honeywell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreText/CTStringAttributes.h>
#import <CoreText/CoreText.h>
#import <UIKit/UIKit.h>

@interface StringUtil : NSObject

/**
 *  @author Wang Lei, 15-08-05 14:08:03
 *
 *  @brief  generate different style in same text
 *
 *  @param string show text
 *  @param array  attribute array
 *  @[@[[HWFont systemFontOfSize:10.0],[UIColor redColor],   NSStringFromRange(NSMakeRange(0, [@"123456789" length]))],
 *    @[[HWFont systemFontOfSize:20.0],[UIColor blueColor],  NSStringFromRange(NSMakeRange(2, 2))],
 *    @[[HWFont systemFontOfSize:30.0],[UIColor yellowColor],NSStringFromRange(NSMakeRange(4, 2))]
 *   ]
 *  @return NSMutableAttributedString object
 *
 *  @since 1640
 */
+(NSMutableAttributedString *)attributedWithString:(NSString *)string attributeArray:(NSArray *)array;

+(NSMutableAttributedString *)attributedWithString:(NSString *)string attributeArray:(NSArray *)array targetView:(UIView *)targetView;



@end
