//
//  HWSessionAPIRequest.m
//  AirTouch
//
//  Created by Honeywell on 9/14/16.
//  Copyright © 2016 Honeywell. All rights reserved.
//

#import "HWSessionAPIRequest.h"
#import "HWAutoLoginAPIManager.h"
#import "AppMarco.h"
#import "LogUtil.h"
#import "CryptoUtil.h"
#import "AppConfig.h"
#import "NotificationHubConfig.h"

static NSMutableArray *pendingArray = nil;

static void addSessionPendingBlock(void(^block)(BOOL)) {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        pendingArray = [[NSMutableArray alloc] init];
    });
    
    if (block && block != NULL) {
        [pendingArray addObject:block];
    }
    [LogUtil Debug:@"HWSessionAPIRequest" message:[NSString stringWithFormat:@"add session pending, now count : %ld", (long)pendingArray.count]];
}

static void runSessionPendingBlocks(BOOL callAPI) {
    [LogUtil Debug:@"HWSessionAPIRequest" message:[NSString stringWithFormat:@"run session pending, total count : %ld", (long)pendingArray.count]];
    for (NSInteger i = [pendingArray count] - 1; i >= 0; i--) {
        void(^block)(BOOL) = pendingArray[i];
        block(callAPI);
        [pendingArray removeObjectAtIndex:i];
    }
}

@interface BaseAPIRequest ()

- (void)callAPIWithParam:(id)param headerDict:(NSDictionary *)headerDict completion:(HWAPICallBack)completion;

@end

#define kPendingRefreshSessionErrorCode         100000000

@interface HWSessionAPIRequest ()

@property (strong, nonatomic) HWAutoLoginAPIManager *autoLoginManager;
@property (strong, nonatomic) void(^requestAPIBlock)(BOOL);

@end

@implementation HWSessionAPIRequest

- (void)callAPIWithParam:(id)param completion:(HWAPICallBack)completion {
    //把调用API的逻辑存到block里
    self.requestAPIBlock = ^(BOOL callAPI){
        if (callAPI) {
            //实际调用API
            [super callAPIWithParam:param headerDict:nil completion:^(id object, NSError *error){
                //如果是等待刷新Session的错误代码，阻塞，暂时不处理，等待session返回之后，做第二次调用
                //如果是其他错误和消息，直接返回
                if (error.code != kPendingRefreshSessionErrorCode) {
                    completion(object, error);
                }
            }];
        } else {
            //刷新Session失败，直接返回API调用失败的错误
            completion(nil, [NSError errorWithDomain:@"" code:HWErrorForbiddenLoginFirst userInfo:nil]);
        }
    };
    //第一次调用API
    self.requestAPIBlock(YES);
}

//调用了请求的API之后，返回错误
//刷新Session的错误不会调用到这里
- (NSError *)handleError:(NSInteger)errorCode responseObject:(id)responseObject {
    if (errorCode == HWErrorForbiddenLoginFirst) {
        [self refreshSession:^(id object, NSError *error) {
            //根据refreshSession的返回数据，判断是否第二调用阻塞的API请求，或直接返回错误
            runSessionPendingBlocks(!error);
        }];
        //返回给callAPIWithParam: 需要等待刷新Session的错误代码
        return [NSError errorWithDomain:NSLocalizedString(@"account_pop_signinfirst", nil) code:kPendingRefreshSessionErrorCode userInfo:nil];
    } else {
        return [super handleError:errorCode responseObject:responseObject];
    }
}

- (void)refreshSession:(HWAPICallBack)completion {
    if (TEST_MODE) {
        completion(nil, nil);
        return;
    }
    
    if ([pendingArray count] == 0) {
        if ([HWAutoLoginAPIManager loginToken].length == 0) {
            NSError *error = [NSError errorWithDomain:NSLocalizedString(@"account_pop_loginexpired", nil) code:HWErrorLoginTokenError userInfo:nil];
            [self didRefreshSession:nil withError:error];
            if (self.requestAPIBlock) {
                self.requestAPIBlock(NO);
                self.requestAPIBlock = nil;
            }
            completion(nil, error);
            return;
        }
        
        addSessionPendingBlock(self.requestAPIBlock);
        self.requestAPIBlock = nil;
        
        [self callAutoLoginAPICompletion:completion];
    } else {
        //如果有其他API请求正在去刷新session，直接加到等待数组里，并忽略completion的回调
        addSessionPendingBlock(self.requestAPIBlock);
        self.requestAPIBlock = nil;
    }
}

- (void)callAutoLoginAPICompletion:(HWAPICallBack)completion {
    if (!self.autoLoginManager) {
        self.autoLoginManager = [[HWAutoLoginAPIManager alloc] init];
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"username"] = [HWAutoLoginAPIManager username];
    params[@"autoLoginToken"] = [HWAutoLoginAPIManager loginToken];
    params[@"applicationID"] = APPLICATION_ID;
    
    NSString *appVersion = [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"];
    NSString *osLanguage = [AppConfig getLanguage];
    NSString *osType = OS_TYPE;
    NSString *osVersion =  [[UIDevice currentDevice] systemVersion];
    NSString *phoneBrand = [AppConfig platformString];
    NSString *phoneUUID = [AppConfig like_uuid];
    
    if ([osLanguage isEqualToString:@"en"]) {
        osLanguage = @"en_us";
    } else if ([osLanguage isEqualToString:@"zh"]) {
        osLanguage = @"zh_cn";
    }
    
    params[@"clientInfo"] = @{@"appVersion":appVersion,@"osLanguage":osLanguage,@"osType":osType,@"osVersion":osVersion,@"phoneBrand":phoneBrand,@"phoneUUID":phoneUUID,@"pushToken":[NotificationHubConfig getPostPushToken],@"pushTokenVoip":[NotificationHubConfig getPostVoipToken]};
    
    [LogUtil Debug:@"HWSessionAPIRequest" message:@"start to fetch session"];
    [self.autoLoginManager callAPIWithParam:params completion:^(id object, NSError *error){
        [LogUtil Debug:@"HWSessionAPIRequest" message:@"done to fetch session"];
        [self didRefreshSession:object withError:error];
        if (completion) {
            completion(object,error);
        }
    }];
}

- (void)didRefreshSession:(id)object withError:(NSError *)error {
    
}

@end
