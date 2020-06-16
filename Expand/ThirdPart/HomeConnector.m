//
//  HomeConnector.m
//  iOSHomePlatform
//
//  Created by Liu, Carl on 23/03/2017.
//  Copyright © 2017 Honeywell. All rights reserved.
//

#import "HomeConnector.h"
#import "HWSessionAPIRequest.h"
#import "HWLoginAPIManager.h"
#import "ERAPIManager.h"
#import "BroadLinkAPIManager.h"
#import "ContactManager.h"
#import "UserEntity.h"
#import "HomeModel.h"
#import "DeviceModel.h"
#import "AppMarco.h"
#import "WebSocketManager.h"
#import "TimerUtil.h"
#import "HWGroupModel.h"
#import "CountlyTracker.h"
#import "AppMarco.h"

//Common
static NSString * const COMMAND             = @"command";
static NSString * const CALLBACK_ID         = @"callbackId";
static NSString * const PARAM               = @"param";

static NSString * const RESULT              = @"result";
static NSString * const RESPONSE            = @"response";
static NSString * const VALUE               = @"value";
static NSString * const KEEPCALLBACK        = @"keepCallback";

static NSString * const ERROR               = @"error";
static NSString * const CODE                = @"code";
static NSString * const MESSAGE             = @"message";
static NSString * const MESSAGEDATA         = @"msgData";
static NSString * const MESSAGEFLAG         = @"msgFlag";

//Web API
static NSString * const WEBAPI              = @"cmd_webapi_send";
static NSString * const CANCEL_WEB_API      = @"cmd_webapi_cancel";

static NSString * const PLACEHOLDER         = @"placeholder";
static NSString * const API                 = @"api";
static NSString * const REQUESTPARAM        = @"requestParam";
static NSString * const METHOD              = @"method";
static NSString * const SESSION_REQUIRED    = @"isSessionRequired";
static NSString * const REQUEST_ID          = @"requestId";

static NSString * const GET                 = @"GET";
static NSString * const PUT                 = @"PUT";
static NSString * const POST                = @"POST";
static NSString * const DELETE              = @"DELETE";

static NSString * const CLOUD               = @"cloud";
static NSString * const AP_ENROLL           = @"ap_enroll";
static NSString * const BROADLINK           = @"broadlink";

//Web Socket
static NSString * const WEBSOCKET           = @"cmd_websocket_send";
static NSString * const CANCEL_WEBSOCKET    = @"cmd_websocket_cancel";
static NSString * const WEBSOCKET_STARTED   = @"started";
static NSString * const WEBSOCKET_TIMEOUT   = @"timeout";
static NSString * const WEBSOCKET_KEEP      = @"keep";

//Contacts
static NSString * const GET_CONTACTS        = @"cmd_contact_getList";
static NSString * const CONTACTS            = @"contacts";
static NSString * const CONTACTS_QUERY      = @"query";
static NSString * const CONTACTS_UPDATE     = @"cmd_contacts_did_update";

//Authorization
static NSString * const GET_AUTH_HOMES      = @"cmd_auth_getList";
static NSString * const HOMES               = @"homes";
static NSString * const ME                  = @"me";
static NSString * const PHONE_NUMBER        = @"phoneNumber";

//Location
static NSString * const HOME_DID_UPDATE     = @"sbc_location_list";
static NSString * const UPDATE_HOME_LIST    = @"cmd_location_getList_cloud";
static NSString * const HOME_GET_ITEM       = @"cmd_location_getItem_local";
static NSString * const HOME_GET_GATEWAY_DEVICE_ITEM = @"cmd_location_getGatewayDeviceItem_local";
static NSString * const LOCATION_GETLIST_LOCAL = @"cmd_location_getList_local";

//Group
static NSString * const ROOM_DID_UPDATE         = @"sbc_room_list";
static NSString * const GET_GROUP_DEVICE_LIST    = @"cmd_group_getList_local";
static NSString * const UPDATE_GROUP_LIST        = @"cmd_group_getList_cloud";
static NSString * const GET_ROOM_LIST        = @"cmd_room_getList_local";
static NSString * const GET_GROUP_ITEM    = @"cmd_group_getItem_local";
static NSString * const SET_DISPLAY_ROOM = @"cmd_set_location_display_room";

//Device
static NSString * const DEVICE_LIST_DID_UPDATE = @"sbc_device_list";
static NSString * const DEVICE_DID_UPDATE   = @"sbc_device_item";
static NSString * const GET_DEVICE_LOCAL    = @"cmd_device_getItem_local";
static NSString * const GET_DEVICE_CLOUD    = @"cmd_device_getItem_cloud";
static NSString * const GET_SUBDEVICE_LIST_LOCAL = @"cmd_device_getSubDeviceList_local";
static NSString * const GET_DEVICE_LIST_LOCAL    = @"cmd_device_getList_local";
static NSString * const GET_PAIREDSUBDEVICE_LIST_LOCAL = @"cmd_device_getPairedSubDeviceList_local";

//Scenario
static NSString * const SCENARIO_LIST_UPDATE    = @"sbc_scenario_list";
static NSString * const GET_SCENARIO_LIST_LOCAL = @"cmd_scenario_getList_local";
static NSString * const GET_SCENARIO_ITEM_LOCAL = @"cmd_scenario_getItem_local";
static NSString * const GET_SCENARIO_ROOM_LIST_LOCAL = @"cmd_scenario_room_getList_local";
static NSString * const GET_SCENARIO_ROOM_ITEM_LOCAL = @"cmd_scenario_room_getItem_local";
static NSString * const SCENARIO_LOCATION_ROOM_LIST_UPDATE    = @"sbc_scenario_room_list";

static NSString * const GET_CONTROLLING_SCENARIO = @"cmd_location_controllingScenario";
static NSString * const LOCATION_SCENARIO_CONTROL = @"cmd_location_scenario_control";
static NSString * const SCENARIO_ROOM_CONTROL_CHANGE = @"cmd_location_scenario_change";
static NSString * const SBC_SCENARIO_CONTROL = @"sbc_scenario_control";

