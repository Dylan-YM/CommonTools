//
//  HWSessionAPIRequest+UserEntity.m
//  AirTouch
//
//  Created by Honeywell on 9/22/16.
//  Copyright © 2016 Honeywell. All rights reserved.
//

#import "HWSessionAPIRequest+UserEntity.h"
#import "HWSessionAPIRequest.h"
#import "Aspects.h"
#import "UserEntity.h"
#import "LogUtil.h"
#import "UserConfig.h"

@interface HWSessionAPIRequest ()

- (void)didRefreshSession:(id)object withError:(NSError *)error;

@end

@implementation HWSessionAPIRequest (UserEntity)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self aspect_hookSelector:@selector(didRefreshSession:withError:) withOptions:AspectPositionInstead usingBlock:^(id<AspectInfo> aspectInfo, id object, NSError *error){
            UserEntity *currentUser=[UserEntity instance];
            if (error && (error.code == HWErrorUserBeenKicked)) //刷新session失败
            {
                NSString *errorMsg = NSLocalizedString(@"account_pop_kickedout", nil);
                [currentUser logoutWithAlertErrorMessage:errorMsg completion:nil];
                [LogUtil Debug:@"Refresh session failed" message:error];
            } else if (error && (error.code == HWErrorLoginUserAccountLocked)) {
                NSString *errorMsg = NSLocalizedString(@"account_pop_abnormallogin", nil);
                [currentUser logoutWithAlertErrorMessage:errorMsg completion:nil];
            } else if (error && (error.code == HWErrorLoginWrongUserNameOrPassword || error.code == HWErrorUserNotExist)) {
                [currentUser logoutWithAlertErrorMessage:nil completion:nil];
                [LogUtil Debug:@"Refresh session failed" message:error];
            } else if (error && (error.code == HWErrorLoginTokenExpired || error.code == HWErrorLoginTokenError)) {
                NSString *errorMsg = NSLocalizedString(@"account_pop_loginexpired", nil);
                [currentUser logoutWithAlertErrorMessage:errorMsg completion:nil];
                [LogUtil Debug:@"Refresh session failed" message:error];
            }
            if (!error && object) {
                NSMutableDictionary *imported = [NSMutableDictionary dictionary];
                if ([object objectForKey:@"userInfo"]) {
                    [imported addEntriesFromDictionary:[object objectForKey:@"userInfo"]];
                }
                if ([object objectForKey:@"wsUrl"]) {
                    imported[@"wsUrl"] = [object objectForKey:@"wsUrl"];
                }
                [currentUser importData:imported];
                if ([object objectForKey:@"autoLoginToken"]) {
                    [currentUser setLoginToken:object[@"autoLoginToken"]];
                }
                [UserConfig saveUser];
            }
        } error:nil];
    });
}

@end
