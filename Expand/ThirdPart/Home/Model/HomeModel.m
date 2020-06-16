//
//  HomeModel.h
//  AirTouch
//
//  Created by Devin on 1/27/15.
//  Copyright (c) 2015 Honeywell. All rights reserved.
//

#import "HomeModel.h"
#import "DeviceModel.h"
#import "EmotionalModel.h"
#import "RecogTimeUtil.h"
#import "HWModeCellModel.h"
#import "CountlyTracker.h"
#import "UserEntity.h"
#import "AppMarco.h"
#import "AppManager.h"
#import "Role.h"
#import "LogUtil.h"
#import "ModelKey.h"
#import "UserConfig.h"
#import "DateTimeUtil.h"
#import "HWBackHomeAPIManager.h"
#import "HWLocationScenarioControlAPIManager.h"
#import "HWDeleteDeviceAPIManager.h"
#import "WebSocketManager.h"
#import "SHA256.h"
#import "TimerUtil.h"
#import "HWNotMatchDevicesAPIManager.h"
#import "HWCityManager.h"
#import "HWLocaitonScenarioByIdAPIManager.h"
#import "HWRoomScenarioByIdAPIManager.h"
#import "HWLocationScheduleListByIdAPIManager.h"
#import "HWLocationTriggerListAPIManager.h"
#import "HWHistoryEventReadAPIManager.h"

NSString * const HomeModelDidUpdateNotification = @"HomeModelDidUpdateNotification";

@interface HomeModel ()
@property (assign, nonatomic) BOOL containOffLineDevice;
@property (strong, nonatomic) HWBackHomeAPIManager *backHomeAPIManager;
@property (strong, nonatomic) NSString *scenarioMessageId;
@property (strong, nonatomic) NSMutableDictionary *scenarioStatusDictionary;
@property (strong, nonatomic) HWLocationScenarioControlAPIManager *locationScenarioControlAPIManager;
@property (strong, nonatomic) HWDeleteDeviceAPIManager *deleteDeviceManager;
@property (strong, nonatomic) HWGroupEditDeviceAPIManager *editDeviceAPIManager;
@property (strong, nonatomic) HWGroupRemoveAPIManager *removeGroupAPIManager;
@property (strong, nonatomic) HWGroupCreateAPIManager *createGroupAPIManager;
@property (strong, nonatomic) HWNotMatchDevicesAPIManager *notMatchDevicesAPIManager;
@property (nonatomic, strong) HWLocaitonScenarioByIdAPIManager             *locationScenarioByIdAPIManager;
@property (nonatomic, strong) HWRoomScenarioByIdAPIManager             *roomScenarioByIdAPIManager;
@property (nonatomic, strong) HWLocationScheduleListByIdAPIManager             *locationScheduleByIdAPIManager;
@property (nonatomic, strong) HWLocationTriggerListAPIManager             *locationTriggerListAPIManager;
@property (nonatomic, strong) HWHistoryEventReadAPIManager *eventReadAPIManager;

@property (nonatomic, strong) NSMutableDictionary *scenarioControlHistorys;

@property (nonatomic, assign) BOOL updateGroupListFinish;

@end

@implementation HomeModel
@synthesize name;
@synthesize city;
@synthesize devices;
@synthesize cityName;

@synthesize targetStatus;
@synthesize scenarioMode;
@synthesize additionalObject = _additionalObject;

- (void)dealloc {
    [self cancelHttpRequest];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

-(id)init
{
    if (self=[super init]) {
        self.name=@"";
        self.city=@"";
        self.locationID=@"";
        self.cityName=@"";
        self.clock = NO;
        self.backHomeTime = @"";
        self.ownerGender = 1;
        self.targetStatus = HWScenarioType_Invalid;
        self.devices = [[NSMutableArray alloc] init];
        self.groups = [[NSMutableArray alloc] init];
        self.scenarioList = [[NSMutableArray alloc] init];
        self.scheduleList = [NSMutableArray array];
        self.triggerList = [NSMutableArray array];
        self.favoriteDevices = [NSMutableArray array];
        self.scenarioControlHistorys = [NSMutableDictionary dictionary];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scenarioControlResponse:) name:kWebSocketDidReceiveLocationScenarioResponseNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateEventData:) name:kNotification_GetAlarmNofity object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateEventData:) name:kWebsocketDidReceiveEventNewNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateEventData:) name:kVideoCallHasCallIn object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateEventData:) name:kVideoCallHasEnded object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateEventData:) name:kVideoCallDidOpenDoor object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateEventData:) name:kVideoCallHasPickedUp object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateEventData:) name:kWebsocketDidReceiveEventChangeNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateDeviceRunstatus) name:kNotification_AllDeviceRunStatusRefresh object:nil];
        [self getNotMatchDevicesWithCallBack:nil];
    }
    return self;
}

-(BOOL)isHaveDevices
{
    if (devices!=nil && [devices count]>0) {
        return YES;
    }else
    {
        return NO;
    }
}

- (BOOL)isHaveGroups {
    if (self.groups!=nil && [self.groups count]>0) {
        return YES;
    }else
    {
        return NO;
    }
}

-(NSArray *)frequentlyUsedDevices {
    NSMutableArray *frequentlyUsedDevices = [NSMutableArray array];
    for (NSNumber *deviceIdObject in self.frequentlyUsedDeviceIds) {
        NSInteger deviceId = [deviceIdObject integerValue];
        DeviceModel *device = [self getDeviceById:[NSString stringWithFormat:@"%ld", (long)deviceId]];
        if (device) {
            [frequentlyUsedDevices addObject:device];
        }
    }
    return frequentlyUsedDevices;
}

- (NSString *)homeIcon
{
    UserEntity * user = [UserEntity instance];
    if (self.isOwner) {
        if ([self.locationID isEqualToString:[user getDefaultHomeId]]) {
            return kDefaultHomeIcon;
        } else {
            return nil;
        }
    } else {
        if ([self.locationID isEqualToString:[user getDefaultHomeId]]) {
            return kDefaultAuthorizedHomeIcon;
        } else {
            return kAuthorizedHomeIcon;
        }
    }
}

- (BOOL)hasTerribleDevice {
    return NO;
}

