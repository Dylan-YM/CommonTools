//
//  HomeModel.h
//  AirTouch
//
//  Created by Devin on 1/27/15.
//  Copyright (c) 2015 Honeywell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseAPIRequest.h"
#import "HWGroupCreateAPIManager.h"
#import "HWGroupEditDeviceAPIManager.h"
#import "HWGroupRemoveAPIManager.h"
#import "HWGroupModel.h"

#import "HWScenarioModel.h"
#import "HWScheduleModel.h"
#import "HWHistoryEventCountAPIManager.h"
#import "HWTriggerModel.h"
#import "HWScenarioControllable.h"

typedef enum : NSUInteger {
    HomeScenarioTypeInvalid = 0,
    HomeScenarioTypeHome = 1,
    HomeScenarioTypeSecurity,
    HomeScenarioTypeEnvironment,
    HomeScenarioTypeEnergy
} HomeScenarioType;

typedef enum : NSUInteger {
    HomeCategoryTypeSecurity = 1,
    HomeCategoryTypeEnvironmentAndHealth,
} HomeCategoryType;

typedef enum : NSUInteger {
    HomeCategoryAll,
//    HomeCategoryOnlySecurity,
//    HomeCategoryOnlyEnvironmentAndHealth,
    HomeCategoryNone,
} HomeCategory;

typedef enum : NSUInteger {
    HomeAuthroizedTypeOwner = 1,
    HomeAuthroizedTypePermissionAll,
    HomeAuthroizedTypePermissionSome,
} HomeAuthroizedType;

typedef enum : NSUInteger {
    ArmStatusTypeNone = 0,
    ArmStatusTypeDisarm = 1,
    ArmStatusTypePartialArm = 2,
    ArmStatusTypeAllArm = 3,
} ArmStatusType;

extern NSString * const HomeModelDidUpdateNotification;

static NSString * const kDefaultHomeIcon = @"defualt_home_my_home";
static NSString * const kCurrentLocationIcon = @"ontravel_icon";
//加入了授权的家之后
static NSString * const kDefaultAuthorizedHomeIcon = @"defualt home_authorized_home";
static NSString * const kAuthorizedHomeIcon = @"ordinary_home_authorized_home";

@class EmotionalModel,DeviceModel;

@interface HomeModel : NSObject<HWScenarioControllable>

@property (nonatomic,copy)   NSString  *name;
@property (nonatomic,copy)   NSString  *city;
@property (nonatomic,copy)   NSString  *cityName;
@property (nonatomic,copy)   NSString  *streetAddress;
@property (nonatomic,copy)   NSString  *provinceName;
@property (nonatomic,copy)   NSString  *country;
@property (nonatomic,copy)   NSString  *latitude;
@property (nonatomic,copy)   NSString  *longitude;
@property (nonatomic,copy)   NSString  *districtName;
@property (nonatomic,copy)   NSString  *state;
@property (nonatomic, strong) NSString  *locationID;
@property (nonatomic, strong) NSMutableArray<DeviceModel *> *devices;
@property (nonatomic, strong) NSArray<NSNumber *> *frequentlyUsedDeviceIds;

//group
@property (nonatomic, strong) NSMutableArray<HWGroupModel *> *groups;

//scenario
@property (nonatomic, assign) NSInteger energyScenario;
@property (nonatomic, assign) NSInteger healthyScenario;
@property (nonatomic, assign) NSInteger locationScenario;
@property (nonatomic, assign) NSInteger securityScenario;

@property (nonatomic,copy)   NSString  *backHomeTime;//到家时间
@property (nonatomic) BOOL clock;
@property (nonatomic,assign) BOOL isOwner;
@property (nonatomic,assign) BOOL isDefault;
@property (nonatomic,assign) NSInteger ownerId;
@property (nonatomic,strong) NSString *ownerName;
@property (nonatomic,assign) NSInteger ownerGender;
@property (nonatomic,strong) NSString *ownerPhoneNumber;
@property (nonatomic,strong) NSMutableArray *authorizedTo;
@property (nonatomic, strong) NSString * homeIcon;

@property (nonatomic,readonly) BOOL canControl;

@property (nonatomic, strong) EmotionalModel *emotionalModel;

@property (readonly, nonatomic) BOOL hasTerribleDevice;
@property (readonly, nonatomic) BOOL hasUnSupportDevice;

@property (nonatomic, readonly) BOOL isRealHome;

@property (nonatomic, strong) NSArray *categories;

@property (nonatomic, assign) HomeCategory category;

@property (nonatomic, assign) HomeAuthroizedType authorizedType;
@property (nonatomic, strong) NSArray *notMatchDeviceIds;
@property (nonatomic, strong) NSMutableArray <HWScenarioModel *>* scenarioList;
@property (nonatomic, strong) NSMutableArray <HWScheduleModel *>* scheduleList;
@property (nonatomic, strong) NSMutableArray <HWTriggerModel *>* triggerList;
@property (nonatomic, strong) HWHistoryEventCountAPIManager * historyEventCountAPIManager;
@property (nonatomic, assign) NSInteger unreadEventCount;