//Schedule
static NSString * const SCHEDULE_LIST_UPDATE    = @"sbc_schedule_list";
static NSString * const GET_SCHEDULE_LIST_LOCAL = @"cmd_schedule_getList_local";
static NSString * const GET_SCHEDULE_ITEM_LOCAL = @"cmd_schedule_getItem_local";

//Trigger
static NSString * const TRIGGER_LIST_UPDATE    = @"sbc_trigger_list";
static NSString * const GET_TRIGGER_LIST_LOCAL = @"cmd_trigger_getList_local";
static NSString * const GET_TRIGGER_ITEM_LOCAL = @"cmd_trigger_getItem_local";

static NSString * const DEVICE_CHECK_NAME   = @"cmd_device_checkName_local";
static NSString * const DEVICE_NAME     = @"name";

static NSString * const SBC_REGISTERDEVICE = @"sbc_registerDevice";

static NSString * const SBC_TEMPORARY_PASSWORD_LIST = @"sbc_temporary_password_list";

static NSString * const CMD_COUNTLY_TRACK = @"cmd_countly_track";

//User
static NSString * const USER_GETINFO = @"cmd_user_getInfo";

static NSInteger const WEBSOCKET_ERROR_TIMEOUT = -1001;
//static NSInteger const WEBSOCKET_ERROR_CANCELED = -2;

@interface HomeConnector ()

@property (strong, nonatomic) NSMutableDictionary *requestMap;
@property (strong, nonatomic) NSMutableDictionary *websocketMap;

@end


@implementation HomeConnector

+ (void)load {
    static HomeConnector *service = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        service = [[HomeConnector alloc] init];
    });
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.requestMap = [NSMutableDictionary dictionary];
        self.websocketMap = [NSMutableDictionary dictionary];
       
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(homeListDidUpdate:) name:kNotification_sbc_location_list object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(groupInfoUpdated:) name:kNotification_sbc_room_list object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceDidUpdate:) name:kNotification_UpdateDeviceSucceed object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(homeScenarioDidUpdate:) name:kNotification_sbc_scenario_list object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationRoomScenarioDidUpdate:) name:kNotification_sbc_room_scenario object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(homeScheduleDidUpdate:) name:kNotification_sbc_schedule_list object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(homeTriggerDidUpdate:) name:kNotification_sbc_trigger_list object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(homeScenarioControlResponse:) name:kNotification_ScenarioControl object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveWebsocketMessage:) name:kWebSocketDidReceiveResponseNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveRegisterDevice:) name:kWebSocketDidReceiveRegisterDeviceResponseNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveTempPasswordChange:) name:kWebSocketDidReceiveTempPasswordChangeResponseNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceRunstatusListDidUpdate:) name:kNotification_sbc_device_list object:nil];
        [TimerUtil scheduledDispatchTimerWithName:@"check_websocket_garbage" timeInterval:1 repeats:YES action:^{
            [self checkWebsocketGarbage];
        }];
    }
    return self;
}

