//
//  WebSocketConfig.h
//  HomePlatform
//
//  Created by Honeywell on 2017/7/8.
//  Copyright © 2017年 Honeywell. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - string
extern NSString * const kWebSocketMsgData;
extern NSString * const kWebSocketMsgFlag;
extern NSString * const kWebSocketMsgId;
extern NSString * const kWebSocketMsgType;
extern NSString * const kWebSocketErrorCode;

extern NSString * const kWebSocketMsgFlagRequest;
extern NSString * const kWebSocketMsgFlagResponse;

#pragma mark - notification name
extern NSString * const kWebSocketMessageUpdateNotification;
extern NSString * const kWebSocketStateDidChangeNotification;
//All websocket message will goes here
extern NSString * const kWebSocketDidReceiveResponseNotification;
//Device
extern NSString * const kWebSocketDidReceiveBindDeviceResponseNotification;
extern NSString * const kWebSocketDidReceiveUnBindDeviceResponseNotification;
extern NSString * const kWebSocketDidReceiveDeviceOnlineResponseNotification;
extern NSString * const kWebSocketDidReceiveDeviceRunStatusResponseNotification;
extern NSString * const kWebSocketDidReceiveRegisterDeviceResponseNotification;
extern NSString * const kWebSocketDidReceiveConfigSubDeviceResponseNotification;
extern NSString * const kWebSocketDidReceiveDeviceChangeResponseNotification;
extern NSString * const kWebSocketDidReceiveTempPasswordChangeResponseNotification;
//Authorize
extern NSString * const kWebSocketDidReceiveAuthorityAcceptResponseNotification;
extern NSString * const kWebSocketDidReceiveAuthorityGrantResponseNotification;
extern NSString * const kWebSocketDidReceiveAuthorityRejectResponseNotification;
extern NSString * const kWebSocketDidReceiveAuthorityRemoveResponseNotification;
extern NSString * const kWebSocketDidReceiveAuthorityRevokeResponseNotification;
extern NSString * const kWebSocketDidReceiveAuthorityEditResponseNotification;
//Video
extern NSString * const kWebSocketDidReceiveVideoHangUpResponseNotification;
extern NSString * const kWebSocketDidReceiveVideoCallResponseNotification;
extern NSString * const kWebSocketDidReceiveVideoEndResponseNotification;
extern NSString * const kWebSocketDidReceiveVideoAcceptedResponseNotification;
extern NSString * const kWebSocketDidReceiveVideoPickUpResponseNotification;
extern NSString * const kWebSocketDidReceiveVideoOpenDoorResponseNotification;
//group
extern NSString * const kWebSocketDidReceiveGroupChangeResponseNotification;
extern NSString * const kWebSocketDidReceiveGroupCreateResponseNotification;
extern NSString * const kWebSocketDidReceiveGroupEditResponseNotification;
extern NSString * const kWebSocketDidReceiveGroupEditDeviceResponseNotification;
extern NSString * const kWebSocketDidReceiveGroupRemoveResponseNotification;
//User
extern NSString * const kWebSocketDidReceiveUserLoginResponseNotification;
//Control
extern NSString * const kWebSocketDidReceiveControlResponseNotification;
//Alarm
extern NSString * const kWebSocketDidReceiveAlarmNotifyResponseNotification;
extern NSString * const kWebSocketDidReceiveAlarmDeleteResponseNotification;
//Scenario
extern NSString * const kWebSocketDidReceiveScenarioChangeResponseNotification;
extern NSString * const kWebSocketDidReceiveRoomScenarioChangeResponseNotification;
extern NSString * const kWebSocketDidReceiveLocationScenarioSwitchedResponseNotification;
extern NSString * const kWebSocketDidReceiveLocationScenarioResponseNotification;
//Schedule
extern NSString * const kWebSocketDidReceiveScheduleChangeResponseNotificaiton;
extern NSString * const kWebSocketDidReceiveLocationScheduleExecutedResponseNotificaiton;
extern NSString * const kWebSocketDidReceiveRoomScenarioResponseNotification;
//Trigger
extern NSString * const kWebSocketDidReceiveTriggerChangeResponseNotificaiton;
extern NSString * const kWebSocketDidReceiveTriggerExecutedResponseNotificaiton;
//Location
extern NSString * const kWebsocketDidReceiveLocationChangeNotification;
//Event
extern NSString * const kWebsocketDidReceiveEventNewNotification;
extern NSString * const kWebsocketDidReceiveEventChangeNotification;

