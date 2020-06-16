//
//  HWMessageDetailAPIManager.m
//  AirTouch
//
//  Created by Honeywell on 9/18/16.
//  Copyright © 2016 Honeywell. All rights reserved.
//

#import "HWMessageDetailAPIManager.h"

@interface HWMessageDetailAPIManager ()

@end

@implementation HWMessageDetailAPIManager

- (NSString *)apiName {
    return kGetMessageById;
}

- (RequestType)requestType {
    return RequestType_Post;
}

@end
