//
//  AppConfig.h
//  AirTouch
//
//  Created by Devin on 1/16/15.
//  Copyright (c) 2015 Honeywell. All rights reserved.
//
#import "BaseConfig.h"
#import <UIKit/UIKit.h>
#import "HWEnrollModeAPIManager.h"

typedef NS_ENUM(NSInteger, ModelType) {
    iPhone4,
    iPhone5,
    iPhone6,
    iPhone6Plus,
};

typedef enum : NSUInteger {
    HWDeviceCategoryNone,
    HWDeviceCategoryAir,
    HWDeviceCategoryWater,
    HWDeviceCategoryHomePanel,
    HWDeviceCategoryLift,
    HWDeviceCategoryCubeC,
    HWDeviceCategoryShark,
    HWDeviceCategoryCubeCSubDevice,
    HWDeviceCategorySWD,
    HWDeviceCategoryWallVentilator,
} HWDeviceCategory;

typedef enum : NSUInteger {
    HWDeviceCategoryTypeNone,
    HWDeviceCategoryTypeGateway,
    HWDeviceCategoryTypeIpvdp,
    HWDeviceCategoryTypeHomepanel,
    HWDeviceCategoryStandAlone,
} HWDeviceCategoryType;

typedef enum : NSUInteger {
    HWDeviceOnlineTypeNormal,
    HWDeviceOnlineTypeAsParent,
    HWDeviceOnlineTypeSwitch,
} HWDeviceOnlineType;

static NSString * HWDeviceTypeInvalid             =   @"0";
static NSString * HWDeviceTypeAirTouchS           =   @"1048577";
static NSString * HWDeviceTypeAirTouchSJD         =   @"1048578";
static NSString * HWDeviceTypeAirTouchP           =   @"1048579";
static NSString * HWDeviceTypeAirTouchFFAC        =   @"1048580";
static NSString * HWDeviceTypeAirTouchX2          =   @"1048581";
static NSString * HWDeviceTypeAirTouchX3          =   @"1048582";
static NSString * HWDeviceTypeAirTouchX3U         =   @"1048584";
static NSString * HWDeviceTypeAirTouchSU          =   @"1048585";
static NSString * HWDeviceTypeAirTouchPU          =   @"1048586";
static NSString * HWDeviceTypeAirTouchX           =   @"1048592";
static NSString * HWDeviceTypeWaterSmartRO600S    =   @"1048608";
static NSString * HWDeviceTypeWaterSmartRO400S    =   @"1114114";
static NSString * HWDeviceTypeWaterSmartRO100S    =   @"1114115";
static NSString * HWDeviceTypeWaterSmartRO75S     =   @"1114116";
static NSString * HWDeviceTypeWaterSmartRO50S     =   @"1114117";

static NSString * HWDeviceTypeHomePanelTuna1      =   @"2162689";
static NSString * HWDeviceTypeHomePanelTuna2      =   @"2162690";
static NSString * HWDeviceTypeHomePanelTuna3      =   @"2162693";//IS 4500 VE
static NSString * HWDeviceTypeHomePanelTuna4      =   @"2162694";//Cachalot
static NSString * HWDeviceTypeHomePanelTuna5      =   @"2162695";//IS 7500 S

static NSString * HWDeviceTypeHomePanelShark2     =   @"2162696";//IS 7500 KA PRO

static NSString * HWDeviceTypeHomePanelElevator   =   @"elevator";

static NSString * HWDeviceTypeCubeC               =   @"3000001";//cube c
static NSString * HWDeviceTypeShark               =   @"3000002";//shark

static NSString * HWDeviceTypeLight               =   @"3001001";//light
static NSString * HWDeviceTypeCurtain             =   @"3001002";//curtain
static NSString * HWDeviceTypeAirCondition        =   @"3001003";//air condition
static NSString * HWDeviceTypeAirCondition_002    =   @"3001027";//airCondition_002(Hitachi)
static NSString * HWDeviceTypeAirCondition_003    =   @"3001028";//TF228WNMU(O1)
static NSString * HWDeviceTypeAirCondition_004    =   @"3001029";//KNX-FCU

static NSString * HWDeviceTypeVentilation         =   @"3001004";//ventilator
static NSString * HWDeviceTypeRelay               =   @"3001005";//relay
static NSString * HWDeviceTypeBackgroundMusic     =   @"3001006";//background music
static NSString * HWDeviceTypeUnderFloorHeating   =   @"3001007";//under floor heating
static NSString * HWDeviceTypeDimmer              =   @"3001008";//dimmer
static NSString * HWDeviceTypeSmartIAQ            =   @"3001009";//Smart IAQ
static NSString * HWDeviceTypeZone                =   @"3001010";//Zone
static NSString * HWDeviceTypeLobby               =   @"3001011";//lobby_001
static NSString * HWDeviceTypeGuard               =   @"3001012";//guard_001
static NSString * HWDeviceTypeOffice              =   @"3001013";//office_001
static NSString * HWDeviceTypeIpdc                =   @"3001014";//ipdc_001
static NSString * HWDeviceTypeVentilation2        =   @"3001015";//ventilation_002
static NSString * HWDeviceTypeLock                =   @"3001016";//lock_001
static NSString * HWDeviceTypeElevator001         =   @"3001018";//elevator_001
static NSString * HWDeviceType24hZone             =   @"3001019";//24h_zone
static NSString * HWDeviceTypeELock               =   @"3001020";//lock_002
static NSString * HWDeviceTypeDolphin             =   @"3001021";//sensor_002
static NSString * HWDeviceTypeChinaSWD6Key        =   @"3001022";//swd_001
static NSString * HWDeviceTypeChinaSWD8Key        =   @"3001023";//swd_002
static NSString * HWDeviceTypeChinaSensorSWD6Key  =   @"3001024";//swd_003
static NSString * HWDeviceTypeChinaSWD4Key        =   @"3001025";//swd_004
static NSString * HWDeviceTypeHaiLin              =   @"3001026";//sensor_001
static NSString * HWDeviceTypeSensor_005          =   @"3001123";//sensor_005
static NSString * HWDeviceTypeLock_003         		=   @"3001119";//lock_003

