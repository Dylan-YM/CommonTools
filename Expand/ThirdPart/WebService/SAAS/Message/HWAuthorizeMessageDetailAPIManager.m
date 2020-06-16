//
//  HWAuthorizeMessageDetailAPIManager.m
//  AirTouch
//
//  Created by Honeywell on 9/19/16.
//  Copyright © 2016 Honeywell. All rights reserved.
//

#import "HWAuthorizeMessageDetailAPIManager.h"

@implementation HWAuthorizeMessageDetailAPIManager

- (NSString *)apiName {
    return kGetAuthorizeMessageById;
}

- (RequestType)requestType {
    return RequestType_Post;
}


@end
