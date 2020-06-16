//
//  AppMarco.h
//  AirTouch
//
//  Created by Devin on 1/26/15.
//  Copyright (c) 2015 Honeywell. All rights reserved.
//

#ifndef AirTouch_AppMarco_h
#define AirTouch_AppMarco_h

#import "CryptoUtil.h"

//#define Enterprise  1

#if defined(DEBUG) && DEBUG
#import "Debug.h"
#else
#import "Release.h"
#endif

#if defined(Enterprise) && Enterprise
#define OS_TYPE     @"ios_enterprise"
#else
#if defined(DEBUG) && DEBUG
#define OS_TYPE     @"ios"
#else
#define OS_TYPE     @"ios_subphone"
#endif
#endif

#ifndef __OPTIMIZE__
#define NSLog(...) NSLog(__VA_ARGS__)
#else
#define NSLog(...) {}
#endif

//compare float number
#define fequal(a,b) (fabs((a) - (b)) < FLT_EPSILON)
#define fequalzero(a) (fabs(a) < FLT_EPSILON)
#define flessthan(a,b) (fabs(a) < fabs(b)+FLT_EPSILON)

//devin add start
#define iOSSystemVersion [[[UIDevice currentDevice]systemVersion] floatValue]
#define IOS7ORLATER [[[UIDevice currentDevice]systemVersion] floatValue] >= 7.0
#define IOS8ORLATER [[[UIDevice currentDevice]systemVersion] floatValue] >= 8.0
#define IOS9ORLATER [[[UIDevice currentDevice]systemVersion] floatValue] >= 9.0
#define IOS10ORLATER [[[UIDevice currentDevice]systemVersion] floatValue] >= 10.0
#define IOS11ORLATER [[[UIDevice currentDevice]systemVersion] floatValue] >= 11.0

#define SCREENWIDTH     [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT     [UIScreen mainScreen].bounds.size.height
#define SCREENBOUNDS     [UIScreen mainScreen].bounds
#define FRAMESCALE     [UIScreen mainScreen].scale

#define SafeAreaInsetsBottom ({\
float bottom = 0;\
if(@available(iOS 11.0, *)){\
bottom = [UIApplication sharedApplication].delegate.window.safeAreaInsets.bottom;\
}\
(bottom);\
})\

#define IS_IPHONE_X           (SafeAreaInsetsBottom > 0)
#define STATUS_BAR_HEIGHT     (IS_IPHONE_X?44:20)

#define ScaleWidth  (SCREENHEIGHT>480?(MIN(SCREENWIDTH, 414))/320.0:1.0)
#define ScaleHeight (SCREENHEIGHT>480?(MIN(SCREENHEIGHT,812))/568.0:(MIN(SCREENHEIGHT,812))/568.0)
#define Scale MIN(ScaleWidth,ScaleHeight)

#define HeightScaleBase47Inch (MIN(SCREENHEIGHT,812))/1334
#define WidthScaleBase47Inch (MIN(SCREENWIDTH, 414))/750

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define UIColorFromRGBWithAlpha(rgbValue, a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:a]

#define UIColorWithRGB(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define UIColorWithRGBAlpha(r,g,b,α) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:α]

#define DefaultAllColor     [UIColor colorWithRed:157/255.0 green:157/255.0 blue:157/255.0 alpha:1.0]
#define DefaultSpecialColor  [UIColor colorWithRed:0/255.0 green:174/255.0 blue:239/255.0 alpha:1.0]
#define SelectButtonColor   [UIColor colorWithRed:194.0/255.0 green:194.0/255.0 blue:194.0/255.0 alpha:1.0]
#define BlueButtonColor     UIColorWithRGB(0, 151, 215)
#define GrayButtonColor     [UIColor grayColor]

#define GrayTextColor       UIColorFromRGB(0x999999)

//devin add end

