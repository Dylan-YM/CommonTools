//
//  LocationManager.m
//  AirTouch
//
//  Created by Devin on 1/19/15.
//  Copyright (c) 2015 Honeywell. All rights reserved.
//

#import "LocationManager.h"
#import "LogUtil.h"
#import "NetworkUtil.h"
#import "AppMarco.h"
#import "HWCityManager.h"
#import "HWCitySearchAPIManager.h"
#import "AppManager.h"

@interface LocationManager ()

@property (nonatomic, assign) BOOL isLocating;

@property (nonatomic, strong) HWCitySearchAPIManager *locationAPIManager;

@end

static ATResponseBlock responseBlock;
static NSTimeInterval locationTimeOutInterval=0;

@implementation LocationManager

+ (instancetype)shareLocationManager
{
    static LocationManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[LocationManager alloc] init];
    });
    return instance;
}

- (id)init
{
    self = [super init];
    if (self) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
        _isLocating = NO;
        
        _geocoder = [[CLGeocoder alloc] init];
    }
    return self;
}

- (void)startRequestLocation:(ATResponseBlock)paramBlock timeoutInterval:(NSTimeInterval)paramTimeout
{
    locationTimeOutInterval = paramTimeout;
    responseBlock = paramBlock;
    if (![NetworkUtil isReachable]) {
        [LogUtil Debug:@"Not Reachable" message:@"Not Reachable"];
        [_locationManager stopUpdatingLocation];
        self.locationResult = LocationResultError;
        [self doResponseBlockWithDictionary:@{LocationTimeout : @"No Network"} result:self.locationResult info:@"Not Reachable"];
        return;
    }
//    self.locationCoordinate = CLLocationCoordinate2DMake(0, 0);
    
    self.isBeingUpdateLocation = YES;
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    if (self.locationResult != LocationResultSuccessed) {
        self.locationResult = LocationResultInit;
        [self doResponseBlockWithDictionary:@{} result:self.locationResult info:@"LocationResultInit"];
    }
    
    if ([self canRequestLocation] != LocationEnable) {
        [LogUtil Debug:@"locationManager" message:@"startRequestLocation"];
        if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined &&
            [_locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [LogUtil Debug:@"locationManager" message:@"requestWhenInUseAuthorization"];
            [_locationManager requestWhenInUseAuthorization];
        } else {
            self.locationResult = LocationResultAuthorizationDisable;
            [self doResponseBlockWithDictionary:@{} result:self.locationResult info:@"LocationResultAuthorizationDisable"];
        }
    } else {
        self.isLocating = YES;
        [_locationManager startUpdatingLocation];
    }
    
    [LogUtil Debug:@"startLoc" message:[NSString stringWithFormat:@"startUpdatingLocation %ld",(long)paramTimeout]];
    if (!fequalzero(locationTimeOutInterval)) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
        [self performSelector:@selector(stopRequestLocation) withObject:nil afterDelay:locationTimeOutInterval];
    }
}

- (void)stopRequestLocation
{
    [LogUtil Debug:@"stopLoc" message:@"stopRequestLocation"];
    [_locationManager stopUpdatingLocation];
    if ([self canRequestLocation] == LocationEnable && self.isLocating) {
        if (!fequalzero(locationTimeOutInterval)) {
            self.locationResult = LocationResultTimeout;
            [self doResponseBlockWithDictionary:[NSDictionary dictionaryWithObjectsAndKeys:@"timeout",LocationTimeout, nil] result:self.locationResult info:@"timeout"];
            self.isLocating = NO;
        }
    }
}

