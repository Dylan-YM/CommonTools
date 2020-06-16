//
//  UserEntity.m
//  AirTouch
//
//  Created by huangfujun on 15/5/5.
//  Copyright (c) 2015年 Honeywell. All rights reserved.
//

#import "UserEntity.h"
#import "DeviceModel.h"
#import "HomeModel.h"
#import "OutdoorWeatherManager.h"
#import "DataManager.h"
#import "AppManager.h"
#import "AppConfig.h"
#import "AppMarco.h"
#import "HWImageCache.h"
#import "UserConfig.h"
#import "CryptoUtil.h"
#import "ModelKey.h"
#import "LogUtil.h"
#import "HWAutoLoginAPIManager.h"
#import "HWMessageCountAPIManager.h"
#import "HWLocationListAPIManager.h"
#import "HWDevicesListAPIManager.h"
#import "HWFrequentUsedDeviceAPIManager.h"
#import "HWLocationAddAPIManager.h"
#import "HWLocationEditAPIManager.h"
#import "HWLocationDeleteAPIManager.h"
#import "HWAllDeviceRunStatusAPIManager.h"
#import "TimerUtil.h"
#import "LocationManager.h"
#import "HWUpdateLanguageManager.h"
#import "HWLogoutAPIManager.h"
#import "HWLocationSetDefaultHomeAPIManager.h"

#import "WebSocketConfig.h"
#import "WebSocketManager.h"
#import "AuthenticationManager.h"
#import "HWGroupListAPIManager.h"
#import "HWCityManager.h"
#import "HWLocationScenarioListApiManager.h"
#import "HWRoomScenarioListAPIManager.h"
#import "HWLocationScheduleListAPIManager.h"
#import "HWTriggerListAPIManager.h"

#import <UserNotifications/UserNotifications.h>

#if !(TARGET_IPHONE_SIMULATOR)
//WindowAzure Notification Hub framework
#import "NotificationHubConfig.h"
#endif

@interface UserEntity()

@property (assign, nonatomic) BOOL userDataRequestSuccess;

@property (nonatomic, assign) NSTimeInterval lastRefreshTime;
/**
 *  本次加载家的列表时，家的列表相对于上次是否有变动
 */
@property (nonatomic, assign) BOOL locationsModified;

@property (nonatomic, strong) NSMutableArray<HomeModel *> *entities;//保持对location entity 和devices entity 的引用

@property (nonatomic, strong) HWDataBaseManager *userDBManager;

@property (nonatomic, strong) HWMessageCountAPIManager          *messageCountAPIManager;
@property (nonatomic, strong) HWLocationListAPIManager          *locationListAPIManager;
@property (nonatomic, strong) HWDevicesListAPIManager           *deviceListAPIManager;
@property (nonatomic, strong) HWFrequentUsedDeviceAPIManager    *frequentlyUsedDeviceAPIManager;
@property (nonatomic, strong) HWLocationAddAPIManager           *locationAddAPIManager;
@property (nonatomic, strong) HWLocationEditAPIManager          *locationEditAPIManager;
@property (nonatomic, strong) HWLocationDeleteAPIManager        *locationDeleteAPIManager;
@property (nonatomic, strong) HWAllDeviceRunStatusAPIManager    *deviceRunStatusManager;
@property (nonatomic, strong) HWLogoutAPIManager                *logoutAPIManager;
@property (nonatomic, strong) HWLocationSetDefaultHomeAPIManager *locationSetDefaultHomeAPIManager;
@property (nonatomic, strong) HWGroupListAPIManager             *groupListAPIManager;
@property (nonatomic, strong) HWLocationScenarioListApiManager             *locationScenarioListAPIManager;
@property (nonatomic, strong) HWRoomScenarioListAPIManager *roomScenarioListAPIManager;
@property (nonatomic, strong) HWLocationScheduleListAPIManager *locationScheduleListAPIManager;
@property (nonatomic, strong) HWTriggerListAPIManager *triggerListAPIManager;

@end

#define USER_ENTITY_REFRESH_INTERVAL 10.0

@implementation UserEntity

+(UserEntity *)instance
{
    static UserEntity * sharedInstance = nil;
    if (sharedInstance == nil) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            sharedInstance = [[UserEntity alloc]init];
        });
        [sharedInstance loadHistoryData];
    }
    return sharedInstance;
}

-(instancetype)init
{
    self = [super init];
    if (self) {
        _status = UserStatusLogout;
       
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(unBindDevice) name:kWebSocketDidReceiveUnBindDeviceResponseNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateOnline:) name:kWebSocketDidReceiveDeviceOnlineResponseNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateDeviceRunStatus:) name:kWebSocketDidReceiveDeviceRunStatusResponseNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(webSocketStateDidChanged) name:kWebSocketStateDidChangeNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNotificationToRefreshLocations:) name:kWebSocketDidReceiveAuthorityAcceptResponseNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNotificationToRefreshLocations:) name:kWebSocketDidReceiveAuthorityGrantResponseNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNotificationToRefreshLocations:) name:kWebSocketDidReceiveAuthorityRejectResponseNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNotificationToRefreshLocations:) name:kWebSocketDidReceiveAuthorityRemoveResponseNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNotificationToRefreshLocations:) name:kWebSocketDidReceiveAuthorityRevokeResponseNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNotificationToRefreshLocations:) name:kWebSocketDidReceiveAuthorityEditResponseNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNotificationToRefreshLocations:) name:kWebSocketDidReceiveRegisterDeviceResponseNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateGroupList) name:kWebSocketDidReceiveGroupChangeResponseNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNotificationToRefreshScenario:) name:kWebSocketDidReceiveScenarioChangeResponseNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNotificationToRefreshRoomScenario:) name:kWebSocketDidReceiveRoomScenarioChangeResponseNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNotificationToRefreshSchedule:) name:kWebSocketDidReceiveScheduleChangeResponseNotificaiton object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNotificationToRefreshSchedule:) name:kWebSocketDidReceiveLocationScheduleExecutedResponseNotificaiton object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNotificationToRefreshTrigger:) name:kWebSocketDidReceiveTriggerChangeResponseNotificaiton object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNotificationToRefreshLocations:) name:kWebsocketDidReceiveLocationChangeNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateDeviceList:) name:kWebSocketDidReceiveDeviceChangeResponseNotification object:nil];
    }
    return self;
}

//- (void)enterForeground {
//    [self updateAllLocations:nil deviceListBlock:nil runStatusBlock:nil reload:YES newRequest:NO];
//}

-(void)loadHistoryData
{
    NSDictionary * dict = [UserConfig getUserInfo];
    
    if (dict != nil || [dict allKeys].count > 0) {
        self.loginToken = dict[@"loginToken"];
        NSString *salt = [dict objectForKey:@"salt"];
        if (salt.length > 0) {
            self.salt = [dict objectForKey:@"salt"];
        } else {
            self.salt = nil;
        }
    }
}

