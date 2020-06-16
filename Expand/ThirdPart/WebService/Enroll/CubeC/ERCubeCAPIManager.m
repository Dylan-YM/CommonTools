//
//  ERCubeCAPIManager.m
//  HomePlatform
//
//  Created by Honeywell on 28/03/2018.
//  Copyright © 2018 Honeywell. All rights reserved.
//

#import "ERCubeCAPIManager.h"

@implementation ERCubeCAPIManager

- (NSString *)baseUrl {
    return [NSString stringWithFormat:@"http://%@:3060/",self.ipv4Address];
}

- (NSString *)apiName {
    return @"api/getCode";
}

- (HWRequestMode)requestMode {
    return HWRequestMode_Socket;
}

@end

