//
//  YMSizeConstant.h
//  thirdDemo
//
//  Created by Richard on 2018/3/13.
//  Copyright © 2018年 Richard. All rights reserved.
//

#ifndef YMSizeConstant_h
#define YMSizeConstant_h

#define SCREEN_HEIGHT [[UIScreen mainScreen]bounds].size.height
#define SCREEN_WIDTH [[UIScreen mainScreen]bounds].size.width
#define IOS_VERSION ([[[UIDevice currentDevice] systemVersion] floatValue])
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
//#define iPhoneX     (SCREEN_WIDTH == 375 && SCREEN_HEIGHT == 812)
#define iPhone6P    (SCREEN_WIDTH == 414)

/*
 * 通过RGB创建UIColor
 */
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
#define HEXCOLOR(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define HEXACOLOR(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:(a)]

#define YM_TEXTSIZE(text, font) [text length] > 0 ? [text sizeWithAttributes:@{NSFontAttributeName:font}] : CGSizeZero;

#define YM_MULTILINE_TEXTSIZE(text, font, maxSize, mode) [text length] > 0 ? [text boundingRectWithSize:maxSize options:(NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName:font} context:nil].size : CGSizeZero;

#define KIMAGENAME(name)  [UIImage imageNamed:(name)]


//字符串是否为空
#define ISTREMPTY(_ref)    (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]) ||([(_ref)isEqualToString:@""]))
//数组是否为空
#define ISARREMPTY(_ref)    (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]) ||([(_ref) count] == 0))


// iPhone 屏幕尺寸
#define PHONE_SCREEN_SIZE (CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT - PHONE_STATUSBAR_HEIGHT))

// iPhone statusbar 高度
#define PHONE_STATUSBAR_HEIGHT      (iPhoneX == true ? 44.0f : 20.0f)
// iPhone 默认导航条高度
#define PHONE_NAVIGATIONBAR_HEIGHT  44
// 判断是否是iphoneX
#define iPhoneX  ([[UIApplication sharedApplication] statusBarFrame].size.height == 20 ? NO : YES)
#define PHONE_NAVIGATIONBARWITHSTATUS_HEIGHT (iPhoneX == true ? 88.0f : 64.0f)

// iPhone 默认TabBar高度
#define PHONE_TABBAR_HEIGHT     (iPhoneX == true ? (34.f) : 0)

#define VIEW_HEIGHT (SCREEN_HEIGHT - PHONE_STATUSBAR_HEIGHT - PHONE_NAVIGATIONBAR_HEIGHT - PHONE_TABBAR_HEIGHT)

#define VIEW_HIDETABBAR_HEIGHT     (SCREEN_HEIGHT - PHONE_NAVIGATIONBAR_HEIGHT - PHONE_STATUSBAR_HEIGHT)
// 键盘高度
#define KEYBOARDHEIGHT              216

#define PHONE5_WIDTH                320.0
#define PHONE5_HEIGHT               568.0
#define PHONE6_WIDTH                375.0
#define PHONE6P_WIDTH               414.0
#define PHONEX_WIDTH                375.0
#define PHONEX_HEIGHT               812.0

// 6p列表图片的缩放因子
#define IMAGE_PHONE6P_SCALE          (PHONE6P_WIDTH / PHONE6_WIDTH)
#define IMAGE_PHONE6_SCALE           1

// 6p间距的缩放因子
#define MARGIN_PHONE6P_SCALE         (PHONE6P_WIDTH / PHONE6_WIDTH)
#define MARGIN_PHONE6_SCALE          1

/// 分割线宽
#define SEPERATOR_LINE_WIDTH            0.5
#define SEPERATOR_LINE_HEIGHT           0.5
#define YM_SIZE_SCALE(size)             ((size) * [YMAdaptiveManager sizeAllScale])
#define YM_SIZE_SCALE_IS5(size, sizeOfIphone5)             (([UIDevice isPhone5] ? sizeOfIphone5 : size ) * [YMAdaptiveManager marginScale])
#define MARGIN_SCALE(size)              ((size) * [YMAdaptiveManager marginScale])
#define MARGIN_SCALE_ALL(size)          ((size) * [YMAdaptiveManager sizeAllScale])

#define kAutoCountX(width) (SCREEN_WIDTH - width) * 0.5
#define kGray236 [UIColor colorWithRed:236 / 255.0 green:236 / 255.0 blue:236 / 255.0 alpha:1]



// 共通的size
/// 零(用于CGFloat初始化,frame的起始原点),所有需要用0表示的常量
#define ZERO_ORIGIN                      0
/// 分割线宽
#define HEIGHT_SEPERATOR_LINE           0.5

// 按钮的圆角
#define CORNER_RADIUS_LARGER      MARGIN_SCALE(3)
// 按钮的圆角
#define CORNER_RADIUS_SMALL      MARGIN_SCALE(1)

#define YM_COMMOM_MAGIN              MARGIN_SCALE(12)

#define YM_PAGE_SIZE     10
#endif /* YMSizeConstant_h */
