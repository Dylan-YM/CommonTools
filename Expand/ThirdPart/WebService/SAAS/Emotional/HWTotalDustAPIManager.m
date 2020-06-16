//
//  HWTotalDustAPIManager.m
//  Services
//
//  Created by Honeywell on 2017/2/8.
//  Copyright © 2017年 Honeywell. All rights reserved.
//

#import "HWTotalDustAPIManager.h"

@interface HWTotalDustAPIManager ()

@property (strong, nonatomic) NSString *locationId;

@end

@implementation HWTotalDustAPIManager

- (NSString *)apiName {
    NSString *api = kEmotionalTotalDustAPI;
    api = [api stringByReplacingOccurrencesOfString:@"{locationId}" withString:self.locationId];
    return api;
}

- (void)callAPIWithParam:(id)param completion:(HWAPICallBack)completion {
    self.locationId = param[@"locationId"];
    [super callAPIWithParam:nil completion:completion];
}

@end
