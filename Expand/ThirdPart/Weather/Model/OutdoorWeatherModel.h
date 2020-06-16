//
//  OutdoorWeatherModel.h
//  AirTouch
//
//  Created by kenny on 15/10/9.
//  Copyright (c) 2015年 Honeywell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, HWWeatherType) {
    HWWeatherTypeSunny,//晴
    HWWeatherTypeSunnyNight,//晴(夜)
    HWWeatherTypeCloudy,//多云
    HWWeatherTypePartlyCloudy,//晴间多云
    HWWeatherTypePartlyCloudyNight,//晴间多云(夜)
    HWWeatherTypePartlyMostlyCloudy,//大部多云
    HWWeatherTypePartlyMostlyCloudyNight,//大部多云(夜)
    HWWeatherTypeOvercast,//阴
    HWWeatherTypeShower,//阵雨
    HWWeatherTypeThunderShower,//雷阵雨
    HWWeatherTypeThunderShowerWithHail,//雷阵雨夹冰雹
    HWWeatherTypeRainy,//大中小雨
    HWWeatherTypeStorm,//暴雨
    HWWeatherTypeIceRain,//冻雨，雨夹雪
    HWWeatherTypeSnowFlurry,//阵雪
    HWWeatherTypeSnow,//各种雪
    HWWeatherTypeDust,//浮尘
    HWWeatherTypeDustStorm,//沙尘暴
    HWWeatherTypeFoggy,//雾
    HWWeatherTypeHaze,//霾
    HWWeatherTypeWindy,//风
    HWWeatherTypeUnknown,//未知
    HWWeatherTypeInvalid
};

@interface OutdoorWeatherBaseModel : NSObject

- (HWWeatherType)weatherTypeFromCode:(NSString *)code;
    
- (NSString *)displayWeatherDesc:(NSString *)code;

@end

@protocol OutdoorWeatherModelDelegate <NSObject>
@required
-(id)initWithDictionary:(NSDictionary *)params;
@optional
-(NSString *)iconName;

@end

@class HWWeatherNowAPIManager;
@class OutdoorWeatherNowModel;
@interface OutdoorWeatherModel : NSObject

@property (nonatomic, strong) NSArray *future24HArray;
@property (nonatomic, strong) NSArray *future7DArray;
@property (nonatomic, strong) OutdoorWeatherNowModel *nowModel;
@property (nonatomic, assign) int airSuccess;
@property (nonatomic, assign) int future24HSuccess;
@property (nonatomic, assign) int future7DSuccess;
@property (nonatomic, strong) HWWeatherNowAPIManager *nowAPIManager;

-(NSArray *)getTodayWeatherArray;
-(void)resetSuccessAndFailCount;
@end

@interface OutdoorWeatherNowModel : OutdoorWeatherBaseModel<OutdoorWeatherModelDelegate>
@property (nonatomic, copy) NSString *airPressure;
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *temperature;
@property (nonatomic, copy) NSString *aqi;
@property (nonatomic, copy) NSString *pm25;
@property (nonatomic, copy) NSString *high;
@property (nonatomic, copy) NSString *low;
@property (nonatomic, copy) NSString *wind;

- (UIColor *)getMadAirPM25ValueTextColor;
- (UIColor *)getPM25ValueTextColor;
- (UIColor *)getAqiValueTextColor;
    
- (NSString *)getWeatherDesc;

- (NSDictionary *)convertToDictionary;

@end

@interface OutdoorWeatherHourModel : OutdoorWeatherBaseModel<OutdoorWeatherModelDelegate>
@property (nonatomic, assign) long long time;//utc
@property (nonatomic, copy) NSString *temperature;
@property (nonatomic, assign) NSInteger code;
@property (nonatomic, strong) NSString *timeString;

@end

@interface OutdoorWeatherDayModel : OutdoorWeatherBaseModel<OutdoorWeatherModelDelegate>
@property (nonatomic, assign) long long date;
@property (nonatomic, assign) NSInteger code;
@property (nonatomic, copy) NSString *high;
@property (nonatomic, copy) NSString *low;
@property (nonatomic, strong) NSString *dateString;
@end
