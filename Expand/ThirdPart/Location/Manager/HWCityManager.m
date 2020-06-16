//
//  HWCityManager.m
//  AirTouch
//
//  Created by Honeywell on 2016/11/29.
//  Copyright © 2016年 Honeywell. All rights reserved.
//

#import "HWCityManager.h"
#import "UserEntity.h"
#import "AppMarco.h"
#import "NetworkUtil.h"
#import "OutdoorWeatherManager.h"
#import "HWCityListAPIManager.h"
#import "DateTimeUtil.h"
#import "HWProvinceModel.h"
#import "HWCityModel.h"
#import "HWDistrictModel.h"

static NSString * const CityListTimeStamp         = @"CityListTimeStamp";
static NSString * const CityListDBName            = @"CityListDataBase";

@interface HWCityManager ()

@property (nonatomic, assign) HWLocateStatus locateStatus;
@property (nonatomic, strong) HWCityListAPIManager *cityListAPIManager;

@property (strong, nonatomic) NSString *provinceNameKey;
@property (strong, nonatomic) NSString *cityNameKey;
@property (strong, nonatomic) NSString *districtNameKey;
@property (strong, nonatomic) NSString *tableName;

@property (assign, nonatomic) long long timeStamp;

@end

@implementation HWCityManager

+ (instancetype)shareCityManager
{
    static HWCityManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[HWCityManager alloc] init];
        NSString *dbName = [NSString stringWithFormat:@"%@.db",CityListDBName];
        
        NSArray *documents = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *disPath = [documents[0] stringByAppendingPathComponent:dbName];
        
        NSString *resource = [[NSBundle mainBundle] resourcePath];
        NSString *srcPath = [resource stringByAppendingPathComponent:dbName];
        
        [[NSFileManager defaultManager] copyItemAtPath:srcPath toPath:disPath error:NULL];
        
        instance.dbManager = [[HWDataBaseManager alloc] initWithDBName:dbName];
        [instance resetBaseInfo];
        
        [[NSNotificationCenter defaultCenter] addObserver:instance selector:@selector(loginStatusChanged:) name:kNotification_LoginStatusChanged object:nil];
    });
    return instance;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)resetBaseInfo {
    NSString *osLanguage = [AppConfig getLanguage];
    if ([osLanguage isEqualToString:@"en"]) {
        self.provinceNameKey = PROVINCE_NAME_EN;
        self.cityNameKey = CITY_NAME_EN;
        self.districtNameKey = DISTRICT_NAME_EN;
    } else if ([osLanguage isEqualToString:@"zh"]) {
        self.provinceNameKey = PROVINCE_NAME_CN;
        self.cityNameKey = CITY_NAME_CN;
        self.districtNameKey = DISTRICT_NAME_CN;
    }
    UserCountryType country = [[AppManager getLocalProtocol] userCountryType];
    if (country == UserCountryTypeChina) {
        self.tableName = CN_TABLE_NAME;
    } else {
        self.tableName = IN_TABLE_NAME;
    }
}

- (void)loginStatusChanged:(NSNotification *)notification {
    [self resetBaseInfo];
}

- (void)startLocatingCallBack:(LocatingCallBack)callBack {
    if ([[LocationManager shareLocationManager] isLocating]) {
        [[LocationManager shareLocationManager] cancelLocation];
    }
    [[LocationManager shareLocationManager] startRequestLocation:^(NSDictionary *responseDictionary, NSInteger resultType, id resultValue) {
        _locateStatus = resultType;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"AutoLocateUpdateState" object:@(_locateStatus)];
        self.locationCoordinate = [[LocationManager shareLocationManager] locationCoordinate];
        if (resultType==LocationResultSuccessed) {
            if (resultValue) {
                NSString *code = nil;
                if ([resultValue isKindOfClass:[HWCityModel class]]) {
                    code = [(HWCityModel *)resultValue code];
                } else if ([resultValue isKindOfClass:[HWDistrictModel class]]) {
                    code = [(HWDistrictModel *)resultValue code];
                }
                if (code) {
                    if ([UserConfig getCityUpdateMode] == HWLocationUpdateAuto) {
                        NSString *originCode = [UserConfig getCurrentCityCode];
                        if (![code isEqualToString:originCode]) {
                            [self handleLocationChangeWithMode:HWLocationUpdateAuto];
                        }
                    }
                    [UserConfig setAutoCityCode:code];
                    callBack(HWLocateStatusSuccessed, resultValue);
                }
            } else {
                callBack(HWLocateStatusError, resultValue);
            }
        } else {
            callBack(resultType, resultValue);
        }
        
    } timeoutInterval:20];
}

