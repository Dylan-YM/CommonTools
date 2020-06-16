//
//  HWImageCache.m
//  WeatherEffect
//
//  Created by Carl on 8/24/15.
//  Copyright (c) 2015 Honeywell. All rights reserved.
//

#import "HWImageCache.h"
#import "AppManager.h"
#import "CryptoUtil.h"

#define kImageCacheServerChina          @"https://hch.blob.core.chinacloudapi.cn/threelayerimagescitybackground/"
#define kImageCacheServerIndia          @"https://hch.blob.core.chinacloudapi.cn/indiathreebgimages/"
#define kImageCacheApiCity              @"city.txt"
#define kImageCacheChinaFolder          @"ImageCache"
#define kImageCacheIndiaFolder          @"ImageIndia"

static HWImageCache *instance = nil;

NSString * const HWImageCacheDownloadImageNotification = @"HWImageCacheDownloadImageNotification";
NSString * const HWImageCacheDownloadCityNotification = @"HWImageCacheDownloadCityNotification";

NSString * const HWImageClearAttributeName = @"image_clear";

NSString * const HWVersionAttributeName = @"version";
NSString * const HWCityAttributeName = @"city";

NSString * const HWDayNightAttributeName = @"daynight";
NSString * const HWDayNightAttributeDay = @"day";
NSString * const HWDayNightAttributeNight = @"night";

NSString * const HWWeatherAttributeName = @"weather";
NSString * const HWWeatherAttributeGood = @"good";
NSString * const HWWeatherAttributeBad = @"bad";

@interface HWImageCache ()

@property (assign, nonatomic) HWImageCacheStatus status;

@end

@implementation HWImageCache

+ (HWImageCache *)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[HWImageCache alloc] init];
        instance.status = HWImageCacheStatusInvalid;
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        cachequeue = dispatch_queue_create("CACHE_QUEUE", NULL);
        dispatch_set_target_queue(cachequeue, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0));
    }
    return self;
}

- (void)updateCityBackground:(NSArray *)cities {
    if (self.status == HWImageCacheStatusStart) {
        return;
    }
    self.status = HWImageCacheStatusStart;
    if (_block) {
        _block(self.status);
    }
    updateToken = [CryptoUtil randomInt];
    UserCountryType country = [[AppManager getLocalProtocol] userCountryType];
    NSString *cacheFolder = country == UserCountryTypeIndia ? kImageCacheIndiaFolder : kImageCacheChinaFolder;
    NSString *cacheServer = country == UserCountryTypeIndia ? kImageCacheServerIndia : kImageCacheServerChina;
    dispatch_async(cachequeue, ^{
        u_int32_t tempToken = updateToken;
        NSString *cachesPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:cacheFolder];
        if (![[NSFileManager defaultManager] fileExistsAtPath:cachesPath]) {
            NSError *folderError = nil;
            BOOL createSuccess = [[NSFileManager defaultManager] createDirectoryAtPath:cachesPath withIntermediateDirectories:YES attributes:nil error:&folderError];
            if (!createSuccess) {
                NSLog(@"Create Foler Error:%@",[folderError localizedDescription]);
            }
        }
        
        NSURL *serverCityURL = [NSURL URLWithString:[cacheServer stringByAppendingPathComponent:kImageCacheApiCity]];
        NSString *cacheCityPath = [cachesPath stringByAppendingPathComponent:kImageCacheApiCity];
        
        NSError *error = nil;
        NSData *serverCityJsonData = [NSData dataWithContentsOfURL:serverCityURL];
        if (serverCityJsonData) {
            NSDictionary *serverCityObject = [NSJSONSerialization JSONObjectWithData:serverCityJsonData options:NSJSONReadingMutableContainers error:&error];
            
            NSDictionary *cacheCityObject = [NSDictionary dictionaryWithContentsOfFile:cacheCityPath];
            
            if ([serverCityObject isKindOfClass:[NSDictionary class]]
                && (cacheCityObject == nil
                    || ![cacheCityObject isEqualToDictionary:serverCityObject])) {
                    NSMutableDictionary *citiesObject = [NSMutableDictionary dictionary];
                    NSMutableDictionary *tempFinishedCitiesObject = [NSMutableDictionary dictionary];
                    
                    for (NSString *city in [serverCityObject allKeys]) {
                        if ([city isEqualToString:kImageCacheDefault]
                            || [cities containsObject:city]) {
                            citiesObject[city] = serverCityObject[city];
                        }
                    }
                    
                    BOOL success = YES;
                    for (NSString *city in [citiesObject allKeys]) {
                        if (tempToken != updateToken) {
                            success = NO;
                            break;
                        }
                        NSString *serverCityVersion = serverCityObject[city];
                        NSString *cacheCityVersion = cacheCityObject[city];
                        if (cacheCityVersion == nil
                            || ![cacheCityVersion isEqualToString:serverCityVersion]) {
                            BOOL citySuccess = [self updateCity:city];
                            if (!citySuccess) {
                                success = NO;
                            } else {
                                tempFinishedCitiesObject[city] = serverCityVersion;
                            }
                        } else {
                            tempFinishedCitiesObject[city] = serverCityVersion;
                        }
                        [tempFinishedCitiesObject writeToFile:cacheCityPath atomically:YES];
                    }
                    
                    if (success) {
                        //update success,then write new version to path
                        BOOL writeSuccess = [citiesObject writeToFile:cacheCityPath atomically:YES];
                        if (!writeSuccess) {
                            NSLog(@"Write City List Failed");
                        }
                    }
                }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            self.status = HWImageCacheStatusEnd;
            if (_block) {
                _block(self.status);
            }
        });
    });
}

