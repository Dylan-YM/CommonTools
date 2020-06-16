//
//  YMColorConstant.h
//  thirdDemo
//
//  Created by Richard on 2018/3/13.
//  Copyright © 2018年 Richard. All rights reserved.
//

#ifndef YMColorConstant_h
#define YMColorConstant_h
#import "UIColor+YMAddition.h"
// 主色调      #69af00
#define COLOR_YM_MAIN             [UIColor YM_colorFromHex:0xeb4d3f]
// 主题模块背景  #ffffff
#define COLOR_MAIN_BG                 [UIColor YM_colorFromHex:0xffffff]

// 辅色
// 价格数字及可点击按钮（付款）.橙色给人安全感     #fa6400
#define COLOR_IMPORTMENT_INFO         [UIColor YM_colorFromHex:0xfa6400]

// 消息及重要提醒：红色给人警示的感觉 #fa3b00
#define COLOR_WARNING_RED             [UIColor YM_colorFromHex:0xfa3b00]

// 导航 标题文字：稳重的黑色，可用作导航标题文字
#define COLOR_TITLE                   [UIColor YM_colorFromHex:0x000000]

// 模块标题文字：渐沉岩黑色，可用作模块标题文字     #323232
#define COLOR_SECOND_TITLE            [UIColor YM_colorFromHex:0x323232]

// 深灰色灰       #646464
#define COLOR_HALF_GRAY               [UIColor YM_colorFromHex:0x646464]

// 中灰色       #969696
#define COLOR_LIGHT_GRAY              [UIColor YM_colorFromHex:0x969696]


// 模块分割线：轻素的浅灰色用作搭配及展示型文字的颜色  #dcdcdc
#define COLOR_SEPARATOR_LINE          [UIColor YM_colorFromHex:0xdcdcdc]

// app背景色：素灰色的背景，有效降低屏幕色彩适配风险     #f0f0f0
#define COLOR_GRAY_BACKGROUND         [UIColor YM_colorFromHex:0xf0f0f0]
#define COLOR_BACKGROUND              [UIColor YM_colorFromHex:0xf4f4f4]
// app背景色：重要按钮触摸状态的背景，有效降低屏幕色彩适配风险     #5e9d00
#define COLOR_TOUCH_IMPORTANT_BACKGROUND         [UIColor YM_colorFromHex:0x5e9d00]

// app背景色：一般按钮触摸状态的背景，有效降低屏幕色彩适配风险     #f0f7e5
#define COLOR_TOUCH_COMMONLY_BACKGROUND          [UIColor YM_colorFromHex:0xf0f7e5]

// 占位图默认颜色  #c8c8c8
#define COLOR_IMAGEVIEW_BGCOLOR       [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1.0]

//淡绿
#define COLOR_LIGHT_GREEN             [UIColor YM_colorFromHex:0xa8d10a]

//淡红
#define COLOR_LIGHT_RED               [UIColor YM_colorFromHex:0xff0000]

#define COLOR_SELECTED_BACKGROUD      [UIColor YM_colorFromHex:0x68b000]
#define COLOR_SPACE_BACKGROUD         [UIColor YM_colorFromHex:0xeaeaea]
#define COLOR_FRESH_ADRRESS           [UIColor YM_colorFromHex:0xf5f5f5]

// 会员制追加的颜色
#define COLOR_VIP_EXPIRE_REMIND       [UIColor YM_colorFromHex:0xce0000]
#define COLOR_VIP_FLAG_BACKGROUND     [UIColor YM_colorFromHex:0x3d2800]
#define COLOR_VIP_FONT                [UIColor YM_colorFromHex:0xffe8b6]

#define COLOR_BLACK_32                [UIColor YM_colorFromHex:0x303030]
#define COLOR_GRAY_E9                 [UIColor YM_colorFromHex:0xe9e9e9]

#define COLOR_ORANGE                  [UIColor YM_colorFromHex:0xff6600]

#define COLOR_VALIVIEW_CANCEL          [UIColor YM_colorFromHex:0x5e605a]
#define COLOR_VALIVIEW_CONFORIM        [UIColor YM_colorFromHex:0x79ad33]
#define COLOR_VALIVIEW_CONFORIM_UNENABLE [UIColor YM_colorFromHex:0xcccccc]

