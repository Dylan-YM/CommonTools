//
//  HWDistrictModel.m
//  Platform
//
//  Created by Honeywell on 2017/10/25.
//

#import "HWDistrictModel.h"
#import "HWCityKey.h"

@implementation HWDistrictModel

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        [self updateWithDictionary:dictionary];
    }
    return self;
}

- (void)updateWithDictionary:(NSDictionary *)dictionary {
    if ([dictionary objectForKey:DISTRICT_NAME]) {
        self.name = dictionary[DISTRICT_NAME];
    }
    if ([dictionary objectForKey:CITY_CODE]) {
        self.code = dictionary[CITY_CODE];
    }
}

@end