#define IS4INCH ([UIScreen mainScreen].bounds.size.height>480)//5
#define ISLarge4INCH ([UIScreen mainScreen].bounds.size.height>568)//6/6+
#define ISSmall4INCH ([UIScreen mainScreen].bounds.size.height<568)//4/4s

#define BaseFontSizeWidth 375.0

#define ISLarge47Inch ([UIScreen mainScreen].bounds.size.width>375)//6+
#define kRoughFactor (ISLarge47Inch?1.5:1)
#define kFontSize (15*kRoughFactor)
//kenny

// Macro that allows you to clamp a value within the defined bounds
#define CLAMP(X, A, B) ((X < A) ? A : ((X > B) ? B : X))

//TEST MODE
#define TEST_MODE    ([[[NSProcessInfo processInfo] environment] objectForKey:@"TEST_MODE"] != nil)

#define kColor_light_blue         0x18abe1

#define APPSTOREAPPID @"978512367"//439763870
#define kUserDefault_NewVTime @"kUserDefault_NewVTime"

//devin add start
#define TRUEFLOW YES

#define refreshDeviceStateInterval 10.0

#define ServerURIList                @[@"s://qa.homecloud.honeywell.com.cn", @"://115.159.3.43:8083", @"://115.159.114.116:8081", @"s://stg.homecloud.honeywell.com.cn", @"s://homecloud.honeywell.com.cn"]

#define WebSocketURIList                @[@"s://qa.homecloud.honeywell.com.cn", @"://115.159.3.43:8080", @"://115.159.114.116:8082", @"s://stg.homecloud.honeywell.com.cn", @"s://homecloud.honeywell.com.cn"]

#define ServerLocaiton            @"ServerLocaiton"
#define WebSocketLocaiton         @"WebSocketLocaiton"
#define DebugAuthorizeStatus         @"DebugAuthorizeStatus"

typedef enum : NSUInteger {
    ServerTypeQADevOps,
    ServerTypeQAIP,
    ServerTypeDevIP,
    ServerTypeStage,
    ServerTypeProduction,
} ServerType;

#define BaseHTTPRequestURL(type)    [NSString stringWithFormat:@"http%@/",ServerURIList[type]]
#define BaseWebSocketURL(type)      [NSString stringWithFormat:@"ws%@",WebSocketURIList[type]]

#define BaseAPIResponseNotification @"BaseAPIResponseNotification"

// TCC key
#define APPLICATION_ID             @"1237b42b-0ce7-4582-830c-34d930b1fd52"

#define kUrl_UserDefinedDeviceName @"userDefinedDeviceName"
#define kUrl_LocationId   @"locationId"
#define kUrl_Mac                   @"mac"
#define kUrl_Crc                   @"crc"
#define kUserId                @"id"                              //create account
#define NameLength                  20

//thinkpage key
#define SECRET_KEY_WEATHER            @"BNNB44SG1G"

//notifition
#define kNotification_SensorBroken    @"kNotification_SensorBroken"
#define kNotification_Locating        @"locating"
#define kNotification_LocationSuccess @"locationSuccess"
#define kNotification_LocationFailed  @"locationFailed"
#define kNotification_LocationChange  @"locationChange"
#define kNotification_LoginStatusChanged           @"kNotification_LoginStatusChanged"
#define kNotification_LoginTokenChanged           @"kNotification_LoginTokenChanged"
#define kNotification_Logout           @"kNotification_Logout"
#define kNotification_DeleteDevice    @"DeleteDeviceNotification"
#define kNotification_UpdateCleanTime @"UpdateCleanTimeNotification"
#define kNotification_ATControl       @"kNotification_ATControl"
#define kNotification_GetISOCountryCode @"kNotification_GetISOCountryCode"
#define kNotification_GroupControl    @"kNotification_GroupControl"
#define kNotification_ScenarioControl    @"kNotification_ScenarioControl"
#define kNotification_GroupControl_Step1 @"kNotification_GroupControl_Step1"
#define kNotification_GroupNameChanged @"kNotification_GroupNameChanged"
#define kNotification_GetUnreadMessageSucceed @"kNotification_GetUnreadMessageSucceed"
#define kNotification_GetMessagesListSucceed @"kNotification_GetMessagesListSucceed"
#define kNotification_UpdateDevcieWiFi @"kNotification_UpdateDevcieWiFi"

