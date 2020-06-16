//
//  HWDeviceConnectToInternetAPIManager.m
//  AirTouch
//
//  Created by Honeywell on 9/19/16.
//  Copyright © 2016 Honeywell. All rights reserved.
//

#import "HWDeviceConnectToInternetAPIManager.h"

@interface HWDeviceConnectToInternetAPIManager ()

@property (nonatomic, strong) NSString *deviceMacAddress;

@end

@implementation HWDeviceConnectToInternetAPIManager

- (NSString *)apiName {
    return [NSString stringWithFormat:@"%@?%@=%@",kGateways,kUrl_MacID,self.deviceMacAddress];
}

- (void)callAPIWithParam:(id)param completion:(HWAPICallBack)completion {
    self.deviceMacAddress = param[@"deviceMacAddress"];
    [super callAPIWithParam:nil completion:completion];
}

@end
