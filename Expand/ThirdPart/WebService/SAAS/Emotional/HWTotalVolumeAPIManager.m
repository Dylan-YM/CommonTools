//
//  HWTotalVolumeAPIManager.m
//  Services
//
//  Created by Honeywell on 2017/2/8.
//  Copyright © 2017年 Honeywell. All rights reserved.
//

#import "HWTotalVolumeAPIManager.h"

@interface HWTotalVolumeAPIManager ()

@property (strong, nonatomic) NSString *locationId;

@end

@implementation HWTotalVolumeAPIManager

- (NSString *)apiName {
    NSString *api = kEmotionalTotalVolumeAPI;
    api = [api stringByReplacingOccurrencesOfString:@"{locationId}" withString:self.locationId];
    return api;
}

- (void)callAPIWithParam:(id)param completion:(HWAPICallBack)completion {
    self.locationId = param[@"locationId"];
    [super callAPIWithParam:nil completion:completion];
}

@end
