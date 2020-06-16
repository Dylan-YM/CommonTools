//
//  HWLocationScenarioControlAPIManager.m
//  AirTouch
//
//  Created by Liu, Carl on 9/19/16.
//  Copyright © 2016 Honeywell. All rights reserved.
//

#import "HWLocationScenarioControlAPIManager.h"
#import "AppMarco.h"

@interface HWLocationScenarioControlAPIManager ()

@property (strong, nonatomic) NSString *locationId;

@end

@implementation HWLocationScenarioControlAPIManager

- (NSString *)apiName {
    NSString *api = [kLocationScenarioControl stringByReplacingOccurrencesOfString:@"{locationId}" withString:[NSString stringWithFormat:@"%@",self.locationId]];
    return api;
}

- (RequestType)requestType {
    return RequestType_Post;
}

- (void)callAPIWithParam:(id)param completion:(HWAPICallBack)completion {
    self.locationId = param[kUrl_LocationId];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:param];
    [dict removeObjectForKey:kUrl_LocationId];
    [super callAPIWithParam:dict completion:completion];
}

@end
