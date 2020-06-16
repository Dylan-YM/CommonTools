//
//  BroadLinkAPIManager.m
//  HomePlatform
//
//  Created by CarlLiu on 2019/8/8.
//  Copyright © 2019 Honeywell. All rights reserved.
//

#import "BroadLinkAPIManager.h"

@implementation BroadLinkAPIManager

- (NSString *)baseUrl {
    return @"https://cloud-proxy-chn-467a8f05.ibroadlink.com/";
}

- (HWRequestSerializer)requestSerializer {
    return HWRequestSerializer_Json;
}

@end
