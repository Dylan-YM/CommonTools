//
//  TaskManager.m
//  AirTouch
//
//  Created by huangfujun on 15/4/29.
//  Copyright (c) 2015年 Honeywell. All rights reserved.
//

#import "TaskManager.h"
#import "TaskModel.h"
#import "GroupTaskModel.h"

@interface TaskManager ()

@property (strong, nonatomic) NSMutableArray *tasks;
@property (strong, nonatomic) NSMutableArray *groupTasks;

@end

@implementation TaskManager

+(id)sharedManager
{
    static TaskManager * instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc]init];
    });
    return instance;
}

-(instancetype)init
{
    if (self=[super init]) {
        self.tasks = [NSMutableArray array];
        self.groupTasks = [NSMutableArray array];
    }
    return self;
}

-(void)checkControlTaskRepeatly:(TaskModel *)task
{
    if (![self.tasks containsObject:task]) {
        TaskCallbackBlock block = task.callback;
        __weak TaskModel *blockTask = task;
        __weak typeof(self) weakSelf = self;
        task.callback = ^(TaskModel *taskModel,NSError *error) {
            if (block) {
                block(taskModel, error);
            }
            blockTask.callback = nil;
            blockTask.checkBlock = nil;
            [weakSelf.tasks removeObject:blockTask];
        };
        [self.tasks addObject:task];
        [task startControlTask];
    }
}

-(void)checkGroupControlTaskRepeatly:(GroupTaskModel *)groupTask
{
    for (GroupTaskModel *groupTaskModel in self.groupTasks) {
        if ([groupTaskModel.taskName isEqualToString:groupTask.taskName]) {
            [self cancelTask:groupTaskModel];
            break;
        }
    }
    if (![self.groupTasks containsObject:groupTask]) {
        GroupTaskCallbackBlock block = groupTask.callback;
        __weak GroupTaskModel *groupBlockTask = groupTask;
        __weak typeof(self) weakSelf = self;
        groupTask.callback = ^(GroupTaskModel *groupTaskModel,NSError *error) {
            if (block) {
                block(groupTaskModel, error);
            }
            groupBlockTask.callback = nil;
            groupBlockTask.checkBlock = nil;
            [weakSelf.groupTasks removeObject:groupBlockTask];
        };
        [self.groupTasks addObject:groupTask];
        [groupTask startGroupControlTask];
    }
}

- (void)cancelTask:(GroupTaskModel *)groupTask {
    [groupTask cancelGroupControlTask];
    groupTask.callback = nil;
    [self.groupTasks removeObject:groupTask];
}

@end
