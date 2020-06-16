//
//  OutdoorWeatherModel.m
//  AirTouch
//
//  Created by kenny on 15/10/9.
//  Copyright (c) 2015年 Honeywell. All rights reserved.
//

#import "OutdoorWeatherModel.h"
#import "HWWeatherNowAPIManager.h"
#import "AppMarco.h"
#import "DateTimeUtil.h"

@implementation OutdoorWeatherBaseModel

- (HWWeatherType)weatherTypeFromCode:(NSString *)code {
    switch (code.intValue)
    {
        case 0:
        case 2:
        case 38:
            return HWWeatherTypeSunny;
        case 1:
        case 3:
            return HWWeatherTypeSunnyNight;
        case 4:
            return HWWeatherTypeCloudy;
        case 5:
            return HWWeatherTypePartlyCloudy;
        case 6:
            return HWWeatherTypePartlyCloudyNight;
        case 7:
            return HWWeatherTypePartlyMostlyCloudy;
        case 8:
            return HWWeatherTypePartlyMostlyCloudyNight;
        case 9:
        case 37:
            return HWWeatherTypeOvercast;
        case 10:
            return HWWeatherTypeShower;
        case 11:
            return HWWeatherTypeThunderShower;
        case 12:
            return HWWeatherTypeThunderShowerWithHail;
        case 13:
        case 14:
        case 15:
            return HWWeatherTypeRainy;
        case 16:
        case 17:
        case 18:
            return HWWeatherTypeStorm;
        case 19:
        case 20:
            return HWWeatherTypeIceRain;
        case 21:
            return HWWeatherTypeSnowFlurry;
        case 22:
        case 23:
        case 24:
        case 25:
            return HWWeatherTypeSnow;
        case 26:
        case 27:
            return HWWeatherTypeDust;
        case 28:
        case 29:
            return HWWeatherTypeDustStorm;
        case 30:
            return HWWeatherTypeFoggy;
        case 31:
            return HWWeatherTypeHaze;
        case 32:
        case 33:
        case 34:
        case 35:
        case 36:
            return HWWeatherTypeWindy;
        case 39:
            return HWWeatherTypeUnknown;
        default:
            return HWWeatherTypeInvalid;
    }
}

- (NSString *)displayWeatherDesc:(NSString *)code {
    switch (code.intValue)
    {
        case 0:
            return NSLocalizedString(@"outdoorinfo_weather_sunny", nil);
        case 1:
            return NSLocalizedString(@"outdoorinfo_weather_clear", nil);
        case 2:
        case 3:
            return NSLocalizedString(@"outdoorinfo_weather_fair", nil);
        case 4:
            return NSLocalizedString(@"outdoorinfo_weather_cloudy", nil);
        case 5:
        case 6:
            return NSLocalizedString(@"outdoorinfo_weather_partlycloudy", nil);
        case 7:
        case 8:
            return NSLocalizedString(@"outdoorinfo_weather_mostlycloudy", nil);
        case 9:
            return NSLocalizedString(@"outdoorinfo_weather_overcast", nil);
        case 10:
            return NSLocalizedString(@"outdoorinfo_weather_shower", nil);
        case 11:
            return NSLocalizedString(@"outdoorinfo_weather_thundershower", nil);
        case 12:
            return NSLocalizedString(@"outdoorinfo_weather_thundershowerwithhail", nil);
        case 13:
            return NSLocalizedString(@"outdoorinfo_weather_lightrain", nil);
        case 14:
            return NSLocalizedString(@"outdoorinfo_weather_moderaterain", nil);
        case 15:
            return NSLocalizedString(@"outdoorinfo_weather_heavyrain", nil);
        case 16:
            return NSLocalizedString(@"outdoorinfo_weather_storm", nil);
        case 17:
            return NSLocalizedString(@"outdoorinfo_weather_heavystorm", nil);
        case 18:
            return NSLocalizedString(@"outdoorinfo_weather_severestorm", nil);
        case 19:
            return NSLocalizedString(@"outdoorinfo_weather_icerain", nil);
        case 20:
            return NSLocalizedString(@"outdoorinfo_weather_sleet", nil);
        case 21:
            return NSLocalizedString(@"outdoorinfo_weather_snowflurry", nil);
        case 22:
            return NSLocalizedString(@"outdoorinfo_weather_lightsnow", nil);
        case 23:
            return NSLocalizedString(@"outdoorinfo_weather_moderatesnow", nil);
        case 24:
            return NSLocalizedString(@"outdoorinfo_weather_heavysnow", nil);
        case 25:
            return NSLocalizedString(@"outdoorinfo_weather_snowstorm", nil);
        case 26:
            return NSLocalizedString(@"outdoorinfo_weather_dust", nil);
        case 27:
            return NSLocalizedString(@"outdoorinfo_weather_sand", nil);
        case 28:
            return NSLocalizedString(@"outdoorinfo_weather_duststorm", nil);
        case 29:
            return NSLocalizedString(@"outdoorinfo_weather_sandstorm", nil);
        case 30:
            return NSLocalizedString(@"outdoorinfo_weather_foggy", nil);
        case 31:
            return NSLocalizedString(@"outdoorinfo_weather_haze", nil);
        case 32:
            return NSLocalizedString(@"outdoorinfo_weather_windy", nil);
        case 33:
            return NSLocalizedString(@"outdoorinfo_weather_blustery", nil);
        case 34:
            return NSLocalizedString(@"outdoorinfo_weather_hurricane", nil);
        case 35:
            return NSLocalizedString(@"outdoorinfo_weather_tropicalstorm", nil);
        case 36:
            return NSLocalizedString(@"outdoorinfo_weather_tornado", nil);
        case 37:
            return NSLocalizedString(@"outdoorinfo_weather_cold", nil);
        case 38:
            return NSLocalizedString(@"outdoorinfo_weather_hot", nil);
        default:
            return NSLocalizedString(@"outdoorinfo_weather_unkown", nil);
    }
}

