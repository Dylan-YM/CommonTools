//
//  TaskModel.m
//  AirTouch
//
//  Created by Eric Qin on 2/12/15.
//  Copyright (c) 2015 Honeywell. All rights reserved.
//

#import "TaskModel.h"
#import "Reachability.h"
#import "LogUtil.h"
#import "TimerUtil.h"
#import "NetworkUtil.h"
#import "UserConfig.h"
#import "HWDeviceConnectToInternetAPIManager.h"
#import "HWRefreshDeviceControlTaskAPIManager.h"

@interface TaskModel ()

@property (nonatomic, strong) HWDeviceConnectToInternetAPIManager *checkDeviceConnectManager;
@property (nonatomic, strong) HWRefreshDeviceControlTaskAPIManager * refreshDeviceControlTaskManager;

@end

@implementation TaskModel

@synthesize taskID;
@synthesize taskName;
@synthesize requestCount;
@synthesize callback;
@synthesize checkBlock;
@synthesize requestInterval;
@synthesize requestMaxCount;
@synthesize taskType;
@synthesize state;

-(id)init
{
    if (self = [super init])
    {
        self.taskID = -1;
        self.taskName =@"";
        self.requestCount = 0;
        self.requestInterval = 0;
        self.requestMaxCount = 0;
        self.taskType = 0;
        self.state = -1;
    }
    return self;
}

- (void)requestControlTask
{
    NSDictionary * params = @{@"commTaskId":@(self.taskID)};
    [self.refreshDeviceControlTaskManager callAPIWithParam:params completion:^(id object, NSError *error) {
        [LogUtil Debug:@"TaskModel requestControlTask" message:object];
        
        if (self.checkBlock) {
            int taskState=self.checkBlock(self,object,error);
            
            [self stopControlTask:taskState];
        }
    }];
}

-(void)startControlTask
{
    if (self.taskType == TaskTypeCheckNetwork
        || self.taskType == TaskTypeControl
        || self.taskType == TaskTypeDeleteDevice
        || self.taskType == TaskTypeAddDevice
        || self.taskType == TaskTypeCheckDeviceOnline) {
        __weak typeof(self) weakSelf = self;
        [TimerUtil scheduledDispatchTimerWithName:self.taskName timeInterval:self.requestInterval repeats:YES action:^{
            switch (self.taskType) {
                case TaskTypeCheckNetwork:
                    [weakSelf startCheckNetwork];
                    break;
                case TaskTypeControl:
                case TaskTypeDeleteDevice:
                case TaskTypeAddDevice:
                    [weakSelf requestControlTask];
                    break;
                case TaskTypeCheckDeviceOnline:
                    [weakSelf startCheckDevice];
                    break;
                default:
                    break;
            }
        }];
    } else {
        [TimerUtil cancelTimerWithName:self.taskName];
    }
}

-(void)stopControlTask:(TaskState)taskState
{
    if (taskState==TaskStateWaiting) {
        return;
    }
    [TimerUtil cancelTimerWithName:self.taskName];
    
    if (self.callback) {
        if (self.state==TaskStateOver) {
            [LogUtil Debug:@"debug enroll" message:[NSString stringWithFormat:@"%@ TaskStateOver",self.taskName]];
            return;
        }
        self.state=TaskStateOver;
        if (taskState == TaskStateSucceed) {
            self.callback(self, nil);
        } else {
            NSError *error = [NSError errorWithDomain:@"Task Failed" code:taskState userInfo:nil];
            self.callback(self, error);
        }
    }
}


-(void)startCheckNetwork
{
    self.requestCount++;
    if (self.requestCount > self.requestMaxCount)
    {
        self.requestCount=0;
        [self stopControlTask:TaskStateExceeded];
    }else
    {
        NSString *ssidString=[NetworkUtil currentWifiSSID];
        if (![ssidString hasPrefix:self.networkSSID]) {
            if ([NetworkUtil isReachable]) {
                [self stopControlTask:TaskStateSucceed];
            }else
            {
                [self stopControlTask:TaskStateWaiting];
            }
        }else
        {
             [self stopControlTask:TaskStateWaiting];
        }
    }
}

-(void)startCheckDevice
{
    if (!self.macAddress) {
        if (self.checkBlock) {
            [LogUtil Debug:@"debug enroll" message:@"mac address nil"];
            int taskState=self.checkBlock(self,nil,[NSError errorWithDomain:@"No mac address" code:0 userInfo:nil]);
            [self stopControlTask:taskState];
        }
        return;
    }
    NSDictionary * params = @{@"deviceMacAddress":self.macAddress};
    [self.checkDeviceConnectManager callAPIWithParam:params completion:^(id object, NSError *error) {
        if (self.checkBlock) {
            [LogUtil Debug:@"debug enroll" message:object];
            int taskState=self.checkBlock(self,object,error);
            [LogUtil Debug:@"debug enroll" message:@"1111"];
            [self stopControlTask:taskState];
            [LogUtil Debug:@"debug enroll" message:@"2222"];
        }
    }];
}

+ (NSString *)description:(TaskState)taskState {
    NSString *description = @"";
    switch (taskState) {
        case TaskStateNone:
            description = @"TaskStateNone";
            break;
        case TaskStateFailed:
            description = @"TaskStateFailed";
            break;
        case TaskStateSucceed:
            description = @"TaskStateSucceed";
            break;
        case TaskStateExceeded:
            description = @"TaskStateExceeded";
            break;
        case TaskStateNotFound:
            description = @"TaskStateNotFound";
            break;
        case TaskStateNotAuthorized:
            description = @"TaskStateNotAuthorized";
            break;
        case TaskStateBadRequest:
            description = @"TaskStateBadRequest";
            break;
        case TaskStateUnknown:
            description = @"TaskStateUnknown";
            break;
        case TaskStateWaiting:
            description = @"TaskStateWaiting";
            break;
        default:
            break;
    }
    return description;
}

- (HWDeviceConnectToInternetAPIManager *)checkDeviceConnectManager {
    _checkDeviceConnectManager = [[HWDeviceConnectToInternetAPIManager alloc] init];
    return _checkDeviceConnectManager;
}

- (HWRefreshDeviceControlTaskAPIManager *)refreshDeviceControlTaskManager {
    _refreshDeviceControlTaskManager = [[HWRefreshDeviceControlTaskAPIManager alloc] init];
    return _refreshDeviceControlTaskManager;
}

- (void)cancelHttpRequest {
    [self.checkDeviceConnectManager cancel];
    self.checkDeviceConnectManager = nil;
    
    [self.refreshDeviceControlTaskManager cancel];
    self.refreshDeviceControlTaskManager = nil;
}

- (void)dealloc {
    [self cancelHttpRequest];
}

@end
