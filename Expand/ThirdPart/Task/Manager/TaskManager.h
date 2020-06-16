//
//  TaskManager.h
//  AirTouch
//
//  Created by huangfujun on 15/4/29.
//  Copyright (c) 2015年 Honeywell. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TaskModel;
@class GroupTaskModel;

@interface TaskManager : NSObject

+(id)sharedManager;

/**
 *  check control task 
 *
 *  @param task task model type
 */
- (void)checkControlTaskRepeatly:(TaskModel *)task;
- (void)checkGroupControlTaskRepeatly:(GroupTaskModel *)groupTask;

@end
