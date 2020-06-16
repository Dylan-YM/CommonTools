//
//  HWHandleInvitationMessageAPIManager.m
//  AirTouch
//
//  Created by Honeywell on 9/18/16.
//  Copyright © 2016 Honeywell. All rights reserved.
//

#import "HWHandleInvitationMessageAPIManager.h"

@implementation HWHandleInvitationMessageAPIManager

- (NSString *)apiName {
    return kHandleInvitationMessage;
}

- (RequestType)requestType {
    return RequestType_Post;
}

@end