- (void)setSelectedCityCode:(NSString *)cityCode {
    NSString *originCityCode = [UserConfig getCurrentCityCode];
    [UserConfig setSelectCityCode:cityCode];
    [UserConfig setCityUpdateMode:HWLocationUpdateSelected];
    if (![originCityCode isEqualToString:cityCode]) {
        [self handleLocationChangeWithMode:HWLocationUpdateSelected];
    }
}

- (void)handleLocationChangeWithMode:(HWLocationUpdateMode)mode {
    HWLocationUpdateMode currentMode = [UserConfig getCityUpdateMode];
    if (mode == currentMode) {
        [self handleLocationChange];
    }
}

- (void)handleLocationChange {
    [[UserEntity instance] loadCityBackgroundPicturesAndWeather];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_LocationChange object:nil];
}

- (void)updateCityList {
    NSString *timeStamp = @"0";
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults stringForKey:CityListTimeStamp]) {
        timeStamp = [userDefaults stringForKey:CityListTimeStamp];
    }

    NSNumber *timeStampNum = [NSNumber numberWithLongLong:[timeStamp longLongValue]];

    [self.cityListAPIManager callAPIWithParam:@{@"lastSyncTime":timeStampNum} completion:^(id object, NSError *error) {
        if (!error) {
            if ([object isKindOfClass:[NSDictionary class]]) {
                NSDictionary *data = (NSDictionary *)object;
                if ([data.allKeys containsObject:@"timeStamp"] && [data[@"timeStamp"] isKindOfClass:[NSNumber class]]) {
                    self.timeStamp = [data[@"timeStamp"] longLongValue];
                }

                if ([data.allKeys containsObject:@"cities"] && [data[@"cities"] isKindOfClass:[NSArray class]]) {
                    NSArray *cities = data[@"cities"];
                    if (cities.count > 0) {
                        [self updateCityListWithCities:cities];
                    }
                }
            }
        }
    }];
}

- (void)updateCityListWithCities:(NSArray *)cities {
    if (cities.count > 0) {
        NSString *dbTypeText = @"text";
        NSDictionary *keyTypes = @{@"id":dbTypeText,
                                   @"countryCode":dbTypeText,
                                   @"countryCN":dbTypeText,
                                   @"countryEN":dbTypeText,
                                   @"provinceCN":dbTypeText,
                                   @"provinceEN":dbTypeText,
                                   @"cityCN":dbTypeText,
                                   @"cityEN":dbTypeText,
                                   @"districtCN":dbTypeText,
                                   @"districtEN":dbTypeText
                                   };
        
        [self.dbManager createTable:CN_TABLE_NAME keyTypes:keyTypes withCallBack:nil];
        [self.dbManager deleteFromTable:CN_TABLE_NAME whereClause:nil whereArgs:nil withCallBack:nil];
        
//        [self insertDataToTable:cities tableName:@"CityList_CN"];
        
        [self.dbManager insertIntoTable:CN_TABLE_NAME KeyValuesArray:cities withCallBack:^(id object, NSError *error) {
            if (!error) {
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                [userDefaults setObject:[NSString stringWithFormat:@"%@",@(self.timeStamp)] forKey:CityListTimeStamp];
                [userDefaults synchronize];
            }
        }];
    }
}

- (void)insertDataToTable:(NSArray *)cities tableName:(NSString *)tableName {
    for (NSInteger i = 0; i < cities.count; i++) {
        NSDictionary *keyValues = cities[i];
        [self.dbManager insertIntoTable:tableName KeyValues:keyValues withCallBack:nil];
    }
}

