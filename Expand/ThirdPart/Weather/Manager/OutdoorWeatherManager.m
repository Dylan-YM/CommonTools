//
//  OutdoorWeatherManager.m
//  AirTouch
//
//  Created by kenny on 15/10/20.
//  Copyright (c) 2015年 Honeywell. All rights reserved.
//

#import "OutdoorWeatherManager.h"
#import "OutdoorWeatherModel.h"
#import "LogUtil.h"
#import "UserConfig.h"
#import "DateTimeUtil.h"
#import "TimerUtil.h"
#import "HWWeatherNowAPIManager.h"
#import "HWWeatherFutureAPIManager.h"

#define kMaxFreshFailedCount 5
#define kOutdoorWeatherRefreshElapse (30*60)

@interface OutdoorWeatherManager()

@property (strong, nonatomic) NSMutableDictionary<NSString *, OutdoorWeatherModel *> *weathers;
@property (strong, nonatomic) HWWeatherNowAPIManager    *nowAPIManager;
@property (strong, nonatomic) HWWeatherFutureAPIManager *futureAPIManager;

@end
@implementation OutdoorWeatherManager

#pragma mark - Life Cycle
+(id)instance
{
    static OutdoorWeatherManager * weatherManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        weatherManager = [[OutdoorWeatherManager alloc] init];
    });
    return weatherManager;
}

-(instancetype)init
{
    if (self = [super init]) {
        self.weathers = [[NSMutableDictionary alloc]init];
        
        [TimerUtil scheduledDispatchTimerWithName:@"OutDoorTimer" timeInterval:kOutdoorWeatherRefreshElapse repeats:YES action:^{
            [self reloadData];
        }];
    }
    return self;
}

#pragma mark - Public Methods
-(void)addCityCodeAndLoadData:(NSString *)cityCode
{
    if (self.weathers[cityCode] == nil) {
        OutdoorWeatherModel *outWeatherModel = [[OutdoorWeatherModel alloc]init];
        [self.weathers setObject:outWeatherModel forKey:cityCode];
        
        [self loadDataWithCityCode:cityCode];
    }
}

-(void)removeCityCode:(NSString *)cityCode
{
    if (self.weathers[cityCode]) {
        [self.weathers removeObjectForKey:cityCode];
    }
}

-(void)loadDetailWeather:(NSString *)cityCode {
    OutdoorWeatherModel *outdoorWeatherModel = _weathers[cityCode];
    [outdoorWeatherModel resetSuccessAndFailCount];
    [self loadNowWeatherDataWithCityCode:cityCode withBlock:^(id object, NSError *error) {
        outdoorWeatherModel.airSuccess = (error == nil);
        [self afterDetailWithCityCode:cityCode];
    }];
    [self loadFutureWeatherDataWithCityCode:cityCode withBlock:^(id object, NSError *error) {
        outdoorWeatherModel.future24HSuccess = (error == nil);
        outdoorWeatherModel.future7DSuccess = (error == nil);
        [self afterDetailWithCityCode:cityCode];
    }];
}

-(NSArray *)outdoorTodayWeatherArrayWithCityCode:(NSString *)cityCode
{
    OutdoorWeatherModel *outWeatherModel = _weathers[cityCode];
    if (outWeatherModel) {
        return [outWeatherModel getTodayWeatherArray];
    }
    return nil;
}

-(NSArray *)outdoorThisWeekWeatherArrayWithCityCode:(NSString *)cityCode
{
    OutdoorWeatherModel *outWeatherModel = _weathers[cityCode];
    if (outWeatherModel) {
        return outWeatherModel.future7DArray;
    }
    return nil;
}

-(NSDictionary *)outdoorTodayHighAndLowTemperatureWithCityCode:(NSString *)cityCode
{
    NSArray * array = [self outdoorThisWeekWeatherArrayWithCityCode:cityCode];
    if (array) {
        OutdoorWeatherDayModel *todayWeatherDayModel = [array firstObject];
        if (todayWeatherDayModel) {
            return [[NSDictionary alloc]initWithObjectsAndKeys:todayWeatherDayModel.high, @"high", todayWeatherDayModel.low, @"low", nil];
        }else {
            return nil;
        }
    } else {
        return nil;
    }
}

