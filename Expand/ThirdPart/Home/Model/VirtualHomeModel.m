//
//  VirtualHomeModel.m
//  Services
//
//  Created by Liu, Carl on 21/11/2016.
//  Copyright © 2016 Honeywell. All rights reserved.
//

#import "VirtualHomeModel.h"
#import "UserEntity.h"
#import "AppMarco.h"
#import "UserConfig.h"
#import "HWModeCellModel.h"
#import "DeviceModel.h"

NSString * const VirtualHomeModelCityDidUpdateNotification = @"VirtualHomeModelCityDidUpdateNotification";

@implementation VirtualHomeModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.isOwner = YES;
        self.cityName = [UserConfig getCurrentCityName];
        self.city = [UserConfig getCurrentCityCode];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cityChanged:) name:kNotification_LocationChange object:nil];
    }
    return self;
}

- (BOOL)isRealHome {
    return NO;
}

- (void)cityChanged:(NSNotification *)noti {
    self.city = [UserConfig getCurrentCityCode];
    self.cityName = [UserConfig getCurrentCityName];
    [[NSNotificationCenter defaultCenter]postNotificationName:VirtualHomeModelCityDidUpdateNotification object:self userInfo:nil];
}

#pragma  mark - HWScenarioControllable
- (void)checkControlAvailable:(CheckBlock)block{
    block(YES,nil);
}

- (NSInteger)currentScenario{
    return 0;
}

- (BOOL)isControlling {
    return 0;
}

- (void)scenarioControlWithCellModel:(HWModeCellModel *)model withCallback:(ControllBlock)callback{
    [self controlToScenario:model.commandValue withCallback:callback];
}

- (void)controlToScenario:(id)mode withCallback:(ControllBlock)callback {
    
}

@end
