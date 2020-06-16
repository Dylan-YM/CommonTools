//
//  LocationManager.h
//  AirTouch
//
//  Created by Devin on 1/19/15.
//  Copyright (c) 2015 Honeywell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "AppManager.h"
//UIKIT_EXTERN NSString * const HWLocationStateWillUpdateNotification;
//
//UIKIT_EXTERN NSString * const HWLocationOriginLocationKey;
//UIKIT_EXTERN NSString * const HWLocationNewLocationKey;
//
//UIKIT_EXTERN NSString * const HWLocationStateDidUpdateNotification;
//
//UIKIT_EXTERN NSString * const HWLocationOriginStateKey;
//UIKIT_EXTERN NSString * const HWLocationNewStateKey;

typedef void (^ATResponseBlock)(NSDictionary* responseDictionary, NSInteger resultType, id model);

typedef NS_ENUM(NSInteger, LocationAuthorizationStatus) {
    LocationEnable,
    LocationServiceDisable,
    LocationAPPDisable
};

typedef NS_ENUM(NSInteger, LocationResults) {
    LocationResultInit,
    LocationResultSuccessed,
    LocationResultError,
    LocationResultTimeout,
    LocationResultAuthorizationDisable
};

#define GPSLocationName @"GPSLocationName"
#define LocationTimeout @"LocationTimeout"
#define LocationCoordinate @"LocationCoordinate"

@interface LocationManager : NSObject
<CLLocationManagerDelegate>
{
    CLLocationManager *_locationManager;
    CLGeocoder *_geocoder;
}

@property (assign, nonatomic) LocationResults locationResult;
@property (assign, nonatomic) CLLocationCoordinate2D locationCoordinate;

@property BOOL isBeingUpdateLocation;
//@property BOOL isAfterLocation;
@property (nonatomic, strong) NSString * ISOcountryCode;
@property (nonatomic, assign) UserCountryType userCountry;
@property (nonatomic, assign, readonly) BOOL isLocating;

+ (instancetype)shareLocationManager;

/**
 *  Getting current location with block.
 *
 *  @param paramBlock   return (NSDictionary* responseDictionary, NSInteger resultType, NSString * resultValue)
 *                              NSDictionary : {GPSLocationName:GPSLocationValue}
 *                              resultType   : 1,success; 2,error; 3,timeout; 4,authorization forbid
 *                              resultValue  :   location city name / error info / timeout / authorizationStatus
 *
 *  @param paramTimeout timeoutInterval if paramTimeout==0 , no timeout .
 */
- (void)startRequestLocation:(ATResponseBlock)paramBlock timeoutInterval:(NSTimeInterval)paramTimeout;

- (void)stopRequestLocation;

- (void)cancelLocation;

/**
 *  check location authorizationStatus
 *
 *  @return LocationAuthorizationStatus
 */
- (LocationAuthorizationStatus)canRequestLocation;


@end
