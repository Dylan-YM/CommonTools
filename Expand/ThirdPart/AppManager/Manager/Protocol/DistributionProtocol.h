//
//  DistributionProtocol.h
//  AirTouch
//
//  Created by Carl on 3/10/16.
//  Copyright © 2016 Honeywell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Role.h"
/**
 *  This protocol will define features:
 *  Personal's China account & India accout have the same value,
 *  but Personal & Enterprise have different values.
 *  e.g.:change password feature is removed in enterprise distrubtion,but for Personal's China & India distribution, it remains there.
 */
@class HomeModel;
@class DeviceModel;
@protocol DistributionProtocol <NSObject>

- (id<Role>)getRole;

- (BOOL)openRole;

- (BOOL)authorizedOwner:(id)model;

- (BOOL)authorizedPermissionAll:(HomeModel *)homeModel;

- (BOOL)authorizedPermissionSome:(HomeModel *)homeModel;

#pragma mark remove 5 homes limit
- (BOOL)enableUnreadMessageAutoRefresh;

#pragma AP enroll

-(NSArray *)supportDeviceTypesArray;

- (NSString *)enrollTitleForHomePlaceHolder;

@end
