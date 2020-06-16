//
//  HWControlDeviceWaterModeAPIManager.m
//  AirTouch
//
//  Created by Honeywell on 9/20/16.
//  Copyright © 2016 Honeywell. All rights reserved.
//

#import "HWControlDeviceWaterModeAPIManager.h"

@interface HWControlDeviceWaterModeAPIManager ()

@property (nonatomic, assign) NSInteger deviceId;

@end

@implementation HWControlDeviceWaterModeAPIManager

- (NSString *)apiName {
    return [kDeviceWaterControlAPI stringByReplacingOccurrencesOfString:@"{deviceId}" withString:[NSString stringWithFormat:@"%ld", (long)self.deviceId]];
}

- (RequestType)requestType {
    return RequestType_Put;
}

- (void)callAPIWithParam:(id)param completion:(HWAPICallBack)completion {
    self.deviceId = [param[@"deviceId"] integerValue];
    NSDictionary * params = param[@"params"];
    [super callAPIWithParam:params completion:completion];
}

- (NSError *)handleError:(NSInteger)errorCode responseObject:(id)responseObject {
    NSError * error = [super handleError:errorCode responseObject:responseObject];
    switch (errorCode) {
        case NSURLErrorNetworkConnectionLost:
        case NSURLErrorNotConnectedToInternet:
        case NSURLErrorTimedOut:
        case NSURLErrorCancelled:
            return error;
        default:
            return [NSError errorWithDomain:NSLocalizedString(@"CONTROL_MSG_CONTROL_DEVICE_FAIL", nil) code:errorCode userInfo:nil];
    }
}

@end
