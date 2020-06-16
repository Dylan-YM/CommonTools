//
//  HWTriggerListAPIManager.m
//  HomePlatform
//
//  Created by Honeywell on 2018/5/23.
//  Copyright © 2018 Honeywell. All rights reserved.
//

#import "HWTriggerListAPIManager.h"

@implementation HWTriggerListAPIManager

- (NSString *)apiName {
    return kLocationTriggerList;
}

- (RequestType)requestType {
    return RequestType_Post;
}

@end
