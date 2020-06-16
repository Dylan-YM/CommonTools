//
//  HWAllDeviceRunStatusAPIManager.m
//  AirTouch
//
//  Created by Honeywell on 9/20/16.
//  Copyright © 2016 Honeywell. All rights reserved.
//

#import "HWAllDeviceRunStatusAPIManager.h"

@implementation HWAllDeviceRunStatusAPIManager

- (NSString *)apiName {
    return kAllDeviceStatusAPI;
}

- (RequestType)requestType {
    return RequestType_Post;
}

@end
