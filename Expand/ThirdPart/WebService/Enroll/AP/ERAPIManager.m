//
//  ERAPIManager.m
//  AirTouch
//
//  Created by Liu, Carl on 9/20/16.
//  Copyright © 2016 Honeywell. All rights reserved.
//

#import "ERAPIManager.h"

@implementation ERAPIManager

- (NSString *)baseUrl {
    return @"http://192.168.1.1/wapi/";
}

- (HWRequestMode)requestMode {
    return HWRequestMode_Socket;
}

@end
