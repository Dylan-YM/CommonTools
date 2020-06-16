//
//  WebSocketConfig.m
//  HomePlatform
//
//  Created by Honeywell on 2017/7/8.
//  Copyright © 2017年 Honeywell. All rights reserved.
//

#import "WebSocketConfig.h"

#pragma mark - string
NSString * const kWebSocketMsgData = @"msgData";
NSString * const kWebSocketMsgFlag = @"msgFlag";
NSString * const kWebSocketMsgId = @"msgId";
NSString * const kWebSocketMsgType = @"msgType";
NSString * const kWebSocketErrorCode = @"errorCode";

NSString * const kWebSocketMsgFlagRequest = @"request";
NSString * const kWebSocketMsgFlagResponse = @"response";

#pragma mark - notification name
NSString * const kWebSocketMessageUpdateNotification = @"kWebSocketMessageUpdateNotification";
NSString * const kWebSocketStateDidChangeNotification = @"kWebSocketStateDidChangeNotification";

//All websocket message will goes here
NSString * const kWebSocketDidReceiveResponseNotification = @"kWebSocketDidReceiveResponseNotification";
//Device
NSString * const kWebSocketDidReceiveBindDeviceResponseNotification = @"kWebSocketDidReceiveBindDeviceResponseNotification";
NSString * const kWebSocketDidReceiveUnBindDeviceResponseNotification = @"kWebSocketDidReceiveUnBindDeviceResponseNotification";
NSString * const kWebSocketDidReceiveDeviceOnlineResponseNotification = @"kWebSocketDidReceiveDeviceOnlineResponseNotification";
NSString * const kWebSocketDidReceiveDeviceRunStatusResponseNotification = @"kWebSocketDidReceiveDeviceRunStatusResponseNotification";
NSString * const kWebSocketDidReceiveRegisterDeviceResponseNotification = @"kWebSocketDidReceiveRegisterDeviceResponseNotification";
NSString * const kWebSocketDidReceiveConfigSubDeviceResponseNotification = @"kWebSocketDidReceiveConfigSubDeviceResponseNotification";
NSString * const kWebSocketDidReceiveDeviceChangeResponseNotification = @"kWebSocketDidReceiveDeviceChangeResponseNotification";
NSString * const kWebSocketDidReceiveTempPasswordChangeResponseNotification = @"kWebSocketDidReceiveTempPasswordChangeResponseNotification";
//Authorize
NSString * const kWebSocketDidReceiveAuthorityAcceptResponseNotification = @"kWebSocketDidReceiveAuthorityAcceptResponseNotification";
NSString * const kWebSocketDidReceiveAuthorityGrantResponseNotification = @"kWebSocketDidReceiveAuthorityGrantResponseNotification";
NSString * const kWebSocketDidReceiveAuthorityRejectResponseNotification = @"kWebSocketDidReceiveAuthorityRejectResponseNotification";
NSString * const kWebSocketDidReceiveAuthorityRemoveResponseNotification = @"kWebSocketDidReceiveAuthorityRemoveResponseNotification";
NSString * const kWebSocketDidReceiveAuthorityRevokeResponseNotification = @"kWebSocketDidReceiveAuthorityRevokeResponseNotification";
NSString * const kWebSocketDidReceiveAuthorityEditResponseNotification = @"kWebSocketDidReceiveAuthorityEditResponseNotification";
//Video
NSString * const kWebSocketDidReceiveVideoHangUpResponseNotification = @"kWebSocketDidReceiveVideoHangUpResponseNotification";
NSString * const kWebSocketDidReceiveVideoCallResponseNotification = @"kWebSocketDidReceiveVideoCallResponseNotification";
NSString * const kWebSocketDidReceiveVideoEndResponseNotification = @"kWebSocketDidReceiveVideoEndResponseNotification";
NSString * const kWebSocketDidReceiveVideoAcceptedResponseNotification = @"kWebSocketDidReceiveVideoAcceptedResponseNotification";
NSString * const kWebSocketDidReceiveVideoPickUpResponseNotification = @"kWebSocketDidReceiveVideoPickUpResponseNotification";
NSString * const kWebSocketDidReceiveVideoOpenDoorResponseNotification = @"kWebSocketDidReceiveVideoOpenDoorResponseNotification";
//location
NSString * const kWebSocketDidReceiveLocationChangeResponseNotification = @"kWebSocketDidReceiveLocationChangeResponseNotification";
NSString * const kWebSocketDidReceiveLocationScenarioResponseNotification = @"kWebSocketDidReceiveLocationScenarioResponseNotification";
NSString * const kWebSocketDidReceiveLocationScenarioSwitchedResponseNotification = @"kWebSocketDidReceiveLocationScenarioSwitchedResponseNotification";
//group
NSString * const kWebSocketDidReceiveGroupChangeResponseNotification = @"kWebSocketDidReceiveGroupChangeResponseNotification";
NSString * const kWebSocketDidReceiveGroupCreateResponseNotification = @"kWebSocketDidReceiveGroupCreateResponseNotification";
NSString * const kWebSocketDidReceiveGroupEditResponseNotification = @"kWebSocketDidReceiveGroupEditResponseNotification";
NSString * const kWebSocketDidReceiveGroupEditDeviceResponseNotification = @"kWebSocketDidReceiveGroupEditDeviceResponseNotification";
NSString * const kWebSocketDidReceiveGroupRemoveResponseNotification = @"kWebSocketDidReceiveGroupRemoveResponseNotification";
//User
NSString * const kWebSocketDidReceiveUserLoginResponseNotification = @"kWebSocketDidReceiveUserLoginResponseNotification";
//Alarm
NSString * const kWebSocketDidReceiveAlarmNotifyResponseNotification = @"kWebSocketDidReceiveAlarmNotifyResponseNotification";
NSString * const kWebSocketDidReceiveAlarmDeleteResponseNotification = @"kWebSocketDidReceiveAlarmDeleteResponseNotification";
//Control
NSString * const kWebSocketDidReceiveControlResponseNotification = @"kWebSocketDidReceiveControlResponseNotification";
//Scenario
NSString * const kWebSocketDidReceiveScenarioChangeResponseNotification = @"kWebSocketDidReceiveScenarioChangeResponseNotification";
NSString * const kWebSocketDidReceiveRoomScenarioResponseNotification = @"kWebSocketDidReceiveRoomScenarioResponseNotification";
NSString * const kWebSocketDidReceiveRoomScenarioChangeResponseNotification = @"kWebSocketDidReceiveRoomScenarioChangeResponseNotification";
//Schedule
NSString * const kWebSocketDidReceiveScheduleChangeResponseNotificaiton = @"kWebSocketDidReceiveScheduleChangeResponseNotificaiton";
NSString * const kWebSocketDidReceiveLocationScheduleExecutedResponseNotificaiton = @"kWebSocketDidReceiveLocationScheduleExecutedResponseNotificaiton";
//trigger
NSString * const kWebSocketDidReceiveTriggerChangeResponseNotificaiton = @"kWebSocketDidReceiveTriggerChangeResponseNotificaiton";
NSString * const kWebSocketDidReceiveTriggerExecutedResponseNotificaiton = @"kWebSocketDidReceiveTriggerExecutedResponseNotificaiton";
//Location
NSString * const kWebsocketDidReceiveLocationChangeNotification = @"kWebsocketDidReceiveLocationChangeNotification";
//event
NSString * const kWebsocketDidReceiveEventNewNotification = @"kWebsocketDidReceiveEventNewNotification";
NSString * const kWebsocketDidReceiveEventChangeNotification = @"kWebsocketDidReceiveEventChangeNotification";

