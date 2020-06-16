//
//  HWAlarmCountAPIManager.m
//  HomePlatform
//
//  Created by Honeywell on 2017/8/9.
//  Copyright © 2017年 Honeywell. All rights reserved.
//

#import "HWAlarmCountAPIManager.h"

@implementation HWAlarmCountAPIManager

- (NSString *)apiName {
    return kAlarmCount;
}

- (RequestType)requestType {
    return RequestType_Get;
}

@end
