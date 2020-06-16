//
//  LocalizationProtocol.h
//  AirTouch
//
//  Created by BobYang on 16/1/26.
//  Copyright © 2016年 Honeywell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DistributionProtocol.h"
#import "IContainerViewControllerDelegate.h"

typedef NS_ENUM(NSInteger, UserCountryType) {
    UserCountryTypeChina, //中国
    UserCountryTypeIndia, //印度
};

typedef NS_ENUM(NSInteger, WirelessNetworkType) {
    WirelessNetworkTypeWLAN, //中国无线网络叫作WLAN
    WirelessNetworkTypeWiFi, //印度无线网络叫作Wi-Fi
};

@protocol LocalizationProtocol <DistributionProtocol>
@required
#pragma mark - Other
- (BOOL)filterDataUseEnglishUnderUnenglishLanguage;
- (NSArray *)matchCityNamesArray;

#pragma mark - User
- (UserCountryType)userCountryType;
- (WirelessNetworkType)wirelessNetworkType;
- (NSString *)ISOcountryCode;
- (NSInteger)phoneNumberLength;

#pragma mark - Setting
- (NSString *)customerCareTelephoneNumber;
- (BOOL)supportLocationSelect;

#pragma mark - Home
- (BOOL)supportWeatherEffect;

#pragma mark - Device
- (BOOL)showPurchaseOption:(DeviceModel *)deviceModel;

#pragma mark - Enrollment
- (EnrollFlowIndex)startEnrollIndex;
//- (NSArray *)supportEnrollmentManualSelectDeviceTypesArray;
#pragma AP enroll

- (NSArray *)supportEnrollmentManualSelectDeviceTypesArray;

#pragma mark - Emotional
- (NSString *)shareImageSuffix;

@end
