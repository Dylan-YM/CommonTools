//
//  DeviceConfigTools.h
//  HomePlatform
//
//  Created by Honeywell on 2018/9/7.
//  Copyright © 2018 Honeywell. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DeviceConfigModel;

@interface DeviceConfigTools : NSObject

+ (NSDictionary *)initDeviceConfigModelWithProductModel:(NSString *)productModel;

+ (NSDictionary *)initDeviceConfigInfoWithProductModel:(NSString *)productModel;

@end
