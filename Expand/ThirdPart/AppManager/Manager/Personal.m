//
//  Personal.m
//  AirTouch
//
//  Created by Carl on 3/10/16.
//  Copyright © 2016 Honeywell. All rights reserved.
//

#import "Personal.h"
#import "PersonalRole.h"
#import "HomeModel.h"
#import "UserEntity.h"
#import "AppConfig.h"
#import "AppMarco.h"
#import "DeviceModel.h"

static PersonalRole *role = nil;
@implementation Personal

#pragma mark - DistributionProtocol

- (id<Role>)getRole {
    if (role == nil) {
        role = [[PersonalRole alloc] init];
    }
    return role;
}

- (BOOL)authorizedOwner:(id)model {
    if ([model isKindOfClass:[HomeModel class]]) {
        HomeModel *homeModel = (HomeModel *)model;
        return (homeModel.authorizedType == HomeAuthroizedTypeOwner) || [self openRole];
    } else if ([model isKindOfClass:[DeviceModel class]]) {
        DeviceModel *deviceModel = (DeviceModel *)model;
        return ([[UserEntity instance] userID] == deviceModel.ownerId) || [self openRole];
    }
    return YES;
}

- (BOOL)authorizedPermissionAll:(HomeModel *)homeModel {
    return (homeModel.authorizedType == HomeAuthroizedTypePermissionAll);
}

- (BOOL)authorizedPermissionSome:(HomeModel *)homeModel {
    return (homeModel.authorizedType == HomeAuthroizedTypePermissionSome);
}

- (BOOL)openRole {
    return [AppConfig getValueBool:DebugAuthorizeStatus];
}

- (BOOL)enableUnreadMessageAutoRefresh
{
    return YES;
}

- (NSString *)enrollTitleForHomePlaceHolder
{
    return NSLocalizedString(@"locationmgt_lbl_namelocation", nil);
}

- (NSArray *)supportDeviceTypesArray {
    return @[
             HWDeviceTypeShark,
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
             HWDeviceTypeChinaSWD,
             
             //subdevice
             HWDeviceTypeLight,
             HWDeviceTypeCurtain,
             HWDeviceTypeAirCondition,
             HWDeviceTypeAirCondition_002,
             HWDeviceTypeAirCondition_003,
             HWDeviceTypeAirCondition_004,
             HWDeviceTypeVentilation,
             HWDeviceTypeRelay,
             HWDeviceTypeBackgroundMusic,
             HWDeviceTypeUnderFloorHeating,
             HWDeviceTypeDimmer,
             HWDeviceTypeSmartIAQ,
             HWDeviceTypeZone,
             HWDeviceTypeLobby,
             HWDeviceTypeGuard,
             HWDeviceTypeOffice,
             HWDeviceTypeIpdc,
             HWDeviceTypeVentilation2,
             HWDeviceTypeLock,
             HWDeviceTypeLock_003,
             HWDeviceTypeElevator001,
             HWDeviceTypeHomePanelElevator,
             HWDeviceType24hZone,
             HWDeviceTypeELock,
             HWDeviceTypeDolphin,
             HWDeviceTypeHaiLin,
             HWDeviceTypeSensor_005,
             HWDeviceTypeChinaSWD6Key,
             HWDeviceTypeChinaSWD8Key,
             HWDeviceTypeChinaSensorSWD6Key,
             HWDeviceTypeChinaSWD4Key,
             HWDeviceTypeSWDSwitch,
             HWDeviceTypeSWDSwitch2M,
             HWDeviceTypeSWDSwitch3M,
             HWDeviceTypeSWDDimmer,
             HWDeviceTypeSWDCurtain,
             HWDeviceTypeSWDFan,
             HWDeviceTypeSWDBlind,
             HWDeviceTypeSWDSwitch4M,
             HWDeviceTypeIRAC,
             HWDeviceTypeChinaSWDSwitch,
             HWDeviceTypeChinaSWDSwitch2M,
             HWDeviceTypeChinaSWDSwitch3M,
             HWDeviceTypeChinaSWDSwitch4M,
             HWDeviceTypeChinaSWDSwitchSP1,
             HWDeviceTypeChinaSWDSwitchSP2,
             HWDeviceTypeChinaSWDSwitchSP3,
             HWDeviceTypeChinaSWDSwitchDT4,
             HWDeviceTypeChinaSWDSwitchDT8,
             HWDeviceTypeChinaSWDCurtain
             ];
}

@end