- (BOOL)updateCity:(NSString *)city {
    UserCountryType country = [[AppManager getLocalProtocol] userCountryType];
    NSString *cacheFolder = country == UserCountryTypeIndia ? kImageCacheIndiaFolder : kImageCacheChinaFolder;
    NSString *cacheServer = country == UserCountryTypeIndia ? kImageCacheServerIndia : kImageCacheServerChina;
    NSString *cachesPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:cacheFolder];
    
    NSURL *serverCityURL = [NSURL URLWithString:[cacheServer stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.txt",city]]];
    NSString *cacheCityPath = [cachesPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.txt",city]];
    
    NSError *error = nil;
    NSData *serverCityJsonData = [NSData dataWithContentsOfURL:serverCityURL];
    if (serverCityJsonData) {
        NSArray *serverCityObject = [NSJSONSerialization JSONObjectWithData:serverCityJsonData options:NSJSONReadingMutableContainers error:&error];
        
        if (![serverCityObject isKindOfClass:[NSArray class]]) {
            return NO;
        }
        
        NSArray *cacheCityObject = [NSArray arrayWithContentsOfFile:cacheCityPath];
        
        BOOL hasUpdate = NO;
        BOOL updateSuccess = YES;
        if ((cacheCityObject == nil
             || ![cacheCityObject isEqualToArray:serverCityObject])) {
            
            NSMutableArray *tempFinishCityImageArray = [NSMutableArray array];
            for (NSDictionary *serverImageObject in serverCityObject) {
                NSString *imageClearName = serverImageObject[HWImageClearAttributeName];
                if (imageClearName == nil) {
                    updateSuccess = NO;
                    continue;
                }
                
                NSString *serverImageVersion = serverImageObject[HWVersionAttributeName];
                NSString *cacheImageVersion = nil;
                for (NSDictionary *cacheImageObject in cacheCityObject) {
                    if ([cacheImageObject[HWImageClearAttributeName] isEqualToString:imageClearName]) {
                        cacheImageVersion = cacheImageObject[HWVersionAttributeName];
                        break;
                    }
                }
                
                if (cacheImageVersion == nil
                    || ![cacheImageVersion isEqualToString:serverImageVersion]) {
                    NSArray *imageNames = @[imageClearName];
                    BOOL oneCellSuccess = YES;
                    
                    for (NSString *imageName in imageNames) {
                        NSString *imageURL = [cacheServer stringByAppendingPathComponent:imageName];
                        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]];
                        if (imageData) {
                            BOOL writeSuccess = [imageData writeToFile:[cachesPath stringByAppendingPathComponent:imageName] atomically:YES];
                            if (!writeSuccess) {
                                NSLog(@"Write Image Failed");
                                oneCellSuccess = NO;
                                break;
                            }
                        } else {
                            oneCellSuccess = NO;
                            break;
                        }
                    }
                    
                    if (oneCellSuccess) {
                        hasUpdate = YES;
                        [tempFinishCityImageArray addObject:serverImageObject];
                        
                        NSString *daynight = serverImageObject[HWDayNightAttributeName];
                        NSString *weather = serverImageObject[HWWeatherAttributeName];
                        NSDictionary *userInfo = @{HWDayNightAttributeName:daynight,
                                                   HWCityAttributeName:city,
                                                   HWWeatherAttributeName:weather};
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [[NSNotificationCenter defaultCenter] postNotificationName:HWImageCacheDownloadImageNotification object:self userInfo:userInfo];
                        });
                    } else {
                        updateSuccess = NO;
                    }
                } else {
                    [tempFinishCityImageArray addObject:serverImageObject];
                }
                [tempFinishCityImageArray writeToFile:cacheCityPath atomically:YES];
            }
            if (updateSuccess) {
                //update success,then write new version to path
                BOOL writeSuccess = [serverCityObject writeToFile:cacheCityPath atomically:YES];
                if (!writeSuccess) {
                    NSLog(@"Write City Image List Failed");
                } else {
                    if (hasUpdate) {
                        NSDictionary *userInfo = @{HWCityAttributeName:city};
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [[NSNotificationCenter defaultCenter] postNotificationName:HWImageCacheDownloadCityNotification object:self userInfo:userInfo];
                        });
                    }
                }
            }
        }
        return updateSuccess;
    }
    return NO;
}

