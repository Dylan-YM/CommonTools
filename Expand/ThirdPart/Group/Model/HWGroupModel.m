//
//  HWGroupModel.m
//  HomePlatform
//
//  Created by Honeywell on 2017/12/6.
//  Copyright © 2017年 Honeywell. All rights reserved.
//

#import "HWGroupModel.h"
#import "UserEntity.h"
#import "HomeModel.h"
#import "DeviceModel.h"
#import "AppMarco.h"
#import "AppManager.h"

@interface HWGroupModel ()

@property (nonatomic, strong) HWGroupUpdateAPIManager *updateAPIManager;
@property (nonatomic, assign) NSInteger cTempDeviceId;
@property (nonatomic, assign) NSInteger cHumDeviceId;

@end

@implementation HWGroupModel

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.scenarioList = [NSMutableArray array];
        [self updateWithDictionary:dictionary];
    }
    return self;
}

- (void)updateWithDictionary:(NSDictionary *)dictionary {
    NSArray *keys = [dictionary allKeys];
    if ([keys containsObject:@"groupId"]) {
        self.groupId = [dictionary[@"groupId"] integerValue];
    }
    if ([keys containsObject:@"groupName"]) {
        self.groupName = dictionary[@"groupName"];
    }
    if ([keys containsObject:@"scenarioId"]) {
        self.scenarioId = [dictionary[@"scenarioId"]integerValue];
    }
    if ([keys containsObject:@"type"]) {
        self.type = [dictionary[@"type"]integerValue];
    }
    if ([keys containsObject:@"iconIndex"]) {
        self.iconIndex = [dictionary[@"iconIndex"]integerValue];
    }
    if ([keys containsObject:@"gatewayCreated"]) {
        self.gatewayCreated = [dictionary[@"gatewayCreated"] boolValue];
    }
    if ([keys containsObject:@"authorizedTo"]) {
        NSDictionary * authorizedTo = dictionary[@"authorizedTo"];
        self.authorizedTo = [[AuthorizedToModel alloc]initWithDictionary:authorizedTo];
    }
    if ([keys containsObject:@"deviceIds"]) {
        self.deviceIds = dictionary[@"deviceIds"];
    } else {
        self.deviceIds = @[];
    }
    if ([keys containsObject:@"nameIndex"]) {
        self.nameIndex = [dictionary[@"nameIndex"] integerValue];
    }
    if ([keys containsObject:@"nameType"]) {
        self.nameType = [dictionary[@"nameType"] integerValue];
    }
    [self updateGroupName];
    [self updateScenarioWithDictionary:dictionary];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:kNotification_UpdateGroupSucceed object:[self convertToHtml] userInfo:@{@"groupId":[NSString stringWithFormat:@"%ld",(long)self.groupId]}];
}

- (void)updateScenarioWithDictionary:(NSDictionary *)scenarioDict {
    if (![[scenarioDict allKeys] containsObject:@"scenarioList"] && [scenarioDict[@"scenarioList"] isKindOfClass:[NSArray class]]) {
        return;
    }
    NSArray *scenarioDictList = scenarioDict[@"scenarioList"];
    if (scenarioDictList.count > 0) {
        [self updateScenarioWithArray:scenarioDictList];
    } else {
        [self.scenarioList removeAllObjects];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_UpdateRoomScenarioList object:self userInfo:@{@"roomId":@(self.groupId)}];
}

- (void)updateScenarioWithArray:(NSArray *)scenarioDictArray {
    //更新现有的，删除多余的
    for (NSInteger i = 0; i < self.scenarioList.count; i++) {
        HWScenarioModel *scenarioModel = self.scenarioList[i];
        BOOL isExist = NO;
        for (NSInteger j = 0; j < scenarioDictArray.count; j++) {
            NSDictionary *scenarioDict = scenarioDictArray[j];
            NSInteger scenario = [scenarioDict[@"scenario"] integerValue];
            if (scenarioModel.scenario == scenario) {
                isExist = YES;
                [scenarioModel updateWithDictionary:scenarioDict];
            }
        }
        if (!isExist) {
            [self.scenarioList removeObjectAtIndex:i];
        }
    }
    
    //按照index
    for (NSInteger i = 0; i < scenarioDictArray.count; i++) {
        NSDictionary *scenarioDict = scenarioDictArray[i];
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
            scenarioModel.homeModel = self.homeModel;
            [self.scenarioList insertObject:scenarioModel atIndex:i];
        }
    }
}