@property (nonatomic, strong) NSMutableArray *favoriteDevices;
@property (nonatomic, assign) NSInteger displayTempRoomId;
@property (nonatomic, assign) NSInteger displayPm25RoomId;
@property (nonatomic, assign) NSInteger displayHumRoomId;

/**
 *  @author Wang Lei, 15-07-10 14:07:44
 *
 *  @brief  check there are device.
 *
 *  @return return YES if have device , otherwise return NO.
 *
 *  @since 1490
 */
-(BOOL)isHaveDevices;
- (BOOL)isHaveGroups;

- (void)updateCityWithCode:(NSString *)code;

-(NSArray *)frequentlyUsedDevices;

-(id)initWithDictionary:(NSDictionary *)paramDeviceDictionary reload:(BOOL)need;
/**
 *  replace loc entity by cloud dictionary
 *
 *  @param params cloud responseObject
 */
-(void)updateWithDictionary:(NSDictionary *)params reload:(BOOL)need;

- (NSDictionary *)convertToDictionary;

- (NSDictionary *)convertScenarioToDictionary;

- (NSDictionary *)convertScheduleToDictionary;

- (NSDictionary *)convertTriggerToDictionary;

-(void)appendDeviceByDictionary:(NSDictionary *)subDic;

-(void)updateDeviceMetaInfoWithData:(NSArray *)params reload:(BOOL)need;

- (void)updateGroupWithDictionary:(NSDictionary *)params;

- (void)updateScenarioListWithDictionary:(NSDictionary *)dictionary;
- (void)updateHomeScenarioList;

- (void)updateRoomScenarioList;
- (void)updateRoomScenarioListWithDictionary:(NSDictionary *)dictionary;

- (void)updateHomeScheduleList;
- (void)updateScheduleListWithDictionary:(NSDictionary *)dictionary;

- (void)updateTriggerListWithDictionary:(NSDictionary *)dictionary;
- (void)updateTriggerList;

- (void)removeAllRoomScenario;

- (NSInteger)activeScheduleNumber;
- (NSInteger)activeTriggerNumber;

- (HWScenarioModel *)getRoomScenarioById:(NSInteger)scenario;
- (HWScenarioModel *)getScenarioById:(NSInteger)scenario;
- (HWScheduleModel *)getScheduleById:(NSInteger)scheduleId;
- (HWTriggerModel *)getTriggerById:(NSInteger)triggerId;

//include sub devices
- (NSArray *)getAllDevice;
- (NSArray *)getAllDeviceDicts;
- (NSArray *)getAllGroupDicts;

/**
 *  Add device to Home
 *
 *  @param device
 */
//-(void)addDevice:(DeviceModel *)device;

/**
 *  check if any device online in home
 *
 *  @return yes/no
 */
-(BOOL)hasDeviceOnlineInHome;
/**
 *  Description compare all the devices's pm 2.5 value registered in the location
 *
 *  @return Device model(entity)
 */
- (DeviceModel *)getDeviceById:(NSString *)deviceId;

-(void)updateArrivingHomeTime:(NSString *)time WithBlock:(HWAPICallBack)paramBlock;

- (void)updateAllDevicesRunStatus:(NSArray *)params;

- (DeviceModel *)tunaDevice;

- (NSString *)getHomeScenarioImageName;

- (NSArray *)getDeviceListWithGroupId:(NSInteger)groupId;

- (HWGroupModel *)getGroupById:(NSInteger)groupId;

- (HWGroupModel *)getGroupByDeviceId:(NSInteger)deviceId;

- (void)createGroupWithParams:(NSDictionary *)params callBack:(HWAPICallBack)callBack;

- (void)groupEditDeviceWithParams:(NSDictionary *)params callBack:(HWAPICallBack)callBack;

- (void)removeGroupWithParams:(NSDictionary *)params callBack:(HWAPICallBack)callBack;

- (void)getNotMatchDevicesWithCallBack:(HWAPICallBack)callBack;

- (NSArray *)notMatchDevices;

- (NSArray<HWGroupModel *> *)sortedGroups;

- (NSArray<HWScenarioModel *> *)favoriteScenarios;

- (void)controlToScenario:(NSInteger)scenarioId password:(NSString *)pwd type:(HomeScenarioType)type forceExecute:(BOOL)forceExecute RoomId:(NSInteger)roomId withCallback:(ControllBlock)callback;

- (ArmStatusType)armStatus;

- (HWScheduleModel *)upcomingSchedule;

- (void)getUnreadEventCount;

- (void)readEventWithId:(long long)eventId;

- (DeviceModel *)gatewayDeviceModel;

- (BOOL)checkDeviceName:(NSString *)deviceName deviceId:(NSInteger)deviceId;

- (void)updateDisplayGroupId;

- (DeviceModel *)gldDeviceModel;
+ (NSString *)getDefaultSceneTypeName:(NSInteger)nameType;
@end
