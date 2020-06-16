//
//  UILabel+YMAddition.h
//  
//
//  Created by Richard on 2017/6/22.
//  Copyright © 2017年 Richard. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreText/CoreText.h"

@interface UILabel  (YMAddition)

- (CGFloat)YM_fitHeightByTextUsingCurrentFontWithMaxNumOfLines:(NSInteger)maxNumOfLines;
- (CGFloat)YM_fitHeightByTextUsingCurrentFontWithMaxHeight:(CGFloat)maxHeight;

/// 一个方法进行初始化
+ (UILabel *)labelWithFrame:(CGRect)frame text:(NSString *)text textColor:(UIColor *)textColor font:(UIFont *)font;

+ (UILabel *)labelWithFrame:(CGRect)frame text:(NSString *)text textColor:(UIColor *)textColor font:(UIFont *)font textAlignment:(NSTextAlignment)textAlignment;

+ (UILabel *)labelAutoCountSizeWithY:(CGFloat)topY Text:(NSString *)text textColor:(UIColor *)textColor font:(UIFont *)font textAlignment:(NSTextAlignment)textAlignment;

/**
 *  Label得到text数据后,计算text文本宽度,调整Label的frame的宽度
 *
 *  @param text     Label的显示内容
 *  @param fontSize 文本的字体大小
 */
- (void)labelSingleLineWithText:(NSString *)text;
- (void)changeAlignmentRightandLeft;


/**
 *  Label得到text数据后,计算text文本的高度,调整Label的frame的高度
 *
 *  @param text        Label的显示内容
 *  @param lineSpacing 行间距
 */
- (void)labelMultiLineWithText:(NSString *)text lineSpacing:(CGFloat)lineSpacing;


/// 根据label既定长度自动选择单行或多行高度适应方法
- (void)labelAutoStringText:(NSString *)text lineSpacing:(CGFloat)lineSpacing;


/**
 * 自适应计算间距
 */
- (void)resetContentWithText:(NSString *)text maximumLineHeight:(CGFloat)maximumLineHeight lineSpacing:(CGFloat)lineSpacing;
+ (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font size:(CGSize)size maximumLineHeight:(CGFloat)maximumLineHeight lineSpacing:(CGFloat)lineSpacing;

/**
 *  根据Text更改label的AttributeText
 *
 *  @param text              Label显示内容
 *  @param lineSpacing       行间距
 */
- (void)labelAttributeTextWithText:(NSString *)text lineSpacing:(CGFloat)lineSpacing;




@end
