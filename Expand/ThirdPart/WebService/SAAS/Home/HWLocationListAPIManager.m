//
//  HWAllLocationAPIManager.m
//  AirTouch
//
//  Created by Honeywell on 9/18/16.
//  Copyright © 2016 Honeywell. All rights reserved.
//

#import "HWLocationListAPIManager.h"

@implementation HWLocationListAPIManager

- (NSString *)apiName {
     return kGetLocationList;
}

- (RequestType)requestType {
    return RequestType_Post;
}


@end
