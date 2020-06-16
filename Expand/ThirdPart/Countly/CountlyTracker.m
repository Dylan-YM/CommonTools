//
//  CountlyTracker.m
//  Services
//
//  Created by Liu, Carl on 11/11/2016.
//  Copyright © 2016 Honeywell. All rights reserved.
//

#import "CountlyTracker.h"
#import "Countly.h"
#import "AppConfig.h"
#import "AppMarco.h"
#import "NetworkUtil.h"

@implementation CountlyTracker

+ (void)trackLoginEvent:(LoginEvent)loginEvent {
    NSString *eventId = @"pro_login";
    NSDictionary *segmentation = nil;
    switch (loginEvent) {
        case LoginEventVisit:
            segmentation = @{@"visit": @"tick"};
            break;
        case LoginEventSuccess:
            segmentation = @{@"success": @"tick"};
            break;
        case LoginEventFailed:
            segmentation = @{@"failed": @"tick"};
            break;
        case LoginEventOTP:
            segmentation = @{@"otp": @"tick"};
            break;
        case LoginEventLocked:
            segmentation = @{@"locked": @"tick"};
            break;
        default:
            break;
    }
    [self trackEvent:eventId segmentation:segmentation];
}

+ (void)trackRegisterEvent:(RegisterEvent)registerEvent {
    NSString *eventId = @"pro_register";
    NSDictionary *segmentation = nil;
    switch (registerEvent) {
        case RegisterEventVisit:
            segmentation = @{@"visit": @"tick"};
            break;
        case RegisterEventSuccess:
            segmentation = @{@"success": @"tick"};
            break;
        case RegisterEventFailed:
            segmentation = @{@"failed": @"tick"};
            break;
        default:
            break;
    }
    [self trackEvent:eventId segmentation:segmentation];
}

+ (void)trackOTPEvent:(OTPEvent)otpEvent withReason:(OTPEventFailedReason)reason {
    NSString *eventId = @"pro_otp";
    NSDictionary *segmentation = nil;
    switch (otpEvent) {
        case OTPEventSend:
            segmentation = @{@"send": @"tick"};
            break;
        case OTPEventSendSuccess:
            segmentation = @{@"send_success": @"tick"};
            break;
        case OTPEventSendFailed:
            segmentation = @{@"send_failed": @"tick"};
            break;
        case OTPEventVerifiedSuccess:
            segmentation = @{@"verified_success": @"tick"};
            break;
        case OTPEventVerifiedFailed:{
            NSString *reasonString = @"tick";
            switch (reason) {
                case OTPEventFailedReasonExpired:
                    reasonString = @"expired";
                    break;
                case OTPEventFailedReasonWrong:
                    reasonString = @"wrong";
                    break;
                case OTPEventFailedReasonOther:
                    reasonString = @"other";
                    break;
                default:
                    break;
            }
            segmentation = @{@"verified_failed": reasonString?:@"tick"};
            break;
        }
        default:
            break;
    }
    [self trackEvent:eventId segmentation:segmentation];
}

+ (void)trackSSIDEvent {
    [self trackEvent:@"pro_ssid" segmentation:@{@"ssid": [NetworkUtil currentWifiSSID]?:@"__empty__"}];
}

+ (void)trackEnrollEvent:(EnrollEvent)enrollEvent sku:(NSString *)sku {
    NSString *eventId = @"pro_enroll";
    NSDictionary *segmentation = nil;
    switch (enrollEvent) {
        case EnrollEventStart:
            segmentation = @{@"start": @"tick"};
            break;
        case EnrollEventCancel:
            segmentation = @{@"cancel": sku?:@"__empty__"};
            break;
        case EnrollEventEnd:
            segmentation = @{@"end": @"tick"};
            break;
        case EnrollEventSuccess:
            segmentation = @{@"success": sku?:@"__empty__"};
            break;
        case EnrollEventFailed:{
            segmentation = @{@"failed": sku?:@"__empty__"};
            break;
        }
        default:
            break;
    }
    [self trackEvent:eventId segmentation:segmentation];
}

