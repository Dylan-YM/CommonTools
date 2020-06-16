//
//  HWProvinceModel.m
//  Platform
//
//  Created by Honeywell on 2017/10/25.
//

#import "HWProvinceModel.h"
#import "HWCityKey.h"

@implementation HWProvinceModel

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        [self updateWithDictionary:dictionary];
    }
    return self;
}

- (void)updateWithDictionary:(NSDictionary *)dictionary {
    if ([dictionary objectForKey:PROVINCE_NAME]) {
        self.name = dictionary[PROVINCE_NAME];
    }
}

@end