- (BOOL)hasUnSupportDevice {
    for (DeviceModel *device in self.devices) {
        if (device.unSupport) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)isRealHome {
    return YES;
}

- (EmotionalModel *)emotionalModel {
    if (!_emotionalModel) {
        _emotionalModel = [[EmotionalModel alloc] init];
    }
    return _emotionalModel;
}

- (void)cancelHttpRequest {
    [self.backHomeAPIManager cancel];
    self.backHomeAPIManager = nil;
    
    [self.locationScenarioControlAPIManager cancel];
    self.locationScenarioControlAPIManager = nil;
    
    [self.deleteDeviceManager cancel];
    self.deleteDeviceManager = nil;
    
    [self.removeGroupAPIManager cancel];
    self.removeGroupAPIManager = nil;
    
    [self.createGroupAPIManager cancel];
    self.createGroupAPIManager = nil;
    
    [self.eventReadAPIManager cancel];
    self.eventReadAPIManager = nil;
}

-(id)initWithDictionary:(NSDictionary *)paramDeviceDictionary reload:(BOOL)need
{
    self = [self init];
    if (self) {
        [self updateWithDictionary:paramDeviceDictionary reload:need];
    }
    return self;
}

-(void)updateWithDictionary:(NSDictionary *)params reload:(BOOL)need
{
    if ([params.allKeys containsObject:kLocation_ID]) {
        self.locationID = [NSString stringWithFormat:@"%ld", (long)[params[kLocation_ID] integerValue]];
    }
    
    if ([params.allKeys containsObject:kLocation_Name]) {
        self.name = params[kLocation_Name];
    }
    if ([params.allKeys containsObject:kLocation_Street]) {
        self.streetAddress = params[kLocation_Street];
    }
    if ([params.allKeys containsObject:kLocation_State]) {
        self.state = params[kLocation_State];
    }
    if ([params.allKeys containsObject:kLocation_City]) {
        [self updateCityWithCode:params[kLocation_City]];
    }
    if ([params.allKeys containsObject:kLocation_Country]) {
        self.country = params[kLocation_Country];
    }
    if ([params.allKeys containsObject:kLocation_Latitude]) {
        self.latitude = params[kLocation_Latitude];
    }
    if ([params.allKeys containsObject:kLocation_Longitude]) {
        self.longitude = params[kLocation_Longitude];
    }
    if ([params.allKeys containsObject:kLocation_OwnerId]) {
        self.ownerId = [params[kLocation_OwnerId] integerValue];
    }
    if ([params.allKeys containsObject:kLocation_OwnerName]) {
        self.ownerName = params[kLocation_OwnerName];
    }
    if ([params.allKeys containsObject:kLocation_IsDefault]) {
        self.isDefault = [params[kLocation_IsDefault] boolValue];
    }
    BOOL authorizedTypeChanged = NO;
    if ([params.allKeys containsObject:kLocation_Categories]) {
        self.categories = params[kLocation_Categories];
    } else {
        self.categories = @[];
        authorizedTypeChanged = YES;
    }
    
    if ([self.categories containsObject:@(HomeCategoryTypeSecurity)]) {
        self.category = HomeCategoryAll;
    }
    
    if (![self.categories containsObject:@(HomeCategoryTypeSecurity)] && ![self.categories containsObject:@(HomeCategoryTypeEnvironmentAndHealth)]) {
        self.category = HomeCategoryNone;
    }
    
    if ([params.allKeys containsObject:kLocation_AuthorizedType]) {
        if (self.authorizedType != [params[kLocation_AuthorizedType] integerValue]) {
            authorizedTypeChanged = YES;
        }
        self.authorizedType = [params[kLocation_AuthorizedType] integerValue];
        self.isOwner = (self.authorizedType == HomeAuthroizedTypeOwner);
    }
    if ([params.allKeys containsObject:kLocation_OwnerGender]) {
        self.ownerGender = [params[kLocation_OwnerGender] integerValue];
    }
    if ([params.allKeys containsObject:kLocation_OwnerPhone]) {
        self.ownerPhoneNumber = params[kLocation_OwnerPhone];
    }
    if ([params.allKeys containsObject:kLocation_AuthorizedTo]) {
        self.authorizedTo = params[kLocation_AuthorizedTo];
    } else {
        self.authorizedTo = [@[] mutableCopy];
    }
    
    //scenario
    if ([params.allKeys containsObject:kLocation_Scenario] && [params[kLocation_Scenario] isKindOfClass:[NSDictionary class]]) {
        if ([[params[kLocation_Scenario] allKeys] containsObject:kLocation_EnergyScenario]) {
            self.energyScenario = [params[kLocation_Scenario][kLocation_EnergyScenario] integerValue];
        }
        if ([[params[kLocation_Scenario] allKeys] containsObject:kLocation_HealthyScenario]) {
            self.healthyScenario = [params[kLocation_Scenario][kLocation_HealthyScenario] integerValue];
        }
        if ([[params[kLocation_Scenario] allKeys] containsObject:kLocation_LocationScenario]) {
            self.locationScenario = [params[kLocation_Scenario][kLocation_LocationScenario] integerValue];
        }
        if ([[params[kLocation_Scenario] allKeys] containsObject:kLocation_SecurityScenario]) {
            self.securityScenario = [params[kLocation_Scenario][kLocation_SecurityScenario] integerValue];
        }
    }
    
    if ([params.allKeys containsObject:@"displayTempRoomId"]) {
        self.displayTempRoomId = [params[@"displayTempRoomId"] integerValue];
    }
    if ([params.allKeys containsObject:@"displayPm25RoomId"]) {
        self.displayPm25RoomId = [params[@"displayPm25RoomId"] integerValue];
    }
    if ([params.allKeys containsObject:@"displayHumRoomId"]) {
        self.displayHumRoomId = [params[@"displayHumRoomId"] integerValue];
    }
    
    // device
    if ([params.allKeys containsObject:kLocation_Devices])
    {
        [self updateDeviceMetaInfoWithData:params[kLocation_Devices] reload:need];
    }
    [self sortDevice];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:HomeModelDidUpdateNotification object:self userInfo:@{kLocation_ID:self.locationID, @"authorizedTypeChanged":@(authorizedTypeChanged)}];
    
    //emotional
    if ([params.allKeys containsObject:kEmotionalHistoryData]) {
        [self.emotionalModel updateWithDictionary:params[kEmotionalHistoryData]];
    }
    [self getUnreadEventCount];
    [self updateGroupWithDictionary:params];
    
    [self getNotMatchDevicesWithCallBack:nil];
}

- (void)updateGroupWithDictionary:(NSDictionary *)params {
    //group
    if ([params.allKeys containsObject:GroupList]) {
        [self updateGroupMetaInfoWithData:params[GroupList]];
    }
}

-(NSDictionary *)convertToDictionary {
    NSDictionary *dict = @{
                           kLocation_ID:(self.locationID?:@""),
                           kLocation_Name:(self.name?:@""),
                           kLocation_Street:(self.streetAddress?:@""),
                           kLocation_State:(self.state?:@""),
                           kLocation_District:(self.districtName?:@""),
                           kLocation_City:(self.city?:@""),
                           kLocation_Country:(self.country?:@""),
                           kLocation_OwnerId:@(self.ownerId),
                           kLocation_OwnerName:(self.ownerName?:@""),
                           kLocation_OwnerGender:@(self.ownerGender),
                           kLocation_OwnerPhone:self.ownerPhoneNumber?:@"",
                           kLocation_AuthorizedTo:self.authorizedTo?:@[],
                           kLocation_AuthorizedType:@(self.authorizedType),
                           kLocation_IsDefault:@(self.isDefault),
                           kLocation_Latitude:(self.latitude?:@""),
                           kLocation_Longitude:(self.longitude?:@""),
                           kLocation_EnergyScenario:@(self.energyScenario),
                           kLocation_HealthyScenario:@(self.healthyScenario),
                           kLocation_LocationScenario:@(self.locationScenario),
                           kLocation_SecurityScenario:@(self.securityScenario),
                           @"categories":self.categories?:@[],
                           @"displayTempRoomId":@(self.displayTempRoomId),
                           @"displayPm25RoomId":@(self.displayPm25RoomId),
                           @"displayHumRoomId":@(self.displayHumRoomId)
                           };
    NSMutableDictionary *mDict = [NSMutableDictionary dictionaryWithDictionary:dict];
    
    NSMutableArray *devicesArray = [NSMutableArray array];
    for (DeviceModel *device in self.devices) {
        [devicesArray addObject:[device convertToDictionary]];
    }
    mDict[kLocation_Devices] = devicesArray;
    
    NSMutableArray *ungroupArray = [NSMutableArray array];
    for (DeviceModel *device in self.devices) {
        [ungroupArray addObject:@{@"deviceId":@(device.deviceID),
                                  @"isMasterDevice":@(device.isMasterDevice),
                                  }];
    }
    if (ungroupArray.count > 0) {
        mDict[@"unGroupingDeviceList"] = ungroupArray;
    }
    
    mDict[kEmotionalHistoryData] = [self.emotionalModel convertToDictionary];
    
    return mDict;
}

- (NSDictionary *)convertScenarioToDictionary {
    NSMutableArray *convertScenarioListArray = [NSMutableArray array];
    for (NSInteger i = 0; i < self.scenarioList.count; i++) {
        HWScenarioModel *scenarioModel = self.scenarioList[i];
        NSDictionary *scenarioDict = [scenarioModel convertToDictionary];
        [convertScenarioListArray addObject:scenarioDict];
    }
    NSDictionary *dict = @{kLocation_ID:@([self.locationID integerValue]),
                           @"scenarioList":convertScenarioListArray
                           };
    return dict;
}

- (NSDictionary *)convertScheduleToDictionary {
    NSMutableArray *convertScheduleListArray = [NSMutableArray array];
    for (NSInteger i = 0; i < self.scheduleList.count; i++) {
        HWScheduleModel *scheduleModel = self.scheduleList[i];
        NSDictionary *scheduleDict = [scheduleModel convertToDictionary];
        [convertScheduleListArray addObject:scheduleDict];
    }
    NSDictionary *dict = @{kLocation_ID:@([self.locationID integerValue]),
                           @"scheduleList":convertScheduleListArray
                           };
    return dict;
}

- (NSDictionary *)convertTriggerToDictionary {
    NSMutableArray *convertTriggerListArray = [NSMutableArray array];
    for (NSInteger i = 0; i < self.triggerList.count; i++) {
        HWTriggerModel *triggerModel = self.triggerList[i];
        NSDictionary *triggerDict = [triggerModel convertToDictionary];
        [convertTriggerListArray addObject:triggerDict];
    }
    NSDictionary *dict = @{kLocation_ID:@([self.locationID integerValue]),
                           @"triggerList":convertTriggerListArray
                           };
    return dict;
}

- (void)updateCityWithCode:(NSString *)code {
    self.city = code;
    [[HWCityManager shareCityManager] getDistrictModelWithCityCode:code dataBase:nil withCallBack:^(id object, FMDatabase *db, NSError *error) {
        if (!error && [object isKindOfClass:[HWDistrictModel class]]) {
            HWDistrictModel *model = (HWDistrictModel *)object;
            self.districtName = model.name;
            self.cityName = model.cityModel.name;
            self.provinceName = model.cityModel.provinceModel.name;
        }
    }];
}

