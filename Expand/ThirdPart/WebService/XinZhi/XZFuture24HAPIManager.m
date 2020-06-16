//
//  XZFuture24HAPIManager.m
//  AirTouch
//
//  Created by Liu, Carl on 9/20/16.
//  Copyright © 2016 Honeywell. All rights reserved.
//

#import "XZFuture24HAPIManager.h"

@implementation XZFuture24HAPIManager

- (NSString *)apiName {
    return [NSString stringWithFormat:@"%@.json?city=%@&language=%@&key=%@",@"future24h", self.city, self.language, self.apiKey];
}

@end
