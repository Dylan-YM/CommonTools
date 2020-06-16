//
//  HWAlarmEliminateAPIManager.m
//  HomePlatform
//
//  Created by Honeywell on 2017/7/25.
//  Copyright © 2017年 Honeywell. All rights reserved.
//

#import "HWAlarmEliminateAPIManager.h"

@implementation HWAlarmEliminateAPIManager

- (NSString *)apiName {
    return kAlarmEliminate;
}

- (RequestType)requestType {
    return RequestType_Post;
}

@end