- (DeviceModel *)getDeviceModelByDictionary:(NSDictionary *)subDic {
    //check if this device is exist in current device array
    BOOL find = NO;
    for (int j = 0; j < self.devices.count; j++) {
        DeviceModel * deviceModel = self.devices[j];
        if (deviceModel.deviceID == [[subDic objectForKey:DeviceID] integerValue]) {
            find = YES;
            break;
        }
    }
    
    //if not find && a minor check
    //then add device model
    if (find == NO && [subDic objectForKey:DeviceType] != nil) {
        //insert subdict to self.devices
        //init 方法与update方法保持一致
        NSString *deviceType = subDic[@"productModel"];
        Class class = [AppConfig classForDeviceType:deviceType];
        
        if (class) {
            DeviceModel *deviceModel = [[class alloc] initWithDictionary:subDic];
            deviceModel.homeModel = self;
            return deviceModel;
        }
    }
    return nil;
}

-(void)appendDeviceByDictionary:(NSDictionary *)subDic {
    DeviceModel *deviceModel = [self getDeviceModelByDictionary:subDic];
    if (deviceModel) {
        [self.devices addObject:deviceModel];
    }
}

//group
- (void)updateGroupMetaInfoWithData:(NSArray *)params {
    //First : reverse loop current all devices
    // Update device info if exists
    for (int i = (int)self.groups.count - 1; i>=0; i--) {
        HWGroupModel * groupModel = self.groups[i];
        BOOL find = NO;
        //Find same device model from cloud device array,then update
        for (NSDictionary * subDic in params) {
            if (groupModel.groupId == [[subDic objectForKey:GroupId] integerValue]) {
                find = YES;
                //if find, update
                [groupModel updateWithDictionary:subDic];//updateByDictionary
            }
        }
        
        //if not find
        if (find == NO) {
            //delete
            [self.groups removeObject:groupModel];
        }
    }
    
    //Second : loop cloud device array
    // Add device model if new device found from cloud
    for (int i = 0; i < params.count; i++) {
        NSDictionary * groupDict  = params[i];
        HWGroupModel *groupModel = [self getGroupModelByDictionary:groupDict];
        if (groupModel) {
            [self.groups insertObject:groupModel atIndex:i];
        }
    }
    
    self.updateGroupListFinish = YES;
    if ([[UserEntity instance] userDataRequestSuccess]) {
        [self updateDisplayGroupId];
    }
    
}

- (HWGroupModel *)getGroupModelByDictionary:(NSDictionary *)subDic {
    //check if this device is exist in current device array
    BOOL find = NO;
    for (int j = 0; j < self.groups.count; j++) {
        HWGroupModel * groupModel = self.groups[j];
        if (groupModel.groupId == [[subDic objectForKey:GroupId] integerValue]) {
            find = YES;
            break;
        }
    }
    
    //if not find && a minor check
    //then add group model
    if (find == NO) {
        //insert subdict to self.devices
        HWGroupModel *groupModel = [[HWGroupModel alloc] initWithDictionary:subDic];
        groupModel.homeModel = self;
        return groupModel;
    }
    return nil;
}

- (void)updateFavoriteDevicesWithData:(NSArray *)params {
    [self.favoriteDevices removeAllObjects];
    for (NSInteger i = 0; i < params.count; i++) {
        NSDictionary *deviceDic = params[i];
        if ([deviceDic[DeviceIsFavorite] boolValue]) {
            DeviceModel *model = [self getDeviceById:[NSString stringWithFormat:@"%@",deviceDic[DeviceID]]];
            if (model) {
                [self.favoriteDevices addObject:model];
            }
        }
    }
}

/**
 *  Update devices array
 *
 *  @param params Device array from cloud
 *  @param need   reload or not
 */
-(void)updateDeviceMetaInfoWithData:(NSArray *)params reload:(BOOL)need
{
    NSMutableArray *mutableArray = [NSMutableArray arrayWithArray:params];
    NSMutableArray *subDevicesArray = [NSMutableArray array];
    for (NSInteger i = 0; i < mutableArray.count; i++) {
        NSDictionary *subDic = mutableArray[i];
        if ([[subDic objectForKey:@"productClass"] integerValue] == 4) {
            [subDevicesArray addObject:subDic];
        }
    }
    [mutableArray removeObjectsInArray:subDevicesArray];
    
    NSMutableArray *normalDevices = [NSMutableArray array];
    //home panel add sub devices
    for (NSInteger i = 0; i < mutableArray.count; i++) {
        NSMutableDictionary *normalDevice = [NSMutableDictionary dictionaryWithDictionary:mutableArray[i]];
        NSMutableArray *mutableDevices = [NSMutableArray array];
        for (NSInteger j = subDevicesArray.count-1; j >= 0; j--) {
            NSDictionary *subDevice = subDevicesArray[j];
            if ([[normalDevice objectForKey:DeviceID] integerValue] == [[subDevice objectForKey:DeviceParentDeviceId] integerValue]) {
                [mutableDevices addObject:subDevice];
                [subDevicesArray removeObject:subDevice];
            }
        }
        [normalDevice setObject:mutableDevices forKey:DeviceSubDevices];
        [normalDevices addObject:normalDevice];
    }
    
    
    
    //First : reverse loop current all devices
    // Update device info if exists
    for (int i = (int)self.devices.count - 1; i>=0; i--) {
        DeviceModel * deviceModel = self.devices[i];
        BOOL find = NO;
        //Find same device model from cloud device array,then update
        for (NSDictionary * subDic in normalDevices) {
            if (deviceModel.deviceID == [[subDic objectForKey:DeviceID] integerValue]) {
                find = YES;
                //if find, update
                [deviceModel updateWithDictionary:subDic];//updateByDictionary
                
                break;
            }
        }
        
        //if not find
        if (find == NO) {
            //delete
            [self.devices removeObject:deviceModel];
        }
    }
    
    //Second : loop cloud device array
    // Add device model if new device found from cloud
    for (int i = 0; i < normalDevices.count; i++) {
        NSDictionary * normalDevice  = normalDevices[i];
        DeviceModel *deviceModel = [self getDeviceModelByDictionary:normalDevice];
        if (deviceModel) {
            [self.devices insertObject:deviceModel atIndex:i];
        }
    }
    
    [self updateFavoriteDevicesWithData:params];
}

- (void)updateScheduleListWithDictionary:(NSDictionary *)dictionary {
    if ([dictionary[@"scheduleList"] isKindOfClass:[NSArray class]]) {
        NSArray *scheduleList = dictionary[@"scheduleList"];
        if (scheduleList.count == 0) {
            [self.scheduleList removeAllObjects];
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_UpdateHomeScheduleList object:self userInfo:@{@"locationId":self.locationID}];
            return;
        }
        //更新现有的，删除多余的
        for (NSInteger i = self.scheduleList.count-1; i >= 0; i--) {
            HWScheduleModel *scheduleModel = self.scheduleList[i];
            BOOL isExist = NO;
            for (NSInteger j = 0; j < scheduleList.count; j++) {
                NSDictionary *scheduleDict = scheduleList[j];
                NSInteger scheduleId = [scheduleDict[@"scheduleId"] integerValue];
                if (scheduleModel.scheduleId == scheduleId) {
                    isExist = YES;
                    [scheduleModel updateWithDictionary:scheduleDict];
                }
            }
            if (!isExist) {
                [self.scheduleList removeObjectAtIndex:i];
            }
        }
        
        //按照index
        for (NSInteger i = 0; i < scheduleList.count; i++) {
            NSDictionary *scheduleDict = scheduleList[i];
            NSInteger scheduleId = [scheduleDict[@"scheduleId"] integerValue];
            BOOL isExist = NO;
            for (NSInteger j = 0; j < self.scheduleList.count; j++) {
                HWScheduleModel *scheduleModel = self.scheduleList[j];
                if (scheduleModel.scheduleId == scheduleId) {
                    isExist = YES;
                    break;
                }
            }
            if (!isExist) {
                HWScheduleModel *scheduleModel = [[HWScheduleModel alloc] initWithDictionary:scheduleDict];
                [self.scheduleList insertObject:scheduleModel atIndex:i];
            } 
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_UpdateHomeScheduleList object:self userInfo:@{@"locationId":self.locationID}];
    }
}

- (void)updateHomeScheduleList {
    if (!self.locationID) {
        return;
    }
    NSInteger locationId = [self.locationID integerValue];
    [self.locationScheduleByIdAPIManager callAPIWithParam:@{@"locationId":@(locationId)} completion:^(id object, NSError *error) {
        if (!error && [object isKindOfClass:[NSDictionary class]]) {
            [self updateScheduleListWithDictionary:object];
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_sbc_schedule_list object:nil];
        }
    }];
}

