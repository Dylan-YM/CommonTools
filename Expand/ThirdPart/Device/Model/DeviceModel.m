//
//  DeviceModel.m
//  AirTouch
//
//  Created by Devin on 1/22/15.
//  Copyright (c) 2015 Honeywell. All rights reserved.
//

#import "DeviceModel.h"
#import "HomeModel.h"
#import "ModelKey.h"
#import "LogUtil.h"
#import "DateTimeUtil.h"
#import "ProtocolUtil.h"
#import "UserEntity.h"
#import "AppMarco.h"
#import "HWDeviceUpdateAPIManager.h"
#import "HWDeviceRunStatusAPIManager.h"
#import "TimerUtil.h"
#import "AppManager.h"
#import "DeviceConfigTools.h"

#define kCheckOnlineTimerName @"kCheckOnlineTimerName"

@interface DeviceModel()

@property (strong, nonatomic) HWDeviceUpdateAPIManager *deviceUpdateAPIManager;
@property (strong, nonatomic) HWDeviceRunStatusAPIManager *deviceRunStatusAPIManager;

@property (strong, nonatomic) HWAPICallBack callBack;

@property (assign, nonatomic) BOOL checkOnline;

@end

@implementation DeviceModel

@synthesize name = _name;
@synthesize deviceID = _deviceID;
@synthesize deviceType = _deviceType;
@synthesize firmwareVersion = _firmwareVersion;
@synthesize isUpgrading = _isUpgrading;
@synthesize macID = _macID;

@synthesize canBeMasterDevice = _canBeMasterDevice;
@synthesize isMasterDevice = _isMasterDevice;
@synthesize permission = _permission;
@synthesize ownerName = _ownerName;

@synthesize isAlive = _isAlive;
@synthesize enrollmentDate = _enrollmentDate;

@synthesize homeModel = _homeModel;
@synthesize unSupport = _unSupport;

//add
@synthesize category = _category;
@synthesize ownerId = _ownerId;
@synthesize tag = _tag;
@synthesize productClass = _productClass;
@synthesize authorizedTo = _authorizedTo;
@synthesize feature = _feature;
@synthesize featureName = _featureName;
@synthesize locationId = _locationId;
@synthesize sku = _sku;
@synthesize subDevices = _subDevices;
@synthesize parentDeviceId = _parentDeviceId;
@synthesize enable = _enable;
@synthesize armStatus = _armStatus;
@synthesize runStatus = _runStatus;
@synthesize isFavorite = _isFavorite;
@synthesize functionType = _functionType;
@synthesize isMovable = _isMovable;
@synthesize isConfig = _isConfig;
@synthesize isDeletable = _isDeletable;
@synthesize otherAttr = _otherAttr;
@synthesize configModel = _configModel;
@synthesize enrollModel = _enrollModel;
@synthesize lastUpdate = _lastUpdate;
@synthesize nameType = _nameType;
@synthesize nameIndex = _nameIndex;

+ (HWDeviceCategory)deviceCategory {
    return HWDeviceCategoryNone;
}

- (NSString *)deviceCategoryString {
    return self.configModel.deviceCategoryString;
}

- (instancetype)initWithDictionary:(NSDictionary *)params
{
    self = [super init];
    if (self) {
        self.name = @"";
        self.deviceID = -1;
        self.subDevices = [NSMutableArray array];
        [self updateWithDictionary:params];
        NSDictionary *configInfo = [DeviceConfigTools initDeviceConfigModelWithProductModel:self.deviceType];
        if ([configInfo.allKeys containsObject:@"deviceConfigModel"]) {
            self.configModel = configInfo[@"deviceConfigModel"];
        }
        if ([configInfo.allKeys containsObject:@"deviceEnrollModel"]) {
            self.enrollModel = configInfo[@"deviceEnrollModel"];
        }
    }
    return self;
}