- (void)receiveCommandStart:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    NSString *command = userInfo[COMMAND];
    NSString *callbackId = userInfo[CALLBACK_ID];
    NSDictionary *param = userInfo[PARAM];
    
    NSMutableDictionary *res = [NSMutableDictionary dictionary];
    res[RESULT] = @(YES);
    res[RESPONSE] = @{};
    res[CALLBACK_ID] = callbackId;
    
    if ([command isEqualToString:WEBAPI]) {
        NSDictionary *placeholder = param[PLACEHOLDER];
        NSString *api = param[API];
        NSDictionary *requestParam = param[REQUESTPARAM];
        NSString *method = param[METHOD];
        BOOL isSessionRequired = [param[SESSION_REQUIRED] boolValue];
        NSNumber *requestId = param[REQUEST_ID];
        
        BaseAPIRequest *apiManager = nil;
        if ([placeholder isEqual:CLOUD]) {
            if (isSessionRequired) {
                apiManager = [[HWSessionAPIRequest alloc] init];
            } else {
                if ([api isEqualToString:kLoginApi]) {
                    apiManager = [[HWLoginAPIManager alloc] init];
                } else {
                    apiManager = [[HWAPIRequest alloc] init];
                }
            }
        } else if ([placeholder isEqual:AP_ENROLL]) {
            apiManager = [[ERAPIManager alloc] init];
        } else if ([placeholder isEqual:BROADLINK]) {
            apiManager = [[BroadLinkAPIManager alloc] init];
        }
        if (apiManager == nil) {
            res[RESULT] = @(NO);
            res[RESPONSE] = @{};
            
            return;
        }
        apiManager.apiName = api;
        if ([method isEqualToString:GET]) {
            apiManager.requestType = RequestType_Get;
        } else if ([method isEqualToString:POST]) {
            apiManager.requestType = RequestType_Post;
        } else if ([method isEqualToString:PUT]) {
            apiManager.requestType = RequestType_Put;
        } else if ([method isEqualToString:DELETE]) {
            apiManager.requestType = RequestType_Delete;
        }
        
        [apiManager callAPIWithParam:requestParam completion:^(id object, NSError *error) {
            res[RESULT] = @(error==nil);
            res[RESPONSE] = object?:@{};
            if (error) {
                res[ERROR] = @{CODE:@(error.code),
                               MESSAGE:error.domain};
            }
            if ([api isEqualToString:kUnBindDevice]) {
                BOOL unbindFailed = YES;
                if (!error) {
                    if ([object isKindOfClass:[NSDictionary class]]) {
                        id failedList = object[@"falied"];
                        if (!failedList || ([failedList isKindOfClass:[NSArray class]] && [failedList count] == 0)) {
                            unbindFailed = NO;
                        }
                    }
                }
                
                if (unbindFailed) {
                    
                } else {
                    
                }
            }
            if ([api isEqualToString:kDeviceFavorite]) {
                if (!error) {
                    NSInteger deviceId = [requestParam[@"deviceId"] integerValue];
                    DeviceModel *device = [[UserEntity instance] getDeviceById:deviceId];
                    [device updateWithDictionary:@{kDeviceFavorite:@(!device.isFavorite)}];
                }
            }
            if (requestId) {
                [self.requestMap removeObjectForKey:requestId];
            }
           
        }];
        if (requestId) {
            self.requestMap[requestId] = apiManager;
        }
    } else if ([command isEqualToString:CANCEL_WEB_API]) {
        NSNumber *requestId = param[REQUEST_ID];
        if (requestId) {
            BaseAPIRequest *apiManager = self.requestMap[requestId];
            [apiManager cancel];
            [self.requestMap removeObjectForKey:requestId];
        }
       
    } else if ([command isEqualToString:GET_CONTACTS]) {
        NSString *query = param[CONTACTS_QUERY];
        if (query == nil) {
            res[RESPONSE] = @{CONTACTS:@[]};
          
            return;
        }
        [[ContactManager instance] readContactsWithQuery:query completion:^(NSArray *contacts, NSError *error) {
            res[RESULT] = @(error==nil);
            if (contacts) {
                res[RESPONSE] = @{CONTACTS:contacts};
            }
            if (error) {
                res[ERROR] = @{CODE:@(error.code),
                               MESSAGE:error.domain};
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:kPlatformPluginCommandFinishNotification object:self userInfo:res];
        }];
    } else if ([command isEqualToString:CONTACTS_UPDATE]) {
        [[UserEntity instance] updateGLDNotificationActions];
        [[NSNotificationCenter defaultCenter] postNotificationName:kPlatformPluginCommandFinishNotification object:self userInfo:res];
    } else if ([command isEqualToString:DEVICE_CHECK_NAME]) {
        NSNumber *locationId = param[@"locationId"];
        NSNumber *deviceId = param[@"deviceId"];
        NSString *name = param[@"newName"];
        BOOL nameValid = NO;
        HomeModel *home = [[UserEntity instance] getHomebyId:[NSString stringWithFormat:@"%ld", (long)[locationId integerValue]]];
        nameValid = [home checkDeviceName:name deviceId:[deviceId integerValue]];
        res[RESPONSE] = @{@"isExist":@(nameValid)};
        [[NSNotificationCenter defaultCenter] postNotificationName:kPlatformPluginCommandFinishNotification object:self userInfo:res];
    } else if ([command isEqualToString:GET_AUTH_HOMES]) {
        res[RESULT] = @(YES);
        NSArray *allEntites = [UserEntity instance].allEntites;
        if (allEntites) {
            NSMutableArray *myHomes = [NSMutableArray array];
            NSMutableArray *authToMeHomes = [NSMutableArray array];
            
            NSMutableDictionary *myHomeDict = [NSMutableDictionary dictionary];
            myHomeDict[@"type"] = @(0);
            myHomeDict[@"authHomeList"] = myHomes;
            
            NSMutableDictionary *authToMeHomeDict = [NSMutableDictionary dictionary];
            authToMeHomeDict[@"type"] = @(1);
            authToMeHomeDict[@"authHomeList"] = authToMeHomes;
            
            NSMutableArray *homes = [NSMutableArray array];
            [homes addObject:myHomeDict];
            [homes addObject:authToMeHomeDict];
            
            for (HomeModel *homeModel in allEntites) {
                NSMutableDictionary *homeDict = [NSMutableDictionary dictionary];
                homeDict[@"authorizedType"] = @(homeModel.authorizedType);
                homeDict[@"locationId"] = homeModel.locationID;
                homeDict[@"locationName"] = homeModel.name;
                homeDict[@"ownerId"] = @(homeModel.ownerId);
                homeDict[@"ownerGender"] = @(homeModel.ownerGender);
                homeDict[@"ownerName"] = homeModel.ownerName?:@"";
                homeDict[@"ownerPhoneNumber"] = homeModel.ownerPhoneNumber?:@"";
                homeDict[@"locationAuthorizedTo"] = homeModel.authorizedTo?:@[];
                NSMutableArray *deviceList = [NSMutableArray array];
                for (DeviceModel *device in homeModel.devices) {
                    NSMutableDictionary *deviceDict = [NSMutableDictionary dictionary];
                    deviceDict[@"deviceId"] = @(device.deviceID);
                    deviceDict[@"deviceName"] = device.name;
                    deviceDict[@"productModel"] = device.deviceType;
                    if (device.sku) {
                        deviceDict[@"sku"] = device.sku;
                    }
                    NSMutableArray *authTo = [NSMutableArray array];
                    for (NSDictionary *auth in device.authorizedTo) {
                        NSMutableDictionary *authDict = [NSMutableDictionary dictionary];
                        if ([[auth allKeys] containsObject:@"userId"]) {
                            authDict[@"grantToUserId"] = auth[@"userId"];
                        }
                        if ([[auth allKeys] containsObject:@"userName"]) {
                            authDict[@"grantToUserName"] = auth[@"userName"];
                        }
                        if ([[auth allKeys] containsObject:@"phoneNumber"]) {
                            authDict[@"phoneNumber"] = auth[@"phoneNumber"];
                        } else {
                            authDict[@"role"] = @(AuthorizeRoleNone);
                        }
                        if ([[auth allKeys] containsObject:@"permission"]) {
                            authDict[@"role"] = auth[@"permission"];
                        }
                        if ([[auth allKeys] containsObject:@"status"]) {
                            authDict[@"status"] = auth[@"status"];
                        }
                        [authTo addObject:authDict];
                    }
                    
                    deviceDict[@"authorityTo"] = authTo;
                    deviceDict[@"ownerId"] = @(device.ownerId);
                    deviceDict[@"ownerName"] = device.ownerName;
                    deviceDict[@"role"] = @(device.permission);
                    [deviceList addObject:deviceDict];
                }
                homeDict[@"deviceList"] = deviceList;
                
                if (homeModel.isOwner) {
                    [myHomes addObject:homeDict];
                } else {
                    [authToMeHomes addObject:homeDict];
                }
            }
            res[RESPONSE] = @{
                              HOMES:homes,
                              ME:@{
                                      PHONE_NUMBER:[UserEntity instance].username?:@""
                                      }
                              };
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:kPlatformPluginCommandFinishNotification object:self userInfo:res];
    } else if ([command isEqualToString:UPDATE_HOME_LIST]) {
        [[UserEntity instance] updateAllLocations:nil deviceListBlock:nil runStatusBlock:nil reload:YES newRequest:NO];
        [[NSNotificationCenter defaultCenter] postNotificationName:kPlatformPluginCommandFinishNotification object:self userInfo:res];
    } else if ([command isEqualToString:LOCATION_GETLIST_LOCAL]) {
        res[RESULT] = @(YES);
        NSArray *homesDict = [[UserEntity instance] getAllHomeDict];
        res[RESPONSE] = @{@"locationList":homesDict};
        [[NSNotificationCenter defaultCenter] postNotificationName:kPlatformPluginCommandFinishNotification object:self userInfo:res];
    } else if ([command isEqualToString:GET_GROUP_DEVICE_LIST]) {
        res[RESULT] = @(YES);
        NSInteger locationId = [param[@"locationId"] integerValue];
        NSArray *allEntites = [UserEntity instance].allEntites;
        HomeModel *homeModel = nil;
        for (NSInteger i = 0; i < allEntites.count; i++) {
            HomeModel *model = allEntites[i];
            if ([model.locationID integerValue] == locationId) {
                homeModel = model;
                break;
            }
        }
        if (homeModel) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setObject:@([homeModel.locationID integerValue]) forKey:@"locationId"];
            [dict setObject:@(homeModel.isOwner) forKey:@"isOwner"];
            [dict setObject:[homeModel getAllGroupDicts] forKey:@"groups"];
            [dict setObject:[homeModel getAllDeviceDicts] forKey:@"devices"];
            res[RESPONSE] = dict;
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kPlatformPluginCommandFinishNotification object:self userInfo:res];
    } else if ([command isEqualToString:GET_ROOM_LIST]) {
        res[RESULT] = @(YES);
        NSInteger locationId = [param[@"locationId"] integerValue];
        NSArray *allEntites = [UserEntity instance].allEntites;
        HomeModel *homeModel = nil;
        for (NSInteger i = 0; i < allEntites.count; i++) {
            HomeModel *model = allEntites[i];
            if ([model.locationID integerValue] == locationId) {
                homeModel = model;
                break;
            }
        }
        if (homeModel) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setObject:[homeModel getAllGroupDicts] forKey:@"roomList"];
            res[RESPONSE] = dict;
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kPlatformPluginCommandFinishNotification object:self userInfo:res];
    } else if ([command isEqualToString:UPDATE_GROUP_LIST]) {
        [[UserEntity instance] updateGroupList];
        [[NSNotificationCenter defaultCenter] postNotificationName:kPlatformPluginCommandFinishNotification object:self userInfo:res];
    } else if ([command isEqualToString:WEBSOCKET]) {
        NSString *messageId = param[kWebSocketMsgId];
        NSString *messageType = param[kWebSocketMsgType];
        NSNumber *messageFlag = param[kWebSocketMsgFlag];
        NSObject *messageData = param[kWebSocketMsgData];
        NSNumber *messageTimeout = param[WEBSOCKET_TIMEOUT];
        NSNumber *messageKeep = param[WEBSOCKET_KEEP];
        messageId = [[WebSocketManager instance] sendWithType:messageType data:messageData flag:[messageFlag integerValue] messageId:messageId];
        if ([messageFlag integerValue] == WebSocketMessageFlagRequest) {
            if (messageId) {
                self.websocketMap[messageId] = @{
                                                 CALLBACK_ID:callbackId,
                                                 WEBSOCKET_TIMEOUT:messageTimeout?:@(0),
                                                 WEBSOCKET_KEEP:messageKeep?:@(0),
                                                 WEBSOCKET_STARTED:[NSDate date]
                                                 };
            } else {
                res[RESULT] = @(NO);
                res[RESPONSE] = @{};
                res[ERROR] = @{CODE:@(HWErrorInternalServerError),
                               MESSAGE:userInfo[@"erroMsg"]?:@""};
                [[NSNotificationCenter defaultCenter] postNotificationName:kPlatformPluginCommandFinishNotification object:self userInfo:res];
            }
        } else {
            [[NSNotificationCenter defaultCenter] postNotificationName:kPlatformPluginCommandFinishNotification object:self userInfo:res];
        }
    } else if ([command isEqualToString:CANCEL_WEBSOCKET]) {
        NSString *messageId = param[kWebSocketMsgId];
        if (messageId) {
            NSDictionary *requestDictionary = self.websocketMap[messageId];
            if (requestDictionary) {
                NSMutableDictionary *prevRes = [NSMutableDictionary dictionary];
                prevRes[RESULT] = @(YES);
                prevRes[RESPONSE] = @{@"ignore":@(YES)};
//                prevRes[ERROR] = @{CODE:@(WEBSOCKET_ERROR_CANCELED),
//                               MESSAGE:@"web socket request cancelled"};
                prevRes[CALLBACK_ID] = requestDictionary[CALLBACK_ID];
                [[NSNotificationCenter defaultCenter] postNotificationName:kPlatformPluginCommandFinishNotification object:self userInfo:prevRes];
            }
            
            [self.websocketMap removeObjectForKey:messageId];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:kPlatformPluginCommandFinishNotification object:self userInfo:res];
    } else if ([command isEqualToString:GET_DEVICE_LOCAL]) {
        NSInteger deviceId = [param[@"deviceId"] integerValue];
        DeviceModel *device = nil;
        for (HomeModel *home in [UserEntity instance].allEntites) {
            device = [home getDeviceById:[NSString stringWithFormat:@"%ld", (long)deviceId]];
            if (device) {
                break;
            }
        }
        if (device) {
            res[RESPONSE] = [device convertToHtml];
        } else {
            res[RESULT] = @(NO);
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kPlatformPluginCommandFinishNotification object:self userInfo:res];
    } else if ([command isEqualToString:GET_DEVICE_CLOUD]) {
        NSInteger deviceId = [param[@"deviceId"] integerValue];
        DeviceModel *device = nil;
        for (HomeModel *home in [UserEntity instance].allEntites) {
            device = [home getDeviceById:[NSString stringWithFormat:@"%ld", (long)deviceId]];
            if (device) {
                break;
            }
        }
        if (device) {
            [device updateDeviceRunStatus:^(id object, NSError *error) {
                
            }];
        } else {
            res[RESULT] = @(NO);
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:kPlatformPluginCommandFinishNotification object:self userInfo:res];
    } else if ([command isEqualToString:GET_DEVICE_LIST_LOCAL]) {
        res[RESULT] = @(YES);
        NSInteger locationId = [param[@"locationId"] integerValue];
        NSArray *allEntites = [UserEntity instance].allEntites;
        HomeModel *homeModel = nil;
        for (NSInteger i = 0; i < allEntites.count; i++) {
            HomeModel *model = allEntites[i];
            if ([model.locationID integerValue] == locationId) {
                homeModel = model;
                break;
            }
        }
        if (homeModel) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setObject:[homeModel getAllDeviceDicts] forKey:@"deviceList"];
            res[RESPONSE] = dict;
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kPlatformPluginCommandFinishNotification object:self userInfo:res];
    } else if ([command isEqualToString:GET_SCENARIO_LIST_LOCAL]) {
        NSInteger locationId = [param[@"locationId"] integerValue];
        HomeModel *home = [[UserEntity instance] getHomebyId:[NSString stringWithFormat:@"%ld",(long)locationId]];
        if (home) {
            res[RESPONSE] = [home convertScenarioToDictionary];
        } else {
            res[RESULT] = @(NO);
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:kPlatformPluginCommandFinishNotification object:self userInfo:res];
    } else if ([command isEqualToString:GET_SCENARIO_ITEM_LOCAL]) {
        NSInteger locationId = [param[@"locationId"] integerValue];
        NSInteger scenario = [param[@"scenario"] integerValue];
        HomeModel *home = [[UserEntity instance] getHomebyId:[NSString stringWithFormat:@"%ld",(long)locationId]];
        if (home) {
            HWScenarioModel *scenarioModel = [home getScenarioById:scenario];
            if (scenarioModel) {
                NSDictionary *scenarioInfo = [scenarioModel convertToDictionary];
                NSArray *devices = [home getAllDeviceDicts];
                res[RESPONSE] = @{@"scenarioInfo":scenarioInfo,
                                  @"devices":devices
                                  };
            } else {
                res[RESULT] = @(NO);
            }
        } else {
            res[RESULT] = @(NO);
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:kPlatformPluginCommandFinishNotification object:self userInfo:res];
    } else if ([command isEqualToString:GET_SCENARIO_ROOM_LIST_LOCAL]) {
        NSInteger locationId = [param[@"locationId"] integerValue];
        NSInteger roomId = [param[@"groupId"] integerValue];
        HomeModel *home = [[UserEntity instance] getHomebyId:[NSString stringWithFormat:@"%ld",(long)locationId]];
        HWGroupModel *group = [home getGroupById:roomId];
        if (group) {
            res[RESPONSE] = [group convertScenarioToDictionary];
        } else {
            res[RESULT] = @(NO);
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:kPlatformPluginCommandFinishNotification object:self userInfo:res];
    } else if ([command isEqualToString:GET_SCENARIO_ROOM_ITEM_LOCAL]) {
        NSInteger locationId = [param[@"locationId"] integerValue];
        NSInteger roomId = [param[@"groupId"] integerValue];
        NSInteger scenario = [param[@"scenario"] integerValue];
        HomeModel *home = [[UserEntity instance] getHomebyId:[NSString stringWithFormat:@"%ld",(long)locationId]];
        HWGroupModel *group = [home getGroupById:roomId];
        if (home) {
            HWScenarioModel *scenarioModel = nil;
            NSArray *devices = @[];
            if (group) {
                scenarioModel = [group getScenarioById:scenario];
                devices = [group getAllDeviceDicts];
            } else {
                scenarioModel = [home getRoomScenarioById:scenario];
            }
            if (scenarioModel) {
                NSDictionary *scenarioInfo = [scenarioModel convertToDictionary];
                res[RESPONSE] = @{@"scenarioInfo":scenarioInfo,
                                  @"devices":devices
                                  };
            } else {
                res[RESULT] = @(NO);
            }
        } else {
            res[RESULT] = @(NO);
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:kPlatformPluginCommandFinishNotification object:self userInfo:res];
    } else if ([command isEqualToString:GET_SCHEDULE_LIST_LOCAL]) {
        NSInteger locationId = [param[@"locationId"] integerValue];
        HomeModel *home = [[UserEntity instance] getHomebyId:[NSString stringWithFormat:@"%ld",(long)locationId]];
        if (home) {
            res[RESPONSE] = [home convertScheduleToDictionary];
        } else {
            res[RESULT] = @(NO);
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:kPlatformPluginCommandFinishNotification object:self userInfo:res];
    } else if ([command isEqualToString:GET_SCHEDULE_ITEM_LOCAL]) {
        NSInteger locationId = [param[@"locationId"] integerValue];
        NSInteger scheduleId = [param[@"scheduleId"] integerValue];
        HomeModel *home = [[UserEntity instance] getHomebyId:[NSString stringWithFormat:@"%ld",(long)locationId]];
        if (home) {
            HWScheduleModel *scheduleModel = [home getScheduleById:scheduleId];
            if (scheduleModel) {
                NSDictionary *scheduleInfo = [scheduleModel convertToDictionary];
                NSArray *devices = [home getAllDeviceDicts];
                res[RESPONSE] = @{@"scheduleInfo":scheduleInfo,
                                  @"devices":devices
                                  };
            } else {
                res[RESULT] = @(NO);
            }
        } else {
            res[RESULT] = @(NO);
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:kPlatformPluginCommandFinishNotification object:self userInfo:res];
    } else if ([command isEqualToString:GET_TRIGGER_LIST_LOCAL]) {
        NSInteger locationId = [param[@"locationId"] integerValue];
        HomeModel *home = [[UserEntity instance] getHomebyId:[NSString stringWithFormat:@"%ld",(long)locationId]];
        if (home) {
            res[RESPONSE] = [home convertTriggerToDictionary];
        } else {
            res[RESULT] = @(NO);
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:kPlatformPluginCommandFinishNotification object:self userInfo:res];
    } else if ([command isEqualToString:GET_TRIGGER_ITEM_LOCAL]) {
        NSInteger locationId = [param[@"locationId"] integerValue];
        NSInteger triggerId = [param[@"triggerId"] integerValue];
        HomeModel *home = [[UserEntity instance] getHomebyId:[NSString stringWithFormat:@"%ld",(long)locationId]];
        if (home) {
            HWTriggerModel *triggerModel = [home getTriggerById:triggerId];
            if (triggerModel) {
                NSDictionary *triggerInfo = [triggerModel convertToDictionary];
                NSArray *devices = [home getAllDeviceDicts];
                res[RESPONSE] = @{@"triggerInfo":triggerInfo,
                                  @"devices":devices
                                  };
            } else {
                res[RESULT] = @(NO);
            }
        } else {
            res[RESULT] = @(NO);
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:kPlatformPluginCommandFinishNotification object:self userInfo:res];
    } else if ([command isEqualToString:GET_CONTROLLING_SCENARIO]) {
        NSInteger locationId = [param[@"locationId"] integerValue];
        HomeModel *home = [[UserEntity instance] getHomebyId:[NSString stringWithFormat:@"%ld",(long)locationId]];
        if (home) {
            NSInteger scenario = [home isControlling] ? [home currentScenario] : 0;
            res[RESPONSE] = @{@"scenario":@(scenario)};
            
        } else {
            res[RESPONSE] = @{@"scenario":@(0)};
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:kPlatformPluginCommandFinishNotification object:self userInfo:res];
    } else if ([command isEqualToString:HOME_GET_ITEM]) {
        NSInteger locationId = [param[@"locationId"] integerValue];
        HomeModel *home = [[UserEntity instance] getHomebyId:[NSString stringWithFormat:@"%ld",(long)locationId]];
        if (home) {
            NSDictionary *response = [home convertToDictionary];
            res[RESPONSE] = response;
        } else {
            res[RESULT] = @(NO);
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:kPlatformPluginCommandFinishNotification object:self userInfo:res];
    } else if ([command isEqualToString:HOME_GET_GATEWAY_DEVICE_ITEM]) {
        NSInteger locationId = [param[@"locationId"] integerValue];
        HomeModel *home = [[UserEntity instance] getHomebyId:[NSString stringWithFormat:@"%ld",(long)locationId]];
        DeviceModel *deviceModel = [home gatewayDeviceModel];
        NSDictionary *response = @{};
        if (deviceModel) {
            response = [deviceModel convertToHtml];
        }
        res[RESPONSE] = response;
        [[NSNotificationCenter defaultCenter] postNotificationName:kPlatformPluginCommandFinishNotification object:self userInfo:res];
    } else if ([command isEqualToString:LOCATION_SCENARIO_CONTROL]) {
        res[RESPONSE] = @{};
        [[NSNotificationCenter defaultCenter] postNotificationName:kPlatformPluginCommandFinishNotification object:self userInfo:res];
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_H5ControlScenario object:nil userInfo:param];
    } else if ([command isEqualToString:GET_GROUP_ITEM]) {
        NSInteger locationId = [param[@"locationId"] integerValue];
        NSInteger roomId = [param[@"groupId"] integerValue];
        HomeModel *home = [[UserEntity instance] getHomebyId:[NSString stringWithFormat:@"%ld",(long)locationId]];
        HWGroupModel *groupModel = [home getGroupById:roomId];
        NSDictionary *response = @{};
        if (groupModel) {
            response = [groupModel convertToHtml];
        }
        res[RESPONSE] = response;
        [[NSNotificationCenter defaultCenter] postNotificationName:kPlatformPluginCommandFinishNotification object:self userInfo:res];
    } else if ([command isEqualToString:GET_SUBDEVICE_LIST_LOCAL]) {
        NSInteger deviceId = [param[@"deviceId"] integerValue];
        DeviceModel *device = nil;
        for (HomeModel *home in [UserEntity instance].allEntites) {
            device = [home getDeviceById:[NSString stringWithFormat:@"%ld", (long)deviceId]];
            if (device) {
                break;
            }
        }
        if (device) {
            res[RESPONSE] = [device convertSubDevicesToHtml];
        } else {
            res[RESULT] = @(NO);
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kPlatformPluginCommandFinishNotification object:self userInfo:res];
    } else if ([command isEqualToString:GET_PAIREDSUBDEVICE_LIST_LOCAL]) {
        NSInteger deviceId = [param[@"deviceId"] integerValue];
        DeviceModel *device = nil;
        for (HomeModel *home in [UserEntity instance].allEntites) {
            device = [home getDeviceById:[NSString stringWithFormat:@"%ld", (long)deviceId]];
            if (device) {
                break;
            }
        }
        if (device) {
            res[RESPONSE] = [device convertPairedSubDeviceToHtml];
        } else {
            res[RESULT] = @(NO);
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kPlatformPluginCommandFinishNotification object:self userInfo:res];
    } else if ([command isEqualToString:CMD_COUNTLY_TRACK]) {
        NSString *key = param[@"key"];
        NSDictionary *segmentation = param[@"segmentation"];
        [CountlyTracker trackEvent:key segmentation:segmentation];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kPlatformPluginCommandFinishNotification object:self userInfo:res];
    } else if ([command isEqualToString:USER_GETINFO]) {
        UserEntity *user = [UserEntity instance];
        res[RESPONSE] = [user convertToDictionary];
        [[NSNotificationCenter defaultCenter] postNotificationName:kPlatformPluginCommandFinishNotification object:self userInfo:res];
    } else if ([command isEqualToString:SET_DISPLAY_ROOM]) {
        NSInteger locationId = [param[@"locationId"] integerValue];
        NSInteger roomId = [param[@"groupId"] integerValue];
        HomeModel *home = [[UserEntity instance] getHomebyId:[NSString stringWithFormat:@"%ld",(long)locationId]];
        NSString *sensorType = param[@"sensorType"];
        if ([sensorType isEqualToString:@"temp"]) {
            home.displayTempRoomId = roomId;
        } else if ([sensorType isEqualToString:@"pm2.5"]) {
            home.displayPm25RoomId = roomId;
        } else {
            home.displayHumRoomId = roomId;
        }
        [home updateDisplayGroupId];
        res[RESPONSE] = @{};
        [[NSNotificationCenter defaultCenter] postNotificationName:kPlatformPluginCommandFinishNotification object:self userInfo:res];
        
    }else if ([command isEqualToString:SCENARIO_ROOM_CONTROL_CHANGE]){
        NSString *messageId = param[kWebSocketMsgId];
        NSString *messageType = @"/v3/api/location/room/scenario";
        NSNumber *messageFlag = param[kWebSocketMsgFlag];
        NSObject *messageData = param[kWebSocketMsgData];
        NSNumber *messageTimeout = param[WEBSOCKET_TIMEOUT];
        NSNumber *messageKeep = param[WEBSOCKET_KEEP];
        messageId = [[WebSocketManager instance] sendWithType:messageType data:messageData flag:[messageFlag integerValue] messageId:messageId];
        if ([messageFlag integerValue] == WebSocketMessageFlagRequest) {
            if (messageId) {
                self.websocketMap[messageId] = @{
                                                 CALLBACK_ID:callbackId,
                                                 WEBSOCKET_TIMEOUT:messageTimeout?:@(0),
                                                 WEBSOCKET_KEEP:messageKeep?:@(0),
                                                 WEBSOCKET_STARTED:[NSDate date]
                                                 };
            } else {
                res[RESULT] = @(NO);
                res[RESPONSE] = @{};
                res[ERROR] = @{CODE:@(HWErrorInternalServerError),
                               MESSAGE:userInfo[@"erroMsg"]?:@""};
                [[NSNotificationCenter defaultCenter] postNotificationName:kPlatformPluginCommandFinishNotification object:self userInfo:res];
//                [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_ScenarioControl object:self userInfo:res];
                
                
            }
        } else {
            [[NSNotificationCenter defaultCenter] postNotificationName:kPlatformPluginCommandFinishNotification object:self userInfo:res];
        }
    } else {
        //Just ignore other command
    }
}

