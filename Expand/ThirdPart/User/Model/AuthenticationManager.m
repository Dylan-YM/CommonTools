//
//  AuthenticationManager.m
//  AirTouch
//
//  Created by Honeywell on 2017/5/15.
//  Copyright © 2017年 Honeywell. All rights reserved.
//

#import "AuthenticationManager.h"
#import "UserEntity.h"
#import "AppConfig.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import "AppMarco.h"

@interface AuthenticationManager ()

@property (nonatomic, assign) HWSecurityType securityType;

@end

@implementation AuthenticationManager


+ (AuthenticationManager *)instance {
    static AuthenticationManager * sharedInstance = nil;
    if (sharedInstance == nil) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            sharedInstance = [[AuthenticationManager alloc] init];
        });
    }
    return sharedInstance;
}

- (BOOL)checkAuthenticatingFingerPrint {
    return (self.authenticationStatus == AuthenticationStatusAuthenticating && self.securityType == HWSecurityTypeFingerPrint);
}

-(instancetype)init {
    self = [super init];
    if (self) {
        self.securityType = [UserConfig getSecurityType];
        if (_securityType == HWSecurityTypeAuto) {
            self.authenticationStatus = AuthenticationStatusAuthenticated;
        }
    }
    return self;
}

- (void)startAuthen {
    if (self.authenticationStatus == AuthenticationStatusInvalid) {
        self.authenticationStatus = AuthenticationStatusAuthenticating;
    }
}

- (void)setAuthenticationStatus:(AuthenticationStatus)authenticationStatus {
    if (authenticationStatus <= _authenticationStatus) {
        return;
    }
    _authenticationStatus = authenticationStatus;
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_AuthenticationStatusRefresh object:nil];
}

- (BOOL)checkDeviceSupportTouchId {
    AuthenticationType type = [self authenticationTypeWithError:nil];
    if (type == AuthenticationTypeTouchId) {
        return YES;
    } else if (type == AuthenticationTypeFaceId) {
        return NO;
    } else {
        if ([self checkDeviceSupportFaceId]) {
            return NO;
        }
        return [AppConfig deviceSupportFingerPrint];
    }
}

- (BOOL)checkDeviceSupportFaceId {
    return IS_IPHONE_X;
}

- (BOOL)checkDeviceTouchIdLocked {
    NSError *error = nil;
    [self authenticationTypeWithError:&error];
    if (IOS9ORLATER) {
        if (error.code == LAErrorTouchIDLockout) {
            return YES;
        }
    }
    return NO;
}

- (AuthenticationType)authenticationTypeWithError:(NSError **)error {
    LAContext *lacontext = [[LAContext alloc] init];
    if ([lacontext canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:error]) {
        if (@available(iOS 11.0, *)) {
            if (lacontext.biometryType == LABiometryTypeFaceID) {
                return AuthenticationTypeFaceId;
            } else if (lacontext.biometryType == LABiometryTypeTouchID) {
                return AuthenticationTypeTouchId;
            } else {
                return AuthenticationTypeNone;
            }
        } else {
            return AuthenticationTypeTouchId;
        }
    }
    return AuthenticationTypeNone;
}

@end