#pragma mark - city info
- (void)getProvinceListWithDataBase:(FMDatabase *)db callBack:(HWCityInfoManagerCallBack)callBack {
    NSMutableArray *provinces = [NSMutableArray array];
    NSString *query = nil;
    UserCountryType country = [[AppManager getLocalProtocol] userCountryType];
    if (country == UserCountryTypeIndia) {
        query = [NSString stringWithFormat:@"SELECT DISTINCT %@ FROM %@ ORDER BY %@",self.provinceNameKey,self.tableName,self.provinceNameKey];
    } else {
        query = [NSString stringWithFormat:@"SELECT DISTINCT %@ FROM %@",self.provinceNameKey,self.tableName];
    }
    [self.dbManager selectWithRawQuery:query values:nil dataBase:db withCallBack:^(id object,FMDatabase *db, NSError *error) {
        if (object && [object isKindOfClass:[NSArray class]]) {
            for (NSInteger i = 0; i < [object count]; i++) {
                if ([[object objectAtIndex:i] isKindOfClass:[NSDictionary class]]) {
                    NSDictionary *provinceDict = object[i];
                    HWProvinceModel *model = [[HWProvinceModel alloc] init];
                    model.name = provinceDict[self.provinceNameKey];
                    [provinces addObject:model];
                }
            }
            callBack(provinces,db,error);
        } else {
            callBack(object,db,error);
        }
    }];
}

- (void)getCityListWithProvinceName:(NSString *)provinceName dataBase:(FMDatabase *)db withCallBack:(HWCityInfoManagerCallBack)callBack {
    NSMutableArray *cities = [NSMutableArray array];
    NSString *query = nil;
    UserCountryType country = [[AppManager getLocalProtocol] userCountryType];
    if (country == UserCountryTypeChina) {
        query = [NSString stringWithFormat:@"SELECT DISTINCT %@ FROM %@ WHERE %@ = '%@'",self.cityNameKey,self.tableName,self.provinceNameKey,provinceName];
    } else {
        query = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = '%@' ORDER BY %@",self.tableName,self.provinceNameKey,provinceName,self.cityNameKey];
    }
    [self.dbManager selectWithRawQuery:query values:nil dataBase:db withCallBack:^(id object, FMDatabase *db, NSError *error) {
        if (object && [object isKindOfClass:[NSArray class]]) {
            for (NSInteger i = 0; i < [object count]; i++) {
                if ([[object objectAtIndex:i] isKindOfClass:[NSDictionary class]]) {
                    NSDictionary *info = object[i];
                    HWCityModel *model = [[HWCityModel alloc] init];
                    model.name = info[self.cityNameKey];
                    model.code = info[CITY_CODE];
                    
                    HWProvinceModel *province = [[HWProvinceModel alloc] init];
                    province.name = provinceName;
                    
                    model.provinceModel = province;
                    [cities addObject:model];
                }
            }
            callBack(cities,db,error);
        } else {
            callBack(object,db,error);
        }
    }];
}

- (void)getDistrictListWithCityName:(NSString *)cityName provinceName:(NSString *)provinceName dataBase:(FMDatabase *)db withCallBack:(HWCityInfoManagerCallBack)callBack {
    NSMutableArray *districts = [NSMutableArray array];
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = '%@' AND %@ = '%@'",self.tableName,self.cityNameKey,cityName,self.provinceNameKey,provinceName];
    [self.dbManager selectWithRawQuery:query values:nil dataBase:db withCallBack:^(id object, FMDatabase *db, NSError *error) {
        if (object && [object isKindOfClass:[NSArray class]]) {
            for (NSInteger i = 0; i < [object count]; i++) {
                if ([[object objectAtIndex:i] isKindOfClass:[NSDictionary class]]) {
                    NSDictionary *info = object[i];
                    HWDistrictModel *model = [[HWDistrictModel alloc] init];
                    model.name = info[self.districtNameKey];
                    model.code = info[CITY_CODE];
                    
                    HWCityModel *city = [[HWCityModel alloc] init];
                    city.name = info[self.cityNameKey];
                    city.code = info[CITY_CODE];
                    
                    HWProvinceModel *province = [[HWProvinceModel alloc] init];
                    province.name = info[self.provinceNameKey];
                    city.provinceModel = province;
                    
                    model.cityModel = city;
                    [districts addObject:model];
                }
            }
            callBack(districts,db,error);
        } else {
            callBack(object,db,error);
        }
    }];
}

