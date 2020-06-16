//
//  HWGroupRenameAPIManager.m
//  AirTouch
//
//  Created by Liu, Carl on 9/18/16.
//  Copyright © 2016 Honeywell. All rights reserved.
//

#import "HWGroupUpdateAPIManager.h"

@implementation HWGroupUpdateAPIManager

- (NSString *)apiName {
    return kGroupUpdate;
}

- (RequestType)requestType {
    return RequestType_Post;
}

@end
