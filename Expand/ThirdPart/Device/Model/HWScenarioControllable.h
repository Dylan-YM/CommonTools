//
//  HWScenarioControllable.h
//  AirTouch
//
//  Created by Wang, Devin on 8/7/16.
//  Copyright © 2016 Honeywell. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^ControllBlock)(id object, NSError *error);

typedef enum : NSInteger {
    HWScenarioType_Invalid = -1,
    HWScenarioType_Home = 1,
    HWScenarioType_Away,
    HWScenarioType_Sleep,
    HWScenarioType_Awake,
} HWScenarioType;

typedef void(^CheckBlock)(BOOL checkResult, NSString *tipMessage);

@class HWModeCellModel;
@protocol HWScenarioControllable <NSObject>

@property (nonatomic,copy)    NSString  *scenarioMode;
/**
 *  check if device is being controlled or not
 */
@property (nonatomic, assign) NSInteger targetStatus;

@property (nonatomic, strong) NSObject *additionalObject;

- (void)checkControlAvailable:(CheckBlock)block;
- (NSInteger)currentScenario;
- (BOOL)isControlling;
- (void)scenarioControlWithCellModel:(HWModeCellModel *)model withCallback:(ControllBlock)callback;
@end
