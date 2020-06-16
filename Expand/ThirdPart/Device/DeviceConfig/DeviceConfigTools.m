//
//  DeviceConfigTools.m
//  HomePlatform
//
//  Created by Honeywell on 2018/9/7.
//  Copyright © 2018 Honeywell. All rights reserved.
//

#import "DeviceConfigTools.h"
#import "DeviceConfigModel.h"
#import "DeviceEnrollConfigModel.h"

@implementation DeviceConfigTools

+ (NSDictionary *)initDeviceConfigModelWithProductModel:(NSString *)productModel {
    NSString *resourcePath = [[NSBundle mainBundle] pathForResource:@"DeviceConfig" ofType:@"txt"];
    NSData *jsonData = [NSData dataWithContentsOfFile:resourcePath];
    NSError *error = nil;
    
    NSArray *devices = [NSJSONSerialization JSONObjectWithData:jsonData
                     options:NSJSONReadingAllowFragments
                     error:&error];
    DeviceConfigModel *deviceConfigModel = nil;
    DeviceEnrollConfigModel *deviceEnrollModel = nil;
    for (NSDictionary *deviceConfigInfo in devices) {
        NSArray *productModels = deviceConfigInfo[@"productModel"];
        if ([productModels containsObject:productModel]) {
            deviceConfigModel = [[DeviceConfigModel alloc] initWithDictionary:deviceConfigInfo];
            if ([deviceConfigInfo.allKeys containsObject:@"enroll"]) {
                deviceEnrollModel = [[DeviceEnrollConfigModel alloc] initWithDictionary:[deviceConfigInfo objectForKey:@"enroll"]];
            }
            break;
        }
    }
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    if (deviceConfigModel) {
        [result setObject:deviceConfigModel forKey:@"deviceConfigModel"];
    }
    if (deviceEnrollModel) {
        [result setObject:deviceEnrollModel forKey:@"deviceEnrollModel"];
    }
    return result;
}

+ (NSDictionary *)initDeviceConfigInfoWithProductModel:(NSString *)productModel {
    NSString *resourcePath = [[NSBundle mainBundle] pathForResource:@"DeviceConfig" ofType:@"txt"];
    NSData *jsonData = [NSData dataWithContentsOfFile:resourcePath];
    NSError *error = nil;
    
    NSArray *devices = [NSJSONSerialization JSONObjectWithData:jsonData
                                                       options:NSJSONReadingAllowFragments
                                                         error:&error];
    NSDictionary *result = nil;
    for (NSDictionary *deviceConfigInfo in devices) {
        NSArray *productModels = deviceConfigInfo[@"productModel"];
        if ([productModels containsObject:productModel]) {
            result = deviceConfigInfo;
            break;
        }
    }
    return result;
}

@end
