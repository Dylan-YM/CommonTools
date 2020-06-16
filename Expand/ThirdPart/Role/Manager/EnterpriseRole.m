//
//  EnterpriseRole.m
//  AirTouch
//
//  Created by Carl on 3/14/16.
//  Copyright © 2016 Honeywell. All rights reserved.
//

#import "EnterpriseRole.h"
#import "DeviceModel.h"

@implementation EnterpriseRole

- (BOOL)canShowDeviceControl:(DeviceModel *)device {
    return NO;
}

- (BOOL)canShowFilter:(DeviceModel *)device {
    return NO;
}

- (BOOL)canControlDevice:(DeviceModel *)device {
    return NO;
}

- (BOOL)canDeleteDevice:(DeviceModel *)device {
    return device.permission >= AuthorizeRoleOwner;
}

- (BOOL)canGroup:(DeviceModel *)device {
    return NO;
}

- (BOOL)canControlHome:(HomeModel *)home {
    return NO;
}

@end
