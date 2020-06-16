//
//  HWUnreadMessageCountAPIManager.m
//  AirTouch
//
//  Created by Honeywell on 9/18/16.
//  Copyright © 2016 Honeywell. All rights reserved.
//

#import "HWMessageCountAPIManager.h"

@implementation HWMessageCountAPIManager

- (NSString *)apiName {
    return kMessageCount;
}

- (RequestType)requestType {
    return RequestType_Post;
}

@end
