//
//  HWTriggerModel.h
//  HomePlatform
//
//  Created by Honeywell on 2018/5/23.
//  Copyright © 2018 Honeywell. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HWTriggerModel : NSObject

@property (nonatomic, assign) NSInteger triggerId;
@property (nonatomic, strong) NSString *triggerName;
@property (nonatomic, assign) NSInteger triggerType;  //1-场景,只传scenario 2-设备，只传devices
@property (nonatomic, assign) NSInteger scenarioType;  //1-家场景 2-房间场景
@property (nonatomic, assign) NSInteger scenario;  //1-家场景 2-房间场景
@property (nonatomic, assign) BOOL notification;
@property (nonatomic, assign) BOOL enable;
@property (nonatomic, strong) NSArray *deviceList;
@property (nonatomic, strong) NSDictionary *when;

- (id)initWithDictionary:(NSDictionary *)dictionary;

- (void)updateWithDictionary:(NSDictionary *)dictionary;

- (NSDictionary *)convertToDictionary;

@end