- (void)updateScenarioListWithDictionary:(NSDictionary *)dictionary {
    if ([dictionary[@"scenarioList"] isKindOfClass:[NSArray class]]) {
        NSArray *scenarioList = dictionary[@"scenarioList"];
        if (scenarioList.count == 0) {
            [self.scenarioList removeAllObjects];
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_UpdateHomeScenarioList object:self userInfo:@{@"locationId":self.locationID}];
            return;
        }
        [self.scenarioList removeAllObjects];
        
        //按照index
        for (NSInteger i = 0; i < scenarioList.count; i++) {
            NSDictionary *scenarioDict = scenarioList[i];
            NSInteger scenario = [scenarioDict[@"scenario"] integerValue];
            BOOL isExist = NO;
            for (NSInteger j = 0; j < self.scenarioList.count; j++) {
                HWScenarioModel *scenarioModel = self.scenarioList[j];
                if (scenarioModel.scenario == scenario) {
                    isExist = YES;
                    break;
                }
            }
            if (!isExist) {
                HWScenarioModel *scenarioModel = [[HWScenarioModel alloc] initWithDictionary:scenarioDict];
                scenarioModel.homeModel = self;
                [self.scenarioList insertObject:scenarioModel atIndex:i];
            }
        }
                
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_UpdateHomeScenarioList object:self userInfo:@{@"locationId":self.locationID}];
    }
}

- (void)updateHomeScenarioList {
    if (!self.locationID) {
        return;
    }
    NSInteger locationId = [self.locationID integerValue];
    [self.locationScenarioByIdAPIManager callAPIWithParam:@{@"locationId":@(locationId)} completion:^(id object, NSError *error) {
        if (!error && [object isKindOfClass:[NSDictionary class]]) {
            [self updateScenarioListWithDictionary:object];
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_sbc_scenario_list object:nil];
        }
    }];
}

- (void)updateRoomScenarioList {
    if (!self.locationID) {
        return;
    }
    NSInteger locationId = [self.locationID integerValue];
    [self.roomScenarioByIdAPIManager callAPIWithParam:@{@"locationId":@(locationId)} completion:^(id object, NSError *error) {
        if (!error && [object isKindOfClass:[NSDictionary class]]) {
            [self updateRoomScenarioListWithDictionary:object];
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_sbc_room_scenario object:nil];
        }
    }];
}

- (void)updateRoomScenarioListWithDictionary:(NSDictionary *)dictionary {
    if (![dictionary[@"roomList"] isKindOfClass:[NSArray class]]) {
        return;
    }
    NSArray *array = dictionary[@"roomList"];
    for (NSInteger j = 0; j < self.groups.count; j++) {
        HWGroupModel *groupModel = self.groups[j];
        BOOL exist = NO;
        for (NSInteger i = 0; i < array.count; i++) {
            NSDictionary *roomScenarioDict = array[i];
            NSInteger roomId = [roomScenarioDict[@"roomId"] integerValue];
            if (groupModel.groupId == roomId) {
                exist = YES;
                [groupModel updateScenarioWithDictionary:roomScenarioDict];
                break;
            }
        }
        if (!exist) {
            [groupModel updateScenarioWithDictionary:@{@"scenarioList":@[]}];
        }
    }
}

- (void)updateTriggerListWithDictionary:(NSDictionary *)dictionary {
    if ([dictionary[@"triggerList"] isKindOfClass:[NSArray class]]) {
        NSArray *triggerList = dictionary[@"triggerList"];
        if (triggerList.count == 0) {
            [self.triggerList removeAllObjects];
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_UpdateHomeTriggerList object:self userInfo:@{@"locationId":self.locationID}];
            return;
        }
        //更新现有的，删除多余的
        for (NSInteger i = self.triggerList.count-1; i >= 0; i--) {
            HWTriggerModel *triggerModel = self.triggerList[i];
            BOOL isExist = NO;
            for (NSInteger j = 0; j < triggerList.count; j++) {
                NSDictionary *triggerDict = triggerList[j];
                NSInteger triggerId = [triggerDict[@"triggerId"] integerValue];
                if (triggerModel.triggerId == triggerId) {
                    isExist = YES;
                    [triggerModel updateWithDictionary:triggerDict];
                }
            }
            if (!isExist) {
                [self.triggerList removeObjectAtIndex:i];
            }
        }
        
        //按照index
        for (NSInteger i = 0; i < triggerList.count; i++) {
            NSDictionary *triggerDict = triggerList[i];
            NSInteger triggerId = [triggerDict[@"triggerId"] integerValue];
            BOOL isExist = NO;
            for (NSInteger j = 0; j < self.triggerList.count; j++) {
                HWTriggerModel *triggerModel = self.triggerList[j];
                if (triggerModel.triggerId == triggerId) {
                    isExist = YES;
                    break;
                }
            }
            if (!isExist) {
                HWTriggerModel *triggerModel = [[HWTriggerModel alloc] initWithDictionary:triggerDict];
                [self.triggerList insertObject:triggerModel atIndex:i];
            }
        }
        
        
    } else {
        [self.triggerList removeAllObjects];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_UpdateHomeTriggerList object:self userInfo:@{@"locationId":self.locationID}];
}

- (void)updateTriggerList {
    if (!self.locationID) {
        return;
    }
    NSInteger locationId = [self.locationID integerValue];
    [self.locationTriggerListAPIManager callAPIWithParam:@{@"locationId":@(locationId)} completion:^(id object, NSError *error) {
        if (!error && [object isKindOfClass:[NSDictionary class]]) {
            [self updateTriggerListWithDictionary:object];
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_sbc_trigger_list object:nil];
        }
    }];
}

- (void)removeAllRoomScenario {
    for (NSInteger i = 0; i < self.groups.count; i++) {
        HWGroupModel *group = self.groups[i];
        [group updateScenarioWithDictionary:@{@"scenarioList":@[]}];
    }
}

- (NSInteger)activeScheduleNumber {
    NSInteger number = 0;
    for (NSInteger i = 0; i < self.scheduleList.count; i++) {
        HWScheduleModel *schedule = self.scheduleList[i];
        if (schedule.enable) {
            number++;
        }
    }
    return number;
}

- (NSInteger)activeTriggerNumber {
    NSInteger number = 0;
    for (NSInteger i = 0; i < self.triggerList.count; i++) {
        HWTriggerModel *trigger = self.triggerList[i];
        if (trigger.enable) {
            number++;
        }
    }
    return number;
}

- (HWScenarioModel *)getRoomScenarioById:(NSInteger)scenario {
    HWScenarioModel *scenarioModel = nil;
    for (NSInteger i = 0; i < self.groups.count; i++) {
        HWGroupModel *groupModel = self.groups[i];
        if ([groupModel getScenarioById:scenario]) {
            scenarioModel = [groupModel getScenarioById:scenario];
            break;
        }
    }
    return scenarioModel;
}

- (HWScenarioModel *)getScenarioById:(NSInteger)scenario {
    HWScenarioModel *scenarioModel = nil;
    
    for (NSInteger i = 0; i < self.scenarioList.count; i++) {
        HWScenarioModel *model = self.scenarioList[i];
        if (model.scenario == scenario) {
            scenarioModel = model;
            break;
        }
    }
    return scenarioModel;
}

- (HWScheduleModel *)getScheduleById:(NSInteger)scheduleId {
    HWScheduleModel *scheduleModel = nil;
    for (NSInteger i = 0; i < self.scheduleList.count; i++) {
        HWScheduleModel *model = self.scheduleList[i];
        if (model.scheduleId == scheduleId) {
            scheduleModel = model;
            break;
        }
    }
    return scheduleModel;
}

- (HWTriggerModel *)getTriggerById:(NSInteger)triggerId {
    HWTriggerModel *triggerModel = nil;
    for (NSInteger i = 0; i < self.triggerList.count; i++) {
        HWTriggerModel *model = self.triggerList[i];
        if (model.triggerId == triggerId) {
            triggerModel = model;
            break;
        }
    }
    return triggerModel;
}



-(BOOL)hasDeviceOnlineInHome
{
    if (!self.devices || self.devices.count == 0) {
        return NO;
    }
    for (DeviceModel*deviceModel in self.devices) {
        if (deviceModel.isAlive) {
            return YES;
        }
    }
    
    return NO;
}

- (NSString *)getHomeScenarioImageName {
    switch (self.locationScenario) {
//        case HWScenarioType_Home:
//            return @"Dashboard_HomeIcon_AtHome.png";
        case HWScenarioType_Away:
            return @"Dashboard_HomeIcon_Away.png";
        case HWScenarioType_Sleep:
            return @"Dashboard_HomeIcon_Sleep.png";
        case HWScenarioType_Awake:
            return @"Dashboard_HomeIcon_Awake.png";
        default:
            return @"Dashboard_HomeIcon_AtHome.png";
    }
}