#pragma mark - Message Type
NSString * const kWebSocketMessageTypeText = @"/v1/text";
//enroll
NSString * const kWebSocketMessageTypeBindDevice = @"/v2/device/enroll";
NSString * const kWebSocketMessageTypeUnBindDevice = @"/v1/device/unenroll";
NSString * const kWebSocketMessageTypeDeviceOnline = @"/v1/device/online";
NSString * const kWebSocketMessageTypeDeviceRunStatus = @"/v1/device/runStatus";
NSString * const kWebSocketMessageTypeRegisterDevice = @"/v1/device/registerDevice";
//auth
NSString * const kWebSocketMessageTypeAuthorityAccept = @"/v1/authority/accept";
NSString * const kWebSocketMessageTypeAuthorityGrant = @"/v1/authority/grant";
NSString * const kWebSocketMessageTypeAuthorityReject = @"/v1/authority/reject";
NSString * const kWebSocketMessageTypeAuthorityRemove = @"/v1/authority/remove";
NSString * const kWebSocketMessageTypeAuthorityRevoke = @"/v1/authority/revoke";
NSString * const kWebSocketMessageTypeAuthorityEdit = @"/v1/authority/edit";
//video call
NSString * const kWebSocketMessageTypeVideoHangUp = @"/v1/video/hangUp";
NSString * const kWebSocketMessageTypeVideoCall = @"/v1/video/call";
NSString * const kWebSocketMessageTypeVideoEnd = @"/v1/video/end";
NSString * const kWebSocketMessageTypeVideoAccepted = @"/v1/video/accepted";
NSString * const kWebSocketMessageTypeVideoPickUp = @"/v1/video/pickUp";
NSString * const kWebSocketMessageTypeVideoCallOpenDoor = @"/v1/videocall/openDoor";
//group
NSString * const kWebSocketMessageTypeGroupChange = @"/v2/location/group/change";
NSString * const kWebSocketMessageTypeGroupCreate = @"/v2/api/group/create";
NSString * const kWebSocketMessageTypeGroupEdit = @"/v2/api/group/edit";
NSString * const kWebSocketMessageTypeGroupEditDevice = @"/v2/api/group/editDevice";
NSString * const kWebSocketMessageTypeGroupRemove = @"/v2/api/group/remove";
//user
NSString * const kWebSocketMessageTypeUserLogin = @"/v1/user/kickOut";
//Control
NSString * const kWebSocketMessageTypeControl = @"/v1/device/control";
//Alarm
NSString * const kWebSocketMessageTypeAlarmNotify = @"/v1/api/alarm/new";
NSString * const kWebSocketMessageTypeAlarmDelete = @"/v1/api/alarm/delete";
//Scenario
NSString * const kWebSocketMessageTypeScenarioChange = @"/v3/location/scenario/change";
NSString * const kWebSocketMessageTypeRoomScenarioChange = @"/v3/location/room/scenario/change";
NSString * const kWebSocketMessageTypeScenario = @"/v3/location/scenario";
NSString * const kWebSocketMessageTypeRoomScenario = @"/v3/api/location/room/scenario";

