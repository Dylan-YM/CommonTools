//
//  EmotionalModel.h
//  AirTouch
//
//  Created by Carl on 6/1/15.
//  Copyright (c) 2015 Honeywell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HWHistoryDataModel.h"

typedef enum : NSUInteger {
    EmotionPeriodTypeAir,
    EmotionPeriodTypeWater,
    EmotionPeriodTypeInvalid
} EmotionPeriodType;

@class HWHistoryDataModel;

@interface EmotionalModel : NSObject

- (HWHistoryDataModel *)emotionalModelOfType:(EmotionPeriodType)type;

- (NSDictionary *)convertToDictionary;

- (void)updateWithDictionary:(NSDictionary *)dict;

@end
