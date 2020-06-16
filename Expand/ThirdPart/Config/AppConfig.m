//
//  AppConfig.m
//  AirTouch
//
//  Created by Devin on 1/16/15.
//  Copyright (c) 2015 Honeywell. All rights reserved.
//

#import "AppConfig.h"
#import <sys/sysctl.h>
#import "AppMarco.h"
#import "DateTimeUtil.h"
#import "AppManager.h"
#import "DeviceModel.h"
#import "UnSupportDeviceModel.h"

NSString * const kAppConfigNightModeChangeNotification = @"kAppConfigNightModeChangeNotification";

static NSInteger _httpRequestTimeout = 15;
static BOOL isNightMode = NO;

static BOOL manualSwitchNightMode = NO;

@implementation AppConfig

+ (void)setPopNewVTime:(NSString *)time
{
    [self setValue:time withKey:kUserDefault_NewVTime];
}

+ (NSString *)getPopNewVTime
{
    return [self getValueString:kUserDefault_NewVTime];
}

+ (NSString*)getLanguage
{
    NSArray *languageArray = [NSLocale preferredLanguages];
    NSString *language = [languageArray objectAtIndex:0];
    if ([language rangeOfString:@"zh"].location != NSNotFound) {
        return @"zh";
    }
    return @"en";
}

+ (NSString*)getWeatherLanguage
{
    NSArray *languageArray = [NSLocale preferredLanguages];
    NSString *language = [languageArray objectAtIndex:0];
    if ([language rangeOfString:@"zh"].location != NSNotFound) {
        return @"zh-chs";
    }
    return @"en";
}

+ (BOOL)isEnglish
{
    if ([[self getLanguage] isEqualToString:@"zh"])
    {
        return NO;
    }else
    {
        return YES;
    }
}

+ (void)switchNightMode {
    manualSwitchNightMode = YES;
    isNightMode = !isNightMode;
    [[NSNotificationCenter defaultCenter] postNotificationName:kAppConfigNightModeChangeNotification object:self userInfo:@{@"isNightMode":@(isNightMode)}];
}

+ (void)refreshNightMode {
    BOOL isNight;
    if (manualSwitchNightMode) {
        isNight = isNightMode;
    } else {
        isNight = [DateTimeUtil isNightNow:KDayNight_FirstHour firstMin:KDayNight_FirstMin secondHour:KDayNight_SecondHour secondMin:KDayNight_SecondMin];
    }
    if (isNightMode != isNight) {
        isNightMode = isNight;
        [[NSNotificationCenter defaultCenter] postNotificationName:kAppConfigNightModeChangeNotification object:self userInfo:@{@"isNightMode":@(isNightMode)}];
    }
}

+ (BOOL)isNightMode {
    return isNightMode;
}

+(NSInteger)httpRequestTimeout
{
//    if ([BaseConfig isDebug]) {
//        return _httpRequestTimeout * 10;
//    }
    
    return _httpRequestTimeout;
}

+(ModelType)getModel
{
    if (fequal(SCREENWIDTH, 320.0))
    {
        if (fequal(SCREENHEIGHT, 480.0)) {
            return iPhone4;
        } else {
            return iPhone5;
        }
    }
    else
    {
        if (fequal(SCREENWIDTH, 375.0)) {
            return iPhone6;
        } else {
            return iPhone6Plus;
        }
    }
}

+ (NSString *) platformString{
    //NSString *platform = [[UIDevice currentDevice] model];
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    free(machine);
    
    //iPhone
    
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 1";
    
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3";
    
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS";
    
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4";
    
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4";
    
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4";
    
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4s";
    
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5";
    
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5";
    
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5C";
    
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5C";
    
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5S";
    
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5S";
    
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus";
    
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6";
    
    if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone 6S";
    
    if ([platform isEqualToString:@"iPhone8,2"]) return @"iPhone 6S Plus";
    
    if ([platform isEqualToString:@"iPhone8,3"]) return @"iPhone SE";
    
    if ([platform isEqualToString:@"iPhone8,4"]) return @"iPhone SE";
    
    if ([platform isEqualToString:@"iPhone9,1"]) return @"iPhone 7";
    
    if ([platform isEqualToString:@"iPhone9,2"]) return @"iPhone 7 Plus";
    
    //iPot Touch
    
    if ([platform isEqualToString:@"iPod1,1"]) return @"iPod Touch";
    
    if ([platform isEqualToString:@"iPod2,1"]) return @"iPod Touch 2";
    
    if ([platform isEqualToString:@"iPod3,1"]) return @"iPod Touch 3";
    
    if ([platform isEqualToString:@"iPod4,1"]) return @"iPod Touch 4";
    
    if ([platform isEqualToString:@"iPod5,1"]) return @"iPod Touch 5";
    
    if ([platform isEqualToString:@"iPod7,1"]) return @"iPod Touch 6";
    
    //iPad
    
    if ([platform isEqualToString:@"iPad1,1"]) return @"iPad";
    
    if ([platform isEqualToString:@"iPad2,1"]) return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,2"]) return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,3"]) return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,4"]) return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,5"]) return @"iPad Mini 1";
    
    if ([platform isEqualToString:@"iPad2,6"]) return @"iPad Mini 1";
    
    if ([platform isEqualToString:@"iPad2,7"]) return @"iPad Mini 1";
    
    if ([platform isEqualToString:@"iPad3,1"]) return @"iPad 3";
    
    if ([platform isEqualToString:@"iPad3,2"]) return @"iPad 3";
    
    if ([platform isEqualToString:@"iPad3,3"]) return @"iPad 3";
    
    if ([platform isEqualToString:@"iPad3,4"]) return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad3,5"]) return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad3,6"]) return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad4,1"]) return @"iPad air";
    
    if ([platform isEqualToString:@"iPad4,2"]) return @"iPad air";
    
    if ([platform isEqualToString:@"iPad4,3"]) return @"iPad air";
    
    if ([platform isEqualToString:@"iPad4,4"]) return @"iPad mini 2";
    
    if ([platform isEqualToString:@"iPad4,5"]) return @"iPad mini 2";
    
    if ([platform isEqualToString:@"iPad4,6"]) return @"iPad mini 2";
    
    if ([platform isEqualToString:@"iPad4,7"]) return @"iPad mini 3";
    
    if ([platform isEqualToString:@"iPad4,8"]) return @"iPad mini 3";
    
    if ([platform isEqualToString:@"iPad4,9"]) return @"iPad mini 3";
    
    if ([platform isEqualToString:@"iPad5,3"]) return @"iPad air 2";
    
    if ([platform isEqualToString:@"iPad5,4"]) return @"iPad air 2";
    
    if ([platform isEqualToString:@"iPad6,7"]) return @"iPad Pro";
    
    if ([platform isEqualToString:@"iPad6,8"]) return @"iPad Pro";
    
    if ([platform isEqualToString:@"iPhone Simulator"] || [platform isEqualToString:@"i386"] || [platform isEqualToString:@"x86_64"]) return @"iPhone Simulator";
    
    return platform;
}

