//
//  HWUserValidateAPIManager.m
//  Services
//
//  Created by Liu, Carl on 06/02/2017.
//  Copyright © 2017 Honeywell. All rights reserved.
//

#import "HWUserValidateAPIManager.h"

@implementation HWUserValidateAPIManager

- (NSString *)apiName {
    return UserValidate;
}

- (RequestType)requestType {
    return RequestType_Post;
}

@end
