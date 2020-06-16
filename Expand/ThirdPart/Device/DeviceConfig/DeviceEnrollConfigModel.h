//
//  DeviceEnrollConfigModel.h
//  HomePlatform
//
//  Created by Honeywell on 2018/9/7.
//  Copyright © 2018 Honeywell. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ENROLLMODE_BroadSL 8
#define ENROLLMODE_BroadAP 7
#define ENROLLMODE_DEVICEFIND 6
#define ENROLLMODE_AP20  5
#define ENROLLMODE_BLE   4
#define ENROLLMODE_EasyLink   3
#define ENROLLMODE_DirectBind   2
#define ENROLLMODE_SL   1
#define ENROLLMODE_AP   0
#define ENROLLMODE_NON_NETWORKING_EQUIPMENT  -1//非联网设备
#define ENROLLMODE_UNKNOWN_DEVICE_TYPE nil//未知设备

@interface DeviceEnrollConfigModel : NSObject

@property (nonatomic, strong) NSString *enrollCategory;
@property (nonatomic, strong) NSString *enrollCategoryIconString;
@property (nonatomic, strong) NSArray *enrollType;
@property (nonatomic, strong) NSString *namePlaceholder;
@property (nonatomic, strong) NSString *deviceWifiIconString;

//AP
@property (nonatomic, strong) NSString *ssid;
@property (nonatomic, assign) NSInteger apPressSconds;
@property (nonatomic, assign) NSInteger apChimeCount;
@property (nonatomic, strong) NSArray *apTips;
@property (nonatomic, strong) NSString *apTipsTitle;
@property (nonatomic, strong) NSArray *apTimeoutTips;

//Easylink
@property (nonatomic, assign) NSInteger easylinkPressSconds;
@property (nonatomic, assign) NSInteger easylinkChimeCount;
@property (nonatomic, strong) NSArray *easylinkTips;
@property (nonatomic, strong) NSString *easylinkTipsTitle;
@property (nonatomic, strong) NSArray *easylinkTimeoutTips;

//guides
@property (nonatomic, assign) NSInteger duration;
@property (nonatomic, strong) NSArray *tips;
@property (nonatomic, strong) NSString *tipsTitle;

//series
@property (nonatomic, strong) NSArray *series;

- (id)initWithDictionary:(NSDictionary *)params;

@end
