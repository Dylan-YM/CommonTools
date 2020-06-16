//
//  AirQualityHistoryModel.m
//  Services
//
//  Created by Honeywell on 2016/12/26.
//  Copyright © 2016年 Honeywell. All rights reserved.
//

#import "AirQualityHistoryModel.h"
#import "HWEmotionGetDustAndPM25APIManager.h"
#import "HWTotalDustAPIManager.h"
#import "DateTimeUtil.h"

@interface AirQualityHistoryModel ()

@property (strong, nonatomic) HWEmotionGetDustAndPM25APIManager *getDustAndPM25Manager;

@property (strong, nonatomic) HWTotalDustAPIManager *totalDustAPIManager;

@end

@implementation AirQualityHistoryModel

- (void)loadDataWithParam:(NSDictionary *)param completion:(HWAPICallBack)completion {
    
    [self.getDustAndPM25Manager callAPIWithParam:param completion:^(id object, NSError *error) {
        NSDictionary *result = nil;
        if (!error) {
            if ([object isKindOfClass:[NSDictionary class]]) {
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
    [self.totalDustAPIManager callAPIWithParam:param completion:^(id object, NSError *error) {
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

- (NSArray *)parseHistoryData:(NSDictionary *)dictData {
    NSString *axisKey = @"date";
    NSString *valueKey = @"outValue";
    NSString *secondValueKey = @"inValue";
    NSString *particulars = @"value";
    
    if (![[dictData allKeys] containsObject:@"dustAndInPm25Response"] || ![[dictData objectForKey:@"dustAndInPm25Response"] isKindOfClass:[NSArray class]]) {
        return nil;
    }
    NSArray *inPm25Array = dictData[@"dustAndInPm25Response"];
    NSArray *outPm25Array = dictData[@"outPm25Response"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    
    inPm25Array = [inPm25Array sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSDate *date1 = [formatter dateFromString:obj1[@"ymd"]];
        NSDate *date2 = [formatter dateFromString:obj2[@"ymd"]];
        NSComparisonResult result = [date1 compare:date2];
        return result == NSOrderedDescending;
    }];
    NSString *firstDateString = [inPm25Array firstObject][@"ymd"];
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
        
        for (NSDictionary *outData in outPm25Array) {
            if ([[outData allKeys] containsObject:@"ymd"] && [outData[@"ymd"] isEqualToString:dateString]) {
                [oneDayData setObject:([[outData allKeys] containsObject:@"avgOutPM25"] ? outData[@"avgOutPM25"] : @"-1") forKey:valueKey];
                break;
            }
        }
        for (NSDictionary *inData in inPm25Array) {
            if ([[inData allKeys] containsObject:@"ymd"] && [inData[@"ymd"] isEqualToString:dateString]) {
                [oneDayData setObject:([[inData allKeys] containsObject:@"avgInPM25"] ? inData[@"avgInPM25"] : @"-1") forKey:secondValueKey];
                [oneDayData setObject:([[inData allKeys] containsObject:@"cleanDust"] ? inData[@"cleanDust"] : @"-1") forKey:particulars];
                break;
            }
        }
        
        [resultArray addObject:oneDayData];
    }
    
    return resultArray;
}

- (HWEmotionGetDustAndPM25APIManager *)getDustAndPM25Manager {
    if (!_getDustAndPM25Manager) {
        _getDustAndPM25Manager = [[HWEmotionGetDustAndPM25APIManager alloc] init];
    }
    return _getDustAndPM25Manager;
}

- (HWTotalDustAPIManager *)totalDustAPIManager {
    if (!_totalDustAPIManager) {
        _totalDustAPIManager = [[HWTotalDustAPIManager alloc] init];
    }
    return _totalDustAPIManager;
}

@end
