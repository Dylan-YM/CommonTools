//
//  OutdoorWeatherManager.h
//  AirTouch
//
//  Created by kenny on 15/10/20.
//  Copyright (c) 2015年 Honeywell. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kNotification_RefreshWeatherNowFinished @"kNotification_RefreshWeatherNowFinished"
#define kNotification_RefreshWeatherAirFinished @"kNotification_RefreshWeatherAirFinished"
#define kNotification_RefreshWeatherDetailFinished @"kNotification_RefreshWeatherDetailFinished"

@class OutdoorWeatherNowModel;

@interface OutdoorWeatherManager : NSObject

-(void)addCityCodeAndLoadData:(NSString *)cityCode;
-(void)removeCityCode:(NSString *)cityCode;

-(void)loadDetailWeather:(NSString *)cityCode;

+(id)instance;

//now weather
-(OutdoorWeatherNowModel *)outdoorWeatherNowModelWithCityCode:(NSString *)cityCode;

//Detail weather
-(NSArray *)outdoorTodayWeatherArrayWithCityCode:(NSString *)cityCode;
-(NSArray *)outdoorThisWeekWeatherArrayWithCityCode:(NSString *)cityCode;
-(NSDictionary *)outdoorTodayHighAndLowTemperatureWithCityCode:(NSString *)cityCode;

@end
