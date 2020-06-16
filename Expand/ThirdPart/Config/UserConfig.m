//
//  UserConfig.m
//  AirTouch
//
//  Created by Devin on 1/16/15.
//  Copyright (c) 2015 Honeywell. All rights reserved.
//

#import "UserConfig.h"
#import "DataManager.h"
#import "LogUtil.h"
#import "CityEntity.h"
#import "AppManager.h"
#import "AppMarco.h"
#import "UserEntity.h"

static NSMutableDictionary *userGroupControlData = nil;

@implementation UserConfig

#pragma  mark devin start
+ (void)addCityEntityByTelephoneCode:(NSString *)telephoneCode
{
    NSString * resourceName = @"CityList";
    if (![telephoneCode isEqualToString:@"86"]) {
        NSString * subFix = [NSString stringWithFormat:@"_%@", telephoneCode];
        resourceName = [resourceName stringByAppendingString:subFix];
    }
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:resourceName ofType:@"plist"]];
    NSInteger count = [[DataManager shareDataManager] countForEntityClass:[CityEntity class] sortDescriptorsOrNil:nil];
    NSArray *array = dic[@"citylist"];
    //TODO: 这个判断基于什么原理????
    if (count < array.count) {
        for (int i=0; i<[array count]; i++) {
            NSDictionary *cityDic = [array objectAtIndex:i];
            CityEntity *city = [[DataManager shareDataManager] createManagedObject:[CityEntity class]];
            city.cityNameZh = cityDic[@"cityNameZh"];
            city.cityNameEn = cityDic[@"cityNameEn"];
            city.cityCode = cityDic[@"cityCode"];
        }
        [[DataManager shareDataManager] saveManagedObjects];
    }
}

+ (void)addCityEntity
{
    [UserConfig addCityEntityByTelephoneCode:@"86"];
}

+ (NSString *)matchCityName:(NSString *)locateName
{
    if (!locateName) {
        return locateName;
    }
    id<LocalizationProtocol> appProtocol = [AppManager getLocalProtocol];
    if ([appProtocol matchCityNamesArray]) {
        NSArray *indiaCityArray=[appProtocol matchCityNamesArray];
        for (NSString *cityName in indiaCityArray) {
            if ([cityName rangeOfString:locateName].location != NSNotFound || [cityName isEqualToString:locateName]) {
                return cityName;
            }
        }
    }
    return locateName;
}

+(NSString *)getOtherLanguageCityName:(NSString *)paraName
{
    NSPredicate *predicate = nil;
    paraName = [self matchCityName:paraName];
    id<LocalizationProtocol> appProtocol = [AppManager getLocalProtocol];
    NSString * ISOcountryCode = [appProtocol ISOcountryCode];
    if ([AppConfig isEnglish]) {
        predicate = [NSPredicate predicateWithFormat:@"(SELF.cityNameEn == %@) AND (SELF.cityCode BEGINSWITH[c] %@)", paraName,ISOcountryCode];
    }else{
        predicate = [NSPredicate predicateWithFormat:@"(SELF.cityNameZh == %@) AND (SELF.cityCode BEGINSWITH[c] %@)", paraName,ISOcountryCode];
    }
    
    NSArray *array = [DataManager arrayForEntity:[CityEntity class] sortDescriptorsOrNil:nil predicateOrNil:predicate];
    
    if (array && [array count] != 0) {
        CityEntity *entity = array.firstObject;
        
        if ([AppConfig isEnglish]) {
            return entity.cityNameZh;
        }else{
            return entity.cityNameEn;
        }
    }
    return nil;
}

+(NSString *)getCurrentCityName {
    return ([UserConfig getCityUpdateMode]==HWLocationUpdateSelected)?[UserConfig getSelectCityName]:[UserConfig getAutoCityName];
}

+(NSString *)getCurrentCityCode {
    return ([UserConfig getCityUpdateMode]==HWLocationUpdateSelected)?[UserConfig getSelectCityCode]:[UserConfig getAutoCityCode];
}

