//
//  ChinaEnterprise.m
//  AirTouch
//
//  Created by Carl on 3/11/16.
//  Copyright © 2016 Honeywell. All rights reserved.
//

#import "ChinaEnterprise.h"
#import "HomeModel.h"

@implementation ChinaEnterprise

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
    return NO;
}

#pragma mark - Home
- (BOOL)supportWeatherEffect {
    return NO;
}

#pragma mark - Device
- (BOOL)showPurchaseOption:(DeviceModel *)deviceModel
{
    return deviceModel.permission >= AuthorizeRoleMaster;
}

#pragma mark - Enrollment
- (EnrollFlowIndex)startEnrollIndex
{
    return Enroll450SFlowIndex_QRCode;
}

-(NSArray *)supportEnrollmentManualSelectDeviceTypesArray
{
    return @[HWDeviceTypeAirTouchFFAC];
}

#pragma mark - Emotional
- (NSString *)shareImageSuffix {
    return @"zh";
}

@end
