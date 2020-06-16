//
//  HWAlarmListAPIManager.m
//  HomePlatform
//
//  Created by Honeywell on 2017/7/25.
//  Copyright © 2017年 Honeywell. All rights reserved.
//

#import "HWAlarmListAPIManager.h"

@implementation HWAlarmListAPIManager

- (NSString *)apiName {
    return kAlarmList;
}

- (RequestType)requestType {
    return RequestType_Post;
}

@end
