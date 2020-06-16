//
//  HWDeleteMessagesAPIManager.m
//  AirTouch
//
//  Created by Honeywell on 9/18/16.
//  Copyright © 2016 Honeywell. All rights reserved.
//

#import "HWDeleteMessagesAPIManager.h"

@implementation HWDeleteMessagesAPIManager

- (NSString *)apiName {
    return kDeleteMessage;
}

- (RequestType)requestType {
    return RequestType_Post;
}

@end
