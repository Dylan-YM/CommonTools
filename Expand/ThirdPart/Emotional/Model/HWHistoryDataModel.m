//
//  HWHistoryDataModel.m
//  Services
//
//  Created by Honeywell on 2016/12/26.
//  Copyright © 2016年 Honeywell. All rights reserved.
//

#import "HWHistoryDataModel.h"

@interface HWHistoryDataModel ()

@property (nonatomic, strong) NSArray *historyData;

@property (nonatomic, assign) CGFloat totalValue;

@end

@implementation HWHistoryDataModel

- (void)updateWithObject:(id)obj {
    if ([obj isKindOfClass:[NSDictionary class]]) {
        [self updateWithDictionary:obj];
    } else {
        if (self.loadingStatus == HistoryDataLoadingStatusLoading) {
            self.loadingStatus = HistoryDataLoadingStatusFailed;
        }
    }
}

- (void)updateWithDictionary:(NSDictionary *)dictionary {
    if ([dictionary.allKeys containsObject:@"historyData"]) {
        self.loadingStatus = HistoryDataLoadingStatusSuccess;
        self.historyData = dictionary[@"historyData"];
    }
    if ([dictionary.allKeys containsObject:@"totalValue"]) {
        self.totalValue = [dictionary[@"totalValue"] floatValue];
    }
}

- (void)loadDataWithParam:(NSDictionary *)param completion:(HWAPICallBack)completion {
    
}

- (void)loadTotalValueWithParam:(NSDictionary *)param completion:(HWAPICallBack)completion {
    
}

@end