- (void)homeListDidUpdate:(NSNotification *)notification {
    NSMutableDictionary *res = [NSMutableDictionary dictionary];
    res[MESSAGE] = HOME_DID_UPDATE;
    res[VALUE] = @{};
    res[PARAM] = @{};
    [[NSNotificationCenter defaultCenter] postNotificationName:kPlatformPluginMessageBroadcastNotification object:self userInfo:res];
}

- (void)deviceRunstatusListDidUpdate:(NSNotification *)notification {
    NSMutableDictionary *res = [NSMutableDictionary dictionary];
    res[MESSAGE] = DEVICE_LIST_DID_UPDATE;
    res[VALUE] = @{};
    res[PARAM] = @{};
    [[NSNotificationCenter defaultCenter] postNotificationName:kPlatformPluginMessageBroadcastNotification object:self userInfo:res];
}

- (void)groupInfoUpdated:(NSNotification *)notification {
    NSMutableDictionary *res = [NSMutableDictionary dictionary];
    res[MESSAGE] = ROOM_DID_UPDATE;
    res[VALUE] = @{};
    res[PARAM] = @{};
    [[NSNotificationCenter defaultCenter] postNotificationName:kPlatformPluginMessageBroadcastNotification object:self userInfo:res];
}

- (void)deviceDidUpdate:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    NSMutableDictionary *res = [NSMutableDictionary dictionary];
    res[MESSAGE] = DEVICE_DID_UPDATE;
    res[VALUE] = @{@"deviceId":@([userInfo[@"deviceId"] integerValue]),@"locationId":@([userInfo[@"locationId"] integerValue])};
    res[PARAM] = @{};
    [[NSNotificationCenter defaultCenter] postNotificationName:kPlatformPluginMessageBroadcastNotification object:self userInfo:res];
}

