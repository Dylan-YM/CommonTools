//
//  PersonalRole.m
//  AirTouch
//
//  Created by Carl on 3/14/16.
//  Copyright © 2016 Honeywell. All rights reserved.
//

#import "PersonalRole.h"
#import "DeviceModel.h"
#import "HomeModel.h"

@implementation PersonalRole

- (BOOL)canShowDeviceControl:(DeviceModel *)device {
    DeviceModel *deviceModel = nil;
    if (device.productClass == 4) {
        DeviceModel *parentDeviceModel = [device.homeModel getDeviceById:[NSString stringWithFormat:@"%ld",(long)device.parentDeviceId]];
        deviceModel = parentDeviceModel;
    } else {
        deviceModel = device;
    }
    return deviceModel.permission >= AuthorizeRoleObserver && !device.unSupport;
}

- (BOOL)canShowFilter:(DeviceModel *)device {
    return device.permission >= AuthorizeRoleOwner;
}

- (BOOL)canControlDevice:(DeviceModel *)device {
    return device.permission >= AuthorizeRoleController;
}

- (BOOL)canDeleteDevice:(DeviceModel *)device {
    return device.permission >= AuthorizeRoleOwner;
}

- (BOOL)canGroup:(DeviceModel *)device {
    return device.permission >= AuthorizeRoleOwner;
}

- (BOOL)canControlHome:(HomeModel *)home {
    if (home.authorizedType < HomeAuthroizedTypePermissionSome) {
        return YES;
    }
    return NO;
}

@end