- (NSArray *)getAllDevice {
    NSMutableArray *devices = [NSMutableArray array];
    if (self.devices.count > 0) {
        [devices addObjectsFromArray:self.devices];
    }
    for (NSInteger i = 0; i < self.devices.count; i++) {
        DeviceModel *model = self.devices[i];
        if (model.subDevices.count > 0) {
            [devices addObjectsFromArray:model.subDevices];
        }
    }
    return devices;
}

- (NSArray *)getAllDeviceDicts {
    NSMutableArray *deviceDicts = [NSMutableArray array];
    NSArray *devices = [self getAllDevice];
    for (NSInteger i = 0; i < devices.count; i++) {
        DeviceModel *model = devices[i];
        [deviceDicts addObject:[model convertToHtml]];
    }
    return deviceDicts;
}

- (NSArray *)getAllGroupDicts {
    NSMutableArray *groupDicts = [NSMutableArray array];
    for (NSInteger i = 0; i < self.groups.count; i++) {
        HWGroupModel *model = self.groups[i];
        [groupDicts addObject:[model convertToHtml]];
    }
    return groupDicts;
}

-(DeviceModel *)getDeviceById:(NSString *)deviceId
{
    for (DeviceModel * deviceModel in self.devices) {
        if (deviceModel.deviceID == [deviceId integerValue]) {
            return deviceModel;
        } else {
            for (DeviceModel *subModel in deviceModel.subDevices) {
                if (subModel.deviceID == [deviceId integerValue]) {
                    return subModel;
                }
            }
        }
    }
    
    return nil;
}

-(void)updateArrivingHomeTime:(NSString *)time WithBlock:(HWAPICallBack)paramBlock
{
    NSDictionary * otherDic;
    
    if ([time isEqualToString:@""])
    {
        otherDic = @{@"enableCleanBeforeHome":@"false",
                     @"timeToHome": [DateTimeUtil getUTCFormateDate:[NSDate date]],
                     @"deviceString": @"",
                     kUrl_LocationId:self.locationID};
    }
    else
    {
        otherDic = @{@"enableCleanBeforeHome":@"true",
                     @"timeToHome": time,
                     @"deviceString": @"",
                     kUrl_LocationId:self.locationID};
    }
    [LogUtil Debug:@"Alarm" message:[NSString stringWithFormat:@"%@", otherDic]];
    [self.backHomeAPIManager callAPIWithParam:otherDic completion:^(id object, NSError *error) {
        if (!error) {
            if ([time isEqualToString:@""])
            {
                [LogUtil Debug:@"Alarm" message:@"取消闹钟成功"];
                [self setClock:NO];
            }
            else
            {
                [LogUtil Debug:@"Alarm" message:@"设置闹钟成功"];
                [self setClock:YES];
            }
            
            [self setBackHomeTime:time];
        }
        
        if (paramBlock) {
            paramBlock(object, error);
        }
    }];
}

- (void)sortDevice {
    [self.devices sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        DeviceModel * deviceModel1 = (DeviceModel *)obj1;
        DeviceModel * deviceModel2 = (DeviceModel *)obj2;
        if (deviceModel1.unSupport) {
            return NSOrderedAscending;
        } else if (deviceModel2.unSupport) {
            return NSOrderedDescending;
        }
        return NSOrderedAscending;
    }];
}

- (void)updateAllGroupListWithResponse:(NSDictionary *)responseData
{
    NSArray * allKeys = responseData.allKeys;
    if ([allKeys containsObject:@"groupList"] && [allKeys containsObject:@"unGroupingDeviceList"]) {
        
        [self updateUngroupListFromCloudWithResponse:responseData];
        
        [self.devices sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            DeviceModel * deviceModel1 = (DeviceModel *)obj1;
            DeviceModel * deviceModel2 = (DeviceModel *)obj2;
            if (deviceModel1.unSupport) {
                return NSOrderedAscending;
            } else if (deviceModel2.unSupport) {
                return NSOrderedDescending;
            }
            return NSOrderedAscending;
        }];
        for (NSInteger i = [self.devices count]-1; i>=0; i--) {
            DeviceModel *homeDeviceModel = self.devices[i];
            BOOL find = NO;
            for (DeviceModel *ungroupDeviceModel in self.devices) {
                if (ungroupDeviceModel.deviceID == homeDeviceModel.deviceID) {
                    find = YES;
                    break;
                }
            }
            if (!find) {
                [self.devices removeObject:homeDeviceModel];
            }
        }
        
        
        [LogUtil Debug:@"debug getAllDeviceGroupList" message:@([allKeys containsObject:@"groupList"] && [allKeys containsObject:@"unGroupingDeviceList"])];
    }
}

- (void)updateUngroupListFromCloudWithResponse:(NSDictionary *)responseData
{
    NSArray * unGroupingDeviceListFromCloud = responseData[@"unGroupingDeviceList"];
    [self.devices removeAllObjects];
    for (NSDictionary *  deviceDictionary in unGroupingDeviceListFromCloud) {
        NSInteger deviceId = [deviceDictionary[@"deviceId"] integerValue];
        BOOL isMasterDevice = [deviceDictionary[@"isMasterDevice"] boolValue];
        for (DeviceModel * deviceModel in self.devices) {
            if (deviceModel.deviceID == deviceId) {
                deviceModel.isMasterDevice = isMasterDevice;
                [self.devices addObject:deviceModel];
            }
        }
    }
}

- (void)updateAllDevicesRunStatus:(NSArray *)params
{
    for (NSDictionary * param in params) {
        for (DeviceModel * deviceModel in self.devices) {
            NSInteger deviceIdFromCloud = [param[@"deviceId"]integerValue];
            NSInteger deviceIdAtLocal = deviceModel.deviceID;
            if (deviceIdFromCloud == deviceIdAtLocal) {
                NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithDictionary:param];
                if (deviceModel.authorizedTo) {
                    [dictionary setObject:deviceModel.authorizedTo forKey:DeviceAuthorizedTo];
                }
                [deviceModel updateWithDictionary:dictionary];
                break;
            } else {
                for (DeviceModel *subModel in deviceModel.subDevices) {
                    NSInteger deviceIdFromCloud = [param[@"deviceId"]integerValue];
                    NSInteger deviceIdAtLocal = subModel.deviceID;
                    if (deviceIdFromCloud == deviceIdAtLocal) {
                        NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithDictionary:param];
                        [subModel updateWithDictionary:dictionary];
                        break;
                    }
                }
            }
        }
    }
    [self removeDisableDevice];
}

- (void)updateDeviceRunstatus {
    if (self.updateGroupListFinish && [[UserEntity instance] userDataRequestSuccess]) {
        [self updateDisplayGroupId];
    }
}

- (void)removeDisableDevice {
    if (self.tunaDevice) {
        NSMutableArray *removeSubDevices = [NSMutableArray array];
        for (NSInteger i = 0; i < self.tunaDevice.subDevices.count; i++) {
            DeviceModel *subDevice = self.tunaDevice.subDevices[i];
            if (([subDevice.deviceType isEqualToString:HWDeviceTypeZone] || [subDevice.deviceType isEqualToString:HWDeviceType24hZone]) && !subDevice.enable) {
                [removeSubDevices addObject:subDevice];
            }
        }
        if (removeSubDevices.count > 0) {
            [self.tunaDevice.subDevices removeObjectsInArray:removeSubDevices];
        }
    }
}

#pragma  mark - HWScenarioControllable
- (void)checkControlAvailable:(CheckBlock)block{
//    if (!self.isOwner) {
//        block(NO,@"No Access");
//        return;
//    }
    BOOL canControl = [[[AppManager getLocalProtocol] getRole] canControlHome:self];
    if (canControl) {
        block(YES,nil);
    } else {
        block(NO,NSLocalizedString(@"videocall_notice_nopermission", nil));
    }
}
- (NSInteger)currentScenario{
    return self.targetStatus;
}
- (BOOL)isControlling{
    if (self.targetStatus == HWScenarioType_Invalid) {
        return NO;
    }
    return  YES;
}

- (void)scenarioControlWithCellModel:(HWModeCellModel *)model withCallback:(ControllBlock)callback {
    
}


