//
//  HWCheckEnrollVerifyCodeAPIManager.m
//  HomePlatform
//
//  Created by Honeywell on 2018/8/16.
//  Copyright © 2018 Honeywell. All rights reserved.
//

#import "HWCheckEnrollVerifyCodeAPIManager.h"

@implementation HWCheckEnrollVerifyCodeAPIManager

- (NSString *)apiName {
    return kCheckEnrollVerifyCode;
}

- (RequestType)requestType {
    return RequestType_Post;
} 

@end
