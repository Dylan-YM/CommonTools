//
//  HWEmailApiManager.m
//  HomePlatform
//
//  Created by HoneyWell on 2020/4/15.
//  Copyright © 2020 Honeywell. All rights reserved.
//

#import "HWEmailApiManager.h"

@implementation HWEmailApiManager

- (NSString *)apiName {
    return kSendEmailApi;
}

- (RequestType)requestType {
    return RequestType_Post;
}
@end