-(void)importData:(NSDictionary *)dict
{
    NSString *originPassword = nil;
    if ([UserConfig getUserInfo] && [[[UserConfig getUserInfo] allKeys] containsObject:@"username"]) {
        originPassword = [[UserConfig getUserInfo] objectForKey:@"username"];
    }
    BOOL sameUser = [[dict objectForKey:@"username"] isEqualToString:originPassword];
    self.userID = [[dict objectForKey:@"userID"] integerValue];
    self.username = [dict objectForKey:@"username"];
    self.email = [dict objectForKey:@"email"];
    self.country = [dict objectForKey:@"country"];
    self.isActivated = [[dict objectForKey:@"isActivated"] boolValue];
    self.userType = [[dict objectForKey:@"userType"]integerValue];
    self.nickname = [dict objectForKey:@"nickname"];
    self.countryPhoneNum = [dict objectForKey:@"countryCode"];
    self.wsUrl = [dict objectForKey:@"wsUrl"];
    self.userGender = [[dict objectForKey:@"gender"] integerValue];
    
    BOOL alertError = (dict && [[dict allKeys] containsObject:@"errorMsg"]);
    NSString *errorMsg = alertError?dict[@"errorMsg"]:nil;
    
    if (self.userID != 0) {
        [self setStatus:UserStatusLogin sameUser:sameUser alertMsg:nil];
        if ([dict objectForKey:@"locations"]) {
            [self updateLocationInfoWithData:dict[@"locations"] reload:YES];
        }
    } else {
        [self setStatus:UserStatusLogout sameUser:sameUser alertMsg:(alertError?errorMsg:nil)];
    }
    [[HWCityManager shareCityManager] resetBaseInfo];
}

- (void)refreshUserEntity:(BOOL)refresh {
    if (refresh) {
        NSDictionary * dict = [UserConfig getUserInfo];
        if (dict != nil || [dict allKeys].count > 0) {
            [self importData:dict];
        }
    }
}

-(NSDictionary *)convertToDictionary
{
    NSMutableArray *locations = [NSMutableArray array];
    for (HomeModel *home in self.entities) {
        [locations addObject:[home convertToDictionary]];
    }
    NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:
                           [NSString stringWithFormat:@"%ld",(long)self.userID],@"userID",
                           self.username, @"username",
                           self.country, @"country",
                           self.nickname, @"nickname",
                           self.countryPhoneNum, @"countryCode",
                           (self.wsUrl?:@[]), @"wsUrl",
                           locations,@"locations",
                           [NSString stringWithFormat:@"%d", self.isActivated],@"isActivated",
                           [NSString stringWithFormat:@"%ld",(long)self.userType], @"userType",
                           (self.salt?:@""), @"salt",
                           (self.loginToken?:@""), @"loginToken", nil];
    
    return dict;
}

-(void)clean
{
    self.userID = 0;
    self.isEnterprise = NO;
    self.username = nil;
    self.firstname = nil;
    self.lastname = nil;
    self.streetAddress = nil;
    self.city = nil;
    self.state = nil;
    self.zipcode = nil;
    self.country = nil;
    self.countryPhoneNum = nil;
    self.userLanguage = nil;
    self.isActivated = NO;
    self.deviceCount = 0;
    self.tenantID = 0;
    self.userType = UserTypePersonal;
    self.nickname = nil;
    self.salt = nil;
    self.loginToken = nil;
    
    NSString *originCode = [UserConfig getCurrentLocationCode];
    for (HomeModel *homeModel in _entities) {
        if (![homeModel.city isEqualToString:originCode]) {
            [[OutdoorWeatherManager instance] removeCityCode:homeModel.city];
        }
    }
    
    [_entities removeAllObjects];
    _entities = nil;
    _homeLoadingStatus = HomeLoadingStatusLoading;
    [self stopRefreshTimer];
    [self cancelHttpRequest];
    [UserConfig clearUser];
    [UserConfig clearMessages];
    [UserConfig clearPM25];
    
    [UserConfig clearSecurityMethod];
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 1];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 0];
    
    [UserConfig clearCookie];
}

- (void)setUsername:(NSString *)username {
    _username = username;
    [HWAutoLoginAPIManager setUsername:_username];
}

-(void)setLoginToken:(NSString *)loginToken
{
    _loginToken = loginToken;
    [HWAutoLoginAPIManager setLoginToken:_loginToken];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_LoginTokenChanged object:self userInfo:nil];
}

- (BOOL)isEnterprise {
    return self.userType == UserTypeEnterprise;
}

- (void)setEnterprise:(BOOL)enterprise {
    if (enterprise) {
        self.userType = UserTypeEnterprise;
    } else {
        self.userType = UserTypePersonal;
    }
}

-(void)updateLocationInfoWithData:(NSArray *)params reload:(BOOL)reload
{
    if (!_entities) {
        _entities = [NSMutableArray array];
    }
    //倒序排列
    for (int i = (int)_entities.count - 1; i >=0; i--) {
        HomeModel * homeModel = _entities[i];
        BOOL find = NO;
        for (NSDictionary * subDic in params) {
            if ([homeModel.locationID integerValue] == [[subDic objectForKey:kLocation_ID] integerValue])
            {
                find = YES;
                if (![subDic[kLocation_Name] isEqualToString:homeModel.name]) {
                    self.locationsModified = YES;
                }
                [homeModel updateWithDictionary:subDic reload:reload];//updateByDictionary
                break;
            }
        }
        
        if (find == NO) {
            //delete
            [_entities removeObject:homeModel];
            self.locationsModified = YES;
        }
    }
    
    for (int i = 0; i < params.count; i++) {
        NSDictionary * subDic = params[i];
        BOOL find = NO;
        for (HomeModel * homeModel in _entities) {
            if ([homeModel.locationID integerValue] == [[subDic objectForKey:kLocation_ID] integerValue]) {
                find = YES;
                break;
            }
        }
        
        if (find == NO) {
            //insert
            //init 方法与update方法保持一致
            HomeModel * homeModel = [[HomeModel alloc]initWithDictionary:subDic reload:YES];
            [_entities insertObject:homeModel atIndex:i];
            self.locationsModified = YES;
        }
    }
    
    [self sortAllEntities];
}

- (void)updateDeviceInfoWithData:(NSArray *)devices {
    for (HomeModel *home in self.entities) {
        NSMutableArray *deviceDicts = [NSMutableArray array];
        for (NSDictionary *device in devices) {
            NSString *locationId = device[@"locationId"];
            if ([home.locationID integerValue] == [locationId integerValue]) {
                [deviceDicts addObject:device];
            }
        }
        [home updateDeviceMetaInfoWithData:deviceDicts reload:YES];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:HomeModelDidUpdateNotification object:self userInfo:@{kLocation_ID:home.locationID}];
    }
}

- (void)sortAllEntities
{
    //按照自己的家和授权的家进行排序，自己的家排在前面，授权的家排在后面
//    [_entities sortUsingComparator:^NSComparisonResult(HomeModel * obj1, HomeModel * obj2) {
//        NSComparisonResult ownerResult = [@(obj2.isOwner) compare:@(obj1.isOwner)];
//        if (ownerResult != NSOrderedSame) {
//            return ownerResult;
//        } else {
//            return [obj1.ownerName compare:obj2.ownerName];
//        }
//    }];
}

