//
//  HWForgotPasswordAPIManager.m
//  AirTouch
//
//  Created by Honeywell on 9/16/16.
//  Copyright © 2016 Honeywell. All rights reserved.
//

#import "HWForgotPasswordAPIManager.h"

@interface HWForgotPasswordAPIManager ()

@property (nonatomic, strong) NSString * mobile;

@end

@implementation HWForgotPasswordAPIManager

- (NSString *)apiName {
    return kUpdatePassword;
}

- (RequestType)requestType {
    return RequestType_Post;
}

- (void)callAPIWithParam:(id)param completion:(HWAPICallBack)completion {
    self.mobile = param[@"username"];
    [super callAPIWithParam:param completion:completion];
}

- (NSError *)handleError:(NSInteger)errorCode responseObject:(id)responseObject{
    switch (errorCode) {
        case HWErrorUserNotExist:
        {
            return [NSError errorWithDomain:[NSString stringWithFormat:NSLocalizedString(@"account_notifce_usernotexist", nil), self.mobile] code:errorCode userInfo:nil];
        }
        case HWErrorSentVcodeFirst:
        case HWErrorVcodeIsWrong:
        {
            return [NSError errorWithDomain:NSLocalizedString(@"account_notice_invalidvcode", nil) code:errorCode userInfo:nil];
        }
        case HWErrorVcodeIsTimeout:
        {
            return [NSError errorWithDomain:NSLocalizedString(@"account_notice_vcodeexpired", nil) code:errorCode userInfo:nil];
        }
        default:
        {
            return [super handleError:errorCode responseObject:responseObject];
        }
    }
}

@end
