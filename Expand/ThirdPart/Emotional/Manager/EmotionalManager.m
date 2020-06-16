//
//  EmotionalManager.m
//  AirTouch
//
//  Created by Liu, Carl on 8/11/16.
//  Copyright © 2016 Honeywell. All rights reserved.
//

#import "EmotionalManager.h"
#import "EmotionalModel.h"
#import "HomeModel.h"
#import "DateTimeUtil.h"

@interface EmotionalManager ()

@property (strong, nonatomic) HomeModel *homeModel;

@end

@implementation EmotionalManager

- (id)initWithHomeModel:(HomeModel *)homeModel {
    self = [super init];
    if (self) {
        self.homeModel = homeModel;
    }
    return self;
}

- (void)loadDataForPeriod:(EmotionPeriodType)period fromDate:(NSString *)from toDate:(NSString *)to completion:(EmotionalBlock)completion {
    HWHistoryDataModel *historyData = [self.homeModel.emotionalModel emotionalModelOfType:period];
    if (historyData.loadingStatus == HistoryDataLoadingStatusFailed) {
        historyData.loadingStatus = HistoryDataLoadingStatusLoading;
    }
    
    NSDictionary *dict = @{@"locationId":_homeModel.locationID,
                           @"from":from,
                           @"to":to};
    
    [historyData loadDataWithParam:dict completion:^(id object, NSError *error) {
        if (completion) {
            completion(error, historyData);
        }
    }];
}

- (void)loadTotalValueForPeriod:(EmotionPeriodType)period completion:(HWAPICallBack)completion {
    HWHistoryDataModel *historyData = [self.homeModel.emotionalModel emotionalModelOfType:period];
    NSDictionary *params = @{@"locationId":_homeModel.locationID};
    [historyData loadTotalValueWithParam:params completion:^(id object, NSError *error) {
        if (completion) {
            completion(object, error);
        }
    }];
}

- (BOOL)checkLoadDataWithType:(EmotionPeriodType)type {
    HWHistoryDataModel *historyData = [_homeModel.emotionalModel emotionalModelOfType:type];
    NSString *lastDateString = [historyData.historyData lastObject][@"DateString"];
    if (!lastDateString) {
        return YES;
    }
    NSDate *yesterday = [NSDate dateWithTimeInterval:-24*60*60 sinceDate:[DateTimeUtil getLocaleDate]];
    NSString *yesterdayString = [DateTimeUtil getYYMMDDDateString:yesterday];
    return ![yesterdayString isEqualToString:lastDateString];
}

- (BOOL)showLoadingWithType:(EmotionPeriodType)type {
    HWHistoryDataModel *historyData = [_homeModel.emotionalModel emotionalModelOfType:type];
    
    if (historyData.loadingStatus == HistoryDataLoadingStatusLoading || historyData.loadingStatus == HistoryDataLoadingStatusFailed) {
        return YES;
    }
    
    return NO;
}

@end
