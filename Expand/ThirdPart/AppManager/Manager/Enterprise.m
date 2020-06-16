//
//  Enterprise.m
//  AirTouch
//
//  Created by Carl on 3/10/16.
//  Copyright © 2016 Honeywell. All rights reserved.
//

#import "Enterprise.h"
#import "EnterpriseRole.h"
#import "HomeModel.h"
#import "AppConfig.h"
#import "AppMarco.h"
#import "UserEntity.h"
#import "DeviceModel.h"

static EnterpriseRole *role = nil;

@implementation Enterprise

#pragma mark - DistributionProtocol

- (id<Role>)getRole {
    if (role == nil) {
        role = [[EnterpriseRole alloc] init];
    }
    return role;
}

- (BOOL)openRole {
    return [AppConfig getValueBool:DebugAuthorizeStatus];
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

- (BOOL)enableUnreadMessageAutoRefresh
{
    return NO;
}

- (NSString *)enrollTitleForHomePlaceHolder
{
    return NSLocalizedString(@"locationmgt_lbl_namelocation", nil);
}

-(NSArray *)supportDeviceTypesArray
{
    return @[
             HWDeviceTypeAirTouchFFAC,
             HWDeviceTypeHomePanelTuna1,
             HWDeviceTypeHomePanelTuna2,
             HWDeviceTypeHomePanelTuna3,
             HWDeviceTypeHomePanelTuna4,
             HWDeviceTypeHomePanelTuna5
             ];
}

@end
