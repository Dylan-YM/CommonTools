//
//  BaseAPIRequest.h
//  AirTouch
//
//  Created by Honeywell on 9/14/16.
//  Copyright © 2016 Honeywell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HWRequestManager.h"
#import "WebApi.h"
#import "AFURLRequestSerialization.h"

typedef enum : NSInteger {
    HWNoError = 0,
    HWErrorInternalServerError = -1,
    HWErrorJsonError = -2,
    HWErrorScenarioControlTimeOut = -3,
    HWErrorScenarioControlNoPermission = -4,
    HWErrorNetworkError = -5,
    //Device
    HWErrorDeviceBindQRCodeTimeout = 1002,
    HWErrorDeviceHomeHaveAnotherGatewayDevice = 1003,
    HWErrorDeviceDeviceAlreadyBindedByOther = 1004,
    HWErrorDeviceDeviceAlreadyBindedByYourself = 1005,
    HWErrorDeviceHomeUserInfoLose = 1006,
    HWErrorDeviceBindBeforeEnroll = 1007,
    HWErrorDeviceBindDeviceCommunicationLost = 1010,
    
    HWErrorDeviceIdInvalid = 6001,
    
    HWErrorUserAlreadyExist = 7001,
    HWErrorDBError = 7002,
    HWErrorUserNotExist = 7003,
    HWErrorLoginWrongUserNameOrPassword = 7004,
    HWErrorForbiddenLoginFirst = 7005,
    HWErrorUserOldPasswordWrong = 7006,
    HWErrorSentVcodeFirst = 7007,
    HWErrorVcodeIsTimeout = 7008,
    HWErrorVcodeIsWrong = 7009,
    HWErrorLoginEncryptSaltError = 7011,
    HWErrorUserBeenKicked = 7012,
    HWErrorWebSocketUserBeenKicked = 7013,
    HWErrorWebSocketNoValidVideoCall = 7014,
    HWErrorWebSocketUserLoginOnOtherDevice = 7017,
    HWErrorWebSocketLoginPasswordFailed = 7018,//url 登录信息 错误
    HWErrorLoginNeedVcode = 7021,
    HWErrorLoginUserAccountLocked = 7022,
    HWErrorMigrationFailed = 7024,//Account upgrade error
    HWErrorLoginTokenExpired = 7026,//Login Token expired
    HWErrorLoginTokenError = 7027,//Login Token error
    
    HWErrorHomeDeleteHasDevice = 7101,
    HWErrorHomeNotExist = 7103,
    
    HWErrorAuthorizeAlreadyGranted = 7502,
    
    HWErrorMessageIsNotExist = 8002,
    
    HWErrorWebSocketUserNotAuthorizedOpenDoor = 9001,
    HWErrorWebSocketVideoCallSessionExpired = 9002,
    HWErrorWebSocketSecurePasswordInvalid = 9004,
    HWErrorWebSocketOpenDoorFailed = 9005,
    HWErrorWebSocketHomeScenarioControlFailed = 9006,
    HWErrorWebSocketHomeScenarioDeviceUnsupport = 9007,
    HWErrorCitySearchNotExist = 9008,
    HWErrorScenarioSyncing = 9014,
    HWErrorScenarioPartlySynced = 9015,
    HWErrorScenarioPartlySuccess = 9016, //强制执行结果
} HWAPIErrorType;

extern NSInteger const API_SUCCESS;
extern NSString * const kWebServiceDidReceiveResponseNotification;

@interface BaseAPIRequest : NSObject

@property (nonatomic, strong) NSString *apiName;

@property (nonatomic, strong) NSString *baseUrl;

@property (nonatomic, assign) RequestType requestType;

@property (nonatomic, assign) HWRequestSerializer requestSerializer;

- (void)callAPIWithParam:(id)param completion:(HWAPICallBack)completion;

- (NSError *)handleError:(NSInteger)errorCode responseObject:(id)responseObject NS_REQUIRES_SUPER;

- (void)cancel NS_REQUIRES_SUPER;

- (void)setTestResponseObject:(id)testResponseObject statusCode:(NSInteger)statusCode;

@end
