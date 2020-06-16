//
//  HWRoomScenarioListAPIManager.m
//  HomePlatform
//
//  Created by Honeywell on 2018/5/8.
//  Copyright © 2018 Honeywell. All rights reserved.
//

#import "HWRoomScenarioListAPIManager.h"

@implementation HWRoomScenarioListAPIManager

- (NSString *)apiName {
    return kLocationRoomScenarioList;
}

- (RequestType)requestType {
    return RequestType_Post;
}

@end