-(void)updateWithDictionary:(NSDictionary *)params
{
    if ([params.allKeys containsObject:DeviceName]) {
        self.name = [params objectForKey:DeviceName];
    }
    if ([params.allKeys containsObject:DeviceID]) {
        self.deviceID = [[params objectForKey:DeviceID] integerValue];
    }
    if ([params.allKeys containsObject:DeviceType]) {
        self.deviceType=[params objectForKey:DeviceType];
    }
    if ([params.allKeys containsObject:DeviceFirmwareVersion]) {
        self.firmwareVersion=[params objectForKey:DeviceFirmwareVersion];
    }
    if ([params.allKeys containsObject:DeviceIsUpgrading]) {
        self.isUpgrading=[[params objectForKey:DeviceIsUpgrading] boolValue];
    }
    if ([params.allKeys containsObject:DeviceMacId]) {
        self.macID=[params objectForKey:DeviceMacId];
    }
    if ([params.allKeys containsObject:DeviceEnrollmentDate]) {
        self.enrollmentDate = [params objectForKey:DeviceEnrollmentDate];
    }
    if ([params.allKeys containsObject:DeviceIsMasterDevice]) {
        self.isMasterDevice = [[params objectForKey:DeviceIsMasterDevice] boolValue];
    }
    if ([params.allKeys containsObject:DevicePermission]) {
        self.permission = [[params objectForKey:DevicePermission]integerValue];
    }
    if ([params.allKeys containsObject:DeviceOwnerName]) {
        self.ownerName = [params objectForKey:DeviceOwnerName];
    }
    
    //add
    if ([params.allKeys containsObject:DeviceCategory]) {
        self.category = [params objectForKey:DeviceCategory];
    }
    if ([params.allKeys containsObject:DeviceFeature]) {
        self.feature = [params objectForKey:DeviceFeature];
    }
    if ([params.allKeys containsObject:DeviceFeatureName]) {
        self.featureName = [params objectForKey:DeviceFeatureName];
    }
    if ([params.allKeys containsObject:DeviceLocationId]) {
        self.locationId = [[params objectForKey:DeviceLocationId] integerValue];
    }
    if ([params.allKeys containsObject:DeviceOwnerId]) {
        self.ownerId = [[params objectForKey:DeviceOwnerId] integerValue];
    }
    if ([params.allKeys containsObject:DeviceProductClass]) {
        self.productClass = [[params objectForKey:DeviceProductClass] integerValue];
    }
    if ([params.allKeys containsObject:DeviceSku]) {
        self.sku = [params objectForKey:DeviceSku];
    }
    if ([params.allKeys containsObject:DeviceFunctionType]) {
        self.functionType = [params objectForKey:DeviceFunctionType];
    }
    if ([params.allKeys containsObject:DeviceIsDeletable]) {
        self.isDeletable = [[params objectForKey:DeviceIsDeletable] boolValue];
    }
    if ([params.allKeys containsObject:DeviceIsMovable]) {
        self.isMovable = [[params objectForKey:DeviceIsMovable] boolValue];
    }
    if ([params.allKeys containsObject:DeviceIsConfig]) {
        self.isConfig = [[params objectForKey:DeviceIsConfig] boolValue];
    }
    self.authorizedTo = nil;
    if ([params.allKeys containsObject:DeviceAuthorizedTo]) {
        if ([params[DeviceAuthorizedTo] isKindOfClass:[NSArray class]]) {
            self.authorizedTo = [NSMutableArray arrayWithArray:[params objectForKey:DeviceAuthorizedTo]];
        }
    } else {
        self.authorizedTo = [@[] mutableCopy];
    }
    if ([params.allKeys containsObject:DeviceTag]) {
        self.tag = [params objectForKey:DeviceTag];
    }
    if ([params.allKeys containsObject:DeviceParentDeviceId]) {
        self.parentDeviceId = [[params objectForKey:DeviceParentDeviceId] integerValue];
    }
    if ([params.allKeys containsObject:DeviceSubDevices]) {
        [self updateSubDevices:params[DeviceSubDevices]];
    }
    if ([params.allKeys containsObject:DeviceRunStatus]) {
        [self updateRunstatusWithDictionary:params];
    }
    if ([params.allKeys containsObject:DeviceIsFavorite]) {
        self.isFavorite = [[params objectForKey:DeviceIsFavorite]boolValue];
    }
    if ([params.allKeys containsObject:DeviceOtherAttr]) {
        self.otherAttr = [params objectForKey:DeviceOtherAttr];
    }
    if ([params.allKeys containsObject:DeviceNameType]) {
        self.nameType = [[params objectForKey:DeviceNameType] integerValue];
    }
    if ([params.allKeys containsObject:DeviceNameIndex]) {
        self.nameIndex = [[params objectForKey:DeviceNameIndex] integerValue];
    }
    
    self.name = [self getChinaSwdDeviceName];
    
    if (self.otherAttr &&
        [[self.otherAttr allKeys] containsObject:@"zoneType"] &&
        [self.deviceType isEqualToString:HWDeviceTypeZone] &&
        [self.otherAttr[@"zoneType"] isEqualToString:@"24h"]) {
        self.deviceType = HWDeviceType24hZone;
    }
    
    [[NSNotificationCenter defaultCenter]postNotificationName:kNotification_UpdateDeviceSucceed object:[self convertToHtml] userInfo:@{@"deviceId":[NSString stringWithFormat:@"%ld",(long)self.deviceID],@"locationId":[NSString stringWithFormat:@"%@",@(self.locationId)]}];
}

