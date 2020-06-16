//
//  HWMessageListAPIManager.m
//  AirTouch
//
//  Created by Honeywell on 9/18/16.
//  Copyright © 2016 Honeywell. All rights reserved.
//

#import "HWMessageListAPIManager.h"

@interface HWMessageListAPIManager ()

@end

@implementation HWMessageListAPIManager

- (NSString *)apiName {
    return kMessageList;
}

- (RequestType)requestType {
    return RequestType_Post;
}

@end
