//
//  HWDeviceRunStatusAPIManager.m
//  HomePlatform
//
//  Created by Liu, Carl on 19/12/2017.
//  Copyright © 2017 Honeywell. All rights reserved.
//

#import "HWDeviceRunStatusAPIManager.h"

@implementation HWDeviceRunStatusAPIManager

- (NSString *)apiName {
    return kDeviceStatusAPI;
}

- (RequestType)requestType {
    return RequestType_Post;
}

@end
