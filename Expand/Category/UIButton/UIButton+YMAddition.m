//
//  UIButton+YMAddition.m
//
//
//  Created by Richard on 16/3/16.
//  Copyright © 2016年 Richard. All rights reserved.
//

#import "UIButton+YMAddition.h"

@implementation UIButton (YMAddition)

/**
 *  图片和标题排列(0水平或1垂直)居中的按钮,默认(水平排列图片在左,文字在右;垂直排列图片在上,文字在下),否则相反
 *  Tips:按钮的宽度不能太窄,否则会导致title内容显示不全,排列也不会对齐
 *  @param frame      位置
 *  @param title      标题
 *  @param titleColor 标题颜色
 *  @param fontName   字体名称
 *  @param fontSize   字体大小
 *  @param imageName  图片名称
 *  @param margin     图片与标题之间的间距
 *  @param direction  排列方向(0水平或1垂直)
 *  @param isDefault  是否为默认的排列顺序
 *
 *  @return 配置好的按钮
 */
+ (UIButton *)buttonWithFrame:(CGRect)frame title:(NSString *)title titleColor:(UIColor *)titleColor fontName:(NSString *)fontName fontSize:(CGFloat)fontSize imageName:(NSString *)imageName margin:(CGFloat)margin direction:(NSInteger)direction isDefault:(BOOL)isDefault {

    UIButton *button = [[UIButton alloc] initWithFrame:frame];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    button.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    button.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    button.backgroundColor = [UIColor whiteColor];

    UIImage *image = [UIImage imageNamed:imageName];
    [button setImage:image forState:UIControlStateNormal];
    
    button.titleLabel.backgroundColor = [UIColor clearColor];
    button.imageView.backgroundColor = [UIColor clearColor];
    
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    button.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
    [button adjustButtonTitleImageWithFontSize:fontSize margin:margin direction:direction isDefault:isDefault];
    return button;
}

+ (UIButton *)DefaultbuttonWithFrame:(CGRect)frame title:(NSString *)title titleColor:(UIColor *)titleColor fontName:(NSString *)fontName fontSize:(CGFloat)fontSize imageName:(NSString *)imageName  {
    
    
    UIButton *button = [[UIButton alloc] initWithFrame:frame];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    button.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    button.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    button.backgroundColor = [UIColor whiteColor];
    
    UIImage *image = [UIImage imageNamed:imageName];
    [button setImage:image forState:UIControlStateNormal];
    
    button.titleLabel.backgroundColor = [UIColor clearColor];
    button.imageView.backgroundColor = [UIColor clearColor];
    
    return button;
}

