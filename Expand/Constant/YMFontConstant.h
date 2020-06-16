//
//  YMFontConstant.h
//  thirdDemo
//
//  Created by Richard on 2018/3/13.
//  Copyright © 2018年 Richard. All rights reserved.
//

#ifndef YMFontConstant_h
#define YMFontConstant_h
#import "YMAdaptiveManager.h"
#import "HWFont.h"
// -------------------- 字号 ---------------------------
// 6p字体的缩放因子
#define FONT_PHONE6P_SCALE          (PHONE6P_WIDTH / PHONE6_WIDTH)
#define FONT_PHONE6_SCALE           1

#define FONT_SIZE_8                   8 * [YMAdaptiveManager fontScale]
#define FONT_SIZE_9                   9 * [YMAdaptiveManager fontScale]
#define FONT_SIZE_10                  10 * [YMAdaptiveManager fontScale]
#define FONT_SIZE_11                  11 * [YMAdaptiveManager fontScale]
#define FONT_SIZE_12                  12 * [YMAdaptiveManager fontScale]
#define FONT_SIZE_13                  13 * [YMAdaptiveManager fontScale]
#define FONT_SIZE_14                  14 * [YMAdaptiveManager fontScale]
#define FONT_SIZE_15                  15 * [YMAdaptiveManager fontScale]
#define FONT_SIZE_16                  16 * [YMAdaptiveManager fontScale]
#define FONT_SIZE_17                  17 * [YMAdaptiveManager fontScale]
#define FONT_SIZE_18                  18 * [YMAdaptiveManager fontScale]
#define FONT_SIZE_20                  20 * [YMAdaptiveManager fontScale]
#define FONT_SIZE_21                  21 * [YMAdaptiveManager fontScale]
#define FONT_SIZE_22                  22 * [YMAdaptiveManager fontScale]
#define FONT_SIZE_23                  23 * [YMAdaptiveManager fontScale]
#define FONT_SIZE_24                  24 * [YMAdaptiveManager fontScale]

// -------------------- 字体 ---------------------------
#define YM_FONT(fontSize)                 ([UIFont systemFontOfSize:fontSize])
#define YM_BOLD_FONT(fontSize)            ([UIFont boldSystemFontOfSize:fontSize])



// 8号字体
#define YM_FONT_8                  YM_FONT(FONT_SIZE_8)
// 9号字体
#define YM_FONT_9                  YM_FONT(FONT_SIZE_9)
// 10号字体
#define YM_FONT_10                 YM_FONT(FONT_SIZE_10)
// 12号字体
#define YM_FONT_12                 YM_FONT(FONT_SIZE_12)
// 11号字体
#define YM_FONT_11                 YM_FONT(FONT_SIZE_11)
// 13号字体
#define YM_FONT_13                 YM_FONT(FONT_SIZE_13)
// 14号字体
#define YM_FONT_14                 YM_FONT(FONT_SIZE_14)
// 15号字体
#define YM_FONT_15                 YM_FONT(FONT_SIZE_15)
// 16号字体
#define YM_FONT_16                 YM_FONT(FONT_SIZE_16)
// 167号字体
#define YM_FONT_17                 YM_FONT(FONT_SIZE_17)
// 18号字体
#define YM_FONT_18                 YM_FONT(FONT_SIZE_18)
// 20
#define YM_FONT_20                 YM_FONT(FONT_SIZE_20)
// 21
#define YM_FONT_21                 YM_FONT(FONT_SIZE_21)
// 24
#define YM_FONT_24                 YM_FONT(FONT_SIZE_24)

