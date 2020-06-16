//
//  HWLoginAPIManager.m
//  AirTouch
//
//  Created by Honeywell on 9/14/16.
//  Copyright © 2016 Honeywell. All rights reserved.
//

#import "HWLoginAPIManager.h"


@implementation HWLoginAPIManager

- (NSString *)apiName {
    return kLoginApi;
}

- (RequestType)requestType {
    return RequestType_Post;
}

- (void)callAPIWithParam:(id)param completion:(HWAPICallBack)completion {
    [super callAPIWithParam:param completion:^(id object, NSError *error){
        completion(object, error);
    }];
}

- (NSError *)handleError:(NSInteger)errorCode responseObject:(id)responseObject{
    NSString *errorMessage = nil;
    switch (errorCode) {
        case HWErrorUserNotExist:
        case HWErrorLoginWrongUserNameOrPassword:
        {
            errorMessage = NSLocalizedString(@"account_notice_loginfailed", nil);
            return [NSError errorWithDomain:errorMessage code:errorCode userInfo:nil];
        }
//        case HWErrorLoginNeedVcode:
//        {
//            errorMessage = @"请输入验证码";
//            return [NSError errorWithDomain:errorMessage code:errorCode userInfo:nil];
//        }
        case HWErrorVcodeIsWrong:
        {
            errorMessage = NSLocalizedString(@"account_notice_invalidvcode", nil);
            return [NSError errorWithDomain:errorMessage code:errorCode userInfo:nil];
        }
        case HWErrorLoginUserAccountLocked:
        {
            NSInteger lockSeconds = 0;
            id object = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            if ([object isKindOfClass:[NSDictionary class]] && [[object allKeys] containsObject:@"data"]) {
                id data = object[@"data"];
                if ([data isKindOfClass:[NSDictionary class]] && [[data allKeys] containsObject:@"lockSeconds"]) {
                    lockSeconds = [data[@"lockSeconds"] integerValue];
                }
            }
            errorMessage = [NSString stringWithFormat:NSLocalizedString(@"account_notice_trylater", nil),@(lockSeconds)];
            return [NSError errorWithDomain:errorMessage code:errorCode userInfo:nil];
        }
        case HWErrorMigrationFailed:
        {
            errorMessage = NSLocalizedString(@"account_pop_transferaccountinfofailed", nil);
            return [NSError errorWithDomain:errorMessage code:errorCode userInfo:nil];
        }
        default:
        {
            return [super handleError:errorCode responseObject:responseObject];
        }
    }
}

@end