+(NSString *)like_uuid
{
    static NSString *uuid = nil;
    if (uuid == nil) {
        NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString *path = [doc stringByAppendingPathComponent:@"app_uuid"];
        uuid = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        if (!uuid) {
            uuid = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
            [uuid writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
        }
    }
    return uuid;
}

+(NSArray *)deviceTypesArray
{
    id<LocalizationProtocol> localizationProtocol = [AppManager getLocalProtocol];
    return [localizationProtocol supportDeviceTypesArray];
}

+ (Class)classForDeviceType:(NSString *)deviceType {
    Class class = nil;
    id<LocalizationProtocol> localizationProtocol = [AppManager getLocalProtocol];
    NSMutableArray *supportDevices = [[NSMutableArray alloc] initWithArray:[localizationProtocol supportDeviceTypesArray]];
    
    if ([supportDevices containsObject:deviceType]) {
        class = [DeviceModel class];
    } else {
        class = [UnSupportDeviceModel class];
    }
    
    return class;
}

+ (void)getProductModelWithSku:(NSString *)sku callback:(HWAPICallBack)callback {
    NSDictionary * params = @{@"sku":sku};
    HWEnrollModeAPIManager *manager = [[HWEnrollModeAPIManager alloc] init];
    [manager callAPIWithParam:params completion:^(id object, NSError *error) {
        NSString *productModel = nil;
        if (!error) {
            if (object[@"productModel"]) {
                productModel = object[@"productModel"];
            } else {
                error = [NSError errorWithDomain:@"" code:200000 userInfo:nil];
            }
        }
        callback(productModel,error);
    }];
}

+ (BOOL)isSupportedDeviceType:(NSString *)deviceType
{
    NSArray * deviceTypesArray = [[self class]deviceTypesArray];
    return [deviceTypesArray containsObject:deviceType];
}

+ (NSString *)getSmallDeviceIconDeviceType:(NSString *)deviceType sku:(NSString *)sku {
    Class class = [[self class] classForDeviceType:deviceType];
    DeviceModel *deviceModel = [[class alloc] initWithDictionary:@{@"sku":sku?:@"",@"productModel":deviceType?:@""}];
    return [deviceModel deviceSmallIconImageName];
}

+ (BOOL)isTunaDevice:(NSString *)deviceType {
    if (deviceType) {
        return [[self tunaDeviceType] containsObject:deviceType];
    }
    return NO;
}

+ (BOOL)isSwdDeviceSku:(NSString *)sku {
    if (!sku) {
        return NO;
    }
    return [[self swdDeviceSkus] containsObject:sku];
}

+ (BOOL)isZoneDeviceType:(NSString *)deviceType {
    return [[self zoneDeviceTypes] containsObject:deviceType];
}

+ (BOOL)deviceSupportFingerPrint {
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    free(machine);
    
    NSMutableString *compareString = [NSMutableString stringWithString:platform];
    NSString *iphoneLimitPlatform = @"iPhone5,4";
    NSString *ipadLimitPlatform = @"iPad4,6";
    if ([compareString containsString:@"iPhone"]) {
        if ([compareString compare:iphoneLimitPlatform options:NSNumericSearch] == NSOrderedDescending) {
            return YES;
        }
    } else if ([compareString containsString:@"iPad"]) {
        if ([compareString compare:ipadLimitPlatform options:NSNumericSearch] == NSOrderedDescending) {
            return YES;
        }
    }
    return NO;
}

+ (NSString *)uuidString
{
     return [[[NSUUID UUID] UUIDString] lowercaseString];
}
    
+ (NSArray *)zoneDeviceTypes {
    return @[HWDeviceTypeZone,
             HWDeviceType24hZone];
}

+ (NSArray *)swdDeviceSkus {
    return @[@"1CGA0000W",
             @"1CGA0000B"];
}

+ (NSArray *)tunaDeviceType {
    return @[HWDeviceTypeHomePanelTuna1,
             HWDeviceTypeHomePanelTuna2,
             HWDeviceTypeHomePanelTuna3,
             HWDeviceTypeHomePanelTuna4,
             HWDeviceTypeHomePanelTuna5];
}

@end
