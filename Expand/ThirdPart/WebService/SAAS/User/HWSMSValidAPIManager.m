//
//  HWSMSValidAPIManager.m
//  AirTouch
//
//  Created by Honeywell on 9/16/16.
//  Copyright © 2016 Honeywell. All rights reserved.
//

#import "HWSMSValidAPIManager.h"

@implementation HWSMSValidAPIManager

- (NSString *)apiName {
    return kSMSValidAPI;
}

- (RequestType)requestType {
    return RequestType_Post;
}

- (NSError *)handleError:(NSInteger)errorCode responseObject:(id)responseObject {
    NSError * error = [super handleError:errorCode responseObject:responseObject];
    switch (errorCode) {
        case NSURLErrorNetworkConnectionLost:
        case NSURLErrorNotConnectedToInternet:
        case NSURLErrorTimedOut:
            return error;
        default:
            return [NSError errorWithDomain:NSLocalizedString(@"account_notice_sendvcodefailed", nil) code:errorCode userInfo:nil];
    }
}

@end
