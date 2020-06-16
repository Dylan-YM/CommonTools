//
//  WhatsNewAPIRequest.m
//  HomePlatform
//
//  Created by Liu, Carl on 23/08/2017.
//  Copyright © 2017 Honeywell. All rights reserved.
//

#import "WhatsNewAPIRequest.h"
#import "AppMarco.h"

@implementation WhatsNewAPIRequest

- (NSString *)apiName {
    return @"";
}

- (NSString *)baseUrl {
    return VERSION_CHECK_URL;
}

- (NSError *)handleError:(NSInteger)errorCode responseObject:(id)responseObject{
    NSError *error = [super handleError:errorCode responseObject:responseObject];
    NSString *errorMsg = @"";
    switch (errorCode) {
        case NSURLErrorTimedOut:
        {
            errorMsg = NSLocalizedString(@"common_operation_failed_request_timeout", nil);
            break;
        }
        default:
            break;
    }
    if ([errorMsg length] > 0) {
        error = [NSError errorWithDomain:errorMsg code:errorCode userInfo:nil];
    }
    return error;
}

@end
