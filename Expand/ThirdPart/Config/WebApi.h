//
//  WebApi.h
//  AirTouch
//
//  Created by Carl on 2/26/16.
//  Copyright © 2016 Honeywell. All rights reserved.
//

#ifndef WebApi_h
#define WebApi_h

//user
#define kSMSValidAPI           @"v1/api/user/getSmsCode"
#define kRegisterApi           @"v2/api/user/register"
#define kLoginApi              @"v2/api/user/login"
#define kAutoLoginApi          @"v2/api/user/autoLogin"
#define kUrl_PasswordChangeAPI @"v1/api/user/changePassword"
#define UserValidate           @"v1/api/user/encryptInfo"
#define UserLogout             @"v1/api/user/logout"
#define kUpdateLanguage        @"v1/api/user/updateLanguage"
#define kUpdatePassword        @"v1/api/user/resetPassword"
#define kUserVideoCalls        @"v1/api/user/video/calls"
#define kUserClientInfo        @"v1/api/user/updateClientInfo"
#define kUpdateUserInfo        @"v2/api/user/info/update"
#define kDeleteUser            @"v1/api/user/deleteUser"
#define kSendEmailApi          @"v2/api/user/sendEmailCode"
#define kCheckEmailApi         @"v2/api/user/checkEmailCode"


//authorize
#define kCheckUsersByPhoneNumber            @"v2/api/user/checkUsersByPhoneNumber"

//device
#define kBindDevice                @"v2/api/device/bind"
#define kUnBindDevice              @"v1/api/device/unBind"
#define kDevicesList               @"v2/api/device/list"
#define kGetEnrollType             @"v2/api/device/getEnrollType"
#define kAllDeviceStatusAPI        @"v2/api/device/listRunStatus"
#define kDeviceStatusAPI           @"v2/api/device/getRunstatusById"
#define kFrequentUsedDevice        @"v2/api/device/frequently"
#define kDeviceConfig              @"v2/api/device/config"
#define kDeviceSettings            @"v2/api/device/settings"
#define kDeviceUpdate              @"v2/api/device/update"
#define kDeviceFavorite            @"v2/api/device/favorite"
#define kCheckEnrollVerifyCode             @"v2/api/device/checkEnrollVerifyCode"

//group
#define kGroupList            @"v2/api/group/list"
#define kGroupCreate          @"v2/api/group/create"
#define kGroupUpdate          @"v2/api/group/update"
#define kGroupEditDevice      @"v2/api/group/editDevice"
#define kGroupRemove          @"v2/api/group/remove"

//location Http
#define kAddLocation       @"v2/api/location/add"
#define kDeleteLocation    @"v1/api/location/delete/{locationId}"
#define kGetLocationList   @"v2/api/location/list"
#define kSetDefaultHome    @"v1/api/location/default/{locationId}"
#define kEditLocation      @"v2/api/location/update"
#define kScenarioNotMatchDevices @"v2/api/location/scenario/notMatchDevices"
#define kLocationScenarioList     @"v3/api/location/scenario/list"
#define kLocationScenarioById     @"v3/api/location/scenario/getByLocationId"
#define kLocationScenarioFavorite @"v3/api/location/scenario/favorite"
#define kLocationRoomScenarioList     @"v3/api/location/room/scenario/list"
#define kLocationRoomScenarioById     @"v3/api/location/room/scenario/getByLocationId"
#define kLocationScheduleList         @"v2/api/location/schedule/list"
#define kLocationScheduleListById     @"v2/api/location/schedule/getByLocationId"
#define kLocationTriggerList         @"v2/api/location/trigger/list"
#define kLocationTriggerListById     @"v2/api/location/trigger/getByLocationId"

