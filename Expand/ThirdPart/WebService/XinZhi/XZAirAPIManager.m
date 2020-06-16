//
//  XZAirAPIManager.m
//  AirTouch
//
//  Created by Liu, Carl on 9/20/16.
//  Copyright © 2016 Honeywell. All rights reserved.
//

#import "XZAirAPIManager.h"

@implementation XZAirAPIManager

- (NSString *)apiName {
    return [NSString stringWithFormat:@"%@.json?city=%@&language=%@&key=%@",@"air", self.city, self.language, self.apiKey];
}

@end
