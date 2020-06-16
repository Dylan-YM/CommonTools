//
//  HWGroupInfoAPIManager.m
//  AirTouch
//
//  Created by Honeywell on 9/18/16.
//  Copyright © 2016 Honeywell. All rights reserved.
//

#import "HWGroupEditDeviceAPIManager.h"

@implementation HWGroupEditDeviceAPIManager

- (NSString *)apiName {
    return kGroupEditDevice;
}

- (RequestType)requestType {
    return RequestType_Post;
}

@end