@end

@implementation OutdoorWeatherModel
@synthesize future24HArray;

-(instancetype)init
{
    if (self = [super init]) {
        [self resetSuccessAndFailCount];
    }
    return self;
}

-(void)resetSuccessAndFailCount
{
    _airSuccess = -1;
    _future24HSuccess = -1;
    _future7DSuccess = -1;
}

-(NSArray *)getTodayWeatherArray {
    if (future24HArray.count == 0) {
        return nil;
    }
    NSMutableArray *todayWeatherArray = [[NSMutableArray alloc]init];
    
    [todayWeatherArray addObjectsFromArray:future24HArray];
    
    return todayWeatherArray;
}

- (HWWeatherNowAPIManager *)nowAPIManager {
    if (_nowAPIManager == nil) {
        _nowAPIManager = [[HWWeatherNowAPIManager alloc] init];
    }
    return _nowAPIManager;
}

- (void)cancelHttpRequest {
    [self.nowAPIManager cancel];
    self.nowAPIManager = nil;
}

- (void)dealloc {
    [self cancelHttpRequest];
}

@end

@implementation OutdoorWeatherNowModel
@synthesize code,temperature,airPressure,aqi,pm25,high,low,wind;
-(NSString *)iconName
{
    HWWeatherType weatherType = [self weatherTypeFromCode:code];
    switch (weatherType)
    {
        case HWWeatherTypeSunny:
        {
            return @"sunny";
        }
        case HWWeatherTypeSunnyNight:
        {
            return @"sunny_night";
        }
        case HWWeatherTypeCloudy:
        case HWWeatherTypePartlyMostlyCloudy:
        {
            return @"Cloudy";
        }
        case HWWeatherTypePartlyCloudy:
        {
            return @"partly Cloudy";
        }
        case HWWeatherTypePartlyCloudyNight:
        {
            return @"partly Cloudy_night";
        }
        case HWWeatherTypePartlyMostlyCloudyNight:
        {
            return @"Cloudy_night";
        }
        case HWWeatherTypeOvercast:
        {
            return @"Overcast";
        }
        case HWWeatherTypeShower:
        {
            return @"shower";
        }
        case HWWeatherTypeThunderShower:
        {
            return @"Thundershower";
        }
        case HWWeatherTypeThunderShowerWithHail:
        {
            return @"Thundershower  with Hail";
        }
        case HWWeatherTypeRainy:
        {
            return @"Rain";
        }
        case HWWeatherTypeStorm:
        {
            return @"Storm";
        }
        case HWWeatherTypeIceRain:
        {
            return @"Sleet";
        }
        case HWWeatherTypeSnowFlurry:
        {
            return @"snow flurry";
        }
        case HWWeatherTypeSnow:
        {
            return @"Heavy snow";
        }
        case HWWeatherTypeDust:
        {
            return @"Dust";
        }
        case HWWeatherTypeDustStorm:
        {
            return @"Duststorm";
        }
        case HWWeatherTypeFoggy:
        {
            return @"fog";
        }
        case HWWeatherTypeHaze:
        {
            return @"Haze";
        }
        case HWWeatherTypeWindy:
        {
            return @"windy";
        }
        case HWWeatherTypeUnknown:
        {
            return @"unknow";
        }
        default:
        {
            break;
        }
    }
    return @"sunny";
}

