//
//  HWLocationEditAPIManager.m
//  AirTouch
//
//  Created by Liu, Carl on 9/19/16.
//  Copyright © 2016 Honeywell. All rights reserved.
//

#import "HWLocationEditAPIManager.h"
#import "AppMarco.h"

@interface HWLocationEditAPIManager ()

@property (strong, nonatomic) NSString *locationId;

@end

@implementation HWLocationEditAPIManager

- (NSString *)apiName {
    return kEditLocation;
}

- (RequestType)requestType {
    return RequestType_Post;
}

- (void)callAPIWithParam:(id)param completion:(HWAPICallBack)completion {
    [super callAPIWithParam:param completion:completion];
}

@end
