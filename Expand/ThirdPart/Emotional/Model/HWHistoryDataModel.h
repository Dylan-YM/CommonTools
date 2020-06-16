//
//  HWHistoryDataModel.h
//  Services
//
//  Created by Honeywell on 2016/12/26.
//  Copyright © 2016年 Honeywell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseAPIRequest.h"

typedef NS_ENUM(NSInteger, HistoryDataLoadingStatus) {
    HistoryDataLoadingStatusLoading,
    HistoryDataLoadingStatusSuccess,
    HistoryDataLoadingStatusFailed
};

@interface HWHistoryDataModel : NSObject

@property (assign, nonatomic) HistoryDataLoadingStatus loadingStatus;

@property (readonly, nonatomic, strong) NSArray *historyData;

@property (readonly, nonatomic, assign) CGFloat totalValue;

- (void)updateWithObject:(id)obj;

- (void)loadDataWithParam:(NSDictionary *)param completion:(HWAPICallBack)completion;

- (void)loadTotalValueWithParam:(NSDictionary *)param completion:(HWAPICallBack)completion;

@end
