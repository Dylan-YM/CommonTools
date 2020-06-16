//
//  HWAutoLoginAPIManager.m
//  HomePlatform
//
//  Created by Liu, Carl on 27/12/2017.
//  Copyright © 2017 Honeywell. All rights reserved.
//

#import "HWAutoLoginAPIManager.h"

static NSString *username = nil;
static NSString *loginToken = nil;

@implementation HWAutoLoginAPIManager

- (NSString *)apiName {
    return kAutoLoginApi;
}

- (RequestType)requestType {
    return RequestType_Post;
}

+ (void)setUsername:(NSString *)username_ {
    username = [username_ copy];
}

+ (NSString *)username {
    return username;
}

+ (void)setLoginToken:(NSString *)loginToken_ {
    loginToken = [loginToken_ copy];
}

+ (NSString *)loginToken {
    return loginToken;
}

- (void)callAPIWithParam:(id)param completion:(HWAPICallBack)completion {
    [super callAPIWithParam:param completion:^(id object, NSError *error){
        completion(object, error);
    }];
}

- (NSError *)handleError:(NSInteger)errorCode responseObject:(id)responseObject{
    NSString *errorMessage = nil;
    switch (errorCode) {
        case HWErrorLoginTokenExpired:
        case HWErrorLoginTokenError:
        {
            errorMessage = NSLocalizedString(@"account_pop_loginexpired", nil);
            return [NSError errorWithDomain:errorMessage code:errorCode userInfo:nil];
        }
        default:
        {
            return [super handleError:errorCode responseObject:responseObject];
        }
    }
}

@end
