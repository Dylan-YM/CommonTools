//
//  HWScenarioModel.m
//  HomePlatform
//
//  Created by Honeywell on 2018/5/7.
//  Copyright © 2018 Honeywell. All rights reserved.
//

#import "HWScenarioModel.h"
#import "HomeModel.h"
#import "AppConfig.h"
#import "DeviceModel.h"

@implementation HWScenarioModel

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.order = -1;
        [self updateWithDictionary:dictionary];
    }
    return self;
}

- (void)updateWithDictionary:(NSDictionary *)dictionary {
    NSArray *keys = [dictionary allKeys];
    if ([keys containsObject:@"scenario"]) {
        self.scenario = [dictionary[@"scenario"] integerValue];
        self.tunaScenario = [[self tunaScenarios] containsObject:@(self.scenario)];
    }
    if ([keys containsObject:@"order"]) {
        self.order = [dictionary[@"order"] integerValue];
    }
    if ([keys containsObject:@"isDefault"]) {
        self.isDefault = [dictionary[@"isDefault"] boolValue];
    }
    if ([keys containsObject:@"isFavorite"]) {
        self.isFavorite = [dictionary[@"isFavorite"] boolValue];
    }
    if ([keys containsObject:@"iconIndex"]) {
        self.iconIndex = [dictionary[@"iconIndex"] integerValue];
    }
    if ([keys containsObject:@"name"]) {
        self.name = dictionary[@"name"];
    }
    if ([keys containsObject:@"deviceList"]) {
        self.deviceList = dictionary[@"deviceList"];
    }
    if ([keys containsObject:@"notification"]) {
        self.notification = [dictionary[@"notification"] boolValue];
    }
    if ([keys containsObject:@"nameIndex"]) {
        self.nameIndex = [dictionary[@"nameIndex"] integerValue];
    }
    if ([keys containsObject:@"nameType"]) {
        self.nameType = [dictionary[@"nameType"] integerValue];
    }
    
    if (self.name.length <= 0) {
        self.name = [self getDefaultSceneName];
    }
}

- (NSString *)getDefaultSceneName {
    NSString *defaultName = [self getDefaultSceneTypeName:self.nameType];
    if (self.nameIndex > 1) {
        defaultName = [NSString stringWithFormat:@"%@ %@",defaultName,@(self.nameIndex)];
    }
    return defaultName;
}

- (NSString *)getDefaultSceneTypeName:(NSInteger)nameType {
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

- (NSDictionary *)convertToDictionary {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict addEntriesFromDictionary:@{@"scenario":@(self.scenario),
                                     @"isDefault":@(self.isDefault),
                                     @"isFavorite":@(self.isFavorite),
                                     @"iconIndex":@(self.iconIndex),
                                     @"name":self.name?:@"",
                                     @"deviceList":self.deviceList?:@[],
                                     @"hasZoneDevice":self.hasZoneDevice?@(self.hasZoneDevice):@(NO),
                                     @"notification":@(self.notification),
                                     @"order" : @(self.order),
                                     @"nameIndex":@(self.nameIndex),
                                     @"nameType":@(self.nameType)
                                     }];
    return dict;
}

- (NSDictionary<NSNumber *, NSString *> *)iconIndexMap {
    return @{
             @(0) : @"scenario_default_blue",
             @(1) : @"home_blue",
             @(2) : @"away_blue",
             @(3) : @"sleep_blue",
             @(4) : @"awake_blue",
             @(5) : @"movie_blue",
             @(6) : @"party_blue",
             @(7) : @"reading_blue",
             @(8) : @"dinning_blue",
             @(9) : @"all_on",
             @(10) : @"all_off",
             @(11) : @"bright",
             @(12) : @"warm",
             @(13) : @"cozy",
             @(14) : @"romance",
             @(15) : @"game",
             @(16) : @"game",
             @(17) : @"rest",
             @(18) : @"music",
             @(19) : @"night_up",
             };
}

- (NSArray *)tunaScenarios {
    return @[@1,@2,@3,@4];
}

- (NSString *)imageName {
    NSDictionary<NSNumber *, NSString *> * iconIndexMap = [self iconIndexMap];
    NSInteger index = self.iconIndex;
    if (index <= 0) {
        index = self.nameType;
    }
    NSString * imageName = iconIndexMap[@(index)];
    if (!imageName) {
        imageName = iconIndexMap[@0];
    }
    return imageName;
}

- (BOOL)hasZoneDevice {
    if (self.homeModel) {
        for (NSDictionary *deviceDict in self.deviceList) {
            NSString *deviceId = [NSString stringWithFormat:@"%@",deviceDict[@"deviceId"]];
            DeviceModel *device = [self.homeModel getDeviceById:deviceId];
            if ([AppConfig isZoneDeviceType:device.deviceType]) {
                return YES;
            }
        }
    }
    return NO;
}

@end