// 加粗 中文字体：冬青黑体简体中文 W6
#define YM_BOLD_FONT_8               YM_BOLD_FONT(FONT_SIZE_8)
#define YM_BOLD_FONT_9               YM_BOLD_FONT(FONT_SIZE_9)
#define YM_BOLD_FONT_11              YM_BOLD_FONT(FONT_SIZE_11)
#define YM_BOLD_FONT_12              YM_BOLD_FONT(FONT_SIZE_12)
#define YM_BOLD_FONT_13              YM_BOLD_FONT(FONT_SIZE_13)
#define YM_BOLD_FONT_14              YM_BOLD_FONT(FONT_SIZE_14)
#define YM_BOLD_FONT_15              YM_BOLD_FONT(FONT_SIZE_15)
#define YM_BOLD_FONT_16              YM_BOLD_FONT(FONT_SIZE_16)
#define YM_BOLD_FONT_17              YM_BOLD_FONT(FONT_SIZE_17)
#define YM_BOLD_FONT_18              YM_BOLD_FONT(FONT_SIZE_18)
#define YM_BOLD_FONT_20              YM_BOLD_FONT(FONT_SIZE_20)
#define YM_BOLD_FONT_21              YM_BOLD_FONT(FONT_SIZE_21)
#define YM_BOLD_FONT_24              YM_BOLD_FONT(FONT_SIZE_24)

#pragma mark - Hpro font
#define HW_FONT(fontSize)                 ([HWFont systemFontOfSize:fontSize])
#define HW_BOLD_FONT(fontSize)            ([HWFont boldSystemFontOfSize:fontSize])
/// 8号字体
#define HW_FONT_8                  HW_FONT(FONT_SIZE_8)
// 9号字体
#define HW_FONT_9                  HW_FONT(FONT_SIZE_9)
// 10号字体
#define HW_FONT_10                 HW_FONT(FONT_SIZE_10)
// 12号字体
#define HW_FONT_12                 HW_FONT(FONT_SIZE_12)
// 11号字体
#define HW_FONT_11                 HW_FONT(FONT_SIZE_11)
// 13号字体
#define HW_FONT_13                 HW_FONT(FONT_SIZE_13)
// 14号字体
#define HW_FONT_14                 HW_FONT(FONT_SIZE_14)
// 15号字体
#define HW_FONT_15                 HW_FONT(FONT_SIZE_15)
// 16号字体
#define HW_FONT_16                 HW_FONT(FONT_SIZE_16)
// 167号字体
#define HW_FONT_17                 HW_FONT(FONT_SIZE_17)
// 18号字体
#define HW_FONT_18                 HW_FONT(FONT_SIZE_18)
// 20
#define HW_FONT_20                 HW_FONT(FONT_SIZE_20)
// 21
#define HW_FONT_21                 HW_FONT(FONT_SIZE_21)
// 24
#define HW_FONT_24                 HW_FONT(FONT_SIZE_24)

// 加粗 中文字体：冬青黑体简体中文 W6
#define HW_BOLD_FONT_8               HW_BOLD_FONT(FONT_SIZE_8)
#define HW_BOLD_FONT_9               HW_BOLD_FONT(FONT_SIZE_9)
#define HW_BOLD_FONT_11              HW_BOLD_FONT(FONT_SIZE_11)
#define HW_BOLD_FONT_12              HW_BOLD_FONT(FONT_SIZE_12)
#define HW_BOLD_FONT_13              HW_BOLD_FONT(FONT_SIZE_13)
#define HW_BOLD_FONT_14              HW_BOLD_FONT(FONT_SIZE_14)
#define HW_BOLD_FONT_15              HW_BOLD_FONT(FONT_SIZE_15)
#define HW_BOLD_FONT_16              HW_BOLD_FONT(FONT_SIZE_16)
#define HW_BOLD_FONT_17              HW_BOLD_FONT(FONT_SIZE_17)
#define HW_BOLD_FONT_18              HW_BOLD_FONT(FONT_SIZE_18)
#define HW_BOLD_FONT_20              HW_BOLD_FONT(FONT_SIZE_20)
#define HW_BOLD_FONT_21              HW_BOLD_FONT(FONT_SIZE_21)
#define HW_BOLD_FONT_24              HW_BOLD_FONT(FONT_SIZE_24)
#endif /* YMFontConstant_h */
