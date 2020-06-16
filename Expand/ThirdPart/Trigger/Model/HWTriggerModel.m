//
//  HWTriggerModel.m
//  HomePlatform
//
//  Created by Honeywell on 2018/5/23.
//  Copyright © 2018 Honeywell. All rights reserved.
//

#import "HWTriggerModel.h"

@implementation HWTriggerModel

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        [self updateWithDictionary:dictionary];
    }
    return self;
}

- (void)updateWithDictionary:(NSDictionary *)dictionary {
    NSArray *keys = [dictionary allKeys];
    if ([keys containsObject:@"triggerId"]) {
        self.triggerId = [dictionary[@"triggerId"] integerValue];
    }
    if ([keys containsObject:@"triggerName"]) {
        self.triggerName = dictionary[@"triggerName"];
    }
    if ([keys containsObject:@"triggerType"]) {
        self.triggerType = [dictionary[@"triggerType"] integerValue];
    }
    if ([keys containsObject:@"scenarioType"]) {
        self.scenarioType = [dictionary[@"scenarioType"] integerValue];
    }
    if ([keys containsObject:@"scenario"]) {
        self.scenario = [dictionary[@"scenario"] integerValue];
    } else {
        self.scenario = 0;
    }
    if ([keys containsObject:@"notification"]) {
        self.notification = [dictionary[@"notification"] boolValue];
    }
    if ([keys containsObject:@"enable"]) {
        self.enable = [dictionary[@"enable"] boolValue];
    }
    if ([keys containsObject:@"deviceList"]) {
        self.deviceList = dictionary[@"deviceList"];
    } else {
        self.deviceList = @[];
    }
    if ([keys containsObject:@"when"]) {
        self.when = dictionary[@"when"];
    }
}

- (NSDictionary *)convertToDictionary {
    return @{@"triggerId":@(self.triggerId),
             @"triggerName":self.triggerName?:@"",
             @"triggerType":@(self.triggerType),
             @"scenarioType":@(self.scenarioType),
             @"scenario":@(self.scenario),
             @"notification":@(self.notification),
             @"enable":@(self.enable),
             @"when":self.when?:@{},
             @"deviceList":self.deviceList?:@[]
             };
}

@end
