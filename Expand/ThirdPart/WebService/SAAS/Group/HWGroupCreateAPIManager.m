//
//  HWGroupCreateAPIManager.m
//  AirTouch
//
//  Created by Liu, Carl on 9/18/16.
//  Copyright © 2016 Honeywell. All rights reserved.
//

#import "HWGroupCreateAPIManager.h"

@interface HWGroupCreateAPIManager ()

@property (strong, nonatomic) NSString *groupName;
@property (strong, nonatomic) NSString *masterDeviceId;
@property (strong, nonatomic) NSString *locationId;

@end

@implementation HWGroupCreateAPIManager

- (NSString *)apiName {
    return kGroupCreate;
}

- (RequestType)requestType {
    return RequestType_Post;
}

@end
