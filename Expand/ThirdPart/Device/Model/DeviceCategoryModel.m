//
//  DeviceCategoryModel.m
//  HomePlatform
//
//  Created by BobYang on 11/04/2018.
//  Copyright © 2018 Honeywell. All rights reserved.
//

#import "DeviceCategoryModel.h"
#import "UnSupportDeviceModel.h"

#define kNumberOfDevicesInOneRow 3

@implementation DeviceCategoryModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.deviceModels = [NSMutableArray array];
    }
    return self;
}

- (void)refreshDeviceModelSections {
    self.deviceModelSections = [self calculateDeviceModelSections];
}

- (BOOL)isSupported {
    if (self.deviceModels.count == 0) {
        return NO;
    }
    DeviceModel * deviceModel = self.deviceModels[0];
    if ([deviceModel isKindOfClass:[UnSupportDeviceModel class]]) {
        return NO;
    }
    return YES;
}

- (NSArray<DeviceModel *> *)sortedDevices {
    NSArray<DeviceModel *> * sortedDevices = [self.deviceModels sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        DeviceModel * deviceModel1 = (DeviceModel *)obj1;
        DeviceModel * deviceModel2 = (DeviceModel *)obj2;
        NSComparisonResult comparisonResult = [deviceModel1.name localizedCompare:deviceModel2.name];
        return comparisonResult;
    }];
    return sortedDevices;
}

//将deviceModels重组成一个n行kNumberOfDevicesInOneRow列的数组
- (NSArray<NSArray<DeviceModel *> *> *)calculateDeviceModelSections {
    NSMutableArray<NSArray<DeviceModel *> *> * deviceModelSections = [NSMutableArray array];
    NSMutableArray<DeviceModel *> * deviceModelSection = nil;
    NSArray<DeviceModel *> * sortedDevices = [self sortedDevices];
    NSUInteger count = sortedDevices.count;
    for (NSUInteger i = 0; i < count; i++) {
        if (i % kNumberOfDevicesInOneRow == 0) {
            deviceModelSection = [NSMutableArray array];
            [deviceModelSections addObject:deviceModelSection];
        }
        DeviceModel * deviceModel = sortedDevices[i];
        [deviceModelSection addObject:deviceModel];
    }
    return deviceModelSections;
}

@end