+ (NSInteger)getCityUpdateMode {
    return [self getValueInterger:LocationUpdateMode];
}

+ (void)setCityUpdateMode:(NSInteger)model {
    [self setInteger:model withKey:LocationUpdateMode];
}

+ (void)setSelectCityCode:(NSString *)cityCode {
    [self setValue:cityCode withKey:LocationSelectCityName_code];
}

+ (NSString *)getSelectCityName {
    if ([AppConfig isEnglish]) {
        return [self getValueString:LocationSelectCityName_en];
    }else
    {
        return [self getValueString:LocationSelectCityName_zh];
    }
}

+ (NSString *)getSelectCityCode {
    return [self getValueString:LocationSelectCityName_code];
}

+(NSString *)getAutoCityCode
{
    return [self getValueString:CURRENT_CITY_CODE];
}

+ (void)setAutoCityCode:(NSString *)cityCode
{
    [self setValue:cityCode withKey:CURRENT_CITY_CODE];
}

+(NSString *)getAutoCityName
{
    if ([AppConfig isEnglish]) {
        return [self getValueString:CURRENT_CITY_EN];
    }else
    {
        return [self getValueString:CURRENT_CITY_ZH];
    }
}

+(NSString *)getCityNameFromCityCode:(NSString *)cityCode
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.cityCode == %@", cityCode];
    NSArray *array = [DataManager arrayForEntity:[CityEntity class] sortDescriptorsOrNil:nil predicateOrNil:predicate];
    if (array && [array count] != 0) {
        CityEntity *entity = array.firstObject;
        if ([AppConfig isEnglish]) {
            return entity.cityNameEn;
        }else{
            return entity.cityNameZh;
        }
    }
    return nil;
}

/**
 *  find the city's code by city's name
 *
 *  @param cityName city's name
 *
 *  @return if find the instance of CityEntity by cityName , return instance.cityCode
 *           else return nil.
 */
+(NSString *)getCityCodeFromCityName:(NSString *)cityName
{
    NSPredicate *predicate = nil;
    cityName = [self matchCityName:cityName];
    id<LocalizationProtocol> appProtocol = [AppManager getLocalProtocol];
    NSString * ISOcountryCode = [appProtocol ISOcountryCode];
    if ([AppConfig isEnglish]) {
        //        predicate = [NSPredicate predicateWithFormat:@"SELF.cityNameEn == %@", paraName];
        predicate = [NSPredicate predicateWithFormat:@"(SELF.cityNameEn == %@) AND (SELF.cityCode BEGINSWITH[c] %@)", cityName,ISOcountryCode];
    }else{
        //        predicate = [NSPredicate predicateWithFormat:@"SELF.cityNameZh == %@", paraName];
        predicate = [NSPredicate predicateWithFormat:@"(SELF.cityNameZh == %@) AND (SELF.cityCode BEGINSWITH[c] %@)", cityName,ISOcountryCode];
    }
    
    NSArray *array = [DataManager arrayForEntity:[CityEntity class] sortDescriptorsOrNil:nil predicateOrNil:predicate];
    if (array && [array count] != 0) {
        CityEntity *entity = array.firstObject;
        return entity.cityCode;
    }
    return nil;
}

+(void)setEnrollSelectPosition:(NSString *)paramEnrollSelectPosition
{
    [self setValue:paramEnrollSelectPosition withKey:EnrollSelectPosition];
}

+(NSString *)getEnrollSelectPosition
{
    return [self getValueString:EnrollSelectPosition];
}

+(NSString *)getCurrentLocationCode
{
    return [self getValueString:kNSUserDefaults_CurrentLocationId];
}

