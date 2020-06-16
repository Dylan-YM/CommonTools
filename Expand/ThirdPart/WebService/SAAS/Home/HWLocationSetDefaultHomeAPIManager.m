//
//  HWLocationSetDefaultHomeAPIManager.m
//  HomePlatform
//
//  Created by Honeywell on 2017/7/3.
//  Copyright © 2017年 Honeywell. All rights reserved.
//

#import "HWLocationSetDefaultHomeAPIManager.h"

@interface HWLocationSetDefaultHomeAPIManager ()

@property (nonatomic, strong) NSString *locationId;

@end

@implementation HWLocationSetDefaultHomeAPIManager

- (NSString *)apiName {
    NSString *api = kSetDefaultHome;
    if (self.locationId) {
        api = [api stringByReplacingOccurrencesOfString:@"{locationId}" withString:self.locationId];
    }
    return api;
}

- (RequestType)requestType {
    return RequestType_Post;
}

- (void)callAPIWithParam:(id)param completion:(HWAPICallBack)completion {
    if ([param objectForKey:@"locationId"]) {
        self.locationId = param[@"locationId"];
    }
    [super callAPIWithParam:nil completion:completion];
}

@end
