//
//  HWLocationDeleteAPIManager.m
//  AirTouch
//
//  Created by Liu, Carl on 9/19/16.
//  Copyright © 2016 Honeywell. All rights reserved.
//

#import "HWLocationDeleteAPIManager.h"
#import "AppMarco.h"

@interface HWLocationDeleteAPIManager ()

@property (strong, nonatomic) NSString *locationId;

@end

@implementation HWLocationDeleteAPIManager

- (NSString *)apiName {
    NSString *api = [kDeleteLocation stringByReplacingOccurrencesOfString:@"{locationId}" withString:self.locationId];
    return api;
}

- (RequestType)requestType {
    return RequestType_Post;
}

- (void)callAPIWithParam:(id)param completion:(HWAPICallBack)completion {
    self.locationId = param[kUrl_LocationId];
    [super callAPIWithParam:nil completion:completion];
}

- (NSError *)handleError:(NSInteger)errorCode responseObject:(id)responseObject {
    NSString *errorMessage = nil;
    switch (errorCode) {
        case HWErrorHomeDeleteHasDevice:
            errorMessage = NSLocalizedString(@"locationmgt_notice_cannotdeletelocaitonwithdevice", nil);
            break;
        case HWErrorHomeNotExist:
            errorMessage = NSLocalizedString(@"locationmgt_notice_deletelocationfailed", nil);
            break;
        default:
            break;
    }
    NSError *error = [super handleError:errorCode responseObject:responseObject];
    if (errorMessage) {
        error = [NSError errorWithDomain:errorMessage code:errorCode userInfo:nil];
    }
    return error;
}

@end