/// 调整button中的图片和位置位置
- (void)adjustButtonTitleImageWithFontSize:(CGFloat)fontSize margin:(CGFloat)margin direction:(NSInteger)direction isDefault:(BOOL)isDefault {
    
    CGRect frame = self.frame;
    //  button的大小
    CGFloat height = frame.size.height;
    CGFloat width = frame.size.width;
    UIImage *image = self.imageView.image;
    //  图片的大小
    CGFloat imageHeight = image.size.height;
    CGFloat imageWidth = image.size.width;
    //  计算标题的宽度
    CGSize size = YM_MULTILINE_TEXTSIZE(self.titleLabel.text, self.titleLabel.font, CGSizeMake(SCREEN_WIDTH, fontSize), ZERO_ORIGIN);
    fontSize = size.height;
    
    if (direction == 0) {
        if (size.width >= width - margin - imageWidth) {
            size.width = width - margin - imageWidth;
        }
        //  水平方向
        //  计算图片和标题以及间距总共的宽度
        CGFloat totalWidth = imageWidth + size.width + margin;
        //  调整图片、标题位置
        if (isDefault) {
            //  图片居左,标题居右
            [self setImageEdgeInsets:UIEdgeInsetsMake((height - imageHeight)/2, (width - totalWidth)/2, ZERO_ORIGIN, ZERO_ORIGIN)];
            [self setTitleEdgeInsets:UIEdgeInsetsMake((height - fontSize)/2, (width - totalWidth)/2 + margin, ZERO_ORIGIN, ZERO_ORIGIN)];
        }else {
            //  图片居右,标题居左
            [self setImageEdgeInsets:UIEdgeInsetsMake((height - imageHeight)/2, (width - totalWidth)/2 + margin + size.width, ZERO_ORIGIN, ZERO_ORIGIN)];
            [self setTitleEdgeInsets:UIEdgeInsetsMake((height - fontSize)/2, (width - totalWidth)/2 - imageWidth, ZERO_ORIGIN, ZERO_ORIGIN)];
        }
    }else if (direction == 1) {
        //  垂直方向
        //  计算图片和标题以及间距总共的高度
        CGFloat totalHeight = imageHeight + margin + size.height;
        //  调整图片、标题位置
        if (isDefault) {
            //  图片居上,标题居下
            [self setImageEdgeInsets:UIEdgeInsetsMake((height - totalHeight)/2, (width - imageWidth)/2, ZERO_ORIGIN, ZERO_ORIGIN)];
            [self setTitleEdgeInsets:UIEdgeInsetsMake((height - totalHeight)/2 + margin + imageHeight, - imageWidth + (width - size.width)/2, ZERO_ORIGIN, ZERO_ORIGIN)];
        }else {
            //  图片居下,标题居上
            [self setImageEdgeInsets:UIEdgeInsetsMake((height - totalHeight)/2 + margin + size.height, (width - imageWidth)/2, ZERO_ORIGIN, ZERO_ORIGIN)];
            [self setTitleEdgeInsets:UIEdgeInsetsMake((height - totalHeight)/2, (width - size.width)/2  - imageWidth, ZERO_ORIGIN, ZERO_ORIGIN)];
        }
    }
}


// Segment宽度
#define WIDTH_SSO_SEGMENTVIEW             MARGIN_SCALE(235)
// 登录按钮的上边距
#define MARGIN_TOP_SSO_LOGINBUTTON        MARGIN_SCALE(30)
// 登录按钮的高度
#define HEIGHT_SSO_LOGINBUTTON            MARGIN_SCALE(40)
// 登录按钮的圆角
#define CORNERRADIUS_SSO_LOGINBUTTON      MARGIN_SCALE(2)
/// 生成登录、注册该类的按钮
+ (UIButton *)loginRegistButtonWithTitle:(NSString *)title target:(id)target action:(SEL)action {

    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - WIDTH_SSO_SEGMENTVIEW)/2, MARGIN_TOP_SSO_LOGINBUTTON, WIDTH_SSO_SEGMENTVIEW, HEIGHT_SSO_LOGINBUTTON)];
    button.backgroundColor = COLOR_YM_MAIN;
    button.layer.cornerRadius = CORNERRADIUS_SSO_LOGINBUTTON;
    button.layer.masksToBounds = YES;
    [button setTitle:title forState:UIControlStateNormal];
    [button.titleLabel setFont:YM_FONT_17];
    [button setTitleColor:COLOR_MAIN_BG forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}

/// 绿色按钮
+ (UIButton *)YMbestColorButtonWithFrame:(CGRect)frame title:(NSString *)title target:(id)target action:(SEL)action {

    UIButton *button = [[UIButton alloc] initWithFrame:frame];
    button.backgroundColor = [UIColor clearColor];
    button.titleLabel.font = YM_FONT_13;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:COLOR_YM_MAIN forState:UIControlStateNormal];
    [button setTitleColor:COLOR_YM_MAIN forState:UIControlStateHighlighted];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}

/// 调整按钮的宽度
- (void)adjustButtonWidthWithSingleLineTitle:(NSString *)title {

    CGRect frame = self.frame;
    CGSize size = YM_MULTILINE_TEXTSIZE(title, self.font, CGSizeMake(SCREEN_WIDTH, frame.size.height), ZERO_ORIGIN);
    frame.size.width = size.width;
    self.frame = frame;
}
@end