- (void)cancelLocation {
    [LogUtil Debug:@"stopLoc" message:@"cancelRequestLocation"];
    [_locationManager stopUpdatingLocation];
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

- (LocationAuthorizationStatus)canRequestLocation
{
    if ([CLLocationManager locationServicesEnabled]) {
        CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
        if (status != kCLAuthorizationStatusAuthorizedAlways
            && status != kCLAuthorizationStatusAuthorizedWhenInUse)
        {
            return LocationAPPDisable;
        }
        return LocationEnable;
    } else {
        return LocationServiceDisable;
    }
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse || status == kCLAuthorizationStatusAuthorizedAlways) {
        self.isLocating = YES;
        [_locationManager startUpdatingLocation];
    } else {
        self.locationResult = LocationResultAuthorizationDisable;
        [self doResponseBlockWithDictionary:@{} result:self.locationResult info:@"LocationResultAuthorizationDisable"];
    }
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations
{
    CLLocation *loc = locations.firstObject;
    if (loc.coordinate.latitude != 0 && loc.coordinate.longitude != 0) {
        self.locationCoordinate = loc.coordinate;
        [self requestWithCoordinate:self.locationCoordinate];
    }
    // 这里只需要定位一次，因此如果定位成功，就关闭定位更新
    [_locationManager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    self.isLocating = NO;
    self.locationResult = LocationResultError;
    [self doResponseBlockWithDictionary:[NSDictionary dictionaryWithObjectsAndKeys:@"didFailWithError",LocationTimeout, nil] result:self.locationResult info:@"didFailWithError"];
    self.isBeingUpdateLocation = NO;
}
- (void)setISOcountryCode:(NSString *)ISOcountryCode
{
    _ISOcountryCode = ISOcountryCode;
    if (ISOcountryCode != nil) {
        [[NSNotificationCenter defaultCenter]postNotificationName:kNotification_GetISOCountryCode object:nil];
    }
    
}

- (void)doResponseBlockWithDictionary:(NSDictionary *)dict result:(LocationResults)result info:(id)info {
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
        return;
    }
    if (responseBlock) {
        responseBlock(dict, result, info);
        if (result != LocationResultInit) {
            responseBlock = nil;
        }
    }
}

- (void)requestWithCoordinate:(CLLocationCoordinate2D)coordinate {
    NSDictionary *param = @{@"longitude":[NSString stringWithFormat:@"%@",@(coordinate.longitude)],
                            @"latitude":[NSString stringWithFormat:@"%@",@(coordinate.latitude)]
                            };
    __weak typeof(self) weakSelf = self;
    [self.locationAPIManager callAPIWithParam:param completion:^(id object, NSError *error) {
        if (!error) {
            if ([object isKindOfClass:[NSDictionary class]] && object[@"cityId"] && [object[@"cityId"] isKindOfClass:[NSString class]]) {
                NSString *code = object[@"cityId"];
                [self handleCityWithInfo:code];
            }
        } else if (error.code != NSURLErrorCancelled) {
            [weakSelf doResponseBlockWithDictionary:@{} result:LocationResultError info:nil];
        }
    }];
}

- (void)handleCityWithInfo:(NSString *)info {
    if (info) {
        __weak typeof(self) weakSelf = self;
        
        if ([[AppManager getLocalProtocol] userCountryType] == UserCountryTypeChina) {
            [[HWCityManager shareCityManager] getDistrictModelWithCityCode:info dataBase:nil withCallBack:^(id object, FMDatabase *db, NSError *error) {
                if ([object isKindOfClass:[HWDistrictModel class]]) {
                    [weakSelf doResponseBlockWithDictionary:@{} result:LocationResultSuccessed info:object];
                } else {
                    [weakSelf doResponseBlockWithDictionary:@{} result:LocationResultError info:nil];
                }
            }];
        } else {
            [[HWCityManager shareCityManager] getCityModelWithCityCode:info dataBase:nil withCallBack:^(id object, FMDatabase *db, NSError *error) {
                if ([object isKindOfClass:[HWCityModel class]]) {
                    if ([object isKindOfClass:[HWCityModel class]]) {
                        [weakSelf doResponseBlockWithDictionary:@{} result:LocationResultSuccessed info:object];
                    } else {
                        [weakSelf doResponseBlockWithDictionary:@{@"object":object} result:LocationResultError info:nil];
                    }
                }
            }];
        }
    } else {
        [self doResponseBlockWithDictionary:@{} result:LocationResultError info:nil];
    }
}

#pragma mark - getter
- (HWCitySearchAPIManager *)locationAPIManager {
    if (!_locationAPIManager) {
        _locationAPIManager = [[HWCitySearchAPIManager alloc] init];
    }
    return _locationAPIManager;
}

@end