static NSString * HWDeviceTypeWallVentilator      =   @"3200001";//Wall Ventilator

//static NSString * HWDeviceTypeSWD                 =   @"7777777";
static NSString * HWDeviceTypeSWD                 =   @"4000001";
static NSString * HWDeviceTypeSWDSwitch           =   @"4000002";
static NSString * HWDeviceTypeSWDSwitch2M         =   @"4000003";
static NSString * HWDeviceTypeSWDSwitch3M         =   @"4000004";
static NSString * HWDeviceTypeSWDDimmer           =   @"4000005";
static NSString * HWDeviceTypeSWDCurtain          =   @"4000006";
static NSString * HWDeviceTypeSWDFan              =   @"4000007";
static NSString * HWDeviceTypeSWDBlind            =   @"4000008";

static NSString * HWDeviceTypeGLD                 =   @"4000009";
static NSString * HWDeviceTypeSWDSwitch4M         =   @"4000010";

static NSString * HWDeviceTypeIR                  =   @"5000001";
static NSString * HWDeviceTypeIRAC                =   @"5000002";
//china SWD
static NSString * HWDeviceTypeChinaSWD            =   @"6000001";
static NSString * HWDeviceTypeChinaSWDSwitch      =   @"6000002";
static NSString * HWDeviceTypeChinaSWDSwitch2M    =   @"6000003";
static NSString * HWDeviceTypeChinaSWDSwitch3M    =   @"6000004";
static NSString * HWDeviceTypeChinaSWDSwitch4M    =   @"6000005";
static NSString * HWDeviceTypeChinaSWDSwitchSP1   =   @"6000006";
static NSString * HWDeviceTypeChinaSWDSwitchSP2   =   @"6000007";
static NSString * HWDeviceTypeChinaSWDSwitchSP3   =   @"6000008";
static NSString * HWDeviceTypeChinaSWDSwitchDT4   =   @"6000009";
static NSString * HWDeviceTypeChinaSWDSwitchDT8   =   @"6000010";
static NSString * HWDeviceTypeChinaSWDCurtain     =   @"6000011";

static NSString * RELAY_TYPE_LIGHT = @"R1005001";
static NSString * RELAY_TYPE_TV = @"R1005002";
static NSString * RELAY_TYPE_REFRIGERATOR = @"R1005003";
static NSString * RELAY_TYPE_SPEAKER = @"R1005004";
static NSString * RELAY_TYPE_FAN = @"R1005005";
static NSString * RELAY_TYPE_MICROWAVE_OVEN = @"R1005006";
static NSString * RELAY_TYPE_RICE_COOKER = @"R1005007";
static NSString * RELAY_TYPE_ELECTRIC_KETTLE = @"R1005008";
static NSString * RELAY_TYPE_WATER_HEATER = @"R1005009";
static NSString * RELAY_TYPE_OTHERS = @"R1005010";

UIKIT_EXTERN NSString * const kAppConfigNightModeChangeNotification;

@interface AppConfig : BaseConfig
+ (void)setPopNewVTime:(NSString *)time;
+ (NSString *)getPopNewVTime;

+ (NSString*)getLanguage;

+ (NSString*)getWeatherLanguage;

+ (NSInteger)httpRequestTimeout;

+ (ModelType)getModel;

+ (BOOL)isEnglish;

+ (void)switchNightMode;

+ (void)refreshNightMode;

+ (BOOL)isNightMode;

+ (NSString *) platformString;

+ (NSString *)like_uuid;

+ (NSArray *)deviceTypesArray;

+ (Class)classForDeviceType:(NSString *)deviceType;

+ (void)getProductModelWithSku:(NSString *)sku callback:(HWAPICallBack)callback;

+ (BOOL)isSupportedDeviceType:(NSString *)deviceType;

+ (BOOL)isTunaDevice:(NSString *)deviceType;

+ (BOOL)isSwdDeviceSku:(NSString *)sku;

+ (BOOL)isZoneDeviceType:(NSString *)deviceType;

+ (BOOL)deviceSupportFingerPrint;

+ (NSString *)getSmallDeviceIconDeviceType:(NSString *)deviceType sku:(NSString *)sku;

//不唯一 随机的
+ (NSString *)uuidString;

@end
