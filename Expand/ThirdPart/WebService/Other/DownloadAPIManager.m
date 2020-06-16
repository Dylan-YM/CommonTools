//
//  DownloadAPIManager.m
//  AirTouch
//
//  Created by Honeywell on 9/18/16.
//  Copyright © 2016 Honeywell. All rights reserved.
//

#import "DownloadAPIManager.h"

@implementation DownloadAPIManager

- (void)handleResponse:(id)responseObject error:(NSError *)responseError completion:(HWAPICallBack)completion {
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    id object = nil;
    
    if (!responseError) {
        if (responseObject) {
            object = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        }
    }
    
    if (completion) {
        completion(object, responseError);
    }
    [self cancel];
}

@end
