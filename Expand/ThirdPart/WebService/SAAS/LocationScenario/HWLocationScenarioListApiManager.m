//
//  HWLocationScenarioListApiManager.m
//  HomePlatform
//
//  Created by Honeywell on 2018/4/28.
//  Copyright © 2018 Honeywell. All rights reserved.
//

#import "HWLocationScenarioListApiManager.h"

@implementation HWLocationScenarioListApiManager

- (NSString *)apiName {
    return kLocationScenarioList;
}

- (RequestType)requestType {
    return RequestType_Post;
}

@end
