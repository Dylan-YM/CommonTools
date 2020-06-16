//
//  HWHistoryEventCountAPIManager.m
//  HomePlatform
//
//  Created by Yang, Bob on 2018/5/21.
//  Copyright © 2018 Honeywell. All rights reserved.
//

#import "HWHistoryEventCountAPIManager.h"

@implementation HWHistoryEventCountAPIManager

- (NSString *)apiName {
    return kHistoryEventCount;
}

- (RequestType)requestType {
    return RequestType_Post;
}

@end