- (void)controlToScenario:(NSInteger)scenarioId password:(NSString *)pwd type:(HomeScenarioType)type forceExecute:(BOOL)forceExecute RoomId:(NSInteger)roomId withCallback:(ControllBlock)callback {
    self.targetStatus = scenarioId;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@([self.locationID integerValue]) forKey:@"locationId"];
    [params setObject:@(scenarioId) forKey:@"scenario"];
    if (pwd && ![pwd isEqualToString:@""]) {
        [params setObject:[SHA256 hash:pwd] forKey:@"passwd"];
    }
    if (type == HomeScenarioTypeHome) {
        [params setObject:@(1) forKey:@"type"];
    }
    if (forceExecute) {
        [params setObject:@(forceExecute) forKey:@"forceExecute"];
    }
    
    NSInteger deviceCount = [self getScenarioDeviceCountWithScenario:scenarioId RoomId:roomId];
    NSString *scenarioString = [NSString stringWithFormat:@"%@",@(scenarioId)];
    if (deviceCount >= 0 ) {
        NSString *    socketType;
        if (roomId > 0) {
            socketType = kWebSocketMessageTypeRoomScenario;
             [params setObject:@(roomId) forKey:@"roomId"];
        }else{
            socketType =  kWebSocketMessageTypeScenario;
        }
        self.scenarioStatusDictionary = [NSMutableDictionary dictionary];
        self.scenarioMessageId = [[WebSocketManager instance] sendWithType:socketType
                                                                      data:params
                                                                      flag:WebSocketMessageFlagRequest
                                                                 messageId:nil];
        [TimerUtil scheduledDispatchTimerWithName:@"Scenario_Timeout" timeInterval:30 repeats:NO action:^{
            [self scenarioControlTimeout];
        }];
        [self.scenarioControlHistorys setObject:@{@"totalCount":@(deviceCount),@"currentCount":@(0),@"failedDevice":@[],@"responseSuccess":@(NO)} forKey:scenarioString];
    } else { //scenario不存在
        
    }
}

- (void)scenarioControlResponse:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    NSDictionary *msgData = userInfo[kWebSocketMsgData];
    NSString *msgId = userInfo[kWebSocketMsgId];
    BOOL isSameLocation = (([msgData[@"locationId"] integerValue] == [self.locationID integerValue]) || [msgId isEqualToString:self.scenarioMessageId]);
    if (isSameLocation) {
        if (([userInfo[@"errorCode"] integerValue] == HWErrorInternalServerError || [userInfo[@"errorCode"] integerValue] == HWErrorScenarioControlTimeOut)) {
            [self endScenarioControlWithUserInfo:userInfo];
        } else {
            NSInteger errorCode = [userInfo[kWebSocketErrorCode] integerValue];
            BOOL controlSuccess = (errorCode == HWNoError);
            NSInteger scenario = [msgData[@"scenario"] integerValue];
             NSInteger roomId = [msgData[@"roomId"] integerValue];
            NSString *scenarioString = [NSString stringWithFormat:@"%@",@(scenario)];
            NSString *msgFlag = userInfo[kWebSocketMsgFlag];
            if ([self.scenarioControlHistorys.allKeys containsObject:scenarioString]) {
                NSDictionary *info = self.scenarioControlHistorys[scenarioString];
                NSInteger totalCount = [info[@"totalCount"] integerValue];
                NSInteger currentCount = [info[@"currentCount"] integerValue];
                BOOL responseSuccess = [info[@"responseSuccess"] boolValue];
                NSArray *failedDevice = info[@"failedDevice"];
                currentCount += 1;
                if (!controlSuccess) {
                    NSMutableArray *devices = [NSMutableArray arrayWithArray:failedDevice];
                    if ([msgFlag isEqualToString:@"response"]) {
                        responseSuccess = controlSuccess;
                        if (msgData[@"abnormal"] && [msgData[@"abnormal"] count] > 0) {
                            for (NSInteger i = 0; i < [msgData[@"abnormal"] count]; i++) {
                                NSDictionary *dict = msgData[@"abnormal"][i];
                                if ([dict.allKeys containsObject:@"deviceId"]) {
                                    [devices addObject:dict];
                                }
                            }
                        }
                        NSArray *notControlDevices = [self scenarioDeviceIdsWithoutGatewayDevice:scenario roomId:roomId];
                        for (NSNumber *deviceId in notControlDevices) {
                            BOOL exist = NO;
                            NSDictionary *deviceInfo = @{@"deviceId":deviceId};
                            for (NSDictionary *info in devices) {
                                if ([info isEqualToDictionary:deviceInfo]) {
                                    exist = YES;
                                    break;
                                }
                            }
                            if (!exist) {
                                [devices addObject:deviceInfo];
                            }
                        }
                    } else {
                        if ([msgData.allKeys containsObject:@"deviceId"] && totalCount > 0) {
                            [devices addObject:@{@"deviceId":msgData[@"deviceId"]}];
                        }
                    }
                    failedDevice = devices;
                }
                self.scenarioControlHistorys[scenarioString] = @{@"totalCount":@(totalCount),@"currentCount":@(currentCount),@"failedDevice":failedDevice,@"responseSuccess":@(responseSuccess)};
                BOOL end = (totalCount <= currentCount) || ([msgFlag isEqualToString:@"response"] && !controlSuccess);
                if (end) {
                    BOOL success = ((failedDevice.count == 0) && !([msgFlag isEqualToString:@"response"] && !controlSuccess));
                    if (totalCount == 0) {
                        success = controlSuccess;
                    }
                    if (success) {
                        self.locationScenario = scenario;
                        [self endScenarioControlWithUserInfo:userInfo];
                    } else {
                        NSMutableDictionary *mutableUserInfo = [NSMutableDictionary dictionaryWithDictionary:userInfo];
                        NSMutableDictionary *mutableMsgData = [NSMutableDictionary dictionaryWithDictionary:msgData];
                        mutableMsgData[@"abnormal"] = failedDevice;
                        mutableUserInfo[kWebSocketMsgData] = mutableMsgData;
                        if (responseSuccess) {
                            mutableUserInfo[kWebSocketErrorCode] = @(9008);
                        } else {
                            if (errorCode == HWErrorWebSocketSecurePasswordInvalid
                                || errorCode == HWErrorScenarioPartlySynced
                                || errorCode == HWErrorScenarioSyncing
                                || errorCode == HWErrorScenarioPartlySuccess) {
                                mutableUserInfo[kWebSocketErrorCode] = @(errorCode);
                            } else {
                                mutableUserInfo[kWebSocketErrorCode] = @(HWErrorWebSocketHomeScenarioControlFailed);
                            }
                        }
                        [self endScenarioControlWithUserInfo:mutableUserInfo];
                    }
                    [self.scenarioControlHistorys removeObjectForKey:scenarioString];
                }
            }
        }
    } else if (!msgId && [userInfo[@"errorCode"] integerValue] == HWErrorInternalServerError) {
        [self endScenarioControlWithUserInfo:userInfo];
    }
}

- (void)scenarioControlTimeout {
    if (self.scenarioMessageId) {
        NSDictionary *userInfo = @{kWebSocketMsgId:self.scenarioMessageId,
                                   kWebSocketErrorCode:@(HWErrorScenarioControlTimeOut),
                                   kWebSocketMsgData:@{@"locationId":self.locationID}
                                   };
        [[NSNotificationCenter defaultCenter] postNotificationName:kWebSocketDidReceiveLocationScenarioResponseNotification object:self userInfo:userInfo];
    }
}

- (void)scenarioControlEnd {
    self.targetStatus = HWScenarioType_Invalid;
    self.scenarioMessageId = nil;
    [TimerUtil cancelTimerWithName:@"Scenario_Timeout"];
    [self.scenarioStatusDictionary removeAllObjects];
}

- (NSInteger)getScenarioDeviceCountWithScenario:(NSInteger)scenario RoomId:(NSInteger)roomId {
    HWScenarioModel *scenarioModel ;
       if (roomId >0) {
            HWGroupModel * group = [self getGroupById:roomId];
                  scenarioModel = [group getScenarioById:scenario];
       }else{
           scenarioModel = [self getScenarioById:scenario];
      
       }
    if (scenarioModel) {
        NSMutableArray *deviceIds = [NSMutableArray array];
        for (NSDictionary *deviceInfo in scenarioModel.deviceList) {
            NSInteger deviceId = [deviceInfo[@"deviceId"] integerValue];
            DeviceModel *deviceModel = [self getDeviceById:[NSString stringWithFormat:@"%@",@(deviceId)]];
            if (deviceModel.productClass == 4) {
                NSInteger parentDeviceId = deviceModel.parentDeviceId;
                if (![deviceIds containsObject:@(parentDeviceId)]) {
                    [deviceIds addObject:@(parentDeviceId)];
                }
            } else if (deviceModel) {
                [deviceIds addObject:@(deviceId)];
            }
        }
        return deviceIds.count;
    } else {
        return -1;
    }
}

