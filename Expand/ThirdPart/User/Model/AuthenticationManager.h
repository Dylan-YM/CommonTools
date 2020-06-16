//
//  AuthenticationManager.h
//  AirTouch
//
//  Created by Honeywell on 2017/5/15.
//  Copyright © 2017年 Honeywell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserConfig.h"

typedef enum : NSUInteger {
    AuthenticationStatusInvalid,
    AuthenticationStatusAuthenticating,
    AuthenticationStatusFailed,
    AuthenticationStatusAuthenticated,
} AuthenticationStatus;

typedef enum : NSUInteger {
    AuthenticationTypeNone,
    AuthenticationTypeFaceId,
    AuthenticationTypeTouchId,
} AuthenticationType;

@interface AuthenticationManager : NSObject

@property (nonatomic, readonly) HWSecurityType securityType;
@property (nonatomic, assign) AuthenticationStatus authenticationStatus;

+ (AuthenticationManager *)instance;

- (void)startAuthen;

//设备是否支持使用指纹功能
- (BOOL)checkDeviceSupportTouchId;

- (BOOL)checkDeviceSupportFaceId;

- (BOOL)checkDeviceTouchIdLocked;

//正在进行指纹验证
- (BOOL)checkAuthenticatingFingerPrint;

- (AuthenticationType)authenticationTypeWithError:(NSError **)error;

@end