//- (void)groupDidUpdate:(NSNotification *)notification {
//    NSDictionary *userInfo = notification.userInfo;
//    NSMutableDictionary *res = [NSMutableDictionary dictionary];
//    res[MESSAGE] = GROUP_ITEM_DID_UPDATE;
//    res[VALUE] = @{};
//    res[PARAM] = @{@"roomId":@([userInfo[@"groupId"] integerValue])};
//    [[NSNotificationCenter defaultCenter] postNotificationName:kPlatformPluginMessageBroadcastNotification object:self userInfo:res];
//}

- (void)homeScenarioDidUpdate:(NSNotification *)notification {
    NSMutableDictionary *res = [NSMutableDictionary dictionary];
    res[MESSAGE] = SCENARIO_LIST_UPDATE;
    res[VALUE] = @{};
    res[PARAM] = @{};
    [[NSNotificationCenter defaultCenter] postNotificationName:kPlatformPluginMessageBroadcastNotification object:self userInfo:res];
}

- (void)homeScheduleDidUpdate:(NSNotification *)notification {
    NSMutableDictionary *res = [NSMutableDictionary dictionary];
    res[MESSAGE] = SCHEDULE_LIST_UPDATE;
    res[VALUE] = @{};
    [[NSNotificationCenter defaultCenter] postNotificationName:kPlatformPluginMessageBroadcastNotification object:self userInfo:res];
}

