//
//  HWCityManager.h
//  AirTouch
//
//  Created by Honeywell on 2016/11/29.
//  Copyright © 2016年 Honeywell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LocationManager.h"
#import "UserConfig.h"
#import "HWDataBaseManager.h"

#import "HWProvinceModel.h"
#import "HWCityModel.h"
#import "HWDistrictModel.h"
#import "HWCityKey.h"

#define CITY_DB_NAME @"CityTable.db"
#define CN_TABLE_NAME @"CityList_CN"
#define IN_TABLE_NAME @"CityList_IN"

typedef NS_ENUM(NSInteger, HWLocateStatus) {
    HWLocateStatusLoading = LocationResultInit,
    HWLocateStatusSuccessed = LocationResultSuccessed,
    HWLocateStatusError = LocationResultError,
    HWLocateStatusTimeout = LocationResultTimeout,
    HWLocateStatusAuthorizationDisable = LocationResultAuthorizationDisable,
};

typedef void (^HWCityInfoManagerCallBack)(id object, FMDatabase *db, NSError *error);

typedef void (^LocatingCallBack)(HWLocateStatus resultType, NSString *resultValue);

@interface HWCityManager : NSObject

@property (nonatomic, strong) HWDataBaseManager *dbManager;

+ (instancetype)shareCityManager;

@property (nonatomic, assign, readonly) HWLocateStatus locateStatus;

@property (assign, nonatomic) CLLocationCoordinate2D locationCoordinate;

- (void)startLocatingCallBack:(LocatingCallBack)callBack;

- (void)setSelectedCityCode:(NSString *)cityCode;

- (void)handleLocationChange;

- (void)updateCityList;

- (void)resetBaseInfo;

#pragma mark - city info
- (void)getProvinceListWithDataBase:(FMDatabase *)db callBack:(HWCityInfoManagerCallBack)callBack;

- (void)getCityListWithProvinceName:(NSString *)provinceName dataBase:(FMDatabase *)db withCallBack:(HWCityInfoManagerCallBack)callBack;

#pragma mark - model
- (void)getDistrictListWithCityName:(NSString *)cityName provinceName:(NSString *)provinceName dataBase:(FMDatabase *)db withCallBack:(HWCityInfoManagerCallBack)callBack;

- (void)getCityModelWithCityName:(NSString *)cityName cityKey:(NSString *)cityKey dataBase:(FMDatabase *)db withCallBack:(HWCityInfoManagerCallBack)callBack;

- (void)getDistrictModelWithCityName:(NSString *)cityName cityKey:(NSString *)cityKey districtName:(NSString *)districtName districtKey:(NSString *)districtKey dataBase:(FMDatabase *)db withCallBack:(HWCityInfoManagerCallBack)callBack;

#pragma mark - index
- (void)getDistrictModelWithCityCode:(NSString *)code dataBase:(FMDatabase *)db withCallBack:(HWCityInfoManagerCallBack)callBack;

- (void)getCityModelWithCityCode:(NSString *)code dataBase:(FMDatabase *)db withCallBack:(HWCityInfoManagerCallBack)callBack;

@end
