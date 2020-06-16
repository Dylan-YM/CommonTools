//
//  HWRoomScenarioByIdAPIManager.m
//  HomePlatform
//
//  Created by Honeywell on 2018/5/8.
//  Copyright © 2018 Honeywell. All rights reserved.
//

#import "HWRoomScenarioByIdAPIManager.h"

@implementation HWRoomScenarioByIdAPIManager

- (NSString *)apiName {
    return kLocationRoomScenarioById;
}

- (RequestType)requestType {
    return RequestType_Post;
}

@end
