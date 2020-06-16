//
//  HWHistoryEventReadAPIManager.m
//  HomePlatform
//
//  Created by Yang, Bob on 2018/5/8.
//  Copyright © 2018 Honeywell. All rights reserved.
//

#import "HWHistoryEventReadAPIManager.h"

@implementation HWHistoryEventReadAPIManager

- (NSString *)apiName {
    return kHistoryEventRead;
}

- (RequestType)requestType {
    return RequestType_Put;
}

@end