- (void)setDeviceType:(NSString *)deviceType {
    _deviceType = deviceType;
    if ([deviceType isEqualToString:HWDeviceTypeElevator001] ||
        [deviceType isEqualToString:HWDeviceTypeHomePanelElevator]) {
        if (!self.name || [self.name isEqualToString:@""]) {
            self.name = NSLocalizedString(@"devices_title_evevator", nil);
        }
    }
}

- (NSDictionary *)convertRunStatusToHtml {
    return @{};
}

- (void)updateRunstatusWithDictionary:(NSDictionary *)dictionary {
    NSDictionary *runStatus = dictionary[DeviceRunStatus];
    [self.runStatus addEntriesFromDictionary:runStatus];
    for (DeviceModel *subDevice in self.subDevices) {
        [[NSNotificationCenter defaultCenter]postNotificationName:kNotification_UpdateDeviceSucceed object:[subDevice convertToHtml] userInfo:@{@"deviceId":[NSString stringWithFormat:@"%ld",(long)subDevice.deviceID],@"locationId":[NSString stringWithFormat:@"%@",@(self.locationId)]}];
    }
    self.lastUpdate = [[NSDate date] timeIntervalSince1970]*1000;
}

- (BOOL)armStatus {
    if ([self.runStatus.allKeys containsObject:DeviceArmStatus]) {
        return [[self.runStatus objectForKey:DeviceArmStatus] boolValue];
    }
    return NO;
}

- (BOOL)enable {
    return [[self.runStatus objectForKey:DeviceEnable] boolValue];
}

- (BOOL)isAlive {
    if (self.productClass == 4) {
        DeviceModel *parentDevice = [self.homeModel getDeviceById:[NSString stringWithFormat:@"%ld",self.parentDeviceId]];
        if (parentDevice && !parentDevice.isAlive) {
            return NO;
        }
    }
    if (self.configModel.onlineAsParent) {
        DeviceModel *parentDevice = [self.homeModel getDeviceById:[NSString stringWithFormat:@"%ld",self.parentDeviceId]];
        if (parentDevice) {
            return [parentDevice isAlive];
        } else {
            return NO;
        }
    } else {
        return [[self.runStatus objectForKey:DeviceAlive] boolValue];
    }
}

