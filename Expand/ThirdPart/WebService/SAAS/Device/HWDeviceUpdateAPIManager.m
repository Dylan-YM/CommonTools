//
//  HWDeviceUpdateAPIManager.m
//  HomePlatform
//
//  Created by Liu, Carl on 11/12/2017.
//  Copyright © 2017 Honeywell. All rights reserved.
//

#import "HWDeviceUpdateAPIManager.h"

@implementation HWDeviceUpdateAPIManager

- (NSString *)apiName {
    return kDeviceUpdate;
}

- (RequestType)requestType {
    return RequestType_Post;
}

@end
