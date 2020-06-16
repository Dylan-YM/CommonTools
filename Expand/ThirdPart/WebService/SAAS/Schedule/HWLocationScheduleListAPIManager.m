//
//  HWLocationScheduleListAPIManager.m
//  HomePlatform
//
//  Created by Honeywell on 2018/5/9.
//  Copyright © 2018 Honeywell. All rights reserved.
//

#import "HWLocationScheduleListAPIManager.h"

@implementation HWLocationScheduleListAPIManager

- (NSString *)apiName {
    return kLocationScheduleList;
}

- (RequestType)requestType {
    return RequestType_Post;
}

@end
