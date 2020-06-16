//
//  HWHistoryEventListAPIManager.m
//  HomePlatform
//
//  Created by Honeywell on 2017/7/25.
//  Copyright © 2017年 Honeywell. All rights reserved.
//

#import "HWHistoryEventListAPIManager.h"

@implementation HWHistoryEventListAPIManager

- (NSString *)apiName {
    return kHistoryEventList;
}

- (RequestType)requestType {
    return RequestType_Post;
}

@end