#define kNotification_H5ControlScenario @"kNotification_H5ControlScenario"

#define kNotification_GetAlarmNofity @"kNotification_GetAlarmNofity"
#define kNotification_IgnoreAlarm @"kNotification_IgnoreAlarm"
#define kNotification_DeleteAlarm @"kNotification_DeleteAlarm"

#define kNotification_EventCountRefresh @"kNotification_EventCountRefresh"

#define kNotification_AuthenticationStatusRefresh @"kNotification_AuthenticationStatusRefresh"

#define kNotification_UpdateHomeScenarioList    @"UpdateHomeScenarioListNotification"
#define kNotification_UpdateRoomScenarioList    @"kNotification_UpdateRoomScenarioList"
#define kNotification_UpdateHomeScheduleList    @"UpdateHomeScheduleListNotification"
#define kNotification_UpdateHomeTriggerList     @"UpdateHomeTriggerListNotification"
#define kNotification_UpdateUnreadEventCount    @"kNotification_UpdateUnreadEventCount"
#define kNotification_UpdateEventReadStatus    @"kNotification_UpdateEventReadStatus"


#define kNotification_sbc_room_scenario    @"kNotification_sbc_room_scenario"
#define kNotification_sbc_room_list    @"kNotification_sbc_room_list"
#define kNotification_sbc_location_list    @"kNotification_sbc_location_list"
#define kNotification_sbc_device_list    @"kNotification_sbc_device_list"
#define kNotification_sbc_scenario_list    @"kNotification_sbc_scenario_list"
#define kNotification_sbc_schedule_list    @"kNotification_sbc_schedule_list"
#define kNotification_sbc_trigger_list    @"kNotification_sbc_trigger_list"

//video call
#define kVideoCallHasCallIn  @"kVideoCallHasCallIn"
#define kVideoCallConnected  @"kVideoCallConnected"
#define kVideoCallHasPickedUp  @"kVideoCallHasPickedUp"
#define kVideoCallDidOpenDoor  @"kVideoCallDidOpenDoor"
#define kVideoCallRecordPermissionDenied  @"kVideoCallRecordPermissionDenied"
#define kVideoCallHasEnded  @"kVideoCallHasEnded"
#define kVideoCallEndType  @"kVideoCallEndType"
#define kVideoCallPickerName  @"kVideoCallPickerName"
#define kCellularCheck  @"kCellularCheck"

#define KDayNight_FirstHour  6
#define KDayNight_FirstMin   0
#define KDayNight_SecondHour 18
#define KDayNight_SecondMin  0

#define RefreshSessionFailCode 1300

#define GetFloatWithScreen(value1,value2,value3,value4) (ISLarge47Inch?value4:(ISLarge4INCH?value3:(ISSmall4INCH?value1:value2)))

#define kNotification_UpdateDeviceSucceed @"kNotification_UpdateDeviceSucceed"
#define kNotification_UpdateDeviceFailed @"kNotification_UpdateDeviceFailed"

#define kNotification_UpdateGroupSucceed @"kNotification_UpdateGroupSucceed"

#define kNotification_UpdateGroupOrDeviceSucceed @"kNotification_UpdateGroupOrDeviceSucceed"
#define kNotification_UpdateDisplayGroupSucceed @"kNotification_UpdateDisplayGroupSucceed"

#define kNotification_FilterStatusUpdated @"kNotification_FilterStatusUpdated"

#define kNotification_VideoCallComming @"kNotification_VideoCallComming"

#define kNotification_UnsupportedDeviceTypeDetected @"kNotification_UnsupportedDeviceTypeDetected"

