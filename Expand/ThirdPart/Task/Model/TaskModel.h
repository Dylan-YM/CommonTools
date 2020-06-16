//
//  TaskModel.h
//  AirTouch
//
//  Created by Eric Qin on 2/12/15.
//  Copyright (c) 2015 Honeywell. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TaskModel;

typedef NS_ENUM(NSInteger, TaskState) {
    TaskStateNone = -1,
    TaskStateFailed,
    TaskStateSucceed,
    TaskStateExceeded,
    TaskStateNotFound,
    TaskStateNotAuthorized,
    TaskStateBadRequest,
    TaskStateUnknown,
    TaskStateWaiting,
    TaskStateOver
};

typedef NS_ENUM(NSInteger, TaskType) {
    TaskTypeDeleteDevice,
    TaskTypeCheckNetwork,
    TaskTypeControl,
    TaskTypeCheckDeviceOnline,
    TaskTypeAddDevice
};

typedef void (^TaskCallbackBlock)(TaskModel *taskModel, NSError *error);
typedef TaskState (^TaskCheckResponseBlock)(TaskModel *taskModel,id object, NSError *error);

typedef int (^TaskPerformMethodBlock)(TaskCheckResponseBlock checkBlock);

@interface TaskModel : NSObject

@property (nonatomic,assign) NSInteger taskID;
@property (nonatomic,copy)   NSString  *taskName;
@property (nonatomic,assign) NSInteger requestCount;
@property (nonatomic,assign) NSInteger requestInterval;
@property (nonatomic,assign) NSInteger requestMaxCount;
@property (nonatomic,strong) NSString *networkSSID;
@property (nonatomic,strong) NSString *macAddress;
@property (nonatomic,strong) TaskCallbackBlock callback;
@property (nonatomic,strong) TaskCheckResponseBlock checkBlock;
@property (nonatomic,assign) TaskType taskType;
@property (nonatomic,assign) TaskState state;

-(void)startControlTask;
-(void)stopControlTask:(TaskState)taskState;

-(void)startCheckNetwork;
+ (NSString *)description:(TaskState)taskState;

@end
