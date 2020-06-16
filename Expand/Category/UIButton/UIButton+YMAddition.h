//
//  UIButton+YMAddition.h
//
//
//  Created by Richard on 16/3/16.
//  Copyright © 2016年 Richard. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (YMAddition)



/**
 *  图片和标题排列(0水平或1垂直)居中的按钮,默认(水平排列图片在左，文字在右;垂直排列图片在上，文字在下),否则相反
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
+ (UIButton *)buttonWithFrame:(CGRect)frame title:(NSString *)title titleColor:(UIColor *)titleColor fontName:(NSString *)fontName fontSize:(CGFloat)fontSize imageName:(NSString *)imageName margin:(CGFloat)margin direction:(NSInteger)direction isDefault:(BOOL)isDefault;
/// 调整button中的图片和位置位置
- (void)adjustButtonTitleImageWithFontSize:(CGFloat)fontSize margin:(CGFloat)margin direction:(NSInteger)direction isDefault:(BOOL)isDefault;
/// 生成登录、注册该类的按钮
+ (UIButton *)loginRegistButtonWithTitle:(NSString *)title target:(id)target action:(SEL)action;
/// 绿色按钮
+ (UIButton *)YMbestColorButtonWithFrame:(CGRect)frame title:(NSString *)title target:(id)target action:(SEL)action;
/// 调整按钮的宽度
- (void)adjustButtonWidthWithSingleLineTitle:(NSString *)title;
+ (UIButton *)DefaultbuttonWithFrame:(CGRect)frame title:(NSString *)title titleColor:(UIColor *)titleColor fontName:(NSString *)fontName fontSize:(CGFloat)fontSize imageName:(NSString *)imageName ;
@end