- (BOOL)isPowerOn {
    if (!self.isAlive) {
        return NO;
    }
    if (self.productClass != 4) {
        return YES;
    }
    if (self.configModel.powerAsParent) {
        DeviceModel *parentDevice = [self.homeModel getDeviceById:[NSString stringWithFormat:@"%ld",(long)self.parentDeviceId]];
        if (parentDevice) {
            return [parentDevice isPowerOn];
        } else {
            return NO;
        }
    } else {
        if ([self.deviceType isEqualToString:HWDeviceTypeDimmer] ||
            [self.deviceType isEqualToString:HWDeviceTypeSWDDimmer]) {
            NSInteger openClosePercent = [[self.runStatus objectForKey:DeviceOpenClosePercent] integerValue];
            BOOL isPowerOn = openClosePercent > 0;
            return isPowerOn;
        } else if ([self.deviceType isEqualToString:HWDeviceTypeSWDFan]) {
            NSInteger stepSpeed = [[self.runStatus objectForKey:DeviceStepSpeed] integerValue];
            BOOL isPowerOn = stepSpeed > 0;
            return isPowerOn;
        } else if ([self.deviceType isEqualToString:HWDeviceTypeSmartIAQ]) {
            NSString *mode = [self.runStatus objectForKey:@"runMode"];
            return (![mode isEqualToString:@"allClose"]);
        } else if ([[self.runStatus allKeys] containsObject:DeviceOn]) {
            return [[self.runStatus objectForKey:DeviceOn] boolValue];
        }
    }
    return NO;
}

- (DevicePowerStatus)switchDevicePowerStatus {
    if (!self.isAlive) {
        return DevicePowerOff;
    }
    NSMutableArray *switchPowerStatus = [NSMutableArray array];
    if ([[self.runStatus allKeys] containsObject:DeviceOn]) {
        [switchPowerStatus addObject:@([[self.runStatus objectForKey:DeviceOn] boolValue])];
    }
    if ([[self.runStatus allKeys] containsObject:@"on2"]) {
        [switchPowerStatus addObject:@([[self.runStatus objectForKey:@"on2"] boolValue])];
    }
    if ([[self.runStatus allKeys] containsObject:@"on3"]) {
        [switchPowerStatus addObject:@([[self.runStatus objectForKey:@"on3"] boolValue])];
    }
    if ([[self.runStatus allKeys] containsObject:@"on4"]) {
        [switchPowerStatus addObject:@([[self.runStatus objectForKey:@"on4"] boolValue])];
    }
    BOOL allOff = YES;
    BOOL allOn = YES;
    for (NSNumber *number in switchPowerStatus) {
        if ([number boolValue]) {
            allOff = NO;
        } else {
            allOn = NO;
        }
    }
    if (allOn) {
        return DevicePowerOn;
    } else if (allOff) {
        return DevicePowerOff;
    } else {
        return DevicePowerPartiallyOn;
    }
}
- (NSMutableDictionary *)runStatus {
    if (!_runStatus) {
        _runStatus = [NSMutableDictionary dictionary];
    }
    return _runStatus;
}

-(NSDictionary *)convertToDictionary {
    BOOL isOwner = [[AppManager getLocalProtocol] authorizedOwner:self];
    
    HWGroupModel *group = [self.homeModel getGroupByDeviceId:self.deviceID];
    
    return @{DeviceName:(self.name?:@""),
             DeviceID:@(self.deviceID),
             DeviceType:self.deviceType?:@"",
             DeviceFirmwareVersion:(self.firmwareVersion?:@""),
             DeviceIsUpgrading:@(self.isUpgrading),
             DeviceMacId:(self.macID?:@""),
             DeviceEnrollmentDate:(self.enrollmentDate?:@""),
             DeviceIsMasterDevice:@(self.isMasterDevice),
             DevicePermission:@(self.permission),
             DeviceOwnerName:(self.ownerName?:@""),
             @"groupId":group?[NSString stringWithFormat:@"%@",@(group.groupId)]:@"",
             @"groupName":group?(group.groupName?:@""):@"",
             //add
             DeviceCategory:(self.category?:@""),
             DeviceFeature:(self.feature?:@[]),
             DeviceFeatureName:(self.featureName?:@[]),
             DeviceLocationId:@(self.locationId),
             DeviceOwnerId:@(self.ownerId),
             DeviceProductClass:@(self.productClass),
             DeviceSku:(self.sku?:@""),
             DeviceTag:(self.tag?:@[]),
             @"isOwner":[NSNumber numberWithBool:isOwner],
             DeviceAuthorizedTo:self.authorizedTo?:@[],
             DeviceParentDeviceId:@(self.parentDeviceId),
             DeviceArmStatus:@(self.armStatus),
             DeviceRunStatus:self.runStatus?:@{},
             DeviceIsFavorite:@(self.isFavorite),
             DeviceFunctionType:self.functionType?:@"",
             DeviceIsDeletable:@(self.isDeletable),
             DeviceIsMovable:@(self.isMovable),
             DeviceIsConfig:@(self.isConfig),
             DeviceOtherAttr:self.otherAttr?:@{}
             };
}