-(void)loadCityBackgroundPicturesAndWeather {
    NSMutableArray *cities = [NSMutableArray array];
    for (HomeModel *homeModel in _entities) {
        if (homeModel.city
            && ![cities containsObject:homeModel.city]) {
            [cities addObject:homeModel.city];
        }
    }
    
    if ([UserConfig getCurrentCityCode] != nil) {
        [cities addObject:[UserConfig getCurrentCityCode]];
    }
    
    BOOL supportWeather = [[AppManager getLocalProtocol] supportWeatherEffect];
    if (supportWeather) {
        for (NSString *cityCode in cities) {
            [[OutdoorWeatherManager instance]addCityCodeAndLoadData:cityCode];
        }
    }
    [[HWImageCache sharedInstance] updateCityBackground:cities];
}

#pragma mark - scenario
- (void)getNotificationToRefreshScenario:(NSNotification *)noti {
    NSDictionary *userInfo = noti.userInfo;
    NSDictionary *msgData = userInfo[@"msgData"];
    BOOL refreshSingle = NO;
    if (msgData) {
        if ([[msgData allKeys] containsObject:@"locationId"]) {
            NSInteger locationId = [msgData[@"locationId"] integerValue];
            HomeModel *homeModel = [self getHomebyId:[NSString stringWithFormat:@"%ld",(long)locationId]];
            if (homeModel) {
                refreshSingle = YES;
                [homeModel updateHomeScenarioList];
            }
        }
    }
    if (!refreshSingle) {
        [self updateScenarioList];
    }
}

- (void)getNotificationToRefreshRoomScenario:(NSNotification *)noti {
    NSDictionary *userInfo = noti.userInfo;
    NSDictionary *msgData = userInfo[@"msgData"];
    BOOL refreshSingle = NO;
    if (msgData) {
        if ([[msgData allKeys] containsObject:@"locationId"]) {
            NSInteger locationId = [msgData[@"locationId"] integerValue];
            HomeModel *homeModel = [self getHomebyId:[NSString stringWithFormat:@"%ld",(long)locationId]];
            if (homeModel) {
                refreshSingle = YES;
                [homeModel updateRoomScenarioList];
            }
        }
    }
    if (!refreshSingle) {
        [self updateRoomScenarioList];
    }
}

- (void)getNotificationToRefreshSchedule:(NSNotification *)noti {
    NSDictionary *userInfo = noti.userInfo;
    NSDictionary *msgData = userInfo[@"msgData"];
    BOOL refreshSingle = NO;
    if (msgData) {
        if ([[msgData allKeys] containsObject:@"locationId"]) {
            NSInteger locationId = [msgData[@"locationId"] integerValue];
            HomeModel *homeModel = [self getHomebyId:[NSString stringWithFormat:@"%ld",(long)locationId]];
            if (homeModel) {
                refreshSingle = YES;
                [homeModel updateHomeScheduleList];
            }
        }
    }
    if (!refreshSingle) {
        [self updateScheduleList];
    }
}

- (void)getNotificationToRefreshTrigger:(NSNotification *)noti {
    NSDictionary *userInfo = noti.userInfo;
    NSDictionary *msgData = userInfo[@"msgData"];
    BOOL refreshSingle = NO;
    if (msgData) {
        if ([[msgData allKeys] containsObject:@"locationId"]) {
            NSInteger locationId = [msgData[@"locationId"] integerValue];
            HomeModel *homeModel = [self getHomebyId:[NSString stringWithFormat:@"%ld",(long)locationId]];
            if (homeModel) {
                refreshSingle = YES;
                [homeModel updateTriggerList];
            }
        }
    }
    if (!refreshSingle) {
        [self updateTriggerList];
    }
}

#pragma mark - authorize
#pragma mark - Notificaiton
- (void)updateDeviceList:(NSNotificationCenter *)noti {
    [self updateDeviceListCompletion:nil runStatusBlock:nil newRequest:NO];
}

- (void)getNotificationToRefreshLocations:(NSNotification *)noti {
    [self updateAllLocations:nil deviceListBlock:nil runStatusBlock:nil reload:YES newRequest:NO];
}

-(void)updateAllLocations:(HWAPICallBack)block deviceListBlock:(HWAPICallBack)deviceBlock runStatusBlock:(HWAPICallBack)runStatusBlock reload:(BOOL)reload newRequest:(BOOL)newRequest {
//    NSTimeInterval interval = [[NSDate date] timeIntervalSince1970];
//    if (interval - self.lastRefreshTime < USER_ENTITY_REFRESH_INTERVAL) {
//        if (block) {
//            block(nil, [NSError errorWithDomain:@"Call this api too often! please use property `pause` to manual update" code:NSURLErrorCancelled userInfo:nil]);
//        }
//        return;
//    }
//    self.lastRefreshTime = interval;
    
    HWLocationListAPIManager *manager = self.locationListAPIManager;
    if (newRequest) {
        manager = [[HWLocationListAPIManager alloc] init];
    }
    
    NSDictionary *dict = @{@"userId":[NSString stringWithFormat:@"%ld", (long)self.userID]};
    [manager callAPIWithParam:dict completion:^(id object, NSError *error) {
        if (error.code == NSURLErrorCancelled) {
            _userDataRequestSuccess = NO;
            if (block) {
                block(nil, [NSError errorWithDomain:@"" code:error.code userInfo:nil]);
            }
            return;
        }
        self.locationsModified = NO;
        
        // 如果是登录后第一次加载家的列表，无论列表有无变化，都把_locationModified设置为YES
        if (_homeLoadingStatus == HomeLoadingStatusLoading) {
            self.locationsModified = YES;
        }
        
        if (!error)
        {
//            [LogUtil Debug:@"AllLocations" message:object];
            if ([object isKindOfClass:[NSDictionary class]])
            {
                [self updateLocationInfoWithData:object[@"locations"] reload:reload];
                [self loadCityBackgroundPicturesAndWeather];
                [UserConfig saveUser];
            }
            if (_homeLoadingStatus != HomeLoadingStatusSuccess) {
                _homeLoadingStatus = HomeLoadingStatusSuccess;
                self.locationsModified = YES;
            }
            [self updateDeviceListCompletion:deviceBlock runStatusBlock:runStatusBlock newRequest:newRequest];
            
            [self updateGroupList];
            
            [self updateScenarioList];
            
            [self updateScheduleList];
            
            [self updateTriggerList];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_sbc_location_list object:nil];
            
        } else {
            _userDataRequestSuccess = NO;
            if (_homeLoadingStatus == HomeLoadingStatusLoading) {
                _homeLoadingStatus = HomeLoadingStatusFailed;
                self.locationsModified = YES;
            }
            if (error.code != NSURLErrorCancelled) {
                self.deviceListFinishLoading = YES;
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_DeviceListLoaded object:nil];
            }
            if (deviceBlock) {
                deviceBlock(nil,error);
            }
            if (runStatusBlock) {
                runStatusBlock(nil,error);
            }
        }
        
        if (self.locationsModified) {
            NSDictionary * noteDict = @{@"action": @"refresh"};
            [[NSNotificationCenter defaultCenter]postNotificationName:kNotification_HomeManagement object:self userInfo:noteDict];
        }
        [[NSNotificationCenter defaultCenter]postNotificationName:kNotification_HomeListRefresh object:self userInfo:nil];
        
        if (block) {
            block(object, error);
        }
    }];
}

