//
//  YMAdaptiveManager.m
//  
//
//  Created by Richard on 2017/6/21.
//  Copyright © 2017年 Richard. All rights reserved.
//

#import "YMAdaptiveManager.h"
#import "UIDevice+YMExtend.h"
#import "YMFontConstant.h"

@implementation YMAdaptiveManager

// 字体的缩放因子
+(CGFloat)fontScale {
    if ([UIDevice isPhone6p]) {
        return FONT_PHONE6P_SCALE;
    }
    else {
        return FONT_PHONE6_SCALE;
    }
}

// 列表图片缩放因子
+(CGFloat)imageScale {
    if ([UIDevice isPhone6p]) {
        return IMAGE_PHONE6P_SCALE;
    }
    else {
        return IMAGE_PHONE6_SCALE;
    }
}

/// 间距的缩放因子
+ (CGFloat)marginScale {
    if ([UIDevice isPhone6p]) {
        return MARGIN_PHONE6P_SCALE;
    }else {
        return MARGIN_PHONE6_SCALE;
    }
}

+ (CGFloat)sizeAllScale {
    if ([UIDevice isPhone6p]) {
        return MARGIN_PHONE6P_SCALE;
    } else if ([UIDevice isPhone6]) {
        return 1;
    } else if (IS_IPAD) {
        return SCREEN_WIDTH / PHONE6_WIDTH;
    } else {
        return PHONE5_WIDTH / PHONE6_WIDTH;
    }
}

@end