+ (void)trackScanEvent:(ScanEvent)scanEvent sku:(NSString *)sku {
    NSString *eventId = @"pro_scan";
    NSDictionary *segmentation = nil;
    switch (scanEvent) {
        case ScanEventVisit:
            segmentation = @{@"visit": @"tick"};
            break;
        case ScanEventSuccess:
            segmentation = @{@"success": sku?:@"__empty__"};
            break;
        case ScanEventFailed:
            segmentation = @{@"failed": sku?:@"__empty__"};
            break;
        case ScanEventNeedUpgrade:
            segmentation = @{@"need_upgrade": sku?:@"__empty__"};
            break;
        case ScanEventNotSmart:
            segmentation = @{@"not_smart": sku?:@"__empty__"};
            break;
        case ScanEventInvalid:
            segmentation = @{@"invalid": @"tick"};
            break;
        case ScanEventUnknown:{
            segmentation = @{@"unknown": @"tick"};
            break;
        }
        default:
            break;
    }
    [self trackEvent:eventId segmentation:segmentation];
}

+ (void)trackManualSelectEvent:(NSString *)sku {
    [self trackEvent:@"pro_manual_select" segmentation:@{@"visit": sku?:@"__empty__"}];
}

+ (void)trackEnrollMethodEvent:(EnrollMethodEvent)enrollMethodEvent extras:(EnrollMethodExtras)extras {
    NSString *eventId = nil;
    
    NSMutableDictionary *segmentation = [NSMutableDictionary dictionary];
    NSString *reasonString = @"tick";
    if (extras & EnrollMethodExtraWiFi1_0) {
        segmentation[@"wifi1.0"] = reasonString;
    }
    if (extras & EnrollMethodExtraWiFi2_0) {
        segmentation[@"wifi2.0"] = reasonString;
    }
    if (extras & EnrollMethodExtraBroadLink) {
        segmentation[@"broadlink"] = reasonString;
    }
    if (extras & EnrollMethodExtraEnrollByOther) {
        segmentation[@"enroll_by_other"] = reasonString;
    }
    if (extras & EnrollMethodExtraTimeout) {
        segmentation[@"timeout"] = reasonString;
    }
    if (extras & EnrollMethodExtraQRCodeExpired) {
        segmentation[@"expired"] = reasonString;
    }
    if (extras & EnrollMethodExtraUnknown) {
        segmentation[@"unknown"] = reasonString;
    }
    
    switch (enrollMethodEvent) {
        case EnrollMethodEventEasyLinkSuccess:
            eventId = @"pro_easylink_success";
            break;
        case EnrollMethodEventEasyLinkFailed:
            eventId = @"pro_easylink_failed";
            break;
        case EnrollMethodEventApModeSuccess:
            eventId = @"pro_ap_success";
            break;
        case EnrollMethodEventApModeFailed:
            eventId = @"pro_ap_failed";
            break;
        case EnrollMethodEventBroadcastSuccess:
            eventId = @"pro_broadcast_success";
            break;
        case EnrollMethodEventBroadcastFailed:
            eventId = @"pro_broadcast_failed";
            break;
        case EnrollMethodEventTokenSuccess:
            eventId = @"pro_token_success";
            break;
        case EnrollMethodEventTokenFailed:
            eventId = @"pro_token_failed";
            break;
        default:
            break;
    }
    if (eventId.length == 0) {
        return;
    }
    [self trackEvent:eventId segmentation:segmentation];
}

+ (void)trackScenarionEvent:(ScenarioEvent)scenarioEvent {
    NSMutableDictionary *segmentation = [NSMutableDictionary dictionary];
    NSString *reasonString = @"tick";
    NSString *eventId = @"pro_scene";
    switch (scenarioEvent) {
        case ScenarioEventControlCommand:
        {
            segmentation[@"automation_scene_control"] = reasonString;
        }
            break;
        case ScenarioEventControlSuccess:
        {
            segmentation[@"automation_scene_control_success"] = reasonString;
        }
            break;
        case ScenarioEventControlPartially:
        {
            segmentation[@"automation_scene_control_partially"] = reasonString;
        }
            break;
        case ScenarioEventControlFailed:
        {
            segmentation[@"automation_scene_control_fail"] = reasonString;
        }
            break;
        default:
            eventId = nil;
            break;
    }
    if (!eventId) {
        return;
    }
    [self trackEvent:eventId segmentation:segmentation];
}

+ (void)trackEvent:(NSString *)key segmentation:(NSDictionary *)segmentation {
    NSMutableDictionary *mSegmentation = [NSMutableDictionary dictionaryWithDictionary:segmentation];
    mSegmentation[@"platform"] = @"ios";
    [Countly.sharedInstance recordEvent:key segmentation:mSegmentation];
}

+ (void)trackPageView:(NSString *)pageName {
    [Countly.sharedInstance reportView:pageName];
}

@end