-(OutdoorWeatherNowModel *)outdoorWeatherNowModelWithCityCode:(NSString *)cityCode
{
    OutdoorWeatherModel *outWeatherModel = _weathers[cityCode];
    if (outWeatherModel) {
        return outWeatherModel.nowModel;
    }
    return nil;
}

#pragma mark - Private Methods
-(void)reloadData {
    NSArray *cities = [self.weathers allKeys];
    for (NSString *cityCode in cities) {
        [self loadDataWithCityCode:cityCode];
    }
}

-(void)loadDataWithCityCode:(NSString *)cityCode
{
    [self loadNowWeatherDataWithCityCode:cityCode withBlock:^(id object, NSError *error) {
        [[NSNotificationCenter defaultCenter]postNotificationName:kNotification_RefreshWeatherNowFinished object:self userInfo:@{@"cityCode":cityCode}];
    }];
}

-(void)afterDetailWithCityCode:(NSString *)cityCode
{
    OutdoorWeatherModel *outdoorWeatherModel = _weathers[cityCode];
    int airSuccess = outdoorWeatherModel.airSuccess;
    int future24HSuccess = outdoorWeatherModel.future24HSuccess;
    int future7DSuccess = outdoorWeatherModel.future7DSuccess;

    if (airSuccess < 0
        || future24HSuccess < 0
        || future7DSuccess < 0) {
        return;
    }
    [[NSNotificationCenter defaultCenter]postNotificationName:kNotification_RefreshWeatherDetailFinished object:self userInfo:@{@"cityCode":cityCode}];
}

#pragma mark - API Relatived Methods
-(void)loadNowWeatherDataWithCityCode:(NSString *)city withBlock:(HWAPICallBack)callback
{
    OutdoorWeatherModel *outWeatherModel = [_weathers objectForKey:city];
    if (outWeatherModel) {
        [outWeatherModel.nowAPIManager callAPIWithParam:@{@"city":city} completion:^(id object, NSError *error) {
            if ([object isKindOfClass:[NSDictionary class]]) {
                OutdoorWeatherNowModel *outdoorWeatherNowModel = [[OutdoorWeatherNowModel alloc]initWithDictionary:object];
                
                outWeatherModel.nowModel = outdoorWeatherNowModel;
            }
            
            callback(object, error);
        }];
    } else {
        callback(nil, nil);
    }
}

-(void)loadFutureWeatherDataWithCityCode:(NSString *)city withBlock:(HWAPICallBack)callback
{
    [self.futureAPIManager callAPIWithParam:@{@"city":city} completion:^(id object, NSError *error) {
        if ([object isKindOfClass:[NSDictionary class]]) {
            NSMutableArray *future24HourWeatherArray = [[NSMutableArray alloc]init];
            NSMutableArray *future7DayWeatherArray = [[NSMutableArray alloc]init];
            
            NSArray * hours = object[@"24h"];
            
            if (hours.count > 0) {
                for (NSDictionary *dict in hours) {
                    OutdoorWeatherHourModel *outdoorWeatherModel = [[OutdoorWeatherHourModel alloc]initWithDictionary:dict];
                    [future24HourWeatherArray addObject:outdoorWeatherModel];
                }
                [LogUtil Debug:@"HK" message:@"loadFuture24H success"];
                
                OutdoorWeatherModel *outWeatherModel = [_weathers objectForKey:city];
                if (outWeatherModel) {
                    outWeatherModel.future24HArray = future24HourWeatherArray;
                }
            }
            
            NSArray *sevenDays = object[@"7d"];
            
            if (sevenDays.count > 0) {
                for (NSDictionary *dict in sevenDays) {
                    OutdoorWeatherDayModel *outdoorWeatherModel = [[OutdoorWeatherDayModel alloc]initWithDictionary:dict];
                    [future7DayWeatherArray addObject:outdoorWeatherModel];
                }
                
                OutdoorWeatherModel *outWeatherModel = [_weathers objectForKey:city];
                if (outWeatherModel) {
                    outWeatherModel.future7DArray = future7DayWeatherArray;
                }
            }
            
        }
        
        callback(object, error);
    }];
}