- (NSArray<DeviceModel *> *)getAllDevices {
    NSMutableArray<DeviceModel *> * allDevices = [NSMutableArray array];
    for (NSInteger i = 0; i < self.deviceIds.count; i++) {
        NSInteger deviceId = [self.deviceIds[i] integerValue];
        DeviceModel *model = [self.homeModel getDeviceById:[NSString stringWithFormat:@"%@",@(deviceId)]];
        if (model) {
            [allDevices addObject:model];
        }
    }
    return allDevices;
}

- (NSUInteger)numberOfTotalDevices {
    NSArray<DeviceModel *> * allDevices = [self getAllDevices];
    return allDevices.count;
}

- (NSUInteger)numberOfActiveDevices {
    NSUInteger numberOfActiveDevices = 0;
    NSArray<DeviceModel *> * allDevices = [self getAllDevices];
    for (DeviceModel * deviceModel in allDevices) {
        BOOL isPowerOn = [deviceModel isPowerOn];
        if (isPowerOn) {
            numberOfActiveDevices++;
        }
    }
    return numberOfActiveDevices;
}

- (NSDictionary<NSNumber *, NSString *> *)iconIndexMap {
    return @{
             @(0) : @"room_default_icon",
             @(1) : @"LivingRoom",
             @(2) : @"Bedroom",
             @(3) : @"Kitchen",
             @(4) : @"Restaurant",
             @(5) : @"Babysroom",
             @(6) : @"Basement",
             @(7) : @"StudyRoom",
             @(8) : @"StoreRoom",
             @(9) : @"Balcony",
             @(10) : @"Corridor",
             @(11) : @"Foyer",
             @(12) : @"Portico",
             @(13) : @"Prayer",
             };
}

- (NSString *)imageName {
    NSDictionary * iconIndexMap = [self iconIndexMap];
    NSArray<NSNumber *> * keys = [iconIndexMap allKeys];
    if (![keys containsObject:@(self.iconIndex)]) {
        return iconIndexMap[@(0)];
    }
    return iconIndexMap[@(self.iconIndex)];
}

- (BOOL)containsDeviceId:(NSInteger)deviceId {
    for (NSNumber *numberDeviceId in self.deviceIds) {
        if ([numberDeviceId integerValue] == deviceId) {
            return YES;
        }
    }
    return NO;
}

- (NSDictionary *)convertToHtml {
    return @{@"groupId":@(self.groupId),
             @"groupName":self.groupName?:@"",
             @"iconIndex":@(self.iconIndex),
             @"gatewayCreated":@(self.gatewayCreated),
             @"deviceIds":self.deviceIds?:@[],
             @"locationId":@([self.homeModel.locationID integerValue]),
             @"isOwner":@([[AppManager getLocalProtocol] authorizedOwner:self.homeModel]),
             @"cTemp":[self getRoomTemp]?:@"",
             @"cHum":[self getRoomHum]?:@"",
             @"pm2.5":[self getRoomPM25]?:@"",
             @"cTempDeviceId":@(self.cTempDeviceId),
             @"cHumDeviceId":@(self.cHumDeviceId),
             @"nameIndex":@(self.nameIndex),
             @"nameType":@(self.nameType)
             };
}

- (NSDictionary *)convertScenarioToDictionary {
    NSMutableArray *convertScenarioListArray = [NSMutableArray array];
    for (NSInteger i = 0; i < self.scenarioList.count; i++) {
        HWScenarioModel *scenarioModel = self.scenarioList[i];
        NSDictionary *scenarioDict = [scenarioModel convertToDictionary];
        [convertScenarioListArray addObject:scenarioDict];
    }
    NSDictionary *dict = @{@"groupId":@(self.groupId),
                           @"scenarioList":convertScenarioListArray
                           };
    return dict;
}