- (void)homeTriggerDidUpdate:(NSNotification *)notification {
    NSMutableDictionary *res = [NSMutableDictionary dictionary];
    res[MESSAGE] = TRIGGER_LIST_UPDATE;
    res[VALUE] = @{};
    [[NSNotificationCenter defaultCenter] postNotificationName:kPlatformPluginMessageBroadcastNotification object:self userInfo:res];
}

- (void)locationRoomScenarioDidUpdate:(NSNotification *)notification {
    NSMutableDictionary *res = [NSMutableDictionary dictionary];
    res[MESSAGE] = SCENARIO_LOCATION_ROOM_LIST_UPDATE;
    res[VALUE] = @{};
    [[NSNotificationCenter defaultCenter] postNotificationName:kPlatformPluginMessageBroadcastNotification object:self userInfo:res];
}

- (void)homeScenarioControlResponse:(NSNotification *)notification {
    NSMutableDictionary *res = [NSMutableDictionary dictionary];
    res[MESSAGE] = SBC_SCENARIO_CONTROL;
    res[VALUE] = @{};
    [[NSNotificationCenter defaultCenter] postNotificationName:kPlatformPluginMessageBroadcastNotification object:self userInfo:res];
}

- (void)didReceiveWebsocketMessage:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    NSString *messageId = userInfo[kWebSocketMsgId];
    NSInteger errorCode = [userInfo[kWebSocketErrorCode] integerValue];
    if (messageId) {
        NSDictionary *requestDictionary = self.websocketMap[messageId];
        if (requestDictionary) {
            BOOL keep = [requestDictionary[WEBSOCKET_KEEP] boolValue];
            
            NSMutableDictionary *res = [NSMutableDictionary dictionary];
            BOOL result = errorCode == 0;
            res[RESULT] = @(result);
            if (!result) {
                res[ERROR] = @{CODE:@(errorCode),
                               MESSAGE:userInfo[@"erroMsg"]?:@"",
                               MESSAGEDATA:userInfo[@"msgData"]?:@{},
                               MESSAGEFLAG:userInfo[@"msgFlag"]?:@""
                               };
            }
            res[RESPONSE] = userInfo;
            res[CALLBACK_ID] = requestDictionary[CALLBACK_ID];
            res[KEEPCALLBACK] = @(keep);
            [[NSNotificationCenter defaultCenter] postNotificationName:kPlatformPluginCommandFinishNotification object:self userInfo:res];
            
            if (!keep) {
                [self.websocketMap removeObjectForKey:messageId];
            }
        }
    }
}

