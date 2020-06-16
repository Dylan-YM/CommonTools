//
//  HWCityListAPIManager.m
//  HomePlatform
//
//  Created by Honeywell on 2018/1/4.
//  Copyright © 2018年 Honeywell. All rights reserved.
//

#import "HWCityListAPIManager.h"

@implementation HWCityListAPIManager

- (NSString *)apiName {
    return kCityList;
}

- (RequestType)requestType {
    return RequestType_Post;
}

@end
