//
//  XZLocationSearchAPIManager.m
//  HomePlatform
//
//  Created by Honeywell on 2017/10/27.
//  Copyright © 2017年 Honeywell. All rights reserved.
//

#import "XZLocationSearchAPIManager.h"

@interface XZLocationSearchAPIManager ()

@property (nonatomic, strong) NSString *q;

@end

@implementation XZLocationSearchAPIManager

- (NSString *)baseUrl {
    return @"https://api.seniverse.com/v3/location/search.json?";
}

- (NSString *)apiName {
    return [NSString stringWithFormat:@"key=%@&q=%@",self.apiKey, self.q];
}

- (RequestType)requestType {
    return RequestType_Get;
}

- (void)callAPIWithParam:(id)param completion:(HWAPICallBack)completion {
    self.q = @"";
    if (param && [param isKindOfClass:[NSDictionary class]] && [param objectForKey:@"q"]) {
        self.q = param[@"q"];
    }
    [super callAPIWithParam:nil completion:completion];
}

@end
