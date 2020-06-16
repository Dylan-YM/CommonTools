//
//  ZYTHotButton.m
//  ZhanYiTang-iOS
//
//  Created by Richard on 2018/8/21.
//  Copyright © 2018年 ZhanYiTang. All rights reserved.
//

#import "ZYTHotButton.h"

@implementation ZYTHotButton
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent*)event
{
    CGRect bounds = self.bounds;
    //若原热区小于44x44，则放大热区，否则保持原大小不变
    CGFloat widthDelta = MAX(44 - bounds.size.width, 0);
    CGFloat heightDelta = MAX(44 - bounds.size.height, 0);
    bounds = CGRectInset(bounds, -0.5 * widthDelta, -0.5 * heightDelta);
    return CGRectContainsPoint(bounds, point);
}
+ (ZYTHotButton *)DefaultbuttonWithFrame:(CGRect)frame title:(NSString *)title titleColor:(UIColor *)titleColor fontName:(NSString *)fontName fontSize:(CGFloat)fontSize imageName:(NSString *)imageName  {
    
    
    ZYTHotButton *button = [[ZYTHotButton alloc] initWithFrame:frame];
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
@end
