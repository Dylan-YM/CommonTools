//
//  NotificationHubConfig.m
//  AirTouch
//
//  Created by Rich on 15/10/26.
//  Copyright © 2015年 Honeywell. All rights reserved.
//

#import "NotificationHubConfig.h"
#import "HWUserClientInfoAPIManager.h"
#import "AppMarco.h"
#import "LogUtil.h"
#import "AppConfig.h"
#import "UserEntity.h"

static NSData *PUSHTOKEN = nil;
static NSData *VOIPTOKEN = nil;

@implementation NotificationHubConfig

+ (void)setDevicePushToken:(NSData *)deviceToken
{
    if (!deviceToken) {
        return;
    }
    PUSHTOKEN = deviceToken;
}

+ (void)setDeviceVoipToken:(NSData *)deviceToken
{
    if (!deviceToken) {
        return;
    }
    VOIPTOKEN = deviceToken;
}

+ (NSString *)analyseTokenWithToken:(NSData *)token {
    NSString *result = nil;
    if (token) {
        NSMutableString *deviceTokenString = [NSMutableString string];
        NSInteger length = [token length];
        Byte *bytes = (Byte *)[token bytes];
        for (int i = 0; i < length; i++) {
            [deviceTokenString appendFormat:@"%02x",bytes[i]];
        }
        result = deviceTokenString;
    }
    return result;
}

+ (void)registerNotificationWithCompeletion:(void(^)(NSError *error))compeletion
{
    if ([UserEntity instance].status == UserStatusLogout) {
        return;
    }
    if (!(PUSHTOKEN || VOIPTOKEN)) {
        return;
    }
    
    NSString *devicePushTokenString = [self analyseTokenWithToken:PUSHTOKEN];
    NSString *deviceVoipTokenString = [self analyseTokenWithToken:VOIPTOKEN];
    
    [LogUtil Debug:@"userClientInfo push token" message:devicePushTokenString];
    [LogUtil Debug:@"userClientInfo voip token" message:deviceVoipTokenString];
    
    NSDictionary *params = @{@"osType":OS_TYPE,
                             @"osVersion":[UIDevice currentDevice].systemVersion,
                             @"pushToken":[self getPostPushToken],
                             @"pushTokenVoip":[self getPostVoipToken]};
    HWUserClientInfoAPIManager *userClientInfoManager = [[HWUserClientInfoAPIManager alloc] init];
    [userClientInfoManager callAPIWithParam:params completion:^(id object, NSError *error){
        if (!error) {
            [LogUtil Debug:@"userClientInfo" message:@"upload token success"];
        } else {
            [LogUtil Debug:@"userClientInfo" message:[NSString stringWithFormat:@"upload token failed : %@", object]];
        }
    }];
}

+ (NSString *)getPostPushToken {
    NSString *devicePushTokenString = [self analyseTokenWithToken:PUSHTOKEN];
    NSMutableString *token = [NSMutableString stringWithString:@""];
    if (devicePushTokenString) {
        [token appendString:devicePushTokenString];
    }
    return token;
}

+ (NSString *)getPostVoipToken {
    NSString *deviceVoipTokenString = [self analyseTokenWithToken:VOIPTOKEN];
    NSMutableString *token = [NSMutableString stringWithString:@""];
    if (deviceVoipTokenString) {
        [token appendString:deviceVoipTokenString];
    }
    return token;
}

@end
