//
//  HWScheduleModel.m
//  HomePlatform
//
//  Created by Honeywell on 2018/5/9.
//  Copyright © 2018 Honeywell. All rights reserved.
//

#import "HWScheduleModel.h"
#import "CronExpression.h"

@implementation HWScheduleModel

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        [self updateWithDictionary:dictionary];
    }
    return self;
}

- (void)updateWithDictionary:(NSDictionary *)dictionary {
    NSArray *keys = [dictionary allKeys];
    if ([keys containsObject:@"scheduleId"]) {
        self.scheduleId = [dictionary[@"scheduleId"] integerValue];
    }
    if ([keys containsObject:@"scheduleTime"]) {
        self.scheduleTime = dictionary[@"scheduleTime"];
        
        NSDate *now = [[NSDate date] dateByAddingTimeInterval:60];
        
        CronExpression *expression = [[CronExpression alloc] init:self.scheduleTime withFieldFactory:[[FieldFactory alloc] init]];
        NSDate *next = [expression getNextRunDate:now];
        
        if (next != nil) {
            NSDateFormatter *format = [[NSDateFormatter alloc] init];
            
            [format setDateFormat:@"yyyy-MM-dd EEE"];
            if ([[format stringFromDate:next] isEqualToString:[format stringFromDate:now]]) {
                [format setDateFormat:@"HH:mm"];
            } else {
                [format setDateFormat:@"EEE HH:mm"];
            }
            
            self.nextScheduleDate = next;
            self.nextScheduleDateString = [format stringFromDate:next];
        } else {
            self.nextScheduleDate = nil;
            self.nextScheduleDateString = nil;
        }
    } else {
        self.nextScheduleDate = nil;
        self.nextScheduleDateString = nil;
    }
    if ([keys containsObject:@"scheduleName"]) {
        self.scheduleName = dictionary[@"scheduleName"];
    }
    if ([keys containsObject:@"scenario"]) {
        self.scenario = [dictionary[@"scenario"] integerValue];
    } else {
        self.scenario = 0;
    }
    if ([keys containsObject:@"scheduleType"]) {
        self.scheduleType = [dictionary[@"scheduleType"] integerValue];
    }
    if ([keys containsObject:@"scenarioType"]) {
        self.scenarioType = [dictionary[@"scenarioType"] integerValue];
    }
    if ([keys containsObject:@"password"]) {
        self.password = dictionary[@"password"];
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
}

- (NSDictionary *)convertToDictionary {
    return @{@"scheduleId":@(self.scheduleId),
             @"scheduleTime":self.scheduleTime?:@"",
             @"scheduleName":self.scheduleName?:@"",
             @"scenario":@(self.scenario),
             @"scheduleType":@(self.scheduleType),
             @"scenarioType":@(self.scenarioType),
             @"password":self.password?:@"",
             @"notification":@(self.notification),
             @"enable":@(self.enable),
             @"deviceList":self.deviceList?:@[],
             @"nextExecuteTime":self.nextScheduleDateString?:@""
             };
}

@end