- (void)updateDeviceListCompletion:(HWAPICallBack)callBack runStatusBlock:(HWAPICallBack)runStatusBlock newRequest:(BOOL)newRequest {
    if (newRequest) {
        _deviceListAPIManager = [[HWDevicesListAPIManager alloc] init];
    }
    [self.deviceListAPIManager callAPIWithParam:nil completion:^(id innerobject, NSError *innererror) {
        if (innererror.code != NSURLErrorCancelled) {
            self.deviceListFinishLoading = YES;
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_DeviceListLoaded object:nil];
        }
        
        if (!innererror) {
            [self updateDeviceInfoWithData:innerobject];
            [[NSNotificationCenter defaultCenter]postNotificationName:kNotification_AllDeviceRefresh object:self userInfo:nil];
            [self updateAllDevicesRunStatus:runStatusBlock newRequest:newRequest];
            [self updateFrequentlyUsedDeviceNewRequest:newRequest];
        } else {
            _userDataRequestSuccess = NO;
            if (runStatusBlock) {
                runStatusBlock(nil,innererror);
            }
        }
        
        if (callBack) {
            callBack(innerobject,innererror);
        }
    }];
}

- (void)updateGroupList {
    [self.groupListAPIManager callAPIWithParam:nil completion:^(id object, NSError *error) {
        if (!error) {
            if ([object isKindOfClass:[NSArray class]]) {
                [self updateGroupListDataWithArray:object];
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_UpdateGroupOrDeviceSucceed object:nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_sbc_room_list object:nil];
                [self updateRoomScenarioList];
            }
        }
    }];
}

- (void)updateGroupListDataWithArray:(NSArray *)array {
    for (NSInteger i = 0; i < [[self entities] count]; i++) {
        HomeModel *home = self.entities[i];
        BOOL exist = NO;
        for (NSInteger j = 0; j < array.count; j++) {
            NSDictionary *groupDict = array[j];
            if ([home.locationID integerValue] == [groupDict[kLocation_ID] integerValue]) {
                exist = YES;
                [home updateGroupWithDictionary:groupDict];
                break;
            }
        }
        
        if (!exist) {
            [home.groups removeAllObjects];
        }
    }
}

- (void)updateScheduleList {
    [self.locationScheduleListAPIManager callAPIWithParam:nil completion:^(id object, NSError *error) {
        if (!error) {
            if ([object isKindOfClass:[NSArray class]]) {
                [self updateScheduleListDataWithArray:object];
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_sbc_schedule_list object:nil];
            }
        }
    }];
}

- (void)updateScheduleListDataWithArray:(NSArray *)array {
    if ([[self entities] count] == 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_UpdateHomeScheduleList object:self userInfo:@{@"locationId":@"0"}];
        return;
    }
    for (NSInteger i = 0; i < [[self entities] count]; i++) {
        HomeModel *home = self.entities[i];
        BOOL exist = NO;
        for (NSInteger j = 0; j < array.count; j++) {
            NSDictionary *scheduleDict = array[j];
            if ([home.locationID integerValue] == [scheduleDict[kLocation_ID] integerValue]) {
                exist = YES;
                [home updateScheduleListWithDictionary:scheduleDict];
                break;
            }
        }
        
        if (!exist) {
            [home.scheduleList removeAllObjects];
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_UpdateHomeScheduleList object:self userInfo:@{@"locationId":home.locationID}];
        }
    }
}

- (void)updateScenarioList {
    [self.locationScenarioListAPIManager callAPIWithParam:nil completion:^(id object, NSError *error) {
        if (!error) {
            if ([object isKindOfClass:[NSArray class]]) {
                [self updateScenarioListDataWithArray:object];
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_sbc_scenario_list object:nil];
            }
        }
    }];
}

- (void)updateScenarioListDataWithArray:(NSArray *)array {
    if ([[self entities] count] == 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_UpdateHomeScenarioList object:self userInfo:@{@"locationId":@"0"}];
        return;
    }
    for (NSInteger i = 0; i < [[self entities] count]; i++) {
        HomeModel *home = self.entities[i];
        BOOL exist = NO;
        for (NSInteger j = 0; j < array.count; j++) {
            NSDictionary *scenarioDict = array[j];
            if ([home.locationID integerValue] == [scenarioDict[kLocation_ID] integerValue]) {
                exist = YES;
                [home updateScenarioListWithDictionary:scenarioDict];
                break;
            }
        }
        
        if (!exist) {
            [home.scenarioList removeAllObjects];
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_UpdateHomeScenarioList object:self userInfo:@{@"locationId":home.locationID}];
        }
    }
}

- (void)updateRoomScenarioList {
    [self.roomScenarioListAPIManager callAPIWithParam:nil completion:^(id object, NSError *error) {
        if (!error) {
            if ([object isKindOfClass:[NSArray class]]) {
                [self updateRoomScenarioListDataWithArray:object];
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_sbc_room_scenario object:nil];
            }
        }
    }];
}

- (void)updateRoomScenarioListDataWithArray:(NSArray *)array {
    for (NSInteger i = 0; i < [[self entities] count]; i++) {
        HomeModel *home = self.entities[i];
        BOOL exist = NO;
        for (NSInteger j = 0; j < array.count; j++) {
            NSDictionary *scenarioDict = array[j];
            if ([home.locationID integerValue] == [scenarioDict[kLocation_ID] integerValue]) {
                exist = YES;
                [home updateRoomScenarioListWithDictionary:scenarioDict];
                break;
            }
        }
        if (!exist) {
            [home removeAllRoomScenario];
        }
    }
}

- (void)updateTriggerList {
    [self.triggerListAPIManager callAPIWithParam:nil completion:^(id object, NSError *error) {
        if (!error) {
            if ([object isKindOfClass:[NSArray class]]) {
                [self updateTriggerListDataWithArray:object];
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_sbc_trigger_list object:nil];
            }
        }
    }];
}

- (void)updateTriggerListDataWithArray:(NSArray *)array {
    if ([[self entities] count] == 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_UpdateHomeTriggerList object:self userInfo:@{@"locationId":@"0"}];
        return;
    }
    for (NSInteger i = 0; i < [[self entities] count]; i++) {
        HomeModel *home = self.entities[i];
        BOOL exist = NO;
        for (NSInteger j = 0; j < array.count; j++) {
            NSDictionary *triggerDict = array[j];
            if ([home.locationID integerValue] == [triggerDict[kLocation_ID] integerValue]) {
                exist = YES;
                [home updateTriggerListWithDictionary:triggerDict];
                break;
            }
        }
        
        if (!exist) {
            [home.triggerList removeAllObjects];
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_UpdateHomeTriggerList object:self userInfo:@{@"locationId":home.locationID}];
        }
    }
}

- (void)updateUnreadMessage
{
    [self.messageCountAPIManager callAPIWithParam:nil completion:^(id object, NSError *error) {
        if (!error) {
            self.authorizeMessageBrief = [object copy];
            [[NSNotificationCenter defaultCenter]postNotificationName:kNotification_GetUnreadMessageSucceed object:nil];
        }
    }];
}

