//
//  EmotionalManager.h
//  AirTouch
//
//  Created by Liu, Carl on 8/11/16.
//  Copyright © 2016 Honeywell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EmotionalModel.h"

@class HomeModel,HWHistoryDataModel;

typedef void(^EmotionalBlock)(NSError *error, HWHistoryDataModel *object);

@interface EmotionalManager : NSObject

- (id)initWithHomeModel:(HomeModel *)homeModel;

- (BOOL)checkLoadDataWithType:(EmotionPeriodType)type;

- (BOOL)showLoadingWithType:(EmotionPeriodType)type;

- (void)loadDataForPeriod:(EmotionPeriodType)period fromDate:(NSString *)from toDate:(NSString *)to completion:(EmotionalBlock)completion;

- (void)loadTotalValueForPeriod:(EmotionPeriodType)period completion:(HWAPICallBack)completion;

@end
