//
//  HWCitySearchAPIManager.m
//  HomePlatform
//
//  Created by Honeywell on 2018/1/4.
//  Copyright © 2018年 Honeywell. All rights reserved.
//

#import "HWCitySearchAPIManager.h"

@implementation HWCitySearchAPIManager

- (NSString *)apiName {
    return kCitySearch;
}

- (RequestType)requestType {
    return RequestType_Post;
}

@end
