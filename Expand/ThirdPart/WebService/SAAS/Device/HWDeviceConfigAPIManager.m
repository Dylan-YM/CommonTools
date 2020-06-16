//
//  HWDeviceConfigAPIManager.m
//  HomePlatform
//
//  Created by Honeywell on 2017/12/5.
//  Copyright © 2017年 Honeywell. All rights reserved.
//

#import "HWDeviceConfigAPIManager.h"

@implementation HWDeviceConfigAPIManager

- (NSString *)apiName {
    return kDeviceConfig;
}

- (RequestType)requestType {
    return RequestType_Post;
}

@end
