//
//  HWScheduleModel.h
//  HomePlatform
//
//  Created by Honeywell on 2018/5/9.
//  Copyright © 2018 Honeywell. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HWScheduleModel : NSObject

@property (nonatomic, assign) NSInteger scheduleId;
@property (nonatomic, strong) NSString *scheduleTime;
@property (nonatomic, strong) NSString *nextScheduleDateString;
@property (nonatomic, strong) NSDate *nextScheduleDate;
@property (nonatomic, strong) NSString *scheduleName;
@property (nonatomic, assign) NSInteger scheduleType;  //1-场景,只传scenario 2-设备，只传devices
@property (nonatomic, assign) NSInteger scenario;  //1-家场景 2-房间场景
@property (nonatomic, assign) NSInteger scenarioType;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, assign) BOOL notification;
@property (nonatomic, assign) BOOL enable;
@property (nonatomic, strong) NSArray *deviceList;

- (id)initWithDictionary:(NSDictionary *)dictionary;

- (void)updateWithDictionary:(NSDictionary *)dictionary;

- (NSDictionary *)convertToDictionary;

@end
