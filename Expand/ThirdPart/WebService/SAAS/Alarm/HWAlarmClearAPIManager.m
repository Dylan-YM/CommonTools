//
//  HWAlarmClearAPIManager.m
//  HomePlatform
//
//  Created by Honeywell on 2017/7/25.
//  Copyright © 2017年 Honeywell. All rights reserved.
//

#import "HWAlarmClearAPIManager.h"

@implementation HWAlarmClearAPIManager

- (NSString *)apiName {
    return kAlarmClear;
}

- (RequestType)requestType {
    return RequestType_Delete;
}

@end
