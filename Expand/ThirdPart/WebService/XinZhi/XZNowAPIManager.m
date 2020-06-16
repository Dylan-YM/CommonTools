//
//  XZNowAPIManager.m
//  AirTouch
//
//  Created by Liu, Carl on 9/20/16.
//  Copyright © 2016 Honeywell. All rights reserved.
//

#import "XZNowAPIManager.h"

@implementation XZNowAPIManager

- (NSString *)apiName {
    return [NSString stringWithFormat:@"%@.json?city=%@&language=%@&key=%@",@"now", self.city, self.language, self.apiKey];
}

@end
