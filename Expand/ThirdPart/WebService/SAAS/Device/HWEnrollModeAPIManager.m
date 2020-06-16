//
//  HWEnrollModeAPIManager.m
//  AirTouch
//
//  Created by Honeywell on 9/19/16.
//  Copyright © 2016 Honeywell. All rights reserved.
//

#import "HWEnrollModeAPIManager.h"

@implementation HWEnrollModeAPIManager

- (NSString *)apiName {
    return kGetEnrollType;
}

- (RequestType)requestType {
    return RequestType_Post;
}

- (void)callAPIWithParam:(id)param completion:(HWAPICallBack)completion {
    [super callAPIWithParam:param completion:completion];
}

@end