-(NSDictionary *)convertToHtml {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    NSMutableDictionary *runStatus = [NSMutableDictionary dictionaryWithDictionary:self.runStatus];
    [runStatus addEntriesFromDictionary:@{DeviceAlive:@([self isAlive])}];
    
    NSDictionary *deviceRunstatus = @{@"runStatus":runStatus};
    NSDictionary *deviceInfo = [self convertToDictionary];
    
    NSMutableArray *pairedSubDevices = [NSMutableArray array];
    for (NSInteger i = 0; i < self.subDevices.count; i++) {
        DeviceModel *deviceModel = self.subDevices[i];
        [pairedSubDevices addObject:@([deviceModel deviceID])];
    }
    
    [dictionary setObject:deviceInfo forKey:@"deviceInfo"];
    [dictionary setObject:deviceRunstatus forKey:@"deviceRunstatus"];
    [dictionary setObject:pairedSubDevices forKey:@"pairedSubDevices"];
    [dictionary setObject:@(self.lastUpdate) forKey:@"updateTime"];
    
    return dictionary;
}

- (NSDictionary *)convertSubDevicesToHtml {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    NSDictionary *deviceInfo = [self convertToDictionary];
    NSMutableArray *subDevice = [NSMutableArray array];
    for (NSInteger i = 0; i < self.subDevices.count; i++) {
        DeviceModel *deviceModel = self.subDevices[i];
        NSMutableDictionary *info = [NSMutableDictionary dictionaryWithDictionary:[deviceModel convertToDictionary]];
        [subDevice addObject:info];
    }
    
    [dictionary setObject:deviceInfo forKey:@"deviceInfo"];
    [dictionary setObject:subDevice forKey:@"subDevices"];
    return dictionary;
}

- (NSDictionary *)convertPairedSubDeviceToHtml {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    NSDictionary *deviceInfo = [self convertToDictionary];
    NSMutableArray *pairedSubDevices = [NSMutableArray array];
    for (NSInteger i = 0; i < self.subDevices.count; i++) {
        DeviceModel *deviceModel = self.subDevices[i];
        [pairedSubDevices addObject:[deviceModel convertToDictionary]];
    }
    [dictionary setObject:deviceInfo forKey:@"deviceInfo"];
    [dictionary setObject:pairedSubDevices forKey:@"pairedSubDevices"];
    return dictionary;
}

- (void)setHomeModel:(HomeModel *)homeModel {
    _homeModel = homeModel;
    for (DeviceModel *subDevice in self.subDevices) {
        subDevice.homeModel = _homeModel;
    }
}

- (NSString *)deviceSmallIconImageName {
    NSString * deviceSmallIconImageName = nil;
    if (self.functionType && [[self showFunctionTypeDevices] containsObject:self.deviceType]) {
        deviceSmallIconImageName = [self relayFunctionDisplayImageName][self.functionType];
    }
    if (deviceSmallIconImageName) {
        return deviceSmallIconImageName;
    } else {
        NSArray *allSkus = [self.configModel.sku allKeys];
        if ([allSkus containsObject:self.sku]) {
            return [self.configModel.sku objectForKey:self.sku][@"small_icon"];
        }
        return [self.configModel.sku objectForKey:@"defaultIcon"][@"small_icon"];
    }
}

