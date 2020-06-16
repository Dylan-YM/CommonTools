//
//  ERConnectAPIManager.m
//  AirTouch
//
//  Created by Liu, Carl on 9/20/16.
//  Copyright © 2016 Honeywell. All rights reserved.
//

#import "ERConnectAPIManager.h"

@implementation ERConnectAPIManager

- (NSString *)apiName {
    return @"connect";
}

- (RequestType)requestType {
    return RequestType_Put;
}

- (HWRequestSerializer)requestSerializer {
    return HWRequestSerializer_Json;
}

@end
