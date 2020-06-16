//
//  HWPasswordChangeAPIManager.m
//  AirTouch
//
//  Created by Honeywell on 9/16/16.
//  Copyright © 2016 Honeywell. All rights reserved.
//

#import "HWPasswordChangeAPIManager.h"

@implementation HWPasswordChangeAPIManager

- (NSString *)apiName {
    return kUrl_PasswordChangeAPI;
}

- (RequestType)requestType {
    return RequestType_Post;
}

- (void)callAPIWithParam:(id)param completion:(HWAPICallBack)completion {
    [super callAPIWithParam:param completion:completion];
}

- (NSError *)handleError:(NSInteger)errorCode responseObject:(id)responseObject{
    switch (errorCode) {
        case HWErrorUserOldPasswordWrong:
            return [NSError errorWithDomain:NSLocalizedString(@"account_notice_invalidoldpassword", nil) code:errorCode userInfo:nil];
        default:
            return [super handleError:errorCode responseObject:responseObject];
    }
}

@end
