//
//  HWDevicesListAPIManager.m
//  HomePlatform
//
//  Created by Honeywell on 2017/6/26.
//  Copyright © 2017年 Honeywell. All rights reserved.
//

#import "HWDevicesListAPIManager.h"

@implementation HWDevicesListAPIManager

- (NSString *)apiName {
    return kDevicesList;
}

- (RequestType)requestType {
    return RequestType_Post;
}

@end