- (NSMutableArray *)getMatchImages:(NSString *)cachesPath reqWeather:(NSString *)reqWeather reqDaynight:(NSString *)reqDaynight cacheCityObject:(NSArray *)cacheCityObject {
    if (cacheCityObject == nil) {
        return nil;
    }
    NSMutableArray *matches = [NSMutableArray array];
    for (NSDictionary *cacheImageObject in cacheCityObject) {
        NSString *imageClearName = cacheImageObject[HWImageClearAttributeName];
        NSString *daynight = cacheImageObject[HWDayNightAttributeName];
        NSString *weather = cacheImageObject[HWWeatherAttributeName];
        
        BOOL shouldAdd = NO;
        //Check day night
        if (reqDaynight != nil) {
            if ([reqDaynight isEqualToString:HWDayNightAttributeDay]) {
                if ([daynight isEqualToString:HWDayNightAttributeDay]) {
                    //Check weather
                    if (reqWeather != nil) {
                        if ([reqWeather isEqualToString:weather]) {
                            shouldAdd = YES;
                        }
                    } else {
                        shouldAdd = YES;
                    }
                }
            } else {
                //if night, ignore weather
                if ([daynight isEqualToString:HWDayNightAttributeNight]) {
                    shouldAdd = YES;
                }
            }
        } else {
            shouldAdd = YES;
        }
        if (shouldAdd) {
            if (imageClearName) {
                [matches addObject:@{HWImageClearAttributeName:[cachesPath stringByAppendingPathComponent:imageClearName]}];
            }
        }
    }
    return matches;
}

- (NSArray *)getImagePathForCity:(NSString *)city condition:(NSDictionary *)condition {
    UserCountryType country = [[AppManager getLocalProtocol] userCountryType];
    NSString *cacheFolder = country == UserCountryTypeIndia ? kImageCacheIndiaFolder : kImageCacheChinaFolder;
    NSString *cachesPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:cacheFolder];
    NSString *cacheCityPath = [cachesPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.txt",city]];
    NSArray *cacheCityObject = [NSArray arrayWithContentsOfFile:cacheCityPath];
    
    NSString *reqDaynight = condition[HWDayNightAttributeName];
    NSString *reqWeather = condition[HWWeatherAttributeName];
    
    NSMutableArray *matches = [self getMatchImages:cachesPath reqWeather:reqWeather reqDaynight:reqDaynight cacheCityObject:cacheCityObject];
    if ([matches count] == 0) {
        NSString *cacheDefaultPath = [cachesPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.txt",kImageCacheDefault]];
        cacheCityObject = [NSArray arrayWithContentsOfFile:cacheDefaultPath];
        matches = [self getMatchImages:cachesPath reqWeather:reqWeather reqDaynight:reqDaynight cacheCityObject:cacheCityObject];
    }
    if (matches == nil) {
        matches = [NSMutableArray array];
    }
    if ([matches count] == 0) {
        //Check day night
        if (reqDaynight == nil || [reqDaynight isEqualToString:HWDayNightAttributeDay]) {
            //Check weather
            [matches addObject:@{HWImageClearAttributeName:[[NSBundle mainBundle] pathForResource:@"Default_day1a.png" ofType:nil]}];
        } else {
            [matches addObject:@{HWImageClearAttributeName:[[NSBundle mainBundle] pathForResource:@"Default_night1a.png" ofType:nil]}];
        }
    }
    return matches;
}

@end
