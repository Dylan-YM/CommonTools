//
//  HWLogoutAPIManager.m
//  HomePlatform
//
//  Created by Honeywell on 2017/6/29.
//  Copyright © 2017年 Honeywell. All rights reserved.
//

#import "HWLogoutAPIManager.h"

@implementation HWLogoutAPIManager

- (NSString *)apiName {
    return UserLogout;
}

- (RequestType)requestType {
    return RequestType_Post;
}

@end
