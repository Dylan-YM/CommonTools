//
//  CountlyTracker.h
//  Services
//
//  Created by Liu, Carl on 11/11/2016.
//  Copyright © 2016 Honeywell. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, RegisterEvent) {
    RegisterEventVisit,
    RegisterEventSuccess,
    RegisterEventFailed
};

typedef NS_ENUM(NSUInteger, LoginEvent) {
    LoginEventVisit,
    LoginEventSuccess,
    LoginEventFailed,
    LoginEventOTP,
    LoginEventLocked
};

typedef NS_ENUM(NSUInteger,OTPEvent) {
    OTPEventSend,
    OTPEventSendSuccess,
    OTPEventSendFailed,
    OTPEventVerifiedSuccess,
    OTPEventVerifiedFailed
};

typedef NS_ENUM(NSUInteger, OTPEventFailedReason) {
    OTPEventFailedReasonNone,
    OTPEventFailedReasonExpired,
    OTPEventFailedReasonWrong,
    OTPEventFailedReasonOther
};

typedef NS_ENUM(NSUInteger, EnrollEvent) {
    EnrollEventStart,
    EnrollEventCancel,
    EnrollEventEnd,
    EnrollEventSuccess,
    EnrollEventFailed
};

typedef NS_ENUM(NSUInteger, ScanEvent) {
    ScanEventVisit,
    ScanEventSuccess,
    ScanEventFailed,
    ScanEventNeedUpgrade,
    ScanEventNotSmart,
    ScanEventInvalid,
    ScanEventUnknown
};

typedef NS_ENUM(NSUInteger, EnrollMethodEvent) {
    EnrollMethodEventEasyLinkSuccess,
    EnrollMethodEventEasyLinkFailed,
    EnrollMethodEventApModeSuccess,
    EnrollMethodEventApModeFailed,
    EnrollMethodEventBroadcastSuccess,
    EnrollMethodEventBroadcastFailed,
    EnrollMethodEventTokenSuccess,
    EnrollMethodEventTokenFailed,
    EnrollMethodEventInvalid
};

typedef NS_ENUM(NSUInteger, EnrollMethodExtras) {
    EnrollMethodExtraWiFi1_0 = 1<<0,
    EnrollMethodExtraWiFi2_0 = 1<<1,
    EnrollMethodExtraBroadLink = 1<<2,
    EnrollMethodExtraEnrollByOther = 1<<3,
    EnrollMethodExtraTimeout = 1<<4,
    EnrollMethodExtraQRCodeExpired = 1<<5,
    EnrollMethodExtraUnknown = 1<<6
};

typedef NS_ENUM(NSUInteger, ScenarioEvent) {
    ScenarioEventControlCommand,
    ScenarioEventControlSuccess,
    ScenarioEventControlPartially,  //部分成功
    ScenarioEventControlFailed
};

@interface CountlyTracker : NSObject

+ (void)trackRegisterEvent:(RegisterEvent)registerEvent;

+ (void)trackLoginEvent:(LoginEvent)loginEvent;

+ (void)trackOTPEvent:(OTPEvent)otpEvent withReason:(OTPEventFailedReason)reason;

+ (void)trackSSIDEvent;

+ (void)trackEnrollEvent:(EnrollEvent)enrollEvent sku:(NSString * _Nullable)sku;

+ (void)trackScanEvent:(ScanEvent)scanEvent sku:(NSString * _Nullable)sku;

+ (void)trackManualSelectEvent:(NSString * _Nullable)sku;

+ (void)trackEnrollMethodEvent:(EnrollMethodEvent)scanEvent extras:(EnrollMethodExtras)extras;

+ (void)trackEvent:(NSString * _Nonnull)key segmentation:(NSDictionary * _Nonnull)segmentation;

+ (void)trackPageView:(NSString * _Nonnull)pageName;

+ (void)trackScenarionEvent:(ScenarioEvent)scenarioEvent;

@end