- (void)getCityModelWithCityName:(NSString *)cityName cityKey:(NSString *)cityKey dataBase:(FMDatabase *)db withCallBack:(HWCityInfoManagerCallBack)callBack {
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = '%@'",self.tableName,cityKey,cityName];
    [self.dbManager selectWithRawQuery:query values:nil dataBase:db withCallBack:^(id object,FMDatabase *db, NSError *error) {
        if (object && [object isKindOfClass:[NSArray class]] && [object count] > 0) {
            NSDictionary *info = object[0];
            HWCityModel *model = [[HWCityModel alloc] init];
            model.name = info[self.cityNameKey];
            model.code = info[CITY_CODE];
            
            HWProvinceModel *province = [[HWProvinceModel alloc] init];
            province.name = info[self.provinceNameKey];
            
            model.provinceModel = province;
            callBack(model,db,error);
        } else {
            callBack(object,db,error);
        }
    }];
}

- (void)getDistrictModelWithCityName:(NSString *)cityName cityKey:(NSString *)cityKey districtName:(NSString *)districtName districtKey:(NSString *)districtKey dataBase:(FMDatabase *)db withCallBack:(HWCityInfoManagerCallBack)callBack {
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = '%@' AND %@ = '%@'",self.tableName,cityKey,cityName,districtKey,districtName];
    [self.dbManager selectWithRawQuery:query values:nil dataBase:db withCallBack:^(id object, FMDatabase *db, NSError *error) {
        if (object && [object isKindOfClass:[NSArray class]] && [object count] > 0) {
            NSDictionary *info = object[0];
            HWDistrictModel *model = [[HWDistrictModel alloc] init];
            model.name = info[self.districtNameKey];
            model.code = info[CITY_CODE];
            
            HWCityModel *city = [[HWCityModel alloc] init];
            city.name = info[self.cityNameKey];
            city.code = info[CITY_CODE];
            
            HWProvinceModel *province = [[HWProvinceModel alloc] init];
            province.name = info[self.provinceNameKey];
            city.provinceModel = province;
            
            model.cityModel = city;
            callBack(model,db,error);
        } else {
            callBack(object,db,error);
        }
    }];
}

- (void)getDistrictModelWithCityCode:(NSString *)code dataBase:(FMDatabase *)db withCallBack:(HWCityInfoManagerCallBack)callBack {
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = '%@'",self.tableName,CITY_CODE,code];
    [self.dbManager selectWithRawQuery:query values:nil dataBase:db withCallBack:^(id object, FMDatabase *db, NSError *error) {
        if (object && [object isKindOfClass:[NSArray class]] && [object count] > 0) {
            NSDictionary *info = object[0];
            HWDistrictModel *model = [[HWDistrictModel alloc] init];
            model.name = info[self.districtNameKey];
            model.code = info[CITY_CODE];
            
            HWCityModel *city = [[HWCityModel alloc] init];
            city.name = info[self.cityNameKey];
            city.code = info[CITY_CODE];
            
            HWProvinceModel *province = [[HWProvinceModel alloc] init];
            province.name = info[self.provinceNameKey];
            city.provinceModel = province;
            
            model.cityModel = city;
            callBack(model,db,error);
        } else {
            callBack(object,db,error);
        }
    }];
}

- (void)getCityModelWithCityCode:(NSString *)code dataBase:(FMDatabase *)db withCallBack:(HWCityInfoManagerCallBack)callBack {
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = '%@'",self.tableName,CITY_CODE,code];
    [self.dbManager selectWithRawQuery:query values:nil dataBase:db withCallBack:^(id object, FMDatabase *db, NSError *error) {
        if (object && [object isKindOfClass:[NSArray class]] && [object count] > 0) {
            NSDictionary *info = object[0];
            HWCityModel *city = [[HWCityModel alloc] init];
            city.name = info[self.cityNameKey];
            city.code = info[CITY_CODE];
            
            HWProvinceModel *province = [[HWProvinceModel alloc] init];
            province.name = info[self.provinceNameKey];
            city.provinceModel = province;
            callBack(city,db,error);
        } else {
            callBack(object,db,error);
        }
    }];
}

- (HWCityListAPIManager *)cityListAPIManager {
    if (!_cityListAPIManager) {
        _cityListAPIManager = [[HWCityListAPIManager alloc] init];
    }
    return _cityListAPIManager;
}

@end
