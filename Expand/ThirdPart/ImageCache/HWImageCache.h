//
//  HWImageCache.h
//  WeatherEffect
//
//  Created by Carl on 8/24/15.
//  Copyright (c) 2015 Honeywell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    HWImageCacheStatusStart,
    HWImageCacheStatusEnd,
    HWImageCacheStatusInvalid
} HWImageCacheStatus;

UIKIT_EXTERN NSString * const HWImageCacheDownloadImageNotification;
UIKIT_EXTERN NSString * const HWImageCacheDownloadCityNotification;

UIKIT_EXTERN NSString * const HWImageClearAttributeName;

UIKIT_EXTERN NSString * const HWVersionAttributeName;
UIKIT_EXTERN NSString * const HWCityAttributeName;

UIKIT_EXTERN NSString * const HWDayNightAttributeName;
UIKIT_EXTERN NSString * const HWDayNightAttributeDay;
UIKIT_EXTERN NSString * const HWDayNightAttributeNight;

UIKIT_EXTERN NSString * const HWWeatherAttributeName;
UIKIT_EXTERN NSString * const HWWeatherAttributeGood;
UIKIT_EXTERN NSString * const HWWeatherAttributeBad;

#define kImageCacheDefault              @"Default"

typedef void(^HWImageCacheBlock)(HWImageCacheStatus);

@interface HWImageCache : NSObject {
    dispatch_queue_t cachequeue;
    u_int32_t updateToken;
}

@property (strong, nonatomic) HWImageCacheBlock block;

+ (HWImageCache *)sharedInstance;

- (void)updateCityBackground:(NSArray *)cities;

- (NSArray *)getImagePathForCity:(NSString *)city condition:(NSDictionary *)condition;

@end
