//
//  HWEmotionGetVolumeAndTDsAPIManager.m
//  Services
//
//  Created by Honeywell on 2017/2/7.
//  Copyright © 2017年 Honeywell. All rights reserved.
//

#import "HWEmotionGetVolumeAndTDsAPIManager.h"

@interface HWEmotionGetVolumeAndTDsAPIManager ()

@property (strong, nonatomic) NSString *locationId;
@property (strong, nonatomic) NSString *from;
@property (strong, nonatomic) NSString *to;

@end

@implementation HWEmotionGetVolumeAndTDsAPIManager

- (NSString *)apiName {
    NSString *api = kEmotionalGetVolumeAndTDsAPI;
    api = [api stringByReplacingOccurrencesOfString:@"{locationId}" withString:self.locationId];
    api = [api stringByReplacingOccurrencesOfString:@"{from}" withString:self.from];
    api = [api stringByReplacingOccurrencesOfString:@"{to}" withString:self.to];
    return api;
}

- (void)callAPIWithParam:(id)param completion:(HWAPICallBack)completion {
    self.locationId = param[@"locationId"];
    self.from = param[@"from"];
    self.to = param[@"to"];
    [super callAPIWithParam:nil completion:completion];
}

@end
