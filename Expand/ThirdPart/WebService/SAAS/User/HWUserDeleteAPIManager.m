//
//  HWUserDeleteAPIManager.m
//  HomePlatform
//
//  Created by BobYang on 05/04/2018.
//  Copyright © 2018 Honeywell. All rights reserved.
//

#import "HWUserDeleteAPIManager.h"

@implementation HWUserDeleteAPIManager

- (NSString *)apiName {
    return kDeleteUser;
}

- (RequestType)requestType {
    return RequestType_Post;
}

@end
