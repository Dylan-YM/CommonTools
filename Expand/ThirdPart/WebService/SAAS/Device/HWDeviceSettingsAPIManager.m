//
//  HWDeviceSettingsAPIManager.m
//  HomePlatform
//
//  Created by Honeywell on 2017/12/5.
//  Copyright © 2017年 Honeywell. All rights reserved.
//

#import "HWDeviceSettingsAPIManager.h"

@implementation HWDeviceSettingsAPIManager

- (NSString *)apiName {
    return kDeviceSettings;
}

- (RequestType)requestType {
    return RequestType_Post;
}

@end
