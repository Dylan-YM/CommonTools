//
//  UserEntity.h
//  AirTouch
//
//  Created by huangfujun on 15/5/5.
//  Copyright (c) 2015年 Honeywell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseAPIRequest.h"
#import "HomeConfig.h"
#import "HWDataBaseManager.h"

#define kUnreadMessageCount @"unread"

typedef NS_ENUM(NSInteger, UserStatus) {
    UserStatusLogout,
    UserStatusLogin
};

typedef NS_ENUM(NSInteger, UserType) {
    UserTypePersonal = 1,    // 个人版用户
    UserTypeEnterprise = 2,  // 企业版用户
};

typedef NS_ENUM(NSInteger, GotoNewVAlertType) {
    GotoNewVAlertTypeWhenEnroll = 1,
    GotoNewVAlertTypeWhenUnsupportedDeviceTypeDetected = 2,
};

typedef NS_ENUM(NSInteger, UserGenderType) {
    UserGenderTypeMale,
    UserGenderTypeFemale
};

typedef void (^UserEntityBlock)(id object, NSError *error);

@class HomeModel;
@class DeviceModel;
@interface UserEntity : NSObject

@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *salt;
@property (nonatomic, strong) NSString *loginToken;
@property (nonatomic, assign) UserGenderType userGender;

@property (nonatomic) NSInteger userID;
@property (nonatomic, assign, setter=setEnterprise:) BOOL isEnterprise;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *firstname;
@property (nonatomic, strong) NSString *lastname;
@property (nonatomic, strong) NSString *streetAddress;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *state;
@property (nonatomic, strong) NSString *zipcode;
@property (nonatomic, strong) NSString *country;
@property (nonatomic, strong) NSString *userLanguage;
@property (nonatomic) BOOL isActivated;
@property (nonatomic) NSInteger deviceCount;
@property (nonatomic) NSInteger tenantID;
@property (nonatomic, strong) NSString *countryPhoneNum;
@property (nonatomic, strong) NSArray *wsUrl;
@property (nonatomic, assign) UserType userType;
@property (nonatomic, strong) NSString *displayHomeId;

@property (readonly, nonatomic) UserStatus status;
/**
 *  家的列表加载状态
 */
@property (readonly, nonatomic) HomeLoadingStatus homeLoadingStatus;
@property (assign, nonatomic) BOOL deviceListFinishLoading;
@property (assign, nonatomic) BOOL pause;

@property (strong, nonatomic) NSDictionary *authorizeMessageBrief;

@property (readonly, nonatomic) BOOL userDataRequestSuccess;

/**
 *
 *
 *  @return singleton
 */
+(UserEntity *)instance;

-(void)importData:(NSDictionary *)dic;

-(void)loadCityBackgroundPicturesAndWeather;

/**
 *  update user all locations data including devices' data
 *
 *  @param block refresh UI
 */
-(void)updateAllLocations:(HWAPICallBack)block deviceListBlock:(HWAPICallBack)deviceBlock runStatusBlock:(HWAPICallBack)runStatusBlock reload:(BOOL)reload newRequest:(BOOL)newRequest;
/**
 *  update unread message count
 */
- (void)updateUnreadMessage;
/**
 *  get user all owner locations
 */
- (NSArray<HomeModel *> *)allOwnerEntites;
/**
 *  get user all locations
 *
 *
 */
-(NSArray<HomeModel *> *)allEntites;
/**
 *  get user's all device count
 *
 *  @return the sum of all location's device count
 */
-(NSInteger)allDeviceCount;
/**
 *
 *
 *  @return user default home Id
 */
-(NSString *)getDefaultHomeId;

- (HomeModel *)getDefaultHomeModel;

- (HomeModel *)getDisplayHomeModel;
/**
 *
 *  @param homeModel homeModel
 *
 *  @return whther a home model is default home
 */
- (BOOL)isDefaultHome:(HomeModel *)homeModel;
/**
 *  get user's locationModel by Id
 *
 *  @param homeId locationId
 *
 *  @return homeModel
 */
-(HomeModel *)getHomebyId:(NSString *)homeId;
-(void)addLocation:(NSDictionary *)otherDictionary resultBlock:(HWAPICallBack)block;
-(void)deleteLocation:(HomeModel *)homeModel resultBlock:(HWAPICallBack)block;
-(void)editLocation:(HomeModel *)homeModel params:(NSDictionary *)otherDictionary resultBlock:(HWAPICallBack)block;
- (void)setDefaultLocation:(HomeModel *)homeModel resultBlock:(HWAPICallBack)block;

/**
 *  save into local system
 *
 *  @return json Dictionary
 */
-(NSDictionary *)convertToDictionary;

-(BOOL)existHome:(NSString *)name;
-(BOOL)existHome:(NSString *)name withCity:(NSString *)city;
-(BOOL)existHome:(NSString *)name withCity:(NSString *)city excludeHomeModel:(HomeModel *)aHomeModel;
-(void)allAuthorizationMessageHaveBeenRead;
-(NSInteger)ownedHomeCount;
-(NSInteger)authorizedHomeCount;
-(BOOL)existHomeWithId:(NSInteger)homeId;

-(void)updateAllDevicesRunStatus:(NSArray *)homes response:(UserEntityBlock)block newRequest:(BOOL)newRequest;

- (void)updateDeviceListCompletion:(HWAPICallBack)callBack runStatusBlock:(HWAPICallBack)runStatusBlock newRequest:(BOOL)newRequest;

- (void)logoutWithAlertErrorMessage:(NSString *)errorMessage completion:(void (^)(BOOL, NSError *))completion;

- (void)clean;

- (void)refreshUserEntity:(BOOL)refresh;

- (void)removeAuthorizeDevice:(NSInteger)deviceId;

- (void)revokeAuthorizeDevice:(NSInteger)deviceId phoneNumbers:(NSArray *)phoneNumbers;

- (BOOL)otherHomeHasEvents:(HomeModel *)nowHomeModel;

- (void)readEventWithEventId:(long long)eventId locationId:(NSInteger)locationId;

- (void)updateGroupList;

- (void)updateScenarioList;
- (void)updateRoomScenarioList;
- (void)updateTriggerList;
- (void)updateScheduleList;

- (BOOL)scenarioControlling;

- (DeviceModel *)getDeviceById:(NSInteger)deviceId;

- (NSArray *)getAllHomeDict;

- (void)getSelectedEmergencyContactWithCallBack:(HWDBCallBack)callBack;

- (void)updateGLDNotificationActions;

@end
