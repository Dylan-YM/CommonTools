//
//  EnrollModeMappingAPIManager.m
//  Services
//
//  Created by Liu, Carl on 10/11/16.
//  Copyright © 2016 Honeywell. All rights reserved.
//

#import "EnrollModeMappingAPIManager.h"
#import "AppMarco.h"

@implementation EnrollModeMappingAPIManager

- (NSString *)apiName {
    return @"";
}

- (NSString *)baseUrl {
    return DeviceTypeAndQRCodeUrl;
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
