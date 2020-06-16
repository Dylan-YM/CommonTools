//
//  HWAutoLoginAPIManager.h
//  HomePlatform
//
//  Created by Liu, Carl on 27/12/2017.
//  Copyright © 2017 Honeywell. All rights reserved.
//

#import "HWAPIRequest.h"

@interface HWAutoLoginAPIManager : HWAPIRequest

+ (void)setLoginToken:(NSString *)loginToken;

+ (NSString *)loginToken;

+ (void)setUsername:(NSString *)username;

+ (NSString *)username;

@end
