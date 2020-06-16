//
//  XZFutureAPIManager.m
//  AirTouch
//
//  Created by Liu, Carl on 9/20/16.
//  Copyright © 2016 Honeywell. All rights reserved.
//

#import "XZFutureAPIManager.h"

@implementation XZFutureAPIManager

- (NSString *)apiName {
    return [NSString stringWithFormat:@"%@.json?city=%@&language=%@&key=%@",@"future", self.city, self.language, self.apiKey];
}

@end