#define kNSUserDefaults_UserEntity @"kNSUserDefaults_UserEntity"
#define kFileManager_Locations  @"Locations"
#define kFileManager_Mad_Airs   @"Mad_Airs"

#define kNSUserDefaults_CurrentLocationId @"kNSUserDefaults_CurrentLocationId"
#define kNSUserDefaults_CurrentLocationName_EN @"kNSUserDefaults_CurrentLocationName_EN"
#define kNSUserDefaults_CurrentLocationName_ZH @"kNSUserDefaults_CurrentLocationName_ZH"

#define kNSUserDefaults_GroupControlMode @"kNSUserDefaults_GroupControlMode"

#define kNSUserDefaults_AppActiveStatus @"kNSUserDefaults_AppActiveStatus"

#define kNSUserDefaults_LogEnable @"kNSUserDefaults_LogEnable"

#define kFileManager_MessageList @"MessageList"

#define kFileManager_PM25Value @"PM25Value"

#define kNSUserDefaults_SecurityType @"kNSUserDefaults_SecurityType"
#define kNSUserDefaults_PatternPassword @"kNSUserDefaults_PatternPassword"

#define USERCONFIG_KEY_MOBILE           @"USERCONFIG_KEY_MOBILE"
#define USERCONFIG_KEY_PASSWORD         @"USERCONFIG_KEY_PASSWORD"
#define kNotification_HomeManagement @"kNotification_HomeManagement"
#define kNotification_HomeListRefresh @"kNotification_HomeListRefresh"
#define kNotification_AllDeviceRefresh @"kNotification_AllDeviceRefresh"
#define kNotification_DeviceListLoaded @"kNotification_DeviceListLoaded"
#define kNotification_AllDeviceRunStatusRefresh @"kNotification_AllDeviceRunStatusRefresh"
#define kNotification_FrequentlyUsedDeviceRefresh @"kNotification_FrequentlyUsedDeviceRefresh"
#define kNotification_NotMatchDevicesRefresh @"kNotification_NotMatchDevicesRefresh"

#define HoneywellBook               @"HoneywellSans-Book"
#define HoneywellBold               @"HoneywellSans-Bold"

#define kGroupControl_Flashing_Frequency 1.2

#define USE_TRIPLE_DES              @"USE_TRIPLE_DES"

#define kCloudVersionInfo           @"kCloudVersionInfo"

#define kSqliteVersion              @"kSqliteVersion"

#define kAPSkipPhoneName            @"kAPSkipPhoneName"

#define kSmartLinkInterval          @"kSmartLinkInterval"
#define kDefaultSmartLinkInterval   0.6

#define kGroupStatusDebug           @"kGroupStatusDebug"

#define kUpdateNeedUpdaeList         @"needToUpdateList"
#define kUpdateMinVersion            @"minVersion"
#define kUpdateForceUpdate           @"forceUpdate"
#define kUpdateVersion               @"version"
#define kUpdateDisplayversion        @"displayversion"
#define kUpdateReleasenotescn        @"releasenotescn"
#define kUpdateReleasenotesen        @"releasenotesen"
#define kUpdateLastTime              @"lastTime"

#define Hplus_Color_TOP_INFO_NORMAL UIColorFromRGB(0x8DC9F2)
#define Hplus_Color_TOP_INFO_ABNORMAL UIColorFromRGB(0xF59791)

