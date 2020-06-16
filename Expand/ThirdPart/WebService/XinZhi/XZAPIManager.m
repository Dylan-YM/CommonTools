//
//  XZAPIManager.m
//  AirTouch
//
//  Created by Honeywell on 9/14/16.
//  Copyright © 2016 Honeywell. All rights reserved.
//

#import "XZAPIManager.h"
#import "AppConfig.h"
#import "AppMarco.h"

@implementation XZAPIManager

- (NSString *)baseUrl {
    return @"https://honeywell.thinkpage.cn/v2/weather/";
}

- (NSString *)language {
    return [AppConfig getWeatherLanguage];
}

- (NSString *)apiKey {
    return SECRET_KEY_WEATHER;
}

- (void)callAPIWithParam:(id)param completion:(HWAPICallBack)completion {
    _city = param[@"city"];
    [super callAPIWithParam:nil completion:completion];
}

@end
