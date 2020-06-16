//
//  HWLocaitonScenarioByIdAPIManager.m
//  HomePlatform
//
//  Created by Honeywell on 2018/4/28.
//  Copyright © 2018 Honeywell. All rights reserved.
//

#import "HWLocaitonScenarioByIdAPIManager.h"

@implementation HWLocaitonScenarioByIdAPIManager

- (NSString *)apiName {
    return kLocationScenarioById;
}

- (RequestType)requestType {
    return RequestType_Post;
}

@end