#define Hplus_Color_Red UIColorFromRGB(0xeb342e)
#define Hplus_Color_Dark_Blue UIColorFromRGB(0x2f78cd)
#define Hplus_Color_Blue UIColorFromRGB(0x419bf9)
#define Hplus_Color_Blue1 UIColorFromRGB(0x2494e2)
#define Hplus_Color_Yellow1 UIColorFromRGB(0xFFC627)
#define Hplus_Color_Red1 UIColorFromRGB(0xEE3124)
#define Hplus_Color_Orange1 UIColorFromRGB(0xF37022)
#define Hplus_Color_Orange UIColorFromRGB(0xF17030)
#define Hplus_Color_Purple UIColorFromRGB(0x9a5cb4)
#define Hplus_Color_Green UIColorFromRGB(0x7FB338)
#define Hplus_Color_PageBackground UIColorFromRGB(0xf5f5f5)
#define Hplus_Color_Font_Black UIColorFromRGB(0x222222)
#define Hplus_Color_Font_White UIColorFromRGB(0xffffff)
#define Hplus_Color_Font_Light_White UIColorFromRGB(0xf2f2f2)
#define Hplus_Color_Font_Light_Black UIColorFromRGB(0x787898)
#define Hplus_Color_Font_Grey1 UIColorFromRGB(0x9DA2AE)
#define Hplus_Color_Border  UIColorFromRGB(0x666666)
#define Hplus_Color_Shadow UIColorFromRGB(0x000000)
#define Hplus_Color_Separater UIColorFromRGBWithAlpha(0x9b9b9b, 0.3)
#define Hplus_Color_Separater_204 UIColorFromRGB(0xcccccc)
#define Hplus_Color_Separater_Light UIColorFromRGB(0xdddddd)
#define Hplus_Color_Separater_Blue UIColorFromRGB(0xc9ced0)
#define Hplus_Color_Grey_170 UIColorFromRGB(0xaaaaaa)
#define Hplus_Color_Light_Grey UIColorFromRGB(0x707070)
#define Hplus_Color_Success UIColorFromRGB(0x48e68b)
#define HPlus_Popup_Background  [UIColor colorWithWhite:0 alpha:0.3]

#define Hplus_Color_Bottom_Button_Blue UIColorFromRGB(0x1892e5)
#define Hplus_Color_Bottom_Button_Gray UIColorFromRGB(0xe8e8e8)
#define Hplus_Color_Bottom_Button_Red UIColorFromRGB(0xee3125)

#define Hplus_Color_Black_Normal UIColorFromRGBWithAlpha(0x000000, 0.87)
#define Hplus_Color_Black_Normal_Bold UIColorFromRGBWithAlpha(0x222222, 0.87)
#define Hplus_Color_Black_Light UIColorFromRGBWithAlpha(0x000000, 0.56)

//列表页面使用（如消息列表、授权设备列表、家庭管理列表）
#define Hplus_TableViewCellTitleFont        [HWFont boldSystemFontOfSize:15]
#define Hplus_TableViewCellSubtitleFont     [HWFont systemFontOfSize:15]

//详情页面使用（如消息详情、授权详情、关于）
#define Hplus_DetailTitleFont               [HWFont boldSystemFontOfSize:15]
#define Hplus_DetailDescFont                [HWFont systemFontOfSize:15]

//详情页面使用（如消息详情、授权详情、关于）
#define Hplus_DetailTitleTopPadding 40*WidthScaleBase47Inch
#define Hplus_DetailInfoTopPadding 20*WidthScaleBase47Inch
#define Hplus_DetailLineTopPadding 40*WidthScaleBase47Inch
#define Hplus_DetailLineLeftPadding 50*WidthScaleBase47Inch

#define Hplus_BottomLoadingHeight 100*HeightScaleBase47Inch

#define HPro_TopPaddingWithoutNavigationBar 54*HeightScaleBase47Inch

#define kNavigationBarContentHeight     44
#define Hplus_DashboardNavigationItemPadding     HeightScaleBase47Inch*30.0

inline static double random_0_to_1();

inline static double random_0_to_1() {
    return [CryptoUtil randomInt]/(1.0f*UINT32_MAX);
}

inline static void runOnMainThread(void (^block)(void));
inline static void runOnBackground(void (^block)(void));

inline static void runOnMainThread(void (^block)(void))
{
    if ([NSThread isMainThread])
    {
        block();
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), block);
    }
}

inline static void runOnBackground(void (^block)(void))
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        @autoreleasepool {
            block();
        }
    });
}

#endif
