//
//  Role.h
//  AirTouch
//
//  Created by Carl on 3/14/16.
//  Copyright © 2016 Honeywell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DeviceRole.h"

@class DeviceModel, HomeModel;
@protocol Role <NSObject>

- (BOOL)canShowDeviceControl:(DeviceModel *)device;

- (BOOL)canShowFilter:(DeviceModel *)device;

- (BOOL)canControlDevice:(DeviceModel *)device;

- (BOOL)canDeleteDevice:(DeviceModel *)device;

- (BOOL)canGroup:(DeviceModel *)device;

- (BOOL)canControlHome:(HomeModel *)home;

@end
