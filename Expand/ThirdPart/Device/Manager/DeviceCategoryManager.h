//
//  DeviceCategoryManager.h
//  HomePlatform
//
//  Created by BobYang on 12/04/2018.
//  Copyright © 2018 Honeywell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HomeModel.h"
#import "DeviceCategoryModel.h"

@interface DeviceCategoryManager : NSObject

@property (nonatomic, weak) HomeModel * homeModel;

- (NSArray<DeviceCategoryModel *> *)sortedDeviceCategorys;

@end