//enroll
- (NSArray *)guideImageName {
    NSArray *allSkus = [self.configModel.sku allKeys];
    NSObject *enrollGuideObject = nil;
    if ([allSkus containsObject:self.sku]) {
        enrollGuideObject = [self.configModel.sku objectForKey:self.sku][@"enroll_guide"];
    } else {
        enrollGuideObject = [self.configModel.sku objectForKey:@"defaultIcon"][@"enroll_guide"];
    }
    return enrollGuideObject;
}

- (BOOL)supportAP20 {
    return [self.enrollModel.enrollType containsObject:@(ENROLLMODE_AP20)];
}

- (BOOL)supportEasylink {
    return [self.enrollModel.enrollType containsObject:@(ENROLLMODE_EasyLink)];
}

- (BOOL)supportBroadAP {
    return [self.enrollModel.enrollType containsObject:@(ENROLLMODE_BroadAP)];
}

- (BOOL)supportBroadSL {
    return [self.enrollModel.enrollType containsObject:@(ENROLLMODE_BroadSL)];
}

- (NSArray *)showFunctionTypeDevices {
    return @[HWDeviceTypeRelay];
}

- (NSDictionary *)relayFunctionDisplayName {
    return @{RELAY_TYPE_LIGHT           : NSLocalizedString(@"common_type_light", nil),
             RELAY_TYPE_TV              : NSLocalizedString(@"common_type_tv", nil),
             RELAY_TYPE_REFRIGERATOR    : NSLocalizedString(@"common_type_refrigerator", nil),
             RELAY_TYPE_SPEAKER         : NSLocalizedString(@"common_type_speaker", nil),
             RELAY_TYPE_FAN             : NSLocalizedString(@"common_type_fan", nil),
             RELAY_TYPE_MICROWAVE_OVEN  : NSLocalizedString(@"common_type_microwaveoven", nil),
             RELAY_TYPE_RICE_COOKER     : NSLocalizedString(@"common_type_ricecooker", nil),
             RELAY_TYPE_ELECTRIC_KETTLE : NSLocalizedString(@"common_type_electrickettle", nil),
             RELAY_TYPE_WATER_HEATER    : NSLocalizedString(@"common_type_waterheater", nil),
             RELAY_TYPE_OTHERS          : NSLocalizedString(@"common_type_switch", nil)};
}

- (NSDictionary *)relayFunctionDisplayImageName {
    return @{RELAY_TYPE_LIGHT           : @"light_small.png",
             RELAY_TYPE_TV              : @"tv_small.png",
             RELAY_TYPE_REFRIGERATOR    : @"refrigerator_small.png",
             RELAY_TYPE_SPEAKER         : @"speaker_small.png",
             RELAY_TYPE_FAN             : @"fan_small.png",
             RELAY_TYPE_MICROWAVE_OVEN  : @"microwave_oven.png",
             RELAY_TYPE_RICE_COOKER     : @"rice_cooker_small.png",
             RELAY_TYPE_ELECTRIC_KETTLE : @"electric_kettle_small.png",
             RELAY_TYPE_WATER_HEATER    : @"water_heater_small.png",
             RELAY_TYPE_OTHERS          : @"relay_small.png"};
}

- (void)updateSubDevices:(NSArray *)devices {
    //First : reverse loop current all devices
    // Update device info if exists
    for (int i = (int)self.subDevices.count - 1; i>=0; i--) {
        DeviceModel * deviceModel = self.subDevices[i];
        BOOL find = NO;
        //Find same device model from cloud device array,then update
        for (NSDictionary * subDic in devices) {
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
            [self.subDevices removeObject:deviceModel];
        }
    }
    
    //Second : loop cloud device array
    // Add device model if new device found from cloud
    for (int i = 0; i < devices.count; i++) {
        NSDictionary * subDic  = devices[i];
        DeviceModel *deviceModel = [self getDeviceModelByDictionary:subDic];
        if (deviceModel) {
            [self.subDevices insertObject:deviceModel atIndex:i];
        }
    }
}