-(void)updateAllDevicesRunStatus:(NSArray *)homes response:(HWAPICallBack)block newRequest:(BOOL)newRequest
{
    if (homes.count <= 0) {
        _userDataRequestSuccess = YES;
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_AllDeviceRunStatusRefresh object:nil];
        if (block) {
            block(nil, nil);
        }
        return;
    }
    
    HWAllDeviceRunStatusAPIManager *manager = [[HWAllDeviceRunStatusAPIManager alloc] init];
    if (newRequest) {
        manager = [[HWAllDeviceRunStatusAPIManager alloc] init];
    }
    
    [manager callAPIWithParam:homes completion:^(id object, NSError *error) {
        if (!error) {
            _userDataRequestSuccess = YES;
            if ([object isKindOfClass:[NSDictionary class]] && [[object objectForKey:@"runStatus"] isKindOfClass:[NSArray class]]) {
                NSArray * allDeviesRunStatus = object[@"runStatus"];
                for (NSDictionary * runStatus in allDeviesRunStatus) {
                    for (HomeModel * homeModel in _entities) {
                        NSInteger locationIdFromCloud = [runStatus[@"locationId"] integerValue];
                        NSInteger locationIdAtLocal = [homeModel.locationID integerValue];
                        if (locationIdFromCloud == locationIdAtLocal) {
                            NSArray * deviceRunStatus = runStatus[@"runStatus"];
                            [homeModel updateAllDevicesRunStatus:deviceRunStatus];
                            break;
                        }
                        
                    }
                }
            }
        } else {
            _userDataRequestSuccess = NO;
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_AllDeviceRunStatusRefresh object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_UpdateGroupOrDeviceSucceed object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_sbc_device_list object:nil];
        if (block) {
            block(object, error);
        }
    }];
}

-(void)updateAllDevicesRunStatus:(HWAPICallBack)block newRequest:(BOOL)newRequest
{
    NSArray * allHomeIds = [self getAllHomeIdsWhichHaveDevice];
    [self updateAllDevicesRunStatus:allHomeIds response:block newRequest:newRequest];
}

- (void)updateFrequentlyUsedDeviceNewRequest:(BOOL)newRequest
{
    NSDictionary *param = @{@"limit":@(4)};
    if (newRequest) {
        _frequentlyUsedDeviceAPIManager = [[HWFrequentUsedDeviceAPIManager alloc] init];
    }
    [self.frequentlyUsedDeviceAPIManager callAPIWithParam:param completion:^(id object, NSError *error) {
        if ([object isKindOfClass:[NSArray class]]) {
            for (NSDictionary *location in (NSArray *)object) {
                NSInteger locationId = [location[@"locationId"] integerValue];
                NSArray *deviceIds = location[@"devices"];
                for (HomeModel *home in self.allEntites) {
                    if ([home.locationID integerValue] == locationId) {
                        home.frequentlyUsedDeviceIds = deviceIds;
                        break;
                    }
                }
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_FrequentlyUsedDeviceRefresh object:self userInfo:nil];
        }
    }];
}

- (void)updateDeviceRunStatus:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    if ([userInfo[@"errorCode"] integerValue] == 0) {
        id object = userInfo[@"msgData"];
        if ([object isKindOfClass:[NSDictionary class]] && [[object objectForKey:@"runStatus"] isKindOfClass:[NSArray class]]) {
            NSArray * allDeviesRunStatus = object[@"runStatus"];
            for (NSDictionary * runStatus in allDeviesRunStatus) {
                for (HomeModel * homeModel in _entities) {
                    NSInteger locationIdFromCloud = [runStatus[@"locationId"] integerValue];
                    NSInteger locationIdAtLocal = [homeModel.locationID integerValue];
                    if (locationIdFromCloud == locationIdAtLocal) {
                        NSArray * deviceRunStatus = runStatus[@"runStatus"];
                        [homeModel updateAllDevicesRunStatus:deviceRunStatus];
                        break;
                    }
                }
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_AllDeviceRunStatusRefresh object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_sbc_room_list object:nil];
        }
    }
}

- (void)updateOnline:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    if ([userInfo[@"errorCode"] integerValue] == 0) {
        NSInteger deviceId = [userInfo[@"msgData"][@"deviceId"] integerValue];
        for (HomeModel *model in self.entities) {
            for (DeviceModel *device in model.devices) {
                if (device.deviceID == deviceId) {
                    [device updateWithDictionary:@{DeviceRunStatus:userInfo[@"msgData"]}];
                    [[NSNotificationCenter defaultCenter]postNotificationName:kNotification_UpdateDeviceSucceed object:[device convertToHtml] userInfo:@{@"deviceId":[NSString stringWithFormat:@"%ld",(long)device.deviceID],@"locationId":[NSString stringWithFormat:@"%@",@(device.locationId)]}];
                    break;
                }
                for (DeviceModel *subDevice in device.subDevices) {
                    if (subDevice.deviceID == deviceId) {
                        [subDevice updateWithDictionary:@{DeviceRunStatus:userInfo[@"msgData"]}];
                        [[NSNotificationCenter defaultCenter]postNotificationName:kNotification_UpdateDeviceSucceed object:[subDevice convertToHtml] userInfo:@{@"deviceId":[NSString stringWithFormat:@"%ld",(long)subDevice.deviceID],@"locationId":[NSString stringWithFormat:@"%@",@(subDevice.locationId)]}];
                        break;
                    }
                }
            }
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_AllDeviceRunStatusRefresh object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_sbc_room_list object:nil];
    }
}

- (void)webSocketStateDidChanged {
    if ([WebSocketManager instance].state == WebSocketStateConnected) {
        [self updateAllLocations:nil deviceListBlock:nil runStatusBlock:nil reload:YES newRequest:NO];
    }
}

- (void)unBindDevice {
    [self updateAllLocations:nil deviceListBlock:nil runStatusBlock:nil reload:YES newRequest:NO];
}

- (BOOL)otherHomeHasEvents:(HomeModel *)nowHomeModel {
    BOOL result = NO;
    for (HomeModel *homeModel in self.entities) {
        if (![homeModel.locationID isEqualToString:nowHomeModel.locationID]) {
            if (homeModel.unreadEventCount > 0) {
                result = YES;
                break;
            }
        }
    }
    return result;
}

- (void)readEventWithEventId:(long long)eventId locationId:(NSInteger)locationId {
    HomeModel *homeModel = [self getHomebyId:[NSString stringWithFormat:@"%@",@(locationId)]];
    [homeModel readEventWithId:eventId];    
}

- (NSArray *)getAllHomeIdsWhichHaveDevice
{
    NSMutableArray * allHomeIds = [NSMutableArray array];
    for (HomeModel * homeModel in _entities) {
        if ([homeModel isHaveDevices]) {
            [allHomeIds addObject:homeModel.locationID];
        }
    }
    return allHomeIds;
}

- (BOOL)scenarioControlling {
    NSArray *homes = [self allEntites];
    for (HomeModel *home in homes) {
        if ([home isControlling]) {
            return YES;
        }
    }
    return NO;
}

