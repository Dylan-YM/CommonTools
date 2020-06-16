//
//  HWLocationScheduleListByIdAPIManager.m
//  HomePlatform
//
//  Created by Honeywell on 2018/5/9.
//  Copyright © 2018 Honeywell. All rights reserved.
//

#import "HWLocationScheduleListByIdAPIManager.h"

@implementation HWLocationScheduleListByIdAPIManager

- (NSString *)apiName {
    return kLocationScheduleListById;
}

- (RequestType)requestType {
    return RequestType_Post;
}

@end
