//
//  HWCityModel.m
//  Platform
//
//  Created by Honeywell on 2017/10/25.
//

#import "HWCityModel.h"
#import "HWCityKey.h"

@implementation HWCityModel

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        [self updateWithDictionary:dictionary];
    }
    return self;
}

- (void)updateWithDictionary:(NSDictionary *)dictionary {
    if ([dictionary objectForKey:CITY_NAME]) {
        self.name = dictionary[CITY_NAME];
    }
}

@end