-(void)addLocation:(NSDictionary *)otherDictionary resultBlock:(HWAPICallBack)block
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:otherDictionary];
    dict[kUrl_UserId] = [NSString stringWithFormat:@"%ld", (long)self.userID];
    dict[@"latitude"] = [NSString stringWithFormat:@"%ld",(long)([[LocationManager shareLocationManager] locationCoordinate].latitude)];
    dict[@"longitude"] = [NSString stringWithFormat:@"%ld",(long)([[LocationManager shareLocationManager] locationCoordinate].longitude)];
    [self.locationAddAPIManager callAPIWithParam:dict completion:^(id object, NSError *error) {
        if (!error) {
            [LogUtil Debug:@"HK" message:@"add location succeed"];
            HomeModel * homeModel = [[HomeModel alloc]init];
            homeModel.name = otherDictionary[@"name"];
            homeModel.locationID = [NSString stringWithFormat:@"%ld", (long)[object[@"id"] integerValue]];
            [homeModel updateCityWithCode:otherDictionary[@"city"]];
            homeModel.streetAddress = otherDictionary[@"street"];
            homeModel.isOwner = YES;
            homeModel.authorizedType = HomeAuthroizedTypeOwner;
            homeModel.category = HomeCategoryNone;
            [_entities addObject:homeModel];
            [self sortAllEntities];
            [self loadCityBackgroundPicturesAndWeather];
            
            [UserConfig saveUser];
            NSDictionary * noteDict = @{@"action": @"add", @"locationId": homeModel.locationID};
            [[NSNotificationCenter defaultCenter]postNotificationName:kNotification_HomeManagement object:nil userInfo:noteDict];
            [[NSNotificationCenter defaultCenter]postNotificationName:kNotification_sbc_location_list object:nil userInfo:noteDict];
        }
        if (block) {
            block(object, error);
        }
    }];
}

-(void)deleteLocation:(HomeModel *)homeModel resultBlock:(HWAPICallBack)block
{
    NSDictionary *dict = @{kUrl_LocationId:homeModel.locationID};
    [self.locationDeleteAPIManager callAPIWithParam:dict completion:^(id object, NSError *error) {
        if (!error) {
            [LogUtil Debug:@"HK" message:@"delete location succeed"];
            
            [_entities removeObject:homeModel];
            
            [UserConfig saveUser];
            
            NSDictionary * noteDict = @{@"action": @"delete", @"locationId": homeModel.locationID};
            [[NSNotificationCenter defaultCenter]postNotificationName:kNotification_HomeManagement object:nil userInfo:noteDict];
            [[NSNotificationCenter defaultCenter]postNotificationName:kNotification_sbc_location_list object:nil userInfo:noteDict];
        }
        if (block) {
            block(object, error);
        }
    }];
}

-(void)editLocation:(HomeModel *)homeModel params:(NSDictionary *)otherDictionary resultBlock:(HWAPICallBack)block
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:otherDictionary];
    dict[kUrl_LocationId] = homeModel.locationID;
    dict[@"latitude"] = [NSString stringWithFormat:@"%ld",(long)([[LocationManager shareLocationManager] locationCoordinate].latitude)];
    dict[@"longitude"] = [NSString stringWithFormat:@"%ld",(long)([[LocationManager shareLocationManager] locationCoordinate].longitude)];
    [self.locationEditAPIManager callAPIWithParam:dict completion:^(id object, NSError *error) {
        if (!error) {
            [LogUtil Debug:@"HK" message:@"edit location succeed"];
            UserEntity * user = [UserEntity instance];
            HomeModel * aHomeModel = [user getHomebyId:homeModel.locationID];
            [aHomeModel setName:otherDictionary[@"newName"]];
            [aHomeModel updateCityWithCode:otherDictionary[@"city"]];
            [aHomeModel setDistrictName:otherDictionary[@"district"]];
            [aHomeModel setStreetAddress:otherDictionary[@"street"]];
            [UserConfig saveUser];
            
            NSDictionary * noteDict = @{@"action": @"edit", @"locationId": homeModel.locationID};
            [[NSNotificationCenter defaultCenter]postNotificationName:kNotification_HomeManagement object:nil userInfo:noteDict];
            [[NSNotificationCenter defaultCenter]postNotificationName:kNotification_sbc_location_list object:nil userInfo:noteDict];
        }
        if (block) {
            block(object, error);
        }
    }];
}

- (void)setDefaultLocation:(HomeModel *)homeModel resultBlock:(HWAPICallBack)block {
    [self.locationSetDefaultHomeAPIManager callAPIWithParam:@{@"locationId":homeModel.locationID} completion:^(id object, NSError *error) {
        if (!error) {
            [LogUtil Debug:@"HK" message:@"edit location succeed"];
            UserEntity * user = [UserEntity instance];
            for (HomeModel *model in user.entities) {
                if (model.isDefault) {
                    model.isDefault = NO;
                }
            }
            HomeModel * aHomeModel = [user getHomebyId:homeModel.locationID];
            aHomeModel.isDefault = YES;
            
            [UserConfig saveUser];
        }
        if (block) {
            if (error) {
                error = [NSError errorWithDomain:NSLocalizedString(@"locationmgt_lbl_setdefaultfailed", nil) code:error.code userInfo:nil];
            }
            block(object, error);
        }
    }];
}

-(NSArray *)allEntites
{
    return [NSArray arrayWithArray:_entities];
}

- (NSArray *)allOwnerEntites {
    NSMutableArray *ownerEntites = [NSMutableArray array];
    for (NSInteger i = 0; i < _entities.count; i ++) {
        HomeModel *homeModel = [_entities objectAtIndex:i];
        if (homeModel.isOwner) {
            [ownerEntites addObject:homeModel];
        }
    }
    return ownerEntites;
}

-(NSInteger)allDeviceCount
{
    NSInteger deviceCount = 0;
    for (HomeModel * homeModel in _entities) {
        deviceCount += homeModel.devices.count;
    }
    return deviceCount;
}

-(NSString *)getDefaultHomeId
{
    NSString *defaultHomeId = nil;
    if (_entities.count > 0) {
        for (HomeModel *model in _entities) {
            if (model.isDefault) {
                defaultHomeId = model.locationID;
            }
        }
    }
    if (!defaultHomeId) {
        if (_entities.count > 0) {
            HomeModel * homeModel = _entities[0];
            defaultHomeId = homeModel.locationID;
        }
    }
    return defaultHomeId;
}

- (HomeModel *)getDefaultHomeModel {
    NSString *defaultHomeId = [self getDefaultHomeId];
    HomeModel *homeModel = nil;
    if (defaultHomeId) {
        for (HomeModel *model in _entities) {
            if ([model.locationID isEqualToString:defaultHomeId]) {
                homeModel = model;
                break;
            }
        }
    }
    return homeModel;
}

- (void)setDisplayHomeId:(NSString *)displayHomeId {
    if (_displayHomeId == displayHomeId) {
        return;
    }
    _displayHomeId = displayHomeId;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeDisplayHomeId" object:nil];
}

- (HomeModel *)getDisplayHomeModel {
    if (!self.displayHomeId) {
        self.displayHomeId = [self getDefaultHomeId];
    }
    if (!self.displayHomeId) {
        return nil;
    }
    HomeModel *homeModel = nil;
    for (HomeModel *model in _entities) {
        if ([model.locationID isEqualToString:self.displayHomeId]) {
            homeModel = model;
            break;
        }
    }
    return homeModel;
}

- (DeviceModel *)getDeviceById:(NSInteger)deviceId {
    DeviceModel *device = nil;
    for (HomeModel *home in [self allEntites]) {
        device = [home getDeviceById:[NSString stringWithFormat:@"%ld",(long)deviceId]];
        if (device) {
            break;
        }
    }
    return device;
}

- (void)setPause:(BOOL)pause {
    _pause = pause;
    if (_pause) {
        self.lastRefreshTime = 0;
    }
}

