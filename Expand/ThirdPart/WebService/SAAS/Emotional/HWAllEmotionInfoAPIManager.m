//
//  HWAllEmotionInfoAPIManager.m
//  AirTouch
//
//  Created by Honeywell on 9/18/16.
//  Copyright © 2016 Honeywell. All rights reserved.
//

#import "HWAllEmotionInfoAPIManager.h"

@interface HWAllEmotionInfoAPIManager ()

@property (strong, nonatomic) NSString *locationId;
@property (strong, nonatomic) NSString *periodType;

@end

@implementation HWAllEmotionInfoAPIManager

- (NSString *)apiName {
    NSString *api = kAllEmotionalPageAPI;
    api = [api stringByReplacingOccurrencesOfString:@"{locationId}" withString:self.locationId];
    api = [api stringByReplacingOccurrencesOfString:@"{periodType}" withString:self.periodType];
    return api;
}

- (void)callAPIWithParam:(id)param completion:(HWAPICallBack)completion {
    self.locationId = param[@"locationId"];
    self.periodType = param[@"periodType"];
    [super callAPIWithParam:nil completion:completion];
}

@end
