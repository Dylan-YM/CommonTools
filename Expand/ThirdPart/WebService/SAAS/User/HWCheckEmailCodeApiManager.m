//
//  HWCheckEmailCodeApiManager.m
//  HomePlatform
//
//  Created by HoneyWell on 2020/4/15.
//  Copyright © 2020 Honeywell. All rights reserved.
//

#import "HWCheckEmailCodeApiManager.h"

@implementation HWCheckEmailCodeApiManager

- (NSString *)apiName {
    return kCheckEmailApi;
}

- (RequestType)requestType {
    return RequestType_Post;
}

@end
