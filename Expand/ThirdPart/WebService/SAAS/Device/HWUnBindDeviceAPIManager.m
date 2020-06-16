//
//  HWUnBindDeviceAPIManager.m
//  HomePlatform
//
//  Created by Honeywell on 2017/6/26.
//  Copyright © 2017年 Honeywell. All rights reserved.
//

#import "HWUnBindDeviceAPIManager.h"

@implementation HWUnBindDeviceAPIManager

- (NSString *)apiName {
    return kUnBindDevice;
}

- (RequestType)requestType {
    return RequestType_Post;
}

- (void)callAPIWithParam:(id)param completion:(HWAPICallBack)completion {
    [super callAPIWithParam:param completion:completion];
}

@end
