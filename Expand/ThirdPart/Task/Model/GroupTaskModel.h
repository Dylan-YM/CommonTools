//
//  GroupTaskModel.h
//  AirTouch
//
//  Created by kenny on 15/10/26.
//  Copyright © 2015年 Honeywell. All rights reserved.
//

#import <Foundation/Foundation.h>
@class GroupTaskModel;

typedef NS_ENUM(NSInteger, GroupTaskState) {
    GroupTaskStateNone = -1,
    GroupTaskStatePartFailed,
    GroupTaskStateAllFailed,
    GroupTaskStateSucceed,
    GroupTaskStateExceeded,
    /*
    GroupTaskStateNotFound,
    GroupTaskStateNotAuthorized,
    GroupTaskStateBadRequest,
    GroupTaskStateUnknown,
     */
    GroupTaskStateWaiting,
};

typedef NS_ENUM(NSInteger, GroupTaskType) {
    GroupTaskTypeControl,
    GroupTaskTypeDelete
};

typedef void (^GroupTaskCallbackBlock)(GroupTaskModel *groupTaskModel, NSError *error);
typedef GroupTaskState (^GroupTaskCheckResponseBlock)(GroupTaskModel *groupTaskModel,id object, NSError *error);

//@class GroupDeviceModel;

//typedef int (^GroupTaskPerformMethodBlock)(GroupTaskCheckResponseBlock checkBlock);
@interface GroupTaskModel : NSObject

@property (nonatomic,strong) NSArray *taskIDs;
@property (nonatomic,copy)   NSString  *taskName;
@property (nonatomic,assign) NSInteger requestCount;
@property (nonatomic,assign) NSInteger requestInterval;
@property (nonatomic,assign) NSInteger requestMaxCount;
@property (nonatomic,strong) GroupTaskCallbackBlock callback;
@property (nonatomic,strong) GroupTaskCheckResponseBlock checkBlock;
//@property (nonatomic,strong) GroupDeviceModel *groupDeviceModel;
@property (nonatomic,assign) GroupTaskType taskType;
@property (nonatomic,assign) GroupTaskState state;

-(void)startGroupControlTask;
-(void)cancelGroupControlTask;
+ (NSString *)description:(GroupTaskState)taskState;
@end
