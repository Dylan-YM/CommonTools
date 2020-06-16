//
//  ERPhoneNameAPIManager.m
//  AirTouch
//
//  Created by Liu, Carl on 9/20/16.
//  Copyright © 2016 Honeywell. All rights reserved.
//

#import "ERPhoneNameAPIManager.h"

@implementation ERPhoneNameAPIManager

- (NSString *)apiName {
    return @"phonename";
}

- (RequestType)requestType {
    return RequestType_Put;
}

- (HWRequestSerializer)requestSerializer {
    return HWRequestSerializer_Json;
}

@end
