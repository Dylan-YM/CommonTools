//
//  UserConfig.h
//  AirTouch
//
//  Created by Devin on 1/16/15.
//  Copyright (c) 2015 Honeywell. All rights reserved.
//

#import "BaseConfig.h"
#define USERNAME @"userName"
#define PASSWORD @"password"
#define kSESSION_ID @"sessionId"

#define CURRENT_CITY_EN @"CURRENT_CITY_en"
#define CURRENT_CITY_ZH @"CURRENT_CITY_zh"
#define CURRENT_CITY_CODE @"CURRENT_CITY_CODE"

#define CURRENT_TEMPERATURE_UNIT @"temperatureUnit"

#define LAST_ENROLL_ERROR  @"lastEnrollError"
#define CURRENT_Device_MAC @"currentDeviceMac"
#define CURRENT_Device_CRC @"currentDeviceCRC"

#define APIRequestTime @"RequestTime"

#define EnrollSelectPosition @"EnrollSelectPosition"

#define LocationUpdateMode @"LocationUpdateMode"
#define LocationSelectCityName_en @"LocationSelectCityName_en"
#define LocationSelectCityName_zh @"LocationSelectCityName_zh"
#define LocationSelectCityName_code @"LocationSelectCityName_code"

typedef enum : NSUInteger {
    HWLocationUpdateAuto = 0,
    HWLocationUpdateSelected,
} HWLocationUpdateMode;

typedef enum : NSUInteger {
    HWSecurityTypeAuto = 0,
    HWSecurityTypeFingerPrint,
    HWSecurityTypePattern,
} HWSecurityType;

@class CityEntity,DeviceModel;

typedef void(^ReceiveData)(NSArray *paramBackData);

@interface UserConfig : BaseConfig

#pragma mark devin start
+(NSString *)getCurrentCityName;
+(NSString *)getCurrentCityCode;

//can be put in locationManager
+ (void)setAutoCityCode:(NSString*)cityCode;
//+(NSString *)getAutoCityName;
+(NSString *)getAutoCityCode;

//select location
+ (NSString *)getSelectCityCode;
//+ (NSString *)getSelectCityName;
+ (void)setSelectCityCode:(NSString *)cityCode;
+ (NSInteger)getCityUpdateMode;
+ (void)setCityUpdateMode:(NSInteger)model;
//location Manager
+(NSString *)getCityNameFromCityCode:(NSString *)cityCode ;
+(NSString *)getCityCodeFromCityName:(NSString *)cityName ;
+ (void)addCityEntity ;
+ (void)addCityEntityByTelephoneCode:(NSString *)telephoneCode;
//not belong to user
+(void)setEnrollSelectPosition:(NSString *)paramEnrollSelectPosition ;
+(NSString *)getEnrollSelectPosition ;

//App Config
+(void)setCurrentLocationCode:(NSString *)cityName ;
+(NSString *)getCurrentLocationCode ;
+(NSString *)getCurrentLocationName ;

#pragma mark kenny refactor
/**
 *  把当前用户的信息保存在本地
 */
+(void)saveUser;
+(void)clearUser;
+(NSDictionary *)getUserInfo;

#pragma mark - kenny end

#pragma mark - Group Control
+(void)setUserGroupControlMode:(NSString *)value andKey:(id<NSCopying>)key;
+(NSMutableDictionary *)getUserGroupControlMode;

#pragma mark -  filterCapability
+(void)setFilterCapability:(NSDictionary *)value andKey:(id<NSCopying>)key;
+(NSDictionary *)getFilterCapability:(NSString *)key;

#pragma mark -  Cloud Version Info
+(void)setCloudVersionInfo:(NSDictionary *)value;
+(NSDictionary *)getCloudVersionInfo;

#pragma mark - message info
+(void)saveMessagesWithInfo:(NSDictionary *)info;
+(void)clearMessages;
+(NSDictionary *)getMessages;

#pragma mark - outdoor weather
+(void)savePM25WithInfo:(NSDictionary *)info;
+(void)clearPM25;
+(NSDictionary *)getPM25;

#pragma mark - me&security
+(HWSecurityType)getSecurityType;
+(void)setSecurityType:(HWSecurityType)type;

+(NSString *)getPatternPassword;
+(void)setPatternPassword:(NSString *)password;
+(void)clearPatternPassword;
+(void)clearSecurityMethod;

#pragma mark - cookie
+ (void)clearCookie;

@end