-(instancetype)init
{
    if (self = [super init]) {
        temperature = @"";
        airPressure = @"";
        code = @"";
        aqi = @"";
        pm25 = @"";
        high = @"";
        low = @"";
        wind = @"";
    }
    
    return self;
}

-(id)initWithDictionary:(NSDictionary *)params
{
    self = [self init];
    if (self) {
        if ([params.allKeys containsObject:@"airPressure"]) {
            airPressure = params[@"airPressure"];
        }
        if ([params.allKeys containsObject:@"code"]) {
            code = params[@"code"];
        }
        if ([params.allKeys containsObject:@"temperature"]) {
            temperature = params[@"temperature"];
        }
        if ([params.allKeys containsObject:@"aqi"]) {
            aqi = params[@"aqi"];
        }
        if ([params.allKeys containsObject:@"pm25"]) {
            pm25 = params[@"pm25"];
        }
        if ([params.allKeys containsObject:@"high"]) {
            high = params[@"high"];
        }
        if ([params.allKeys containsObject:@"low"]) {
            low = params[@"low"];
        }
        if ([params.allKeys containsObject:@"wind"]) {
            wind = params[@"wind"];
        }
    }
    
    return self;
}
    
- (NSString *)getWeatherDesc {
    return [self displayWeatherDesc:code];
}

- (UIColor *)getMadAirPM25ValueTextColor {
    NSInteger pm25Value = [pm25 integerValue];
    if (pm25Value <= 75) {
        return Hplus_Color_Font_White;
    } else if (pm25Value > 75 && pm25Value <= 150) {
        return Hplus_Color_Yellow1;
    } else {
        return Hplus_Color_Red1;
    }
}

- (UIColor *)getPM25ValueTextColor {
    NSInteger pm25Value = [pm25 integerValue];
    if (pm25Value <= 75) {
        return Hplus_Color_Blue1;
    } else if (pm25Value > 75 && pm25Value <= 150) {
        return Hplus_Color_Yellow1;
    } else {
        return Hplus_Color_Red1;
    }
}

- (UIColor *)getAqiValueTextColor {
    NSInteger aqiValue = [aqi integerValue];
    if (aqiValue <= 75) {
        return Hplus_Color_Blue1;
    } else if (aqiValue > 75 && aqiValue <= 150) {
        return Hplus_Color_Yellow1;
    } else {
        return Hplus_Color_Red1;
    }
}

- (NSDictionary *)convertToDictionary {
    return @{
             @"airPressure":airPressure,
             @"code":@([code integerValue]),
             @"temperature":temperature,
             @"aqi":aqi,
             @"pm25":pm25,
             @"high":high,
             @"low":low,
             @"wind":wind
             };
}

@end

@implementation OutdoorWeatherHourModel
@synthesize temperature,code,timeString;

-(NSString *)iconName
{
    HWWeatherType weatherType = [self weatherTypeFromCode:[NSString stringWithFormat:@"%ld",(long)code]];
    switch (weatherType)
    {
        case HWWeatherTypeSunny:
        {
            return @"sunny_white";
        }
        case HWWeatherTypeSunnyNight:
        {
            return @"sunny_night_white";
        }
        case HWWeatherTypeCloudy:
        case HWWeatherTypePartlyMostlyCloudy:
        {
            return @"Cloudy_white";
        }
        case HWWeatherTypePartlyCloudy:
        {
            return @"partly Cloudy_white";
        }
        case HWWeatherTypePartlyCloudyNight:
        {
            return @"partly Cloudy_night_white";
        }
        case HWWeatherTypePartlyMostlyCloudyNight:
        {
            return @"Cloudy_night_white";
        }
        case HWWeatherTypeOvercast:
        {
            return @"Overcast_white";
        }
        case HWWeatherTypeShower:
        {
            return @"shower_white";
        }
        case HWWeatherTypeThunderShower:
        {
            return @"Thundershower_white";
        }
        case HWWeatherTypeThunderShowerWithHail:
        {
            return @"Thundershower  with Hail_white";
        }
        case HWWeatherTypeRainy:
        {
            return @"Rain_white";
        }
        case HWWeatherTypeStorm:
        {
            return @"Storm_white";
        }
        case HWWeatherTypeIceRain:
        {
            return @"Sleet_white";
        }
        case HWWeatherTypeSnowFlurry:
        {
            return @"snow flurry_white";
        }
        case HWWeatherTypeSnow:
        {
            return @"Heavy snow_white";
        }
        case HWWeatherTypeDust:
        {
            return @"Dust_white";
        }
        case HWWeatherTypeDustStorm:
        {
            return @"Duststorm_white";
        }
        case HWWeatherTypeFoggy:
        {
            return @"fog_white";
        }
        case HWWeatherTypeHaze:
        {
            return @"Haze_white";
        }
        case HWWeatherTypeWindy:
        {
            return @"windy_white";
        }
        case HWWeatherTypeUnknown:
        {
            return @"unknow_white";
        }
        default:
        {
            break;
        }
    }
    return @"sunny_white";
}