- (void)didReceiveRegisterDevice:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    NSDictionary *messageData = userInfo[kWebSocketMsgData];
    
    NSArray *subDevices = @[];
    if ([messageData isKindOfClass:[NSDictionary class]]) {
        subDevices = messageData[@"subDevices"];
    }
    if (subDevices && [subDevices isKindOfClass:[NSArray class]]) {
        for (NSDictionary *data in subDevices) {
            NSMutableDictionary *res = [NSMutableDictionary dictionary];
            res[MESSAGE] = SBC_REGISTERDEVICE;
            res[VALUE] = data;
            res[PARAM] = @{
                           @"localId":data[@"localId"],
                           @"parentId":data[@"parentId"]
                           };
            [[NSNotificationCenter defaultCenter] postNotificationName:kPlatformPluginMessageBroadcastNotification object:self userInfo:res];
        }
    }
}

- (void)didReceiveTempPasswordChange:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    if (![userInfo[kWebSocketMsgData] isKindOfClass:[NSDictionary class]]
        || [userInfo[kWebSocketMsgData] count] == 0) {
        return;
    }
    
    NSDictionary *messageData = userInfo[kWebSocketMsgData];
    NSMutableDictionary *res = [NSMutableDictionary dictionary];
    res[MESSAGE] = SBC_TEMPORARY_PASSWORD_LIST;
    res[VALUE] = messageData;
    res[PARAM] = @{
                   @"locationId":messageData[@"locationId"],
                   @"deviceId":messageData[@"deviceId"]
                   };
    [[NSNotificationCenter defaultCenter] postNotificationName:kPlatformPluginMessageBroadcastNotification object:self userInfo:res];
}

- (void)checkWebsocketGarbage {
    NSDate *now = [NSDate date];
    NSArray *keys = [self.websocketMap allKeys];
    for (NSInteger i = keys.count-1; i >= 0; i--) {
        NSString *key = keys[i];
        NSDictionary *requestDictionary = self.websocketMap[key];
        
        NSDate *date = requestDictionary[WEBSOCKET_STARTED];
        NSInteger timeout = [requestDictionary[WEBSOCKET_TIMEOUT] integerValue];
        
        //if this websocket need timeout
        if (timeout > 0 && [now timeIntervalSinceDate:date] > timeout) {
            NSMutableDictionary *res = [NSMutableDictionary dictionary];
            res[RESULT] = @(NO);
            res[RESPONSE] = @{};
            res[ERROR] = @{CODE:@(WEBSOCKET_ERROR_TIMEOUT),
                           MESSAGE:@"web socket request timeout"};
            res[CALLBACK_ID] = requestDictionary[CALLBACK_ID];
            [[NSNotificationCenter defaultCenter] postNotificationName:kPlatformPluginCommandFinishNotification object:self userInfo:res];
            
            [self.websocketMap removeObjectForKey:key];
        }
    }
}

@end