NSString * const kWebSocketMessageTypeScenario_v2 = @"/v2/location/scenario";
NSString * const kWebSocketMessageTypeScenarioCreate = @"/v3/api/location/scenario/create";
NSString * const kWebSocketMessageTypeScenarioEdit = @"/v3/api/location/scenario/edit";
NSString * const kWebSocketMessageTypeScenarioRemove = @"/v3/api/location/scenario/remove";
NSString * const kWebSocketMessageTypeScenarioReorder = @"/v3/api/location/scenario/reorder";
NSString * const kWebSocketMessageTypeRoomScenarioCreate = @"/v3/api/location/room/scenario/create";
NSString * const kWebSocketMessageTypeRoomScenarioEdit = @"/v3/api/location/room/scenario/edit";
NSString * const kWebSocketMessageTypeRoomScenarioRemove = @"/v3/api/location/room/scenario/remove";
NSString * const kWebSocketMessageTypeLocationScenarioSwitched = @"/v3/location/scenario/switched";
//Schedule
NSString * const kWebSocketMessageTypeScheduleChange = @"/v2/location/schedule/change";
NSString * const kWebSocketMessageTypeScheduleCreate = @"/v2/api/location/schedule/add";
NSString * const kWebSocketMessageTypeScheduleEdit = @"/v2/api/location/schedule/edit";
NSString * const kWebSocketMessageTypeScheduleRemove = @"/v2/api/location/schedule/remove";
NSString * const kWebSocketMessageTypeScheduleEnable = @"/v2/api/location/schedule/enable";
NSString * const kWebSocketMessageTypeScheduleExecuted = @"/v2/location/schedule/executed";
//Trigger
NSString * const kWebSocketMessageTypeTriggerChange = @"/v2/location/trigger/change";
NSString * const kWebSocketMessageTypeTriggerExecuted = @"/v2/location/trigger/executed";
NSString * const kWebSocketMessageTypeTriggerCreate = @"/v2/api/location/trigger/add";
NSString * const kWebSocketMessageTypeTriggerEdit = @"/v2/api/location/trigger/edit";
NSString * const kWebSocketMessageTypeTriggerRemove = @"/v2/api/location/trigger/remove";
NSString * const kWebSocketMessageTypeTriggerEnable = @"/v2/api/location/trigger/enable";
//Device
NSString * const kWebSocketMessageTypeConfigSubDevice = @"/v2/api/device/configSubDevice";
NSString * const kWebsocketMessageTypeDeviceChange = @"/v2/device/change";
NSString * const kWebsocketMessageTypeTempPasswordChange = @"/v2/security/passwordList/change";
//Location
NSString * const kWebsocketMessageTypeLocationChange = @"/v2/location/change";
//event
NSString * const kWebsocketMessageTypeEventNew = @"/v2/api/event/new";
NSString * const kWebsocketMessageTypeEventChange = @"/v2/location/event/change";