-(instancetype)init
{
    if (self = [super init]) {
        temperature = @"";
        timeString = @"";
    }
    
    return self;
}

-(id)initWithDictionary:(NSDictionary *)params
{
    self = [self init];
    if (self) {
        if ([params.allKeys containsObject:@"code"]) {
            code = [params[@"code"] integerValue];
        }
        if ([params.allKeys containsObject:@"temperature"]) {
            temperature = params[@"temperature"];
        }
        if ([params.allKeys containsObject:@"time"]) {
            _time = [params[@"time"] longLongValue];
            timeString = [DateTimeUtil getHHStringWithLongDate:_time];
        }
    }
    
    return self;
}
@end

@implementation OutdoorWeatherDayModel
@synthesize date,code,high,low,dateString;

-(NSString *)iconName
{
    HWWeatherType weatherType = [self weatherTypeFromCode:[NSString stringWithFormat:@"%ld",(long)code]];
    switch (weatherType)
    {
        case HWWeatherTypeSunny:
        {
            return @"sunny_white";
        }
        case HWWeatherTypeSunnyNight:
        {
            return @"sunny_night_white";
        }
        case HWWeatherTypeCloudy:
        case HWWeatherTypePartlyMostlyCloudy:
        {
            return @"Cloudy_white";
        }
        case HWWeatherTypePartlyCloudy:
        {
            return @"partly Cloudy_white";
        }
        case HWWeatherTypePartlyCloudyNight:
        {
            return @"partly Cloudy_night_white";
        }
        case HWWeatherTypePartlyMostlyCloudyNight:
        {
            return @"Cloudy_night_white";
        }
        case HWWeatherTypeOvercast:
        {
            return @"Overcast_white";
        }
        case HWWeatherTypeShower:
        {
            return @"shower_white";
        }
        case HWWeatherTypeThunderShower:
        {
            return @"Thundershower_white";
        }
        case HWWeatherTypeThunderShowerWithHail:
        {
            return @"Thundershower  with Hail_white";
        }
        case HWWeatherTypeRainy:
        {
            return @"Rain_white";
        }
        case HWWeatherTypeStorm:
        {
            return @"Storm_white";
        }
        case HWWeatherTypeIceRain:
        {
            return @"Sleet_white";
        }
        case HWWeatherTypeSnowFlurry:
        {
            return @"snow flurry_white";
        }
        case HWWeatherTypeSnow:
        {
            return @"Heavy snow_white";
        }
        case HWWeatherTypeDust:
        {
            return @"Dust_white";
        }
        case HWWeatherTypeDustStorm:
        {
            return @"Duststorm_white";
        }
        case HWWeatherTypeFoggy:
        {
            return @"fog_white";
        }
        case HWWeatherTypeHaze:
        {
            return @"Haze_white";
        }
        case HWWeatherTypeWindy:
        {
            return @"windy_white";
        }
        case HWWeatherTypeUnknown:
        {
            return @"unknow_white";
        }
        default:
        {
            break;
        }
    }
    return @"sunny_white";
}

-(instancetype)init
{
    if (self = [super init]) {
        high = @"";
        low = @"";
        dateString = @"";
    }
    
    return self;
}

-(id)initWithDictionary:(NSDictionary *)params
{
    self = [self init];
    if (self) {
        if ([params.allKeys containsObject:@"date"]) {
            date = [params[@"date"] longLongValue];
            dateString = [DateTimeUtil getWeekdayFromLongDate:date];
        }
        if ([params.allKeys containsObject:@"code"]) {
            code = [params[@"code"] integerValue];
        }
        if ([params.allKeys containsObject:@"high"]) {
            high = params[@"high"];
        }
        if ([params.allKeys containsObject:@"low"]) {
            low = params[@"low"];
        }
    }
    
    return self;
}

@end
