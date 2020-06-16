//
//  HWDeleteDeviceAPIManager.m
//  AirTouch
//
//  Created by Honeywell on 9/19/16.
//  Copyright © 2016 Honeywell. All rights reserved.
//

#import "HWDeleteDeviceAPIManager.h"

@interface HWDeleteDeviceAPIManager ()

@property (nonatomic, assign) NSInteger deviceId;

@end

@implementation HWDeleteDeviceAPIManager

- (NSString *)apiName {
    NSString *api = [kDeviceDeleteAPI stringByReplacingOccurrencesOfString:@"{deviceId}" withString:[NSString stringWithFormat:@"%ld", (long)self.deviceId]];
    return api;
}

- (RequestType)requestType {
    return RequestType_Delete;
}

- (void)callAPIWithParam:(id)param completion:(HWAPICallBack)completion {
    self.deviceId = [param[@"deviceId"] integerValue];
    [super callAPIWithParam:nil completion:completion];
}

@end