- (NSArray *)scenarioDeviceIdsWithoutGatewayDevice:(NSInteger)scenario roomId:(NSInteger)roomId {
    HWScenarioModel *scenarioModel ;
    if (roomId >0) {
       HWGroupModel * group = [self getGroupById:roomId];
              scenarioModel = [group getScenarioById:scenario];
    }else{
          scenarioModel = [self getScenarioById:scenario];
       
    }
   
    if (scenarioModel) {
        NSMutableArray *deviceIds = [NSMutableArray array];
        for (NSDictionary *deviceInfo in scenarioModel.deviceList) {
            NSInteger deviceId = [deviceInfo[@"deviceId"] integerValue];
            DeviceModel *deviceModel = [self getDeviceById:[NSString stringWithFormat:@"%@",@(deviceId)]];
            if (deviceModel.productClass != 4) {
                [deviceIds addObject:@(deviceId)];
            }
        }
        return deviceIds;
    }
    return nil;
}



- (void)endScenarioControlWithUserInfo:(NSDictionary *)userInfo {
    [self scenarioControlEnd];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_ScenarioControl object:self userInfo:userInfo];
}
- (DeviceModel *)tunaDevice {
    DeviceModel *tunaDevice = nil;
    for (DeviceModel *model in self.devices) {
        if ([AppConfig isTunaDevice:model.deviceType]) {
            tunaDevice = model;
            break;
        }
    }
    return tunaDevice;
}

- (DeviceModel *)gatewayDeviceModel {
    DeviceModel *device = nil;
    for (DeviceModel *model in self.devices) {
        if (model.productClass == 3) {
            device = model;
            break;
        }
    }
    return device;
}

- (DeviceModel *)gldDeviceModel {
    DeviceModel *device = nil;
    for (DeviceModel *model in self.devices) {
        if ([model.deviceType isEqualToString:HWDeviceTypeGLD]) {
            device = model;
            break;
        }
    }
    return device;
}

- (NSArray *)getDeviceListWithGroupId:(NSInteger)groupId {
    return @[];
}

- (HWGroupModel *)getGroupById:(NSInteger)groupId {
    HWGroupModel *groupModel = nil;
    for (NSInteger i = 0; i < self.groups.count; i++) {
        HWGroupModel *model = self.groups[i];
        if (model.groupId == groupId) {
            groupModel = model;
            break;
        }
    }
    return groupModel;
}

- (HWGroupModel *)getGroupByDeviceId:(NSInteger)deviceId {
    for (NSInteger i = 0; i < self.groups.count; i++) {
        HWGroupModel *model = self.groups[i];
        if ([model containsDeviceId:deviceId]) {
            return model;
        }
    }
    return nil;
}

- (void)createGroupWithParams:(NSDictionary *)params callBack:(HWAPICallBack)callBack {
    __weak typeof (self) weakSelf = self;
    [self.createGroupAPIManager callAPIWithParam:params completion:^(id object, NSError *error) {
        if (!error) {
            for (int i = 0; i < [(NSArray *)object count]; i++) {
                NSDictionary *groupObject = object[i];
                NSInteger groupId = [groupObject[@"groupId"] integerValue];
                NSMutableDictionary *groupDict = [NSMutableDictionary dictionary];
                [groupDict addEntriesFromDictionary:params[@"groupList"][i]];
                groupDict[@"groupId"] = groupObject[@"groupId"];
                HWGroupModel *groupModel = [[HWGroupModel alloc] initWithDictionary:@{@"groupId":@(groupId),@"groupName":(params[@"groupName"])?:@""}];
                groupModel.homeModel = self;
                [weakSelf.groups addObject:groupModel];
            }
            [[UserEntity instance] updateGroupList];
        }
        callBack(object, error);
    }];
}

- (void)groupEditDeviceWithParams:(NSDictionary *)params callBack:(HWAPICallBack)callBack {
    [self.editDeviceAPIManager callAPIWithParam:params completion:^(id object, NSError *error) {
        if (!error) {
            [[UserEntity instance] updateGroupList];
        }
        callBack(object, error);
    }];
}

- (void)getUnreadEventCount {
    NSDictionary * params = @{@"locationId" : @([self.locationID integerValue])};
    [self.historyEventCountAPIManager callAPIWithParam:params completion:^(id object, NSError *error) {
        if (!error) {
            if ([object isKindOfClass:[NSDictionary class]]) {
                NSDictionary * response = (NSDictionary *)object;
                self.unreadEventCount = [response[@"unread"]integerValue];
                NSDictionary * userInfo = @{@"locationId" : @([self.locationID integerValue])};
                [[NSNotificationCenter defaultCenter]postNotificationName:kNotification_UpdateUnreadEventCount object:nil userInfo:userInfo];
            }
        }
    }];
}

- (void)removeGroupWithParams:(NSDictionary *)params callBack:(HWAPICallBack)callBack {
    __weak typeof (self) weakSelf = self;
    [self.removeGroupAPIManager callAPIWithParam:params completion:^(id object, NSError *error) {
        if (!error) {
            NSInteger groupId = [params[@"groups"][0][@"groupId"] integerValue];
            HWGroupModel *model = [weakSelf getGroupById:groupId];
            if (model) {
                [weakSelf.groups removeObject:model];
            }
            [[UserEntity instance] updateGroupList];
        }
        callBack(object, error);
    }];
}

- (void)getNotMatchDevicesWithCallBack:(HWAPICallBack)callBack {
    __weak typeof (self) weakSelf = self;
    if (self.locationID) {
        [self.notMatchDevicesAPIManager callAPIWithParam:@{@"locationId":@([self.locationID integerValue])} completion:^(id object, NSError *error) {
            if (!error) {
                if ([object isKindOfClass:[NSDictionary class]]) {
                    weakSelf.notMatchDeviceIds = object[@"deviceIds"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_NotMatchDevicesRefresh object:self userInfo:@{@"locationId":@([self.locationID integerValue])}];
                }
            }
            if (callBack) {
                callBack(object,error);
            }
        }];
    }
}

- (void)updateEventData:(NSNotification *)notification {
    id userInfo = notification.userInfo;
    if (userInfo != nil) {
        if ([userInfo isKindOfClass:[NSArray class]]) {
            NSArray<NSDictionary *> * alarmArray = (NSArray<NSDictionary *> *)userInfo;
            for (NSDictionary * dic in alarmArray) {
                NSInteger locationId = [dic[@"locationId"]integerValue];
                if (locationId == [self.locationID integerValue]) {
                    [self getUnreadEventCount];
                }
            }
        } else if ([userInfo isKindOfClass:[NSDictionary class]]) {
            NSInteger locationId = 0;
            if ([[userInfo allKeys] containsObject:@"locationId"]) {
                locationId = [userInfo[kUrl_LocationId] integerValue];
            } else if (userInfo[@"msgData"] && userInfo[@"msgData"][@"locationId"]) {
                locationId = [userInfo[@"msgData"][@"locationId"] integerValue];
            }
            
            if (locationId == [self.locationID integerValue]) {
                [self getUnreadEventCount];
            }
        }
    }
}

- (NSArray *)notMatchDevices {
    NSMutableArray *notMatchDevices = [NSMutableArray array];
    for (NSNumber *deviceIdObject in self.notMatchDeviceIds) {
        NSInteger deviceId = [deviceIdObject integerValue];
        DeviceModel *device = [self getDeviceById:[NSString stringWithFormat:@"%ld", (long)deviceId]];
        if (device) {
            [notMatchDevices addObject:device];
        }
    }
    return notMatchDevices;
}

- (NSArray<HWGroupModel *> *)sortedGroups {
    NSArray<HWGroupModel *> * sortedGroups = [self .groups sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        HWGroupModel * groupModel1 = (HWGroupModel *)obj1;
        HWGroupModel * groupModel2 = (HWGroupModel *)obj2;
        NSComparisonResult comparisonResult = [groupModel1.groupName localizedCompare:groupModel2.groupName];
        return comparisonResult;
    }];
    return sortedGroups;
}

- (void)updateDisplayGroupId {
    HWGroupModel *tempGroup = [self getGroupById:self.displayTempRoomId];
    HWGroupModel *pm25Group = [self getGroupById:self.displayPm25RoomId];
    HWGroupModel *humGroup = [self getGroupById:self.displayHumRoomId];
    if ([tempGroup getRoomTemp] && [pm25Group getRoomPM25] && [humGroup getRoomHum]) {
        [UserConfig saveUser];
        return;
    }
    for (NSInteger i = 0; i < self.groups.count; i++) {
        HWGroupModel *model = self.groups[i];
        if (![tempGroup getRoomTemp] && [model getRoomTemp]) {
            self.displayTempRoomId = model.groupId;
            tempGroup = model;
        }
        if (![pm25Group getRoomPM25] && [model getRoomPM25]) {
            self.displayPm25RoomId = model.groupId;
            pm25Group = model;
        }
        if (![humGroup getRoomHum] && [model getRoomHum]) {
            self.displayHumRoomId = model.groupId;
            humGroup = model;
        }
        if ([tempGroup getRoomTemp] && [pm25Group getRoomPM25] && [humGroup getRoomHum]) {
            break;
        }
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_UpdateDisplayGroupSucceed object:nil userInfo:@{kLocation_ID:self.locationID}];
    [UserConfig saveUser];
}

