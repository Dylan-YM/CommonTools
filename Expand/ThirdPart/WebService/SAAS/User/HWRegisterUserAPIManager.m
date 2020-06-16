//
//  HWRegisterUserAPIManager.m
//  AirTouch
//
//  Created by Honeywell on 9/16/16.
//  Copyright © 2016 Honeywell. All rights reserved.
//

#import "HWRegisterUserAPIManager.h"

@implementation HWRegisterUserAPIManager

- (NSString *)apiName {
    return kRegisterApi;
}

- (RequestType)requestType {
    return RequestType_Post;
}

- (NSError *)handleError:(NSInteger)errorCode responseObject:(id)responseObject{
    switch (errorCode) {
        case HWErrorUserAlreadyExist:
        {
            return [NSError errorWithDomain:NSLocalizedString(@"account_pop_alreadysignedup", nil) code:errorCode userInfo:nil];
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
