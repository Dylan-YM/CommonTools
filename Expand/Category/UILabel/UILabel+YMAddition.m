//
//  UILabel+YMAddition.m
//  
//
//  Created by Richard on 2017/6/22.
//  Copyright © 2017年 Richard. All rights reserved.
//

#import "UILabel+YMAddition.h"

@implementation UILabel(YMAddition)

+ (UILabel *)labelWithFrame:(CGRect)frame text:(NSString *)text textColor:(UIColor *)textColor font:(UIFont *)font {
    
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text = text;
    label.textColor = textColor;
    label.font = font;
    return label;
}

+ (UILabel *)labelWithFrame:(CGRect)frame text:(NSString *)text textColor:(UIColor *)textColor font:(UIFont *)font textAlignment:(NSTextAlignment)textAlignment {
    UILabel *label = [self labelWithFrame:frame text:text textColor:textColor font:font];
    label.textAlignment = textAlignment;
    return label;
}
/**
 *  Label得到text数据后,计算text文本宽度,调整Label的frame的宽度
 *
 *  @param text     Label的显示内容
 *  @param fontSize 文本的字体大小
 */
- (void)labelSingleLineWithText:(NSString *)text {
    
    self.text = text;
    CGRect frame = self.frame;
    CGSize size = YM_MULTILINE_TEXTSIZE(text, self.font, CGSizeMake(SCREEN_WIDTH, self.frame.size.height), ZERO_ORIGIN);
    
    frame.size.width = size.width;
    self.frame = frame;
}

- (void)changeAlignmentRightandLeft {
    
    CGRect textSize = [self.text boundingRectWithSize:CGSizeMake(self.frame.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingTruncatesLastVisibleLine |NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : self.font} context:nil];
    
    CGFloat margin = (self.frame.size.width - textSize.size.width) / (self.text.length - 1);
    
    NSNumber *number = [NSNumber numberWithFloat:margin];
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc]initWithString:self.text];
    [attributeString addAttribute:(id)kCTKernAttributeName value:number range:NSMakeRange(0, self.text.length - 1)];
    self.attributedText = attributeString;
}

/**
 *  Label得到text数据后,计算text文本的高度,调整Label的frame的高度
 *
 *  @param text        Label的显示内容
 *  @param lineSpacing 行间距
 */
- (void)labelMultiLineWithText:(NSString *)text lineSpacing:(CGFloat)lineSpacing {

    if (ISTREMPTY(text)) {
        return;
    }
    
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.lineSpacing = lineSpacing;
    
    CGSize size = YM_MULTILINE_TEXTSIZE(text, self.font, CGSizeMake(CGRectGetWidth(self.frame), FLT_MAX), 0);
//    CGSize testSize = YM_MULTILINE_TEXTSIZE(@"测试内容", self.font, CGSizeMake(CGRectGetWidth(self.frame), FLT_MAX), 0);
    CGRect frame = self.frame;
//    CGFloat pointSize = self.font.pointSize;
//    frame.size.height = size.height < pointSize * 2 ? testSize.height : testSize.height * 2 + lineSpacing;
    frame.size.height = size.height;
    self.frame = frame;
    // 设置label的富文本
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:text];
    paragraph.lineSpacing = lineSpacing;
    paragraph.alignment = NSTextAlignmentNatural;
    paragraph.lineBreakMode = NSLineBreakByTruncatingTail;
    [attributeString addAttribute:NSParagraphStyleAttributeName value:paragraph range:NSMakeRange(0, text.length)];
    self.attributedText = attributeString;
}

- (void)labelAutoStringText:(NSString *)text lineSpacing:(CGFloat)lineSpacing {
    if (ISTREMPTY(text)) {
        //text 为空不进行高度计算
        return;
    }
    UIFont *font = self.font;
    if (text.length > CGRectGetWidth(self.frame) / font.pointSize) {
        //字数 > 可显示字数， 进行换行
        [self labelAttributeTextWithText:text lineSpacing:lineSpacing];
    }else {
        //单行显示即可
        [self labelSingleLineWithText:text];
    }
}

/**
 *  根据Text更改label的AttributeText
 *
 *  @param text              Label显示内容
 *  @param lineSpacing       行间距
 */
- (void)labelAttributeTextWithText:(NSString *)text lineSpacing:(CGFloat)lineSpacing {
    
    if (text) {
        // 设置label的富文本
        NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:text];
        NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
        paragraph.lineSpacing = lineSpacing;
        paragraph.lineBreakMode = NSLineBreakByTruncatingTail;
        [attributeString addAttribute:NSParagraphStyleAttributeName value:paragraph range:NSMakeRange(0, text.length)];
        self.attributedText = attributeString;
        
        CGRect originFrame = self.frame;
        [self sizeToFit];
        
        CGRect frame = self.frame;
        frame.origin = originFrame.origin;
        frame.size.width = originFrame.size.width;
        self.frame = frame;
    }
}

- (void)resetContentWithText:(NSString *)text maximumLineHeight:(CGFloat)maximumLineHeight lineSpacing:(CGFloat)lineSpacing{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentLeft;
    paragraphStyle.maximumLineHeight = maximumLineHeight;  //最大的行高
    paragraphStyle.lineSpacing = lineSpacing;  //行自定义行高度
    //    [paragraphStyle setFirstLineHeadIndent:firstLineHeadIndent];//首行缩进
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text length])];
    //    [attributedString addAttribute:NYMontAttributeName value:YM_FONT_MORE range:NSMakeRange(0, [text length])];
    //    [attributedString addAttribute:NYMoregroundColorAttributeName value:COLOR_TITLE range:NSMakeRange(0, [text length])];
    self.attributedText = attributedString;
    [self sizeToFit];
}

+ (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font size:(CGSize)size maximumLineHeight:(CGFloat)maximumLineHeight lineSpacing:(CGFloat)lineSpacing {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    label.text = text;
    label.font = font;
    label.numberOfLines = 3;
    label.lineBreakMode = NSLineBreakByTruncatingTail;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentLeft;
    paragraphStyle.maximumLineHeight = maximumLineHeight;  //最大的行高
    paragraphStyle.lineSpacing = lineSpacing;  //行自定义行高度
    //    [paragraphStyle setFirstLineHeadIndent:firstLineHeadIndent];//首行缩进
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text length])];
    //    [attributedString addAttribute:NYMontAttributeName value:YM_FONT_MORE range:NSMakeRange(0, [text length])];
    //    [attributedString addAttribute:NYMoregroundColorAttributeName value:COLOR_TITLE range:NSMakeRange(0, [text length])];
    label.attributedText = attributedString;
    [label sizeToFit];
    return label.bounds.size;
}


@end
