//
//  HWAPIRequest.m
//  AirTouch
//
//  Created by Honeywell on 9/14/16.
//  Copyright © 2016 Honeywell. All rights reserved.
//

#import "HWAPIRequest.h"
#import "AppMarco.h"
#import "AppConfig.h"

@implementation HWAPIRequest

- (NSString *)baseUrl {
    NSString *baseUrl = BaseRequestUrl;
    if (CAN_CHANGE_SERVER) {
        if ([AppConfig getValueString:ServerLocaiton]) {
            baseUrl = [AppConfig getValueString:ServerLocaiton];
        }
    }
    return baseUrl;
}

- (HWRequestSerializer)requestSerializer {
    return HWRequestSerializer_Json;
}

@end