- (void)startRefreshTimer
{
    [TimerUtil scheduledDispatchTimerWithName:@"UserEntityTimer" timeInterval:USER_ENTITY_REFRESH_INTERVAL repeats:YES action:^{
        [self refreshTimerAction];
    }];
    [self refreshTimerAction];
}

- (void)stopRefreshTimer
{
    [TimerUtil cancelTimerWithName:@"UserEntityTimer"];
    self.lastRefreshTime = 0;
}

- (void)refreshTimerAction {
    if (self.pause) {
        return;
    }
    if (!_userDataRequestSuccess) {
        [self updateAllLocations:nil deviceListBlock:nil runStatusBlock:nil reload:YES newRequest:NO];
    }
    id<LocalizationProtocol> localizationProtocol = [AppManager getLocalProtocol];
    BOOL enableUnreadMessageAutoRefresh = [localizationProtocol enableUnreadMessageAutoRefresh];
    
    if (enableUnreadMessageAutoRefresh) {
        [self updateUnreadMessage];
    }
}

-(HomeModel *)getHomebyId:(NSString *)homeId
{
    for (HomeModel * homeModel in _entities) {
        if ([homeModel.locationID isEqualToString:homeId]) {
            return homeModel;
        }
    }
    
    return nil;
}

-(void)setStatus:(UserStatus)status sameUser:(BOOL)sameUser alertMsg:(NSString *)errorMsg
{
    if (_status != status) {
        _status = status;
#if !(TARGET_IPHONE_SIMULATOR)
        if (_status == UserStatusLogin) {
            if (self.username == nil) {
                return;
            }
            NSString *dbName = [NSString stringWithFormat:@"airtouch_%ld.db",(long)self.userID];
            self.userDBManager = nil;
            self.userDBManager = [[HWDataBaseManager alloc] initWithDBName:dbName];
           
            //向推送服务器注册tags
            [NotificationHubConfig registerNotificationWithCompeletion:^(NSError *error) {
                if (error) {
                    NSLog(@"NofificationHUBError: %@",error);
                }
            }];
        }
#endif
        if (_status == UserStatusLogin) {
            _entities = [[NSMutableArray alloc] init];
            [self startRefreshTimer];
        }
        if (_status == UserStatusLogout) {
            [self clean];
        }
        NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
        [userInfo setObject:@(status) forKey:@"status"];
        [userInfo setObject:[NSNumber numberWithBool:sameUser] forKey:@"SameUser"];
        if (errorMsg && ![errorMsg isEqualToString:@""]) {
            [userInfo setObject:errorMsg forKey:@"errorMsg"];
        }
        [[NSNotificationCenter defaultCenter]postNotificationName:kNotification_LoginStatusChanged object:nil userInfo:userInfo];
    }
    
}

-(BOOL)existHome:(NSString *)name {
    for (HomeModel * homeModel in _entities) {
        if (homeModel.isOwner) {
            if ([[homeModel.name lowercaseString] isEqualToString:[name lowercaseString]]) {
                return YES;
            }
        }
    }
    return NO;
}

-(BOOL)existHome:(NSString *)name withCity:(NSString *)city
{
    for (HomeModel * homeModel in _entities) {
        if (homeModel.isOwner) {
            if ([homeModel.name isEqualToString:name] && [homeModel.city isEqualToString:city]) {
                return YES;
            }
        }
    }
    return NO;
}

-(BOOL)existHome:(NSString *)name withCity:(NSString *)city excludeHomeModel:(HomeModel *)aHomeModel
{
    for (HomeModel * homeModel in _entities) {
        if (homeModel.isOwner) {
            if (![homeModel.locationID isEqualToString:aHomeModel.locationID]) {
                if ([homeModel.name isEqualToString:name] && [homeModel.city isEqualToString:city]) {
                    return YES;
                }
            }
        }
    }
    
    return NO;
}

-(BOOL)existHomeWithId:(NSInteger)homeId
{
    for (HomeModel *homeModel in _entities) {
        if ([homeModel.locationID integerValue] == homeId) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)isDefaultHome:(HomeModel *)homeModel
{
    NSString *defaultLocStr  = [self getDefaultHomeId];
    if ([defaultLocStr isEqualToString:homeModel.locationID]) {
        return YES;
    }
    return NO;
}

-(void)allAuthorizationMessageHaveBeenRead
{
    self.authorizeMessageBrief = @{kUnreadMessageCount : @(0)};
}

-(NSInteger)ownedHomeCount
{
    NSInteger count = 0;
    for (HomeModel * homeModel in _entities) {
        if (homeModel.isOwner) {
            count++;
        }
    }
    return count;
}

-(NSInteger)authorizedHomeCount
{
    NSInteger count = 0;
    for (HomeModel * homeModel in _entities) {
        if (!homeModel.isOwner) {
            count++;
        }
    }
    return count;
}

- (void)logoutWithAlertErrorMessage:(NSString *)errorMessage completion:(void (^)(BOOL, NSError *))completion {
    if ([[AuthenticationManager instance] authenticationStatus] == AuthenticationStatusAuthenticated ||
        [[AuthenticationManager instance] authenticationStatus] == AuthenticationStatusFailed) {
        [self.logoutAPIManager callAPIWithParam:nil completion:^(id object, NSError *error) {
            if (!error || error.code == HWErrorForbiddenLoginFirst) {
                NSDictionary *logoutMessage = nil;
                if (errorMessage) {
                    logoutMessage = @{@"errorMsg":errorMessage};
                }
                [self importData:logoutMessage];
                error = nil;
            } else {
                
            }
            if (completion) {
                completion(!error,nil);
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_Logout object:nil];
        }];
    }
}

- (void)removeAuthorizeDevice:(NSInteger)deviceId {
    DeviceModel *deviceModel = nil;
    HomeModel *homeModel = nil;
    for (HomeModel *home in self.entities) {
        for (DeviceModel *device in home.devices) {
            if (device.deviceID == deviceId) {
                deviceModel = device;
                homeModel = home;
                break;
            }
        }
    }
    if (homeModel && deviceModel) {
        if ([homeModel.devices containsObject:deviceModel]) {
            [homeModel.devices removeObject:deviceModel];
        }
    }
}

- (void)revokeAuthorizeDevice:(NSInteger)deviceId phoneNumbers:(NSArray *)phoneNumbers {
    DeviceModel *device = [self getDeviceWithId:deviceId];
    if (device.authorizedTo.count > 0) {
        for (NSString *phoneNum in phoneNumbers) {
            for (NSInteger i = device.authorizedTo.count-1; i >= 0; i--) {
                NSDictionary *dict = device.authorizedTo[i];
                if ([[dict objectForKey:@"phoneNumber"] isEqualToString:phoneNum]) {
                    [device.authorizedTo removeObject:dict];
                }
            }
        }
    }
}

- (DeviceModel *)getDeviceWithId:(NSInteger)deviceId {
    DeviceModel *deviceModel = nil;
    for (HomeModel *home in self.entities) {
        for (DeviceModel *device in home.devices) {
            if (device.deviceID == deviceId) {
                deviceModel = device;
                break;
            }
        }
    }
    return deviceModel;
}

- (NSArray *)getAllHomeDict {
    NSArray *homes = [self allEntites];
    NSMutableArray *result = [NSMutableArray array];
    for (NSInteger i = 0; i < homes.count; i++) {
        HomeModel *home = homes[i];
        [result addObject:[home convertToDictionary]];
    }
    return result;
}

- (void)getSelectedEmergencyContactWithCallBack:(HWDBCallBack)callBack {
    if (self.status == UserStatusLogin) {
        NSString *tableName = @"emergency_contact";
        NSString *query = [NSString stringWithFormat:@"SELECT * from %@ where major = '1'",tableName];
        [self.userDBManager selectWithRawQuery:query values:nil withCallBack:callBack];
    }
}

- (void)updateGLDNotificationActions {
    [self getSelectedEmergencyContactWithCallBack:^(id object, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            UNNotificationAction * callAction = nil;
            UNNotificationAction * readAction = nil;
            BOOL showCall = NO;
            NSArray *array = (NSArray *)object;
            if (array.count > 0) {
                NSDictionary *dict = [array firstObject];
                showCall = ([dict[@"name"] length] > 0);
                NSString *name = dict[@"name"];
                NSString *callTitle = [NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"common_call", nil),name];
                
                callAction = [UNNotificationAction actionWithIdentifier:@"action-call"
                                                                  title:callTitle
                                                                options:UNNotificationActionOptionForeground];
            }
            readAction = [UNNotificationAction actionWithIdentifier:@"action-read"
                                                              title:NSLocalizedString(@"common_markasread", nil)
                                                            options:UNNotificationActionOptionAuthenticationRequired];
            NSArray *actions = showCall ? @[callAction, readAction] : @[readAction];
            UNNotificationCategory * category = [UNNotificationCategory categoryWithIdentifier:@"CallPrimaryContact"
                                                                                       actions:actions
                                                                             intentIdentifiers:@[]
                                                                                       options:UNNotificationCategoryOptionNone];
            NSSet * sets = [NSSet setWithObjects:category, nil];
            [[UNUserNotificationCenter currentNotificationCenter] setNotificationCategories:sets];
        });
    }];
}

