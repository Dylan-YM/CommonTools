//
//  DataUpdateManager.m
//  HomePlatform
//
//  Created by Honeywell on 2018/5/25.
//  Copyright © 2018 Honeywell. All rights reserved.
//

#import "DataUpdateManager.h"
#import "WebSocketManager.h"
#import "WebSocketConfig.h"
#import "UserEntity.h"
#import "AppMarco.h"
#import "WebApi.h"

@implementation DataUpdateManager

+ (DataUpdateManager *)instance {
    static DataUpdateManager * sharedInstance = nil;
    if (sharedInstance == nil) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            sharedInstance = [[DataUpdateManager alloc] init];
            [sharedInstance addNotificationObserver];
        });
    }
    return sharedInstance;
}

- (void)addNotificationObserver {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(apiResponse:) name:kWebSocketDidReceiveResponseNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(apiResponse:) name:BaseAPIResponseNotification object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)apiResponse:(NSNotification *)noti {
    NSDictionary *userInfo = [noti userInfo];
    NSString *msgType = [userInfo objectForKey:kWebSocketMsgType];
    NSInteger errorCode = [[userInfo objectForKey:kWebSocketErrorCode] integerValue];
    BOOL error = (errorCode != 0);
    
    if (!error) {
        //home scenario list
        if ([msgType isEqualToString:kWebSocketMessageTypeScenarioCreate] ||
            [msgType isEqualToString:kWebSocketMessageTypeScenarioEdit] ||
            [msgType isEqualToString:kWebSocketMessageTypeScenarioRemove] ||
            [msgType isEqualToString:kWebSocketMessageTypeScenarioReorder] ||
            [msgType isEqualToString:kLocationScenarioFavorite]) {
            [[UserEntity instance] updateScenarioList];
        }
        //room scenario list
        else if ([msgType isEqualToString:kWebSocketMessageTypeRoomScenarioCreate] ||
                 [msgType isEqualToString:kWebSocketMessageTypeRoomScenarioEdit] ||
                 [msgType isEqualToString:kWebSocketMessageTypeRoomScenarioRemove]) {
            [[UserEntity instance] updateRoomScenarioList];
        }
        //home schedule list
        else if ([msgType isEqualToString:kWebSocketMessageTypeScheduleCreate] ||
                 [msgType isEqualToString:kWebSocketMessageTypeScheduleEdit] ||
                 [msgType isEqualToString:kWebSocketMessageTypeScheduleRemove] ||
                 [msgType isEqualToString:kWebSocketMessageTypeScheduleEnable]) {
            [[UserEntity instance] updateScheduleList];
        }
        //home trigger list
        else if ([msgType isEqualToString:kWebSocketMessageTypeTriggerCreate] ||
                 [msgType isEqualToString:kWebSocketMessageTypeTriggerEdit] ||
                 [msgType isEqualToString:kWebSocketMessageTypeTriggerRemove] ||
                 [msgType isEqualToString:kWebSocketMessageTypeTriggerEnable]) {
            [[UserEntity instance] updateTriggerList];
        }
        //group
        else if ([msgType isEqualToString:kWebSocketMessageTypeGroupCreate] ||
                 [msgType isEqualToString:kWebSocketMessageTypeGroupEdit] ||
                 [msgType isEqualToString:kWebSocketMessageTypeGroupEditDevice] ||
                 [msgType isEqualToString:kWebSocketMessageTypeGroupRemove]) {
            [[UserEntity instance] updateGroupList];
        }
        //Device
        else if ([msgType isEqualToString:kWebSocketMessageTypeConfigSubDevice] ||
                 [msgType isEqualToString:kDeviceFavorite]) {
            [[UserEntity instance] updateDeviceListCompletion:nil runStatusBlock:nil newRequest:NO];
        }
    }
}

@end