//message
#define kDeleteMessage            @"v1/api/message/delete"
#define kGetMessageById           @"v1/api/message/detail"
#define kGetAuthorizeMessageById  @"v2/api/message/authority/detail"
#define kMessageList              @"v1/api/message/list"
#define kUpdateMessageReadStatus  @"v1/api/message/read"
#define kMessageCount             @"v1/api/message/count"
#define kMessageClear             @"v1/api/message/clear"
#define kHandleInvitationMessage  @"v1/api/message/authority/handle"

//History event
#define kHistoryEventList    @"v2/api/event/list"
#define kHistoryEventRead    @"v2/api/event/read"
#define kHistoryEventCount   @"v2/api/event/count"

//Alarm
#define kAlarmEliminate    @"v1/api/alarm/eliminate"
#define kAlarmClear        @"v1/api/alarm/clear"
#define kAlarmList         @"v2/api/alarm/list"
#define kAlarmCount        @"v1/api/alarm/count"

//Weather
#define kWeatherNow      @"v1/api/weather/now"
#define kWeatherFuture   @"v1/api/weather/future"

//City
#define kCitySearch      @"v2/api/city/search"
#define kCityList        @"v2/api/city/list"

#define kDeviceControlAPI    @"devices/{deviceId}/AirCleaner/Control"
#define kDeviceWaterControlAPI    @"devices/{deviceId}/Water/SenarioControl"
#define kDeviceTaskAPI       @"commTasks?commTaskId={commTaskId}"
#define kDeviceDeleteAPI     @"devices/{deviceId}"
#define kDeviceConfigAPI @"device/Config"
#define kEmotionalPageAPI    @"locationEmotion?locationId={locationId}&periodType={periodType}"
#define kAllEmotionalPageAPI @"locationAllEmotionInfo?locationId={locationId}&periodType={periodType}"
#define kEmotionalGetVolumeAndTDsAPI @"locations/GetVolumeAndTdsByLocationID?locationId={locationId}&from={from}&to={to}"
#define kEmotionalGetDustAndPM25API @"locations/GetDustAndPm25ByLocationID?locationId={locationId}&from={from}&to={to}"
#define kEmotionalTotalDustAPI @"locations/GetTotalDustByLocationID?locationId={locationId}"
#define kEmotionalTotalVolumeAPI @"locations/GetTotalVolumeByLocationID?locationId={locationId}"

#define kUrl_UserId        @"userId"
#define kLocationScenarioControl     @"locations?locationId={locationId}"

#define kGateways                  @"gateways/AliveStatus"
#define kUrl_MacID                 @"macId"
#define kGroupingGetLocationAPI    @"Grouping/GetGroupByLocationId?locationId={locationId}"
#define kGroupingCreateGroupAPI    @"Grouping/CreateGroup?groupName={groupName}&masterDeviceId={masterDeviceId}&locationId={locationId}"
#define kGroupingDeleteDeviceFromGroupAPI @"Grouping/DeleteDeviceFromGroup?groupId={groupId}"
#define kGroupingDeleteGroupAPI    @"Grouping/DeleteGroup?groupId={groupId}"
#define kGroupingAddDeviceIntoGroupAPI     @"Grouping/AddDeviceIntoGroup?groupId={groupId}"
//kenny add

#define kUrl_BackHome          @"AirCleaner/{locationId}/BackHome"
#define kGroupControlAPI       @"Grouping/GroupControl?groupId={groupId}"
#define kCommTasksAPI          @"commTasks"
#define kUpdateGroupNameAPI    @"Grouping/UpdateGroupName?groupNewName={groupNewName}&groupId={groupId}"
#define kGetGroupAPI           @"Grouping/GetGroupByGroupId?groupId={groupId}"

//Feedback
#define kFeedbackSaveImageInfo      @"FeedBack/SaveImageInfo"
#define kFeedbackDelImageInfo       @"FeedBack/DelImageInfo?imgUrl={imgUrl}"
#define kFeedbackSaveFeedBack       @"FeedBack/SaveFeedBack"

#endif /* WebApi_h */
