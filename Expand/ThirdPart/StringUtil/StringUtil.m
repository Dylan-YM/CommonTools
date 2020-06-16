//
//  StringUtil.m
//  AirTouch
//
//  Created by huangfujun on 15/2/4.
//  Copyright (c) 2015年 Honeywell. All rights reserved.
//

#import "StringUtil.h"

@implementation StringUtil

+(NSMutableAttributedString *)attributedWithString:(NSString *)string attributeArray:(NSArray *)array
{
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:string];
    for (NSArray *temp in array) {
        UIFont *font=temp[0];
        [attributedStr addAttribute:NSFontAttributeName
                              value:font
                              range:NSRangeFromString(temp[2])];
        [attributedStr addAttribute:NSForegroundColorAttributeName
                              value:temp[1]
                              range:NSRangeFromString(temp[2])];
    }
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5];//调整行间距
    [attributedStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [string length])];
    return attributedStr;
}

+(NSMutableAttributedString *)attributedWithString:(NSString *)string attributeArray:(NSArray *)array targetView:(UIView *)targetView
{
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:string];
    for (NSArray *temp in array) {
        //不同屏幕放大字体
        UIFont *font=temp[0];
        [attributedStr addAttribute:NSFontAttributeName
                              value:font
                              range:NSRangeFromString(temp[2])];
        [attributedStr addAttribute:NSForegroundColorAttributeName
                              value:temp[1]
                              range:NSRangeFromString(temp[2])];
    }
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5];//调整行间距
    [attributedStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [string length])];
    
    CGRect rect=[attributedStr boundingRectWithSize:CGSizeMake(CGRectGetWidth(targetView.frame), CGFLOAT_MAX)
                                            options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                            context:nil];
    CGRect resultRect=targetView.frame;
    resultRect.size.height=rect.size.height;
    targetView.frame=resultRect;
    return attributedStr;
}
@end