- (DeviceModel *)getDeviceModelByDictionary:(NSDictionary *)subDic {
    //check if this device is exist in current device array
    BOOL find = NO;
    for (int j = 0; j < self.subDevices.count; j++) {
        DeviceModel * deviceModel = self.subDevices[j];
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
            DeviceModel *deviceModel = [[class alloc]initWithDictionary:subDic];
            deviceModel.homeModel = self.homeModel;
            return deviceModel;
        }
    }
    return nil;
}

- (void)updateDeviceRunStatus:(HWAPICallBack)callback {
    [self.deviceRunStatusAPIManager callAPIWithParam:@{
                                                       @"devices":@[
                                                               @{
                                                                   @"deviceId":@(self.deviceID),
                                                                   @"locationId": @(self.locationId),
                                                                   }
                                                               ]
                                                       }
                                          completion:^(id object, NSError *error) {
                                              if (!error) {
                                                  if ([object isKindOfClass:[NSDictionary class]]) {
                                                      NSArray *devices = (NSArray *)object[@"devices"];
                                                      if ([devices count] > 0) {
                                                          [self updateWithDictionary:devices[0]];
                                                          if (callback) {
                                                              callback(object, error);
                                                          }
                                                          [[NSNotificationCenter defaultCenter]postNotificationName:kNotification_UpdateDeviceSucceed object:self userInfo:@{@"deviceId":[NSString stringWithFormat:@"%ld",(long)self.deviceID],@"locationId":[NSString stringWithFormat:@"%@",@(self.locationId)]}];
                                                      }
                                                  }
                                              }
                                          }];
}

- (void)checkOnlineWithTimeout:(NSInteger)timeout callBack:(HWAPICallBack)callBack {
    self.checkOnline = YES;
    self.callBack = callBack;
    [self checkOnlineWithOnline:NO];
    __weak __typeof(self) weakSelf = self;
    [TimerUtil scheduledDispatchTimerWithName:kCheckOnlineTimerName timeInterval:timeout repeats:NO action:^{
        if (weakSelf.callBack) {
            weakSelf.callBack(nil, [NSError errorWithDomain:@"DeviceOffLine" code:0 userInfo:nil]);
            weakSelf.callBack = nil;
            weakSelf.checkOnline = NO;
        }
    }];
}

- (void)checkOnlineWithOnline:(BOOL)online {
    if (self.checkOnline) {
        if (online) {
            [TimerUtil cancelTimerWithName:kCheckOnlineTimerName];
            if (self.callBack) {
                self.callBack(nil, nil);
                self.callBack = nil;
                self.checkOnline = NO;
            }
        } else {
            __weak __typeof(self) weakSelf = self;
            [self checkOnlineRequest:^(BOOL deviceOnline) {
                [weakSelf checkOnlineWithOnline:deviceOnline];
            }];
        }
    }
}

- (void)checkOnlineRequest:(void(^)(BOOL))block {
    NSInteger authorizedType = self.homeModel.authorizedType;
    [self.deviceRunStatusAPIManager callAPIWithParam:@{
                                                       @"devices":@[
                                                               @{
                                                                   @"deviceId":@(self.deviceID),
                                                                   @"locationId": @(self.locationId),
                                                                   @"authorizedType":@(authorizedType)
                                                                   }
                                                               ]
                                                       } completion:^(id object, NSError *error) {
                                                           NSLog(@"DeviceOnlineStatus:%@",object);
                                                           BOOL online = NO;
                                                           if ([object isKindOfClass:[NSDictionary class]]) {
                                                               NSArray *devices = (NSArray *)object[@"devices"];
                                                               if ([devices count] > 0) {
                                                                   [self updateWithDictionary:devices[0]];
                                                                   NSDictionary *info = devices[0];
                                                                   online = [info[@"online"] boolValue];
                                                               }
                                                           }
                                                           if (block) {
                                                               block(online);
                                                           }
                                                       }];
}