- (HWGroupRemoveAPIManager *)removeGroupAPIManager {
    if (!_removeGroupAPIManager) {
        _removeGroupAPIManager = [[HWGroupRemoveAPIManager alloc] init];
    }
    return _removeGroupAPIManager;
}

- (HWGroupCreateAPIManager *)createGroupAPIManager {
    if (!_createGroupAPIManager) {
        _createGroupAPIManager = [[HWGroupCreateAPIManager alloc] init];
    }
    return _createGroupAPIManager;
}

- (HWGroupEditDeviceAPIManager *)editDeviceAPIManager {
    if (!_editDeviceAPIManager) {
        _editDeviceAPIManager = [[HWGroupEditDeviceAPIManager alloc] init];
    }
    return _editDeviceAPIManager;
}

- (HWBackHomeAPIManager *)backHomeAPIManager {
    if (_backHomeAPIManager == nil) {
        _backHomeAPIManager = [[HWBackHomeAPIManager alloc] init];
    }
    return _backHomeAPIManager;
}

- (HWLocationScenarioControlAPIManager *)locationScenarioControlAPIManager {
    if (_locationScenarioControlAPIManager == nil) {
        _locationScenarioControlAPIManager = [[HWLocationScenarioControlAPIManager alloc] init];
    }
    return _locationScenarioControlAPIManager;
}

- (HWDeleteDeviceAPIManager *)deleteDeviceManager {
    _deleteDeviceManager = [[HWDeleteDeviceAPIManager alloc] init];
    return _deleteDeviceManager;
}

- (HWNotMatchDevicesAPIManager *)notMatchDevicesAPIManager {
    if (!_notMatchDevicesAPIManager) {
        _notMatchDevicesAPIManager = [[HWNotMatchDevicesAPIManager alloc] init];
    }
    return _notMatchDevicesAPIManager;
}

- (HWLocaitonScenarioByIdAPIManager *)locationScenarioByIdAPIManager {
    if (!_locationScenarioByIdAPIManager) {
        _locationScenarioByIdAPIManager = [[HWLocaitonScenarioByIdAPIManager alloc] init];
    }
    return _locationScenarioByIdAPIManager;
}

- (HWLocationScheduleListByIdAPIManager *)locationScheduleByIdAPIManager {
    if (!_locationScheduleByIdAPIManager) {
        _locationScheduleByIdAPIManager = [[HWLocationScheduleListByIdAPIManager alloc] init];
    }
    return _locationScheduleByIdAPIManager;
}

- (HWRoomScenarioByIdAPIManager *)roomScenarioByIdAPIManager {
    if (!_roomScenarioByIdAPIManager) {
        _roomScenarioByIdAPIManager = [[HWRoomScenarioByIdAPIManager alloc] init];
    }
    return _roomScenarioByIdAPIManager;
}

- (HWLocationTriggerListAPIManager *)locationTriggerListAPIManager {
    if (!_locationTriggerListAPIManager) {
        _locationTriggerListAPIManager = [[HWLocationTriggerListAPIManager alloc] init];
    }
    return _locationTriggerListAPIManager;
}

- (HWHistoryEventCountAPIManager *)historyEventCountAPIManager {
    if (!_historyEventCountAPIManager) {
        _historyEventCountAPIManager = [[HWHistoryEventCountAPIManager alloc]init];
    }
    return _historyEventCountAPIManager;
}

- (HWHistoryEventReadAPIManager *)eventReadAPIManager {
    if (!_eventReadAPIManager) {
        _eventReadAPIManager = [[HWHistoryEventReadAPIManager alloc]init];
    }
    return _eventReadAPIManager;
}

- (NSArray<HWScenarioModel *> *)favoriteScenarios {
    NSMutableArray<HWScenarioModel *> * favoriteScenarios = [NSMutableArray array];
    for (NSInteger i = 0; i < self.scenarioList.count;i++) {
        HWScenarioModel *scenarioModel = self.scenarioList[i];
        if (scenarioModel.isFavorite) {
            [favoriteScenarios addObject:scenarioModel];
        }
    }
    return favoriteScenarios;
}

- (ArmStatusType)armStatus {
    NSUInteger armCount = 0;
    NSUInteger disarmCount = 0;
    NSArray<DeviceModel *> * allDevices = [self getAllDevice];
    for (DeviceModel * deviceModel in allDevices) {
        if ([deviceModel.deviceType isEqualToString:HWDeviceTypeZone]) {
            if (deviceModel.armStatus == DeviceArmStatusTypeDisarm) {
                disarmCount++;
            } else {
                armCount++;
            }
        }
    }
    if (armCount == 0 && disarmCount == 0) {
        return ArmStatusTypeNone;
    } else if (armCount > 0 && disarmCount > 0) {
        return ArmStatusTypePartialArm;
    } else if (armCount > 0 && disarmCount == 0) {
        return ArmStatusTypeAllArm;
    } else {
        return ArmStatusTypeDisarm;
    }
}

- (HWScheduleModel *)upcomingSchedule {
    if (self.scheduleList.count == 0) {
        return nil;
    } else {
        NSMutableArray *scheduleList = [NSMutableArray array];
        
        for (HWScheduleModel *upcommingSchedule in self.scheduleList) {
            BOOL enable = upcommingSchedule.enable;
            if (enable) {
                if (upcommingSchedule.nextScheduleDate != nil) {
                    [scheduleList addObject:upcommingSchedule];
                }
            }
        }
        
        if (scheduleList.count > 0) {
            [scheduleList sortUsingComparator:^NSComparisonResult(HWScheduleModel *obj1, HWScheduleModel *obj2) {
                return [obj1.nextScheduleDate compare:obj2.nextScheduleDate];
            }];
            return scheduleList[0];
        } else {
            return nil;
        }
    }
}

- (void)readEventWithId:(long long)eventId {
    NSArray<NSNumber *> * eventIds = @[
                                       @(eventId)
                                       ];
    [self.eventReadAPIManager callAPIWithParam:eventIds completion:^(id object, NSError *error) {
        if (error == nil) {
            [self getUnreadEventCount];
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_UpdateEventReadStatus object:@{@"eventId":@(eventId),@"locationId":self.locationID}];
        }
    }];
}

- (BOOL)checkDeviceName:(NSString *)deviceName deviceId:(NSInteger)deviceId {
    BOOL nameValid = NO;
    for (DeviceModel *d in self.devices) {
        if (d.deviceID == deviceId) {
            continue;
        }
        if (deviceName && [[d.name lowercaseString] isEqualToString:[deviceName lowercaseString]]) {
            nameValid = YES;
        } else {
            for (DeviceModel *subDevice in d.subDevices) {
                if (subDevice.deviceID == deviceId) {
                    continue;
                }
                if (deviceName && [[subDevice.name lowercaseString] isEqualToString:[deviceName lowercaseString]]) {
                    nameValid = YES;
                }
            }
        }
    }
    return nameValid;
}

+ (NSString *)getDefaultSceneTypeName:(NSInteger)nameType {
    switch (nameType) {
        case 1:
            return NSLocalizedString(@"scenes_lbl_home", nil);
        case 2:
            return NSLocalizedString(@"scenes_lbl_away", nil);
        case 3:
            return NSLocalizedString(@"scenes_lbl_sleep", nil);
        case 4:
            return NSLocalizedString(@"scenes_lbl_awake", nil);
        case 5:
            return NSLocalizedString(@"scenes_lbl_movie", nil);
        case 6:
            return NSLocalizedString(@"scenes_lbl_party", nil);
        case 7:
            return NSLocalizedString(@"scenes_lbl_reading", nil);
        case 8:
            return NSLocalizedString(@"scenes_lbl_dinning", nil);
        case 9:
            return NSLocalizedString(@"scenes_lbl_roomallon", nil);
        case 10:
            return NSLocalizedString(@"scenes_lbl_roomalloff", nil);
        case 11:
            return NSLocalizedString(@"scenes_lbl_bright", nil);
        case 12:
            return NSLocalizedString(@"scenes_lbl_warm", nil);
        case 13:
            return NSLocalizedString(@"scenes_lbl_cozy", nil);
        case 14:
            return NSLocalizedString(@"scenes_lbl_romantic", nil);
        case 15:
            return NSLocalizedString(@"scenes_lbl_entertainment", nil);
        case 16:
            return NSLocalizedString(@"scenes_lbl_gaming", nil);
        case 17:
            return NSLocalizedString(@"scenes_lbl_rest", nil);
        case 18:
            return NSLocalizedString(@"scenes_lbl_music", nil);
        case 19:
            return NSLocalizedString(@"scenes_lbl_deepnight", nil);
        default:
            return @"";
    }
}
@end
