//
//  HWLocationTriggerListAPIManager.m
//  HomePlatform
//
//  Created by Honeywell on 2018/5/23.
//  Copyright © 2018 Honeywell. All rights reserved.
//

#import "HWLocationTriggerListAPIManager.h"

@implementation HWLocationTriggerListAPIManager

- (NSString *)apiName {
    return kLocationTriggerListById;
}

- (RequestType)requestType {
    return RequestType_Post;
}

@end
