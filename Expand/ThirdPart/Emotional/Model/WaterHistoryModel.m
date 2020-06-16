//
//  WaterHistoryModel.m
//  Services
//
//  Created by Honeywell on 2016/12/26.
//  Copyright © 2016年 Honeywell. All rights reserved.
//

#import "WaterHistoryModel.h"
#import "HWEmotionGetVolumeAndTDsAPIManager.h"
#import "DateTimeUtil.h"
#import "HWTotalVolumeAPIManager.h"

@interface WaterHistoryModel ()

@property (strong, nonatomic) HWEmotionGetVolumeAndTDsAPIManager *getVolumeAndTDsAPIManager;

@property (strong, nonatomic) HWTotalVolumeAPIManager *totalVolumeAPIManager;

@end

@implementation WaterHistoryModel

- (void)loadDataWithParam:(NSDictionary *)param completion:(HWAPICallBack)completion {
    
    [self.getVolumeAndTDsAPIManager callAPIWithParam:param completion:^(id object, NSError *error) {
        NSDictionary *result = nil;
        if (!error) {
            if ([object isKindOfClass:[NSArray class]]) {
                NSArray *dataArray = [self parseHistoryData:object];
                if (dataArray) {
                    result = @{@"historyData":dataArray};
                }
            }
            [self updateWithObject:result];
        }
        
        if (completion) {
            completion(result, error);
        }
    }];
}

- (void)loadTotalValueWithParam:(NSDictionary *)param completion:(HWAPICallBack)completion {
    [self.totalVolumeAPIManager callAPIWithParam:param completion:^(id object, NSError *error) {
        if (!error) {
            if (object) {
                [self updateWithObject:@{@"totalValue":object}];
            }
        }
        if (completion) {
            completion(object, error);
        }
    }];
}

- (NSArray *)parseHistoryData:(NSArray *)arrData {
    NSString *axisKey = @"date";
    NSString *valueKey = @"outValue";
    NSString *secondValueKey = @"inValue";
    NSString *particulars = @"value";
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    arrData = [arrData sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        
        
        NSDate *date1 = [formatter dateFromString:obj1[@"ymd"]];
        NSDate *date2 = [formatter dateFromString:obj2[@"ymd"]];
        NSComparisonResult result = [date1 compare:date2];
        return result == NSOrderedDescending;
    }];
    NSString *firstDateString = [arrData firstObject][@"ymd"];
    NSDate *yesterday = [NSDate dateWithTimeInterval:-24*60*60 sinceDate:[DateTimeUtil getLocaleDate]];
    NSString *lastDateString = [formatter stringFromDate:yesterday];
    
    NSArray *dateArray = nil;
    if (firstDateString != nil && lastDateString != nil) {
        dateArray = [DateTimeUtil getDateStringsFrom:firstDateString to:lastDateString];
    }
    
    if (!dateArray || dateArray.count < 30) {
        dateArray = [DateTimeUtil getMadAirDateStringArrayWithDays:30];
    }
    
    NSMutableArray *resultArray = [NSMutableArray array];
    [resultArray addObject:@{axisKey:@"",valueKey:@"-1",secondValueKey:@"-1",particulars:@"-1",@"DateString":@""}];
    [resultArray addObject:@{axisKey:@"",valueKey:@"-1",secondValueKey:@"-1",particulars:@"-1",@"DateString":@""}];
    [resultArray addObject:@{axisKey:@"",valueKey:@"-1",secondValueKey:@"-1",particulars:@"-1",@"DateString":@""}];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    for (NSInteger i = 0; i < [dateArray count]; i++) {
        NSMutableDictionary *oneDayData = [NSMutableDictionary dictionary];
        NSString *dateString = dateArray[i];
        
        NSUInteger unitFlags = NSCalendarUnitMonth | NSCalendarUnitDay;
        NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:[formatter dateFromString:dateString]];
        NSInteger month = [dateComponent month];
        NSInteger day = [dateComponent day];
        NSString *monthString = (month >= 10) ? [NSString stringWithFormat:@"%ld",(long)month] : [NSString stringWithFormat:@"0%ld",(long)month];
        NSString *dayString = (day >= 10) ? [NSString stringWithFormat:@"%ld",(long)day] : [NSString stringWithFormat:@"0%ld",(long)day];
        NSString *axisValue = [NSString stringWithFormat:@"%@/%@",monthString,dayString];
        
        [oneDayData setObject:axisValue forKey:axisKey];
        [oneDayData setObject:dateString forKey:@"DateString"];
        [oneDayData setObject:@"-1" forKey:valueKey];
        [oneDayData setObject:@"-1" forKey:secondValueKey];
        [oneDayData setObject:@"-1" forKey:particulars];
        
        for (NSDictionary *data in arrData) {
            if ([[data allKeys] containsObject:@"ymd"] && [data[@"ymd"] isEqualToString:dateString]) {
                [oneDayData setObject:([[data allKeys] containsObject:@"avgInflowTDS"] ? data[@"avgInflowTDS"] : @"-1") forKey:valueKey];
                [oneDayData setObject:([[data allKeys] containsObject:@"outflowVolume"] ? data[@"outflowVolume"] : @"-1") forKey:particulars];
                [oneDayData setObject:([[data allKeys] containsObject:@"avgOutflowTDS"] ? data[@"avgOutflowTDS"] : @"-1") forKey:secondValueKey];
                break;
            }
        }
        
        [resultArray addObject:oneDayData];
    }
    
    return resultArray;
}

- (HWEmotionGetVolumeAndTDsAPIManager *)getVolumeAndTDsAPIManager {
    if (!_getVolumeAndTDsAPIManager) {
        _getVolumeAndTDsAPIManager = [[HWEmotionGetVolumeAndTDsAPIManager alloc] init];
    }
    return _getVolumeAndTDsAPIManager;
}

- (HWTotalVolumeAPIManager *)totalVolumeAPIManager {
    if (!_totalVolumeAPIManager) {
        _totalVolumeAPIManager = [[HWTotalVolumeAPIManager alloc] init];
    }
    return _totalVolumeAPIManager;
}

@end
