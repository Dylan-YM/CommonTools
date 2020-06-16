//
//  HWGroupListAPIManager.m
//  AirTouch
//
//  Created by Liu, Carl on 9/18/16.
//  Copyright © 2016 Honeywell. All rights reserved.
//

#import "HWGroupListAPIManager.h"

@implementation HWGroupListAPIManager

- (NSString *)apiName {
    return kGroupList;
}

- (RequestType)requestType {
    return RequestType_Post;
}

@end
