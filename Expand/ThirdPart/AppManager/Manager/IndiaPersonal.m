//
//  IndiaPersonal.m
//  AirTouch
//
//  Created by Carl on 3/10/16.
//  Copyright © 2016 Honeywell. All rights reserved.
//

#import "IndiaPersonal.h"
#import "HomeModel.h"

@implementation IndiaPersonal

#pragma mark - LocalizationProtocol
#pragma mark - Other
-(BOOL)filterDataUseEnglishUnderUnenglishLanguage
{
    return YES;
}

- (NSArray *)matchCityNamesArray
{
    NSArray *indiaCityArray=[[NSArray alloc] initWithObjects:@"Bengaluru (Bangalore)",@"Belagavi (Belgaum)",@"Mysuru (Mysore)",@"Mangaluru (Mangalore)",@"Kalburgi (Gulbarga)",@"Shivamogga (Shimoga)",@"Vijayapura (Bijapur)",@"Tumakuru (Tumkur)", nil];
    return indiaCityArray;
}

#pragma mark - User
- (UserCountryType)userCountryType {
    return UserCountryTypeIndia;
}

- (WirelessNetworkType)wirelessNetworkType {
    return WirelessNetworkTypeWiFi;
}

- (NSString *)ISOcountryCode
{
    return @"IN";
}

- (NSInteger)phoneNumberLength {
    return 10;
}

#pragma mark - Setting
- (NSString *)customerCareTelephoneNumber
{
    return @"18001034761";
}

- (BOOL)supportLocationSelect {
    return NO;
}

#pragma mark - Home
- (BOOL)supportWeatherEffect {
    return NO;
}

#pragma mark - Device
- (BOOL)showPurchaseOption:(DeviceModel *)deviceModel
{
    return NO;
}

#pragma mark - Enrollment
- (EnrollFlowIndex)startEnrollIndex
{
    return EnrollFlowIndex_SelectDevice;
}

- (NSArray *)supportEnrollmentManualSelectDeviceTypesArray {
    return @[HWDeviceTypeShark,
             HWDeviceTypeHomePanelShark2,
             HWDeviceTypeSWD,
             HWDeviceTypeHomePanelTuna1,
             HWDeviceTypeHomePanelTuna2,
             HWDeviceTypeHomePanelTuna3,
             HWDeviceTypeHomePanelTuna4,
             HWDeviceTypeHomePanelTuna5,
             HWDeviceTypeCubeC,
             HWDeviceTypeWallVentilator,
             HWDeviceTypeGLD,
             HWDeviceTypeIR,
             HWDeviceTypeChinaSWD];
}

#pragma mark - Emotional
- (NSString *)shareImageSuffix {
    return @"en";
}

@end
