//
//  DeviceCategoryModel.h
//  HomePlatform
//
//  Created by BobYang on 11/04/2018.
//  Copyright © 2018 Honeywell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HomeModel.h"

@interface DeviceCategoryModel : NSObject

@property (nonatomic, strong) NSString * categoryName;

@property (nonatomic, weak) HomeModel *homeModel;

@property (nonatomic, strong) NSMutableArray<DeviceModel *> * deviceModels;

@property (nonatomic, strong) NSArray<NSArray<DeviceModel *> *> * deviceModelSections;

@property (nonatomic, assign, readonly) BOOL isSupported;

- (void)refreshDeviceModelSections;

@end
