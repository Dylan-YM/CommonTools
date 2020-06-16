//
//  ChinaPersonal.m
//  AirTouch
//
//  Created by Carl on 3/10/16.
//  Copyright © 2016 Honeywell. All rights reserved.
//

#import "ChinaPersonal.h"
#import "HomeModel.h"

@implementation ChinaPersonal

#pragma mark - LocalizationProtocol
#pragma mark - Other
-(BOOL)filterDataUseEnglishUnderUnenglishLanguage
{
    return NO;
}

- (NSArray *)matchCityNamesArray
{
    return nil;
}

#pragma mark - User
- (UserCountryType)userCountryType {
    return UserCountryTypeChina;
}

- (WirelessNetworkType)wirelessNetworkType {
    return WirelessNetworkTypeWLAN;
}

- (NSString *)ISOcountryCode
{
    return @"CH";
}

- (NSInteger)phoneNumberLength {
    return 11;
}

#pragma mark - Setting
- (NSString *)customerCareTelephoneNumber
{
    return @"4007204321";
}

- (BOOL)supportLocationSelect {
    return YES;
}

#pragma mark - Home
- (BOOL)supportWeatherEffect {
    return YES;
}

#pragma mark - Device
- (BOOL)showPurchaseOption:(DeviceModel *)deviceModel
{
    return deviceModel.permission >= AuthorizeRoleObserver;
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
    return @"zh";
}

@end
