//
//  YMAdaptiveManager.h
//  
//
//  Created by Richard on 2017/6/21.
//  Copyright © 2017年 Richard. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YMAdaptiveManager : NSObject

// 字体的缩放因子
+(CGFloat)fontScale;

// 列表图片缩放因子
+(CGFloat)imageScale;

/// 间距的缩放因子
+ (CGFloat)marginScale;

/**
 *  全部比例 320 375 414 相比375像素的比例
 */
+ (CGFloat)sizeAllScale;

@end
