//
//  HWRequestGroupControlTaskAPIManager.m
//  AirTouch
//
//  Created by Honeywell on 9/20/16.
//  Copyright © 2016 Honeywell. All rights reserved.
//

#import "HWRequestGroupControlTaskAPIManager.h"

@implementation HWRequestGroupControlTaskAPIManager

- (NSString *)apiName {
    return kCommTasksAPI;
}

- (RequestType)requestType {
    return RequestType_Post;
}

@end
