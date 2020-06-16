//
//  HWGroupDeleteAPIManager.m
//  AirTouch
//
//  Created by Liu, Carl on 9/18/16.
//  Copyright © 2016 Honeywell. All rights reserved.
//

#import "HWGroupRemoveAPIManager.h"

@interface HWGroupRemoveAPIManager ()

@property (strong, nonatomic) NSString *groupId;

@end

@implementation HWGroupRemoveAPIManager

- (NSString *)apiName {
    return kGroupRemove;
}

- (RequestType)requestType {
    return RequestType_Post;
}

@end
