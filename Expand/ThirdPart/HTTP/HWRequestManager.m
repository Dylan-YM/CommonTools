//
//  HWRequestManager.m
//  HTTPClient
//
//  Created by Honeywell on 2017/1/4.
//  Copyright © 2017年 Honeywell. All rights reserved.
//

#import "HWRequestManager.h"
#import "HWSocketRequestManager.h"
#import "AFHTTPManager.h"

@implementation HWRequestManager

+ (id<HWRequestProtocol>)HTTPManagerWithMode:(HWRequestMode)mode {
    id <HWRequestProtocol> manager = nil;
    switch (mode) {
        case HWRequestMode_AFNetworking:
        {
            manager = [[AFHTTPManager alloc] init];
        }
            break;
        case HWRequestMode_Socket:
        {
            manager = [[HWSocketRequestManager alloc] init];
        }
            break;
            
        default:
            break;
    }
    return manager;
}

@end
