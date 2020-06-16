//
//  HWUserInfoAPIManager.m
//  HomePlatform
//
//  Created by BobYang on 01/04/2018.
//  Copyright © 2018 Honeywell. All rights reserved.
//

#import "HWUserInfoAPIManager.h"

@implementation HWUserInfoAPIManager

- (NSString *)apiName {
    return kUpdateUserInfo;
}

- (RequestType)requestType {
    return RequestType_Post;
}

@end
