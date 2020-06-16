//
//  HWUserClientInfoAPIManager.m
//  AirTouch
//
//  Created by Honeywell on 9/20/16.
//  Copyright © 2016 Honeywell. All rights reserved.
//

#import "HWUserClientInfoAPIManager.h"

@implementation HWUserClientInfoAPIManager

- (NSString *)apiName {
    return kUserClientInfo;
}

- (RequestType)requestType {
    return RequestType_Post;
}

@end
