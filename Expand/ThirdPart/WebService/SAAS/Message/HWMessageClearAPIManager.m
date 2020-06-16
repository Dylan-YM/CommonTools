//
//  HWMessageClearAPIManager.m
//  HomePlatform
//
//  Created by Honeywell on 2017/7/12.
//  Copyright © 2017年 Honeywell. All rights reserved.
//

#import "HWMessageClearAPIManager.h"

@implementation HWMessageClearAPIManager

- (NSString *)apiName {
    return kMessageClear;
}

- (RequestType)requestType {
    return RequestType_Post;
}

@end