- (void)groupUpdateWithParams:(NSDictionary *)params callBack:(HWAPICallBack)callBack {
    __weak typeof (self) weakSelf = self;
    [self.updateAPIManager callAPIWithParam:params completion:^(id object, NSError *error) {
        if (!error) {
            weakSelf.groupName = params[@"groupList"][0][@"groupName"];
            [[UserEntity instance] updateGroupList];
        }
        callBack(object, error);
    }];
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

- (NSArray *)getAllDeviceDicts {
    NSMutableArray *deviceDicts = [NSMutableArray array];
    NSArray *devices = [self getAllDevices];
    for (NSInteger i = 0; i < devices.count; i++) {
        DeviceModel *model = devices[i];
        [deviceDicts addObject:[model convertToHtml]];
    }
    return deviceDicts;
}

- (NSString *)getRoomTemp {
    NSArray *deviceList = [self getAllDevices];
    DeviceModel *dolphinDevice = nil;
    DeviceModel *acDevice = nil;
    DeviceModel *floorHeatingDevice = nil;
    DeviceModel *smartIAQDevice = nil;
    DeviceModel *wallventilatorDevice = nil;
    DeviceModel *sensorDevice = nil;
    for (NSInteger i = deviceList.count-1; i >= 0; i--) {
        DeviceModel *model = deviceList[i];
        if ([model.deviceType isEqualToString:HWDeviceTypeDolphin]
            && model.isAlive) {
            dolphinDevice = model;
        }
        if (([model.deviceType isEqualToString:HWDeviceTypeAirCondition]|| [model.deviceType isEqualToString:HWDeviceTypeAirCondition_002]||[model.deviceType isEqualToString:HWDeviceTypeAirCondition_003]||[model.deviceType isEqualToString:HWDeviceTypeAirCondition_004])
            && model.isAlive) {
            acDevice = model;
        } else if ([model.deviceType isEqualToString:HWDeviceTypeSmartIAQ]
                   && model.isAlive) {
            smartIAQDevice = model;
        } else if ([model.deviceType isEqualToString:HWDeviceTypeWallVentilator]
                   && model.isAlive) {
            wallventilatorDevice = model;
        } else if ([model.deviceType isEqualToString:HWDeviceTypeUnderFloorHeating]
                   && model.isAlive) {
            floorHeatingDevice = model;
        }
        if ([model.deviceType isEqualToString:HWDeviceTypeHaiLin] && model.isAlive) {
            sensorDevice = model;
        }
    }
    NSInteger tempInt = 0;
    if (sensorDevice && sensorDevice.runStatus[@"cTemp"] && ![sensorDevice.runStatus[@"cTemp"] isEqualToString:@""]) {
        self.cTempDeviceId = sensorDevice.deviceID;
        tempInt = [sensorDevice.runStatus[@"cTemp"] integerValue];
    } else if (dolphinDevice && dolphinDevice.runStatus[@"cTemp"] && ![dolphinDevice.runStatus[@"cTemp"] isEqualToString:@""]) {
        self.cTempDeviceId = dolphinDevice.deviceID;
        tempInt = [[NSString stringWithFormat:@"%@",dolphinDevice.runStatus[@"cTemp"]] integerValue];
    } else if (acDevice && acDevice.runStatus[@"cTemp"] && ![acDevice.runStatus[@"cTemp"] isEqualToString:@""]) {
        self.cTempDeviceId = acDevice.deviceID;
        tempInt = [[NSString stringWithFormat:@"%@",acDevice.runStatus[@"cTemp"]] integerValue];
    } else if (smartIAQDevice && smartIAQDevice.runStatus[@"cTemp"] && ![smartIAQDevice.runStatus[@"cTemp"] isEqualToString:@""]) {
        self.cTempDeviceId = smartIAQDevice.deviceID;
        tempInt = [[NSString stringWithFormat:@"%@",smartIAQDevice.runStatus[@"cTemp"]] integerValue];
    } else if (wallventilatorDevice && wallventilatorDevice.runStatus[@"indoorTemp"] && ![wallventilatorDevice.runStatus[@"indoorTemp"] isEqualToString:@""]) {
        self.cTempDeviceId = wallventilatorDevice.deviceID;
        tempInt = [[NSString stringWithFormat:@"%@",wallventilatorDevice.runStatus[@"indoorTemp"]] integerValue];
    } else if (floorHeatingDevice && floorHeatingDevice.runStatus[@"cTemp"] && ![floorHeatingDevice.runStatus[@"cTemp"] isEqualToString:@""]) {
        self.cTempDeviceId = floorHeatingDevice.deviceID;
        tempInt = [[NSString stringWithFormat:@"%@",floorHeatingDevice.runStatus[@"cTemp"]] integerValue];
    } else {
        return nil;
    }
    return [NSString stringWithFormat:@"%@",@(tempInt)];
}

- (NSString *)getRoomHum {
    NSArray *deviceList = [self getAllDevices];
    DeviceModel *dolphinDevice = nil;
    DeviceModel *smartIAQDevice = nil;
    DeviceModel *sensorDevice = nil;
    for (NSInteger i = deviceList.count-1; i >= 0; i--) {
        DeviceModel *model = deviceList[i];
        if ([model.deviceType isEqualToString:HWDeviceTypeDolphin]
            && model.isAlive) {
            dolphinDevice = model;
        }
        if ([model.deviceType isEqualToString:HWDeviceTypeSmartIAQ]
            && model.isAlive) {
            smartIAQDevice = model;
        }
        if ([model.deviceType isEqualToString:HWDeviceTypeHaiLin] && model.isAlive) {
            sensorDevice = model;
        }
    }
    NSInteger humValue = 0;
    if (sensorDevice && sensorDevice.runStatus[@"cHum"] && ![sensorDevice.runStatus[@"cHum"] isEqualToString:@""]) {
        self.cHumDeviceId = sensorDevice.deviceID;
        humValue = [sensorDevice.runStatus[@"cHum"] integerValue];
    } else if (dolphinDevice && dolphinDevice.runStatus[@"cHum"] && ![dolphinDevice.runStatus[@"cHum"] isEqualToString:@""]) {
        self.cHumDeviceId = dolphinDevice.deviceID;
        humValue = [dolphinDevice.runStatus[@"cHum"] integerValue];
    } else if (smartIAQDevice && smartIAQDevice.runStatus[@"cHum"] && ![smartIAQDevice.runStatus[@"cHum"] isEqualToString:@""]) {
        self.cHumDeviceId = smartIAQDevice.deviceID;
        humValue = [smartIAQDevice.runStatus[@"cHum"] integerValue];
    } else {
        return nil;
    }
    
    if (humValue == 65534 || humValue == 65535) {
        return nil;
    } else if (humValue > 999) {
        return @"999";
    } else {
        return [NSString stringWithFormat:@"%@",@(humValue)];
    }
}

- (NSString *)getRoomPM25 {
    NSArray *deviceList = [self getAllDevices];
    DeviceModel *smartIAQDevice = nil;
    DeviceModel *wallventilatorDevice = nil;
    DeviceModel *sensorDevice = nil;
    for (NSInteger i = deviceList.count-1; i >= 0; i--) {
        DeviceModel *model = deviceList[i];
        if ([model.deviceType isEqualToString:HWDeviceTypeSmartIAQ]
            && model.isAlive) {
            smartIAQDevice = model;
        }
        if ([model.deviceType isEqualToString:HWDeviceTypeWallVentilator]
            && model.isAlive) {
            wallventilatorDevice = model;
        }
        if ([model.deviceType isEqualToString:HWDeviceTypeHaiLin] && model.isAlive) {
            sensorDevice = model;
        }
    }
    NSInteger pm25Value = 0;
    if (sensorDevice && sensorDevice.runStatus[@"PM2.5"] && ![sensorDevice.runStatus[@"PM2.5"] isEqualToString:@""]) {
        pm25Value = [sensorDevice.runStatus[@"PM2.5"] integerValue];
    } else if (smartIAQDevice && smartIAQDevice.runStatus[@"PM2.5"] && ![smartIAQDevice.runStatus[@"PM2.5"] isEqualToString:@""]) {
        pm25Value = [smartIAQDevice.runStatus[@"PM2.5"] integerValue];
    } else if (wallventilatorDevice && wallventilatorDevice.runStatus[@"pm25"]) {
        pm25Value = [wallventilatorDevice.runStatus[@"pm25"] integerValue];
    } else {
        return nil;
    }
    
    if (pm25Value == 65534 || pm25Value == 65535) {
        return nil;
    } else if (pm25Value > 999) {
        return @"999";
    } else {
        return [NSString stringWithFormat:@"%@",@(pm25Value)];
    }
}

- (void)updateGroupName {
    if (!self.groupName || self.groupName.length == 0) {
        NSString *defaultName = [self getDefaultRoomTypeName:self.nameType];
        if (self.nameIndex > 1) {
            defaultName = [NSString stringWithFormat:@"%@ %@",defaultName,@(self.nameIndex)];
        }
        self.groupName = defaultName;
    }
}

- (NSString *)getDefaultRoomTypeName:(NSInteger)nameType {
    switch (nameType){
        case 1:
            return NSLocalizedString(@"devices_lbl_livingroom", nil);
        case 2:
            return NSLocalizedString(@"devices_lbl_bedroom", nil);
        case 3:
            return NSLocalizedString(@"devices_lbl_kitchen", nil);
        case 4:
            return NSLocalizedString(@"devices_lbl_dinningroom", nil);
        case 5:
            return NSLocalizedString(@"devices_lbl_kidsroom", nil);
        case 6:
            return NSLocalizedString(@"devices_lbl_bathroom", nil);
        case 7:
            return NSLocalizedString(@"devices_lbl_studyroom", nil);
        case 8:
            return NSLocalizedString(@"devices_lbl_storeroom", nil);
        case 9:
            return NSLocalizedString(@"devices_lbl_balcony", nil);
        case 10:
            return NSLocalizedString(@"devices_lbl_corridor", nil);
        case 11:
            return NSLocalizedString(@"devices_lbl_foyer", nil);
        case 12:
            return NSLocalizedString(@"devices_lbl_portico", nil);
        case 13:
            return NSLocalizedString(@"devices_lbl_prayerroom", nil);
        case 14:
            return NSLocalizedString(@"devices_lbl_room", nil);
        case 15:
            return NSLocalizedString(@"devices_lbl_masterbedroom", nil);
        case 16:
            return NSLocalizedString(@"devices_lbl_secondarybedroom", nil);
        case 17:
            return NSLocalizedString(@"devices_lbl_portico", nil);
        case 18:
            return NSLocalizedString(@"devices_lbl_playroom", nil);
        case 19:
            return NSLocalizedString(@"devices_lbl_movieroom", nil);
        case 20:
            return NSLocalizedString(@"devices_lbl_gymroom", nil);
        case 21:
            return NSLocalizedString(@"devices_lbl_equipmentroom", nil);
        case 22:
            return NSLocalizedString(@"devices_lbl_guestroom", nil);
        case 23:
            return NSLocalizedString(@"devices_lbl_elderroom", nil);
        case 24:
            return NSLocalizedString(@"devices_lbl_maidroom", nil);
        default:
            return @"";
    }
}

#pragma mark - getter
- (HWGroupUpdateAPIManager *)updateAPIManager {
    if (!_updateAPIManager) {
        _updateAPIManager = [[HWGroupUpdateAPIManager alloc] init];
    }
    return _updateAPIManager;
}

@end