- (void)savePM25:(NSString *)pm25Value cityCode:(NSString *)cityCode {
    if (![cityCode isEqualToString:[UserConfig getCurrentCityCode]]) {
        return;
    }
    NSMutableDictionary *pm25Dict = [NSMutableDictionary dictionaryWithDictionary:[UserConfig getPM25]];
    NSString *dateFormat = @"yyyy-MM-dd";
    NSDate *localeDate = [DateTimeUtil getLocaleDate];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [dateFormatter setDateFormat:dateFormat];
    NSString *dateKey = [dateFormatter stringFromDate:localeDate];
    pm25Dict[dateKey] = pm25Value;

#if defined(DEBUG) && DEBUG
    pm25Dict[@"2016-12-14"] = @"180";
    pm25Dict[@"2016-12-15"] = @"77";
    pm25Dict[@"2016-12-16"] = @"21";
    pm25Dict[@"2016-12-17"] = @"96";
    pm25Dict[@"2016-12-18"] = @"0";
    pm25Dict[@"2016-12-19"] = @"44";
    pm25Dict[@"2016-12-20"] = @"99";
    pm25Dict[@"2016-12-21"] = @"44";
    pm25Dict[@"2016-12-22"] = @"109";
    pm25Dict[@"2016-12-23"] = @"60";
    pm25Dict[@"2016-12-24"] = @"77";
    pm25Dict[@"2016-12-25"] = @"158";
    pm25Dict[@"2016-12-26"] = @"14";
    pm25Dict[@"2016-12-27"] = @"13";
    pm25Dict[@"2016-12-28"] = @"29";
    pm25Dict[@"2016-12-29"] = @"99";
    pm25Dict[@"2016-12-30"] = @"147";
    pm25Dict[@"2016-12-31"] = @"147";
    pm25Dict[@"2017-01-01"] = @"29";
    pm25Dict[@"2017-01-02"] = @"155";
    pm25Dict[@"2017-01-03"] = @"277";
    pm25Dict[@"2017-01-04"] = @"311";
    pm25Dict[@"2017-01-05"] = @"35";
    pm25Dict[@"2017-01-06"] = @"63";
    pm25Dict[@"2017-01-07"] = @"24";
    pm25Dict[@"2017-01-08"] = @"20";
    pm25Dict[@"2017-01-09"] = @"100";
    pm25Dict[@"2017-01-10"] = @"400";
    pm25Dict[@"2017-01-11"] = @"7";
    pm25Dict[@"2017-01-12"] = @"78";
#endif
    
    NSArray *keys = [pm25Dict allKeys];
    for (NSString *dateString in keys) {
        if ([DateTimeUtil checkDateStringOver31DaysFromNow:dateString]) {
            [pm25Dict removeObjectForKey:dateString];
        }
    }
    [UserConfig savePM25WithInfo:pm25Dict];
}

#pragma mark - Getter
- (HWWeatherFutureAPIManager *)futureAPIManager {
    if (_futureAPIManager == nil) {
        _futureAPIManager = [[HWWeatherFutureAPIManager alloc] init];
    }
    return _futureAPIManager;
}

- (HWWeatherNowAPIManager *)nowAPIManager {
    if (_nowAPIManager == nil) {
        _nowAPIManager = [[HWWeatherNowAPIManager alloc] init];
    }
    return _nowAPIManager;
}

- (void)cancelHttpRequest {
    [self.futureAPIManager cancel];
    self.futureAPIManager = nil;
    
    [self.nowAPIManager cancel];
    self.nowAPIManager = nil;
}

@end