+(void)setCurrentLocationCode:(NSString *)cityName
{
    if ([cityName rangeOfString:@"市"].location != NSNotFound) {
        cityName = [cityName substringWithRange:NSMakeRange(0, [cityName rangeOfString:@"市"].location/*cityName.length-1*/)];
    }
    
    cityName = [self matchCityName:cityName];
    NSString *otherLanguageCityName=[self getOtherLanguageCityName:cityName];
    
    NSPredicate *predicate = nil;
    id<LocalizationProtocol> appProtocol = [AppManager getLocalProtocol];
    NSString * ISOcountryCode = [appProtocol ISOcountryCode];
    if ([AppConfig isEnglish]) {
        //        predicate = [NSPredicate predicateWithFormat:@"SELF.cityNameEn == %@", paraName];
        predicate = [NSPredicate predicateWithFormat:@"(SELF.cityNameEn == %@) AND (SELF.cityCode BEGINSWITH[c] %@)", cityName,ISOcountryCode];
    }else{
        //        predicate = [NSPredicate predicateWithFormat:@"SELF.cityNameZh == %@", paraName];
        predicate = [NSPredicate predicateWithFormat:@"(SELF.cityNameZh == %@) AND (SELF.cityCode BEGINSWITH[c] %@)", cityName,ISOcountryCode];
    }
    
    NSArray *array = [DataManager arrayForEntity:[CityEntity class] sortDescriptorsOrNil:nil predicateOrNil:predicate];

    if (array && [array count] != 0)
    {
        CityEntity *entity = array.firstObject;
        //return entity.cityCode;
        [LogUtil Debug:@"Location" message:[NSString stringWithFormat:@"entity.cityCode:%@", entity.cityCode]];
        [self setValue:entity.cityCode withKey:kNSUserDefaults_CurrentLocationId];
        
        if ([AppConfig isEnglish]) {
            [self setValue:cityName withKey:kNSUserDefaults_CurrentLocationName_EN];
            [self setValue:otherLanguageCityName withKey:kNSUserDefaults_CurrentLocationName_ZH];
        }else{
            [self setValue:cityName withKey:kNSUserDefaults_CurrentLocationName_ZH];
            [self setValue:otherLanguageCityName withKey:kNSUserDefaults_CurrentLocationName_EN];
        }
    }
    else
    {
        [LogUtil Debug:@"Location" message:@"entity.cityCode: null"];
        [self setValue:nil withKey:kNSUserDefaults_CurrentLocationId];
        
        [self setValue:cityName withKey:kNSUserDefaults_CurrentLocationName_EN];
        [self setValue:cityName withKey:kNSUserDefaults_CurrentLocationName_ZH];
    }
}

+(NSString *)getCurrentLocationName
{
    if ([AppConfig isEnglish]) {
        return [self getValueString:kNSUserDefaults_CurrentLocationName_EN];
    }else{
        return [self getValueString:kNSUserDefaults_CurrentLocationName_ZH];
    }
}

+(void)setUserGroupControlMode:(NSString *)value andKey:(id<NSCopying>)key
{
    if (value!=nil && key != nil) {
        userGroupControlData = [self getUserGroupControlMode];
        if (userGroupControlData == nil) {
            userGroupControlData = [[NSMutableDictionary alloc]init];
        }
        
        [userGroupControlData setObject:value forKey:key];
        [self setDictionaryValue:userGroupControlData withKey:kNSUserDefaults_GroupControlMode];
    }
}

+(NSMutableDictionary *)getUserGroupControlMode
{
    NSDictionary *dic = [self getDictionaryValue:kNSUserDefaults_GroupControlMode];
    return [NSMutableDictionary dictionaryWithDictionary:dic];
}

+(void)saveUser
{
    NSMutableDictionary *userDict = [NSMutableDictionary dictionaryWithDictionary:[[UserEntity instance]convertToDictionary]];
    NSArray *locations = [userDict[@"locations"] copy];
    [userDict removeObjectForKey:@"locations"];
    if (locations) {
        [self saveToPlistWithFileName:kFileManager_Locations dictionaryInfo:@{@"locations":locations}];
    }
    [self setDictionaryValue:userDict withKey:kNSUserDefaults_UserEntity];
}

