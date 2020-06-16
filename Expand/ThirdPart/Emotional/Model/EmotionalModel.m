//
//  EmotionalModel.m
//  AirTouch
//
//  Created by Carl on 6/1/15.
//  Copyright (c) 2015 Honeywell. All rights reserved.
//

#import "EmotionalModel.h"
#import "AirQualityHistoryModel.h"
#import "WaterHistoryModel.h"
#import "ModelKey.h"

@interface EmotionalModel ()

@property (nonatomic, strong) HWHistoryDataModel *air;
@property (nonatomic, strong) HWHistoryDataModel *water;

@end

@interface HWHistoryDataModel ()

@property (nonatomic, strong) NSArray *historyData;

@property (nonatomic, assign) CGFloat totalValue;

@end

@implementation EmotionalModel


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.air = [[AirQualityHistoryModel alloc] init];
        self.water = [[WaterHistoryModel alloc] init];
    }
    return self;
}

- (void)updateWithDictionary:(NSDictionary *)dict {
    if ([dict.allKeys containsObject:kAirHistoryData] && [dict[kAirHistoryData] isKindOfClass:[NSArray class]]) {
        self.air.historyData = dict[kAirHistoryData];
    }
    if ([dict.allKeys containsObject:kAirHistoryDataBarTotalValue]) {
        self.air.totalValue = [dict[kAirHistoryDataBarTotalValue] floatValue];
    }
    
    if ([dict.allKeys containsObject:kWaterHistoryData] && [dict[kWaterHistoryData] isKindOfClass:[NSArray class]]) {
        self.water.historyData = dict[kWaterHistoryData];
    }
    if ([dict.allKeys containsObject:kWaterHistoryDataBarTotalValue]) {
        self.water.totalValue = [dict[kWaterHistoryDataBarTotalValue] floatValue];
    }
}

- (NSDictionary *)convertToDictionary {
    NSArray *airHistoryData = self.air.historyData;
    NSArray *waterHistoryData = self.water.historyData;
    CGFloat airBarTotalValue = self.air.totalValue;
    CGFloat waterBarTotalValue = self.water.totalValue;
    NSMutableDictionary *resultDict = [NSMutableDictionary dictionary];
    if (airHistoryData) {
        [resultDict setValue:airHistoryData forKey:kAirHistoryData];
    }
    if (waterHistoryData) {
        [resultDict setValue:waterHistoryData forKey:kWaterHistoryData];
    }
    [resultDict setValue:@(airBarTotalValue) forKey:kAirHistoryDataBarTotalValue];
    [resultDict setValue:@(waterBarTotalValue) forKey:kWaterHistoryDataBarTotalValue];
    return resultDict;
}

- (HWHistoryDataModel *)emotionalModelOfType:(EmotionPeriodType)type {
    HWHistoryDataModel *model = nil;
    switch (type) {
        case EmotionPeriodTypeAir:
            model = _air;
            break;
        case EmotionPeriodTypeWater:
            model = _water;
            break;
        default:
            break;
    }
    return model;
}

@end
