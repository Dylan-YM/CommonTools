//
//  HWAllFilterAPIManager.m
//  AirTouch
//
//  Created by Honeywell on 9/14/16.
//  Copyright © 2016 Honeywell. All rights reserved.
//

#import "HWAllFilterAPIManager.h"

@implementation HWAllFilterAPIManager

- (NSString *)apiName {
    return kDeviceConfigAPI;
}

- (RequestType)requestType {
    return RequestType_Put;
}

@end