+(NSString *)getPlistFilePathWithName:(NSString *)fileName {
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *path = [doc stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",fileName]];
    return path;
}

+(void)saveToPlistWithFileName:(NSString *)fileName dictionaryInfo:(NSDictionary *)info {
    [info writeToFile:[self getPlistFilePathWithName:fileName] atomically:YES];
}

+(NSDictionary *)getPlistInfoWithFileName:(NSString *)fileName {
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:[self getPlistFilePathWithName:fileName]];
    return dict;
}

+(void)clearPlistFileWithFileName:(NSString *)fileName {
    NSString *path = [self getPlistFilePathWithName:fileName];
    BOOL isExist=[[NSFileManager defaultManager] fileExistsAtPath:path];
    if (isExist) {
        [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    }
}

+(void)clearUser
{
    [self clearValueObject:kNSUserDefaults_UserEntity];
    [self clearPlistFileWithFileName:kFileManager_Locations];
    [self clearPlistFileWithFileName:kFileManager_Mad_Airs];
}

+(NSDictionary *)getUserInfo
{
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithDictionary:[self getDictionaryValue:kNSUserDefaults_UserEntity]];
    {
        NSDictionary *locationsDict = [self getPlistInfoWithFileName:kFileManager_Locations];
        NSArray *locations = @[];
        if (locationsDict) {
            locations = locationsDict[@"locations"];
        }
        userInfo[@"locations"] = locations;
    }
    
    return userInfo;
}

+(void)setFilterCapability:(NSDictionary *)value andKey:(id<NSCopying>)key
{
    [self setDictionaryValue:value withKey:key];
}
+(NSDictionary *)getFilterCapability:(NSString *)key
{
    return [self getDictionaryValue:key];
}

+(void)setCloudVersionInfo:(NSDictionary *)value
{
    [self saveToPlistWithFileName:kCloudVersionInfo dictionaryInfo:value];
}
+(NSDictionary *)getCloudVersionInfo
{
    return [self getPlistInfoWithFileName:kCloudVersionInfo];
}

+(void)saveMessagesWithInfo:(NSDictionary *)info {
    [self saveToPlistWithFileName:kFileManager_MessageList dictionaryInfo:info];
}

+(void)clearMessages {
    [self clearPlistFileWithFileName:kFileManager_MessageList];
}

+(NSDictionary *)getMessages {
    NSDictionary *messages = [self getPlistInfoWithFileName:kFileManager_MessageList];
    return messages;
}

+(void)savePM25WithInfo:(NSDictionary *)info {
    [self saveToPlistWithFileName:kFileManager_PM25Value dictionaryInfo:info];
}

+(void)clearPM25{
    [self clearPlistFileWithFileName:kFileManager_PM25Value];
}

+(NSDictionary *)getPM25 {
    NSDictionary *pm25 = [self getPlistInfoWithFileName:kFileManager_PM25Value];
    return pm25;
}

#pragma mark - me&security
+(HWSecurityType)getSecurityType {
    NSInteger type = [self getValueInterger:kNSUserDefaults_SecurityType];
    return type;
}

+(void)setSecurityType:(HWSecurityType)type {
    [self setInteger:type withKey:kNSUserDefaults_SecurityType];
}

+(NSString *)getPatternPassword {
    NSString *password = [self getValueString:kNSUserDefaults_PatternPassword];
    return password;
}

+(void)setPatternPassword:(NSString *)password {
    [self setValue:password withKey:kNSUserDefaults_PatternPassword];
}

+(void)clearPatternPassword {
    [self setValue:@"" withKey:kNSUserDefaults_PatternPassword];
}

+(void)clearSecurityMethod {
    [self setSecurityType:HWSecurityTypeAuto];
    [self clearPatternPassword];
}

+ (void)clearCookie {
//    //获取所有cookies
//    NSArray*array =  [[NSHTTPCookieStorage sharedHTTPCookieStorage]cookiesForURL:[NSURL URLWithString:SERVER_ADDRESS_COOKIE]];
//    //删除
//    for(NSHTTPCookie*cookie in array) {
//        [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie: cookie];
//    }
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"USER_DEFAULT_COOKIE"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
