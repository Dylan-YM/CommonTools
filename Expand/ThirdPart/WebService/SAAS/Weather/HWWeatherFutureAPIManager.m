//
//  HWWeatherFutureAPIManager.m
//  HomePlatform
//
//  Created by Honeywell on 2017/8/7.
//  Copyright © 2017年 Honeywell. All rights reserved.
//

#import "HWWeatherFutureAPIManager.h"

@implementation HWWeatherFutureAPIManager

- (NSString *)apiName {
    return kWeatherFuture;
}

- (RequestType)requestType {
    return RequestType_Post;
}

@end
