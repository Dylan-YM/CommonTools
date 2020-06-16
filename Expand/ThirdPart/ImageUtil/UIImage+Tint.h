//
//  UIImage+Tint.h
//  RMEO
//
//  Created by Faney on 14-3-18.
//  Copyright (c) 2014年 RMEO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Tint)

// 图片换颜色
- (UIImage *)imageWithTintColor:(UIColor *)tintColor;

// 图片虚化
- (UIImage *)blurryImage:(CGFloat)blur;

// 图片剪切
- (UIImage*)clipImageInRect:(CGRect)rect;

//解决相机拍摄超过2M旋转90度的问题
- (UIImage *)fixOrientation;

@end