//  键盘上方inputAccessoryView视图的颜色
#define YMCOLOR_INPUTACCESSORYVIEW          [UIColor YM_colorFromHex:0x8c8c8c]

#define COLOR_LINE                     [UIColor YM_colorFromHex:0xbebebe]

// 找回密码，立即注册
#define COLOR_SDS_CANCLICK             [UIColor YM_colorFromHex:0x666666]
#define CPLOR_REGISTER_HEAD            [UIColor YM_colorFromHex:0xf4f4f4]
#define CPLOR_REGISTER_STORE            [UIColor YM_colorFromHex:0x999999]
#define CPLOR_REGISTER_AUTHCODE        [UIColor YM_colorFromHex:0xf3f3f3]
#define CPLOR_REGISTER_BUTTON         [UIColor YM_colorFromHex:0xeb4c40]
// 确定登录
#define COLOR_SDS_FILL             [UIColor YM_colorFromHex:0x2c2c2c]
#define random(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)/255.0]
#define COLOR_RANDOM random(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))



//仁美

// 仁美主要背景色
#define COLOR_RM_BG         [UIColor YM_colorFromHex:0xF4F5F7]

// 仁美主要标题
#define COLOR_RM_TITLE         [UIColor YM_colorFromHex:0x333333]
// 仁美账户 二级标题
#define COLOR_RM_SECEND_TITLE       [UIColor YM_colorFromHex:0xAAAAAA]
// 仁美按钮主要背景色
#define COLOR_RM_BTN_BG         [UIColor YM_colorFromHex:0xE03E50]

// 仁美主要分割线
#define COLOR_RM_SEPARATOR_LINE        [UIColor YM_colorFromHex:0xdddddd]
// 仁美次要分割线
#define COLOR_RM_SECEND_SEPARATOR_LINE        [UIColor YM_colorFromHex:0xeeeeeee]

// 仁美 绿色主题色
#define COLOR_RM_GREEN     [UIColor YM_colorFromHex:0x00CC99]
// 仁美账户右边按钮
#define COLOR_RM_ACCOUNT_RIGHT_ITEM       [UIColor YM_colorFromHex:0x4F515B]
// 仁美账户按钮失效颜色
#define COLOR_RM_DISABLE_BTN      [UIColor YM_colorFromHex:0xB5B6BC]

// 仁美账户 金额颜色
#define COLOR_RM_CUSTOM_PRICE     [UIColor YM_colorFromHex:0xA49276]

// 仁美账户 账户累计颜色
#define COLOR_RM_ACCOUNT_PRICE     [UIColor YM_colorFromHex:0xFF6666]

// 仁美账户 直播下评论字体
#define COLOR_RM_COMMENT_NAME    [UIColor YM_colorFromHex:0x5D6991]

// 仁美账户 直播下评论字体
#define COLOR_RM_DARK_GRAY    [UIColor YM_colorFromHex:0xEEEFF2]
// 仁美账户 评论下颜色
#define COLOR_RM_COMMENT_ACCOUNT  [UIColor YM_colorFromHex:0x5D6991]

// 仁美账户 仁美名师 标题
#define COLOR_RM_TEACHER_ICON  [UIColor YM_colorFromHex:0xC29E9E]




//Hpro  UK

#define COLOR_UK_ACCOUNT_BLUE  [UIColor YM_colorFromHex:0x2191FC]

#define COLOR_UK_REGIST_SUCCESS_BLUE  [UIColor YM_colorFromHex:0x1274B7]
#define COLOR_UK_COMMON_NEXT_BLUE  [UIColor YM_colorFromHex:0x1780C9]
#define COLOR_UK_RESEND_DISABLE_BLUE  [UIColor YM_colorFromHex:0x81BBFC]

#define COLOR_UK_DISABLE_NEXT_BLUE  [UIColor YM_colorFromHex:0x93C1E5]
#define COLOR_UK_DISABLE_NEXT_LABEL_BLUE  [UIColor YM_colorFromHex:0xB8D7ED]
#define COLOR_UK_ALERT_BACK_GRAY  [UIColor YM_colorFromHex:0xF2F2F2]
#define COLOR_UK_ALERT_TITLE_BLUE  [UIColor YM_colorFromHex:0x007AFF]

#define COLOR_UK_ALERT_LINE_GRAY  [UIColor YM_colorFromHex:0x3C3C43]


#endif /* YMColorConstant_h */
