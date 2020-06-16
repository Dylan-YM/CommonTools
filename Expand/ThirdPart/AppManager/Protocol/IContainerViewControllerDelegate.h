//
//  IContainerViewControllerDelegate.h
//  AirTouch
//
//  Created by Eric Qin on 1/21/15.
//  Copyright (c) 2015 Honeywell. All rights reserved.
//

#import <MessageUI/MFMailComposeViewController.h>
#import "HomeModel.h"
#import "DeviceModel.h"

#ifndef AirTouch_IContainerViewControllerDelegate_h
#define AirTouch_IContainerViewControllerDelegate_h

typedef NS_ENUM(NSInteger, EnrollFlowIndex) {
    Enroll450SFlowIndex_QRCode,
    EnrollFlowIndex_TunaQRCode,
    EnrollFlowIndex_GuideQRCode,
    EnrollFlowIndex_SelectType,
    EnrollFlowIndex_HandleHome,
    EnrollFlowIndex_CreateHome,
    EnrollFlowIndex_NameDevice,
    EnrollFlowIndex_APConnectTimeOut,
    EnrollFlowIndex_NotConnectInternet,
    EnrollFlowIndex_SelectDevice,
    EnrollFlowIndex_APWelcome,
    EnrollFlowIndex_ConnectAP,
    EnrollFlowIndex_SelectLocation,
    EnrollFlowIndex_SelectWifi,
    EnrollFlowIndex_InputPassword,
    EnrollFlowIndex_RegisterDevice,
    Enroll450SFlowIndex_InputPassword,
    Enroll450SFlowIndex_ConnectionTimeout,
    EnrollFlowIndex_BLEWelcome,
    EnrollFlowIndex_BLESelectBLE,
    EnrollFlowIndex_BLETimeOut,
    EnrollFlowIndex_CubeCSearch,
    EnrollFlowIndex_Welcome,
};

typedef enum : NSUInteger {
    HWPageAllDevices,
    HWPageLocation,
    HWPageDeviceControl,
    HWPageMessageCenter,
    HWPageMessageDetail,
    HWPageLogin,
    HWPageDeviceTrialList,
    HWPageShowAlarm,
    HWPageAutomation,
    HWPageMe,
    HWPageDashboard,
    HWPageEventList,
    HWPageShowEvent
} HWPageType;

typedef enum : NSUInteger {
    HWHelpDeviceIntroduce,
    HWHelpDeviceUserManual,
    HWHelpEULA,
} HWHelpType;

typedef enum : NSUInteger {
    HWTabBadgeTypeNone,
    HWTabBadgeTypeNew,
    HWTabBadgeTypeError,
} HWTabBadgeType;

typedef enum : NSUInteger {
    HWTabBarItemTagDashboard = 0,
    HWTabBarItemTagAllDevice,
    HWTabbarItemTagAutomation,
//    HWTabBarItemTagMessages,
    HWTabBarItemTagMe,
} HWTabBarItemTag;

typedef enum : NSUInteger {
    HWMessageViewTypeEvent,
    HWMessageViewTypeMessage,
} HWMessageViewType;

@protocol IContainerViewControllerDelegate <NSObject, MFMailComposeViewControllerDelegate>

#pragma mark - TabBar
- (void)tabBarHidden:(BOOL)hidden;

#pragma mark - Badge
- (void)badgeType:(HWTabBadgeType)type onIndex:(HWTabBarItemTag)index;

#pragma mark - Jumping Page
- (void)jumpToPageURI;

#pragma mark - Navigation UIViewControllers
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated;
- (void)popViewControllerAnimated:(BOOL)animated;
- (void)popToViewController:(UIViewController *)popToViewController animated:(BOOL)animated;
- (void)popToSettingViewControllerAnimated:(BOOL)animated;
- (BOOL)isOnTop:(UIViewController *)vc;
- (void)showViewController:(HWPageType)type object:(id)object animation:(BOOL)animation;

#pragma mark - Login And Register
- (void)showUserRegisterVCAnimated:(BOOL)animated;
- (void)onLoginSuccess;
- (void)onLoginSuccessToShowSecurityAlert;
- (void)showSecurityAlert;

#pragma mark - Home Present
- (void)presentViewController:(UIViewController *)presentViewController animated:(BOOL)flag completion:(void (^)(void))completion;
- (void)dismissViewControllerAnimated:(BOOL)animation completion:(void (^)(void))completion;

#pragma mark - Home
- (void)showHomeWithLocationID:(NSString *)locationID;

- (void)changeAllDeviceLocationID:(NSString *)locationID;

#pragma mark - Enrollment
- (void)startEnroll;
- (void)startUpdateWifiWithParam:(NSDictionary *)param;

#pragma mark - VideoCall
- (void)showVideoCall:(NSNotification *)notification;

#pragma mark - go to app store to update
- (void)gotoNewV;

#pragma mark - Go Setting
- (void)goToAppSetting;
- (void)goToWiFiSetting;
- (void)gotoPhotosSetting;
- (void)goToSettingRestrictions;
- (void)goToBlueToothSetting;

#pragma mark - Debug
- (void)toggleDebugButton;
- (void)showDebugViewController;

#pragma mark - customer care
- (void)toCustomerCare;

#pragma mark - message
- (BOOL)showEventListWithType:(HWMessageViewType)type animation:(BOOL)animation;

- (void)messageBadgeType:(HWTabBadgeType)type;

#pragma mark - alarm
- (void)showAlarmWithAlarmModel:(id)model;

#pragma mark - device
- (void)showDeviceControl:(DeviceModel *)deviceModel animation:(BOOL)animation;

#pragma mark - group
- (void)showAddGroupWithLocationId:(NSInteger)locationId animation:(BOOL)animation;

- (void)showGroup:(HWGroupModel *)group animation:(BOOL)animation;

- (void)goToContects; // GLD

@end

#endif
