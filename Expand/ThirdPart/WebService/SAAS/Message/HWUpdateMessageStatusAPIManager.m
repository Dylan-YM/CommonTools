//
//  HWUpdateMessageStatusAPIManager.m
//  AirTouch
//
//  Created by Honeywell on 9/18/16.
//  Copyright © 2016 Honeywell. All rights reserved.
//

#import "HWUpdateMessageStatusAPIManager.h"

@implementation HWUpdateMessageStatusAPIManager

- (NSString *)apiName {
    return kUpdateMessageReadStatus;
}

- (RequestType)requestType {
    return RequestType_Post;
}

@end
