//
//  DeviceCategoryManager.m
//  HomePlatform
//
//  Created by BobYang on 12/04/2018.
//  Copyright © 2018 Honeywell. All rights reserved.
//

#import "DeviceCategoryManager.h"
#import "AppConfig.h"
#import "DeviceModel.h"

@implementation DeviceCategoryManager

//获取经过排序的DeviceCategorys
- (NSArray<DeviceCategoryModel *> *)sortedDeviceCategorys {
    NSArray<DeviceCategoryModel *> * unsortedDeviceCategorys = [self unsortedDeviceCategorys];
    NSMutableArray<DeviceCategoryModel *> * supportedDeviceCategorys = [NSMutableArray array];
    NSMutableArray<DeviceCategoryModel *> * unsupportedDeviceCategorys = [NSMutableArray array];
    for (DeviceCategoryModel * deviceCategoryModel in unsortedDeviceCategorys) {
        [deviceCategoryModel refreshDeviceModelSections];//向deviceCategoryModel中注入deviceModels
        if ([deviceCategoryModel isSupported]) {//分别组装supportedDeviceCategorys和unsupportedDeviceCategorys
            [supportedDeviceCategorys addObject:deviceCategoryModel];
        } else {
            [unsupportedDeviceCategorys addObject:deviceCategoryModel];
        }
    }
    //将supportedDeviceCategorys安装categoryName的字母顺序进行排序
    NSArray<DeviceCategoryModel *> * sortedSupportedDeviceCategorys = [supportedDeviceCategorys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        DeviceCategoryModel * deviceCategoryModel1 = (DeviceCategoryModel *)obj1;
        DeviceCategoryModel * deviceCategoryModel2 = (DeviceCategoryModel *)obj2;
        NSComparisonResult categoryNameComparisonResult = [deviceCategoryModel1.categoryName localizedCompare:deviceCategoryModel2.categoryName];
        return categoryNameComparisonResult;
    }];
    //最后获取sortedDeviceCategorys
    NSMutableArray<DeviceCategoryModel *> * sortedDeviceCategorys = [NSMutableArray array];
    [sortedDeviceCategorys addObjectsFromArray:sortedSupportedDeviceCategorys];//将排序好的sortedSupportedDeviceCategorys加入sortedDeviceCategorys
    [sortedDeviceCategorys addObjectsFromArray:unsupportedDeviceCategorys];//最后将unsupportedDeviceCategorys加入sortedDeviceCategorys
    return sortedDeviceCategorys;
}

//将device按照deviceCatagoryName分别归入到相应的DeviceCategoryModel下
- (NSArray<DeviceCategoryModel *> *)unsortedDeviceCategorys {
    NSMutableArray<DeviceCategoryModel *> * unsortedDeviceCategorys = [NSMutableArray array];
    NSArray<DeviceModel *> * allDevices = [self allDevices];
    for (DeviceModel * deviceModel in allDevices) {
        NSString *deviceCategoryName = [deviceModel deviceCategoryString];
        DeviceCategoryModel * deviceCategory = [self deviceCategoryWithCategoryName:deviceCategoryName inDeviceCategorys:unsortedDeviceCategorys];
        if (deviceCategory == nil) {
            deviceCategory = [[DeviceCategoryModel alloc]init];
            deviceCategory.categoryName = deviceCategoryName;
            deviceCategory.homeModel = self.homeModel;
        }
        [deviceCategory.deviceModels addObject:deviceModel];
        if (![unsortedDeviceCategorys containsObject:deviceCategory]) {
            [unsortedDeviceCategorys addObject:deviceCategory];
        }
    }
    return unsortedDeviceCategorys;
}

//按照特定的categoryName在DeviceCategory数组中查找DeviceCategoryModel
- (DeviceCategoryModel *)deviceCategoryWithCategoryName:(NSString *)categoryName inDeviceCategorys:(NSArray<DeviceCategoryModel *> *)deviceCategorys {
    for (DeviceCategoryModel * categoryModel in deviceCategorys) {
        if ([categoryModel.categoryName isEqualToString:categoryName]) {
            return categoryModel;
        }
    }
    return nil;
}

- (NSArray<DeviceModel *> *)allDevices {
    NSArray<DeviceModel *> * deviceModels = [self.homeModel getAllDevice];
    return deviceModels;
}

@end
