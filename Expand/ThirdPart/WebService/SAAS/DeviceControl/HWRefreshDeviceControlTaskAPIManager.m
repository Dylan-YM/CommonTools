//
//  HWRefreshDeviceControlTaskAPIManager.m
//  AirTouch
//
//  Created by Honeywell on 9/20/16.
//  Copyright © 2016 Honeywell. All rights reserved.
//

#import "HWRefreshDeviceControlTaskAPIManager.h"

@interface HWRefreshDeviceControlTaskAPIManager ()

@property (assign, nonatomic) NSInteger commTaskId;

@end

@implementation HWRefreshDeviceControlTaskAPIManager

- (NSString *)apiName {
    return [kDeviceTaskAPI stringByReplacingOccurrencesOfString:@"{commTaskId}" withString:[NSString stringWithFormat:@"%ld", (long)self.commTaskId]];
}

- (void)callAPIWithParam:(id)param completion:(HWAPICallBack)completion {
    self.commTaskId = [param[@"commTaskId"] integerValue];
    [super callAPIWithParam:nil completion:completion];
}

@end
