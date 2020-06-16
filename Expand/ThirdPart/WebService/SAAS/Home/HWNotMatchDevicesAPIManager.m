//
//  HWNotMatchDevicesAPIManager.m
//  HomePlatform
//
//  Created by Honeywell on 2017/12/11.
//  Copyright © 2017年 Honeywell. All rights reserved.
//

#import "HWNotMatchDevicesAPIManager.h"

@implementation HWNotMatchDevicesAPIManager

- (NSString *)apiName {
    return kScenarioNotMatchDevices;
}

- (RequestType)requestType {
    return RequestType_Post;
}

@end