- (NSString *)getChinaSwdDeviceName {
    if (self.name.length > 0) {
        return self.name;
    } else if (self.featureName.count > 0) {
        return self.featureName.firstObject;
    } else {
        if (self.nameType != 0) {
            NSString *deviceName = [self getDeviceNameWithType:self.nameType];
            if (self.nameIndex != 0) {
                deviceName = [NSString stringWithFormat:@"%@-%@",deviceName,@(self.nameIndex + 1)];

            }
            return deviceName;
        } else {
            if (self.sku.length > 0) {
                return [self getDeviceNameBySKU:self.sku];
            }
        }
    }
    return @"";
}

- (NSString *)getDeviceNameWithType:(NSInteger)nameType {
    switch (nameType) {
        case 1:
            return NSLocalizedString(@"common_primarylight", nil);
        case 2:
            return NSLocalizedString(@"common_auxiliarylight", nil);
        case 3:
            return NSLocalizedString(@"common_bedlight", nil);
        case 4:
            return NSLocalizedString(@"common_readinglight", nil);
        case 5:
            return NSLocalizedString(@"common_moodlight", nil);
        case 6:
            return NSLocalizedString(@"common_ledstrip", nil);
        case 7:
            return NSLocalizedString(@"common_spotlight", nil);
        case 8:
            return NSLocalizedString(@"common_nightlight", nil);
        case 9:
            return NSLocalizedString(@"common_balconylight", nil);
        case 10:
            return NSLocalizedString(@"common_backgroundlight", nil);
        case 11:
            return NSLocalizedString(@"common_exhibitlight", nil);
        case 12:
            return NSLocalizedString(@"common_cellinglight", nil);
        case 13:
            return NSLocalizedString(@"common_ambientlight", nil);
        case 14:
            return NSLocalizedString(@"common_downlight", nil);
        case 15:
            return NSLocalizedString(@"common_porchlight", nil);
        case 16:
            return NSLocalizedString(@"common_corridorlight", nil);
        case 17:
            return NSLocalizedString(@"common_mirrorlight", nil);
        case 18:
            return NSLocalizedString(@"common_type_fan", nil);
        case 19:
            return NSLocalizedString(@"common_sheer", nil);
        case 20:
            return NSLocalizedString(@"common_type_curtain", nil);
        case 21:
            return NSLocalizedString(@"common_type_scenepanel", nil);
        default:
            return @"";
    }
}

- (NSString *)getDeviceNameBySKU:(NSString *)sku {
    if ([sku isEqualToString:@"HAG1K-433-SWG"] ||
        [sku isEqualToString:@"HAG2K-433-SWG"] ||
        [sku isEqualToString:@"HAG3K-433-SWG"]) {
        return NSLocalizedString(@"common_type_switch", nil);
    } else if ([sku isEqualToString:@"HAG1S-433-SWG"] ||
               [sku isEqualToString:@"HAG2S-433-SWG"] ||
               [sku isEqualToString:@"HAG3S-433-SWG"] ||
               [sku isEqualToString:@"HAG4S-433-SWG"] ||
               [sku isEqualToString:@"HAG8S-433-SWG"]) {
        return NSLocalizedString(@"common_type_scenepanel", nil);
    } else if ([sku isEqualToString:@"HAG4SBC-433-SWG"]) {
        return NSLocalizedString(@"common_type_curtain", nil);
    }
    return @"";
}

#pragma mark - Getter
- (HWDeviceUpdateAPIManager *)deviceUpdateAPIManager {
    if (!_deviceUpdateAPIManager) {
        _deviceUpdateAPIManager = [[HWDeviceUpdateAPIManager alloc] init];
    }
    return _deviceUpdateAPIManager;
}

- (HWDeviceRunStatusAPIManager *)deviceRunStatusAPIManager {
    if (!_deviceRunStatusAPIManager) {
        _deviceRunStatusAPIManager = [[HWDeviceRunStatusAPIManager alloc] init];
    }
    return _deviceRunStatusAPIManager;
}

@end