#pragma mark - Getter
- (HWMessageCountAPIManager *)messageCountAPIManager {
    if (!_messageCountAPIManager) {
        _messageCountAPIManager = [[HWMessageCountAPIManager alloc] init];
    }
    return _messageCountAPIManager;
}

- (HWLocationListAPIManager *)locationListAPIManager {
    if (!_locationListAPIManager) {
        _locationListAPIManager = [[HWLocationListAPIManager alloc] init];
    }
    return _locationListAPIManager;
}

- (HWDevicesListAPIManager *)deviceListAPIManager {
    if (!_deviceListAPIManager) {
        _deviceListAPIManager = [[HWDevicesListAPIManager alloc] init];
    }
    return _deviceListAPIManager;
}

- (HWFrequentUsedDeviceAPIManager *)frequentlyUsedDeviceAPIManager {
    if (!_frequentlyUsedDeviceAPIManager) {
        _frequentlyUsedDeviceAPIManager = [[HWFrequentUsedDeviceAPIManager alloc] init];
    }
    return _frequentlyUsedDeviceAPIManager;
}

- (HWLocationAddAPIManager *)locationAddAPIManager {
    if (!_locationAddAPIManager) {
        _locationAddAPIManager = [[HWLocationAddAPIManager alloc] init];
    }
    return _locationAddAPIManager;
}

- (HWLocationEditAPIManager *)locationEditAPIManager {
    if (!_locationEditAPIManager) {
        _locationEditAPIManager = [[HWLocationEditAPIManager alloc] init];
    }
    return _locationEditAPIManager;
}

- (HWLocationDeleteAPIManager *)locationDeleteAPIManager {
    if (!_locationDeleteAPIManager) {
        _locationDeleteAPIManager = [[HWLocationDeleteAPIManager alloc] init];
    }
    return _locationDeleteAPIManager;
}

- (HWAllDeviceRunStatusAPIManager *)deviceRunStatusManager {
    if (!_deviceRunStatusManager) {
        _deviceRunStatusManager = [[HWAllDeviceRunStatusAPIManager alloc] init];
    }
    return _deviceRunStatusManager;
}

- (HWLogoutAPIManager *)logoutAPIManager {
    if (!_logoutAPIManager) {
        _logoutAPIManager = [[HWLogoutAPIManager alloc] init];
    }
    return _logoutAPIManager;
}

- (HWLocationSetDefaultHomeAPIManager *)locationSetDefaultHomeAPIManager {
    if (!_locationSetDefaultHomeAPIManager) {
        _locationSetDefaultHomeAPIManager = [[HWLocationSetDefaultHomeAPIManager alloc] init];
    }
    return _locationSetDefaultHomeAPIManager;
}

- (HWLocationScenarioListApiManager *)locationScenarioListAPIManager {
    if (!_locationScenarioListAPIManager) {
        _locationScenarioListAPIManager = [[HWLocationScenarioListApiManager alloc] init];
    }
    return _locationScenarioListAPIManager;
}

- (HWRoomScenarioListAPIManager *)roomScenarioListAPIManager {
    if (!_roomScenarioListAPIManager) {
        _roomScenarioListAPIManager = [[HWRoomScenarioListAPIManager alloc] init];
    }
    return _roomScenarioListAPIManager;
}

- (HWLocationScheduleListAPIManager *)locationScheduleListAPIManager {
    if (!_locationScheduleListAPIManager) {
        _locationScheduleListAPIManager = [[HWLocationScheduleListAPIManager alloc] init];
    }
    return _locationScheduleListAPIManager;
}

- (HWGroupListAPIManager *)groupListAPIManager {
    if (!_groupListAPIManager) {
        _groupListAPIManager = [[HWGroupListAPIManager alloc] init];
    }
    return _groupListAPIManager;
}

- (HWTriggerListAPIManager *)triggerListAPIManager {
    if (!_triggerListAPIManager) {
        _triggerListAPIManager = [[HWTriggerListAPIManager alloc] init];
    }
    return _triggerListAPIManager;
}

- (void)cancelHttpRequest {
    [self.messageCountAPIManager cancel];
    self.messageCountAPIManager = nil;
    
    [self.locationListAPIManager cancel];
    self.locationListAPIManager = nil;
    
    [self.deviceListAPIManager cancel];
    self.deviceListAPIManager = nil;
    
    [self.frequentlyUsedDeviceAPIManager cancel];
    self.frequentlyUsedDeviceAPIManager = nil;
    
    [self.locationAddAPIManager cancel];
    self.locationAddAPIManager = nil;
    
    [self.locationEditAPIManager cancel];
    self.locationEditAPIManager = nil;
    
    [self.locationDeleteAPIManager cancel];
    self.locationDeleteAPIManager = nil;
    
    [self.deviceRunStatusManager cancel];
    self.deviceRunStatusManager = nil;
    
    [self.locationSetDefaultHomeAPIManager cancel];
    self.locationSetDefaultHomeAPIManager = nil;
    
    [self.groupListAPIManager cancel];
    self.groupListAPIManager = nil;
    
    [self.locationScenarioListAPIManager cancel];
    self.locationScenarioListAPIManager = nil;
    
    [self.triggerListAPIManager cancel];
    self.triggerListAPIManager = nil;
    
    [self.locationScheduleListAPIManager cancel];
    self.locationScheduleListAPIManager = nil;
    
    [self.roomScenarioListAPIManager cancel];
    self.roomScenarioListAPIManager = nil;
}

- (void)dealloc {
    [self cancelHttpRequest];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