#pragma mark - socket msg type
extern NSString * const kWebSocketMessageTypeText;
//Device
extern NSString * const kWebSocketMessageTypeBindDevice;
extern NSString * const kWebSocketMessageTypeUnBindDevice;
extern NSString * const kWebSocketMessageTypeDeviceOnline;
extern NSString * const kWebSocketMessageTypeDeviceRunStatus;
extern NSString * const kWebSocketMessageTypeRegisterDevice;
extern NSString * const kWebSocketMessageTypeConfigSubDevice;
extern NSString * const kWebsocketMessageTypeDeviceChange;
extern NSString * const kWebsocketMessageTypeTempPasswordChange;
//Authorize
extern NSString * const kWebSocketMessageTypeAuthorityAccept;
extern NSString * const kWebSocketMessageTypeAuthorityGrant;
extern NSString * const kWebSocketMessageTypeAuthorityReject;
extern NSString * const kWebSocketMessageTypeAuthorityRemove;
extern NSString * const kWebSocketMessageTypeAuthorityRevoke;
extern NSString * const kWebSocketMessageTypeAuthorityEdit;
//Video
extern NSString * const kWebSocketMessageTypeVideoHangUp;
extern NSString * const kWebSocketMessageTypeVideoCall;
extern NSString * const kWebSocketMessageTypeVideoEnd;
extern NSString * const kWebSocketMessageTypeVideoAccepted;
extern NSString * const kWebSocketMessageTypeVideoPickUp;
extern NSString * const kWebSocketMessageTypeVideoCallOpenDoor;
//group
extern NSString * const kWebSocketMessageTypeGroupChange;
extern NSString * const kWebSocketMessageTypeGroupCreate;
extern NSString * const kWebSocketMessageTypeGroupEdit;
extern NSString * const kWebSocketMessageTypeGroupEditDevice;
extern NSString * const kWebSocketMessageTypeGroupRemove;
//User
extern NSString * const kWebSocketMessageTypeUserLogin;
//Control
extern NSString * const kWebSocketMessageTypeControl;
//Alarm
extern NSString * const kWebSocketMessageTypeAlarmNotify;
extern NSString * const kWebSocketMessageTypeAlarmDelete;
//Scenario
extern NSString * const kWebSocketMessageTypeScenarioChange;
extern NSString * const kWebSocketMessageTypeRoomScenarioChange;
extern NSString * const kWebSocketMessageTypeScenario;
extern NSString * const kWebSocketMessageTypeRoomScenario;
extern NSString * const kWebSocketMessageTypeScenario_v2;
extern NSString * const kWebSocketMessageTypeScenarioCreate;
extern NSString * const kWebSocketMessageTypeScenarioEdit;
extern NSString * const kWebSocketMessageTypeScenarioRemove;
extern NSString * const kWebSocketMessageTypeScenarioReorder;
extern NSString * const kWebSocketMessageTypeRoomScenarioCreate;
extern NSString * const kWebSocketMessageTypeRoomScenarioEdit;
extern NSString * const kWebSocketMessageTypeRoomScenarioRemove;
extern NSString * const kWebSocketMessageTypeLocationScenarioSwitched;
//Schedule
extern NSString * const kWebSocketMessageTypeScheduleChange;
extern NSString * const kWebSocketMessageTypeScheduleCreate;
extern NSString * const kWebSocketMessageTypeScheduleEdit;
extern NSString * const kWebSocketMessageTypeScheduleRemove;
extern NSString * const kWebSocketMessageTypeScheduleEnable;
extern NSString * const kWebSocketMessageTypeScheduleExecuted;
//Trigger
extern NSString * const kWebSocketMessageTypeTriggerChange;
extern NSString * const kWebSocketMessageTypeTriggerExecuted;
extern NSString * const kWebSocketMessageTypeTriggerCreate;
extern NSString * const kWebSocketMessageTypeTriggerEdit;
extern NSString * const kWebSocketMessageTypeTriggerRemove;
extern NSString * const kWebSocketMessageTypeTriggerEnable;
//Location
extern NSString * const kWebsocketMessageTypeLocationChange;
//event
extern NSString * const kWebsocketMessageTypeEventNew;
extern NSString * const kWebsocketMessageTypeEventChange;
