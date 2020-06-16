//
//  CityEntity.h
//  AirTouch
//
//  Created by Devin on 1/21/15.
//  Copyright (c) 2015 Honeywell. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface CityEntity : NSManagedObject

@property (nonatomic, strong) NSString * cityNameZh;
@property (nonatomic, strong) NSString * cityNameEn;
@property (nonatomic, strong) NSString * cityCode;

@end
