//
//  GroupTaskModel.m
//  AirTouch
//
//  Created by kenny on 15/10/26.
//  Copyright © 2015年 Honeywell. All rights reserved.
//

#import "GroupTaskModel.h"
#import "LogUtil.h"
#import "TimerUtil.h"
#import "HWRequestGroupControlTaskAPIManager.h"

@interface GroupTaskModel ()

@property (nonatomic, strong) HWRequestGroupControlTaskAPIManager * requestGroupControlTaskManager;

@end

@implementation GroupTaskModel
@synthesize taskIDs;
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
        self.taskIDs = [[NSArray alloc]init];
        self.taskName =@"";
        self.requestCount = 0;
        self.requestInterval = 0;
        self.requestMaxCount = 0;
        self.taskType = 0;
        self.state = -1;
    }
    return self;
}

- (void)requestGroupControlTask
{
    [self.requestGroupControlTaskManager callAPIWithParam:self.taskIDs completion:^(id object, NSError *error) {
        [LogUtil Debug:@"groupControl" message:object];
        int groupTaskState = GroupTaskStateSucceed;
        if (self.checkBlock) {
            groupTaskState=self.checkBlock(self,object,error);
        }
        [self stopGroupControlTask:groupTaskState];
    }];
}

-(void)startGroupControlTask
{
    if (self.taskType == GroupTaskTypeControl
        || self.taskType == GroupTaskTypeDelete) {
        __weak typeof(self) weakSelf = self;
        [TimerUtil scheduledDispatchTimerWithName:self.taskName timeInterval:self.requestInterval repeats:YES action:^{
            [weakSelf requestGroupControlTask];
        }];
    }
}

-(void)cancelGroupControlTask {
    [TimerUtil cancelTimerWithName:self.taskName];
}

-(void)stopGroupControlTask:(GroupTaskState)groupTaskState
{
    if (groupTaskState==GroupTaskStateWaiting) {
        return;
    }
    [TimerUtil cancelTimerWithName:self.taskName];
    self.state = groupTaskState;
    
    if (self.callback) {
        if (groupTaskState == GroupTaskStateSucceed) {
            self.callback(self, nil);
        } else {
            NSError *error = [NSError errorWithDomain:@"Task Failed" code:groupTaskState userInfo:nil];
            self.callback(self, error);
        }
    }
}

+ (NSString *)description:(GroupTaskState)taskState {
    NSString *description = @"";
    switch (taskState) {
        case GroupTaskStateNone:
            description = @"GroupTaskStateNone";
            break;
        case GroupTaskStatePartFailed:
            description = @"GroupTaskStatePartFailed";
            break;
        case GroupTaskStateAllFailed:
            description = @"GroupTaskStateAllFailed";
            break;
        case GroupTaskStateSucceed:
            description = @"GroupTaskStateSucceed";
            break;
        case GroupTaskStateExceeded:
            description = @"GroupTaskStateExceeded";
            break;
        case GroupTaskStateWaiting:
            description = @"GroupTaskStateWaiting";
            break;
        default:
            break;
    }
    return description;
}

- (HWRequestGroupControlTaskAPIManager *)requestGroupControlTaskManager {
    _requestGroupControlTaskManager = [[HWRequestGroupControlTaskAPIManager alloc] init];
    return _requestGroupControlTaskManager;
}

- (void)cancelHttpRequest {
    [self.requestGroupControlTaskManager cancel];
    self.requestGroupControlTaskManager = nil;
}

- (void)dealloc {
    [self cancelHttpRequest];
}

@end
