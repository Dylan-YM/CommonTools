//
//  HWWeatherNowAPIManager.m
//  HomePlatform
//
//  Created by Honeywell on 2017/8/7.
//  Copyright © 2017年 Honeywell. All rights reserved.
//

#import "HWWeatherNowAPIManager.h"

@implementation HWWeatherNowAPIManager

- (NSString *)apiName {
    return kWeatherNow;
}

- (RequestType)requestType {
    return RequestType_Post;
}

@end
