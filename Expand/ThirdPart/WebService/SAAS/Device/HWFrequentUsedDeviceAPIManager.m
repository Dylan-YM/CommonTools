//
//  HWFrequentUsedDeviceAPIManager.m
//  HomePlatform
//
//  Created by Liu, Carl on 16/11/2017.
//  Copyright © 2017 Honeywell. All rights reserved.
//

#import "HWFrequentUsedDeviceAPIManager.h"

@implementation HWFrequentUsedDeviceAPIManager

- (NSString *)apiName {
    return kFrequentUsedDevice;
}

- (RequestType)requestType {
    return RequestType_Post;
}

@end
