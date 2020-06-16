//
//  HWLocationAddAPIManager.m
//  AirTouch
//
//  Created by Liu, Carl on 9/19/16.
//  Copyright © 2016 Honeywell. All rights reserved.
//

#import "HWLocationAddAPIManager.h"

@interface HWLocationAddAPIManager ()

@property (strong, nonatomic) NSString *userId;

@end

@implementation HWLocationAddAPIManager

- (NSString *)apiName {
    return kAddLocation;
}

- (RequestType)requestType {
    return RequestType_Post;
}

- (void)callAPIWithParam:(id)param completion:(HWAPICallBack)completion {
    [super callAPIWithParam:param completion:completion];
}

@end
