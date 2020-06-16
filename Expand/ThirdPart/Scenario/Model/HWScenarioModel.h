//
//  HWScenarioModel.h
//  HomePlatform
//
//  Created by Honeywell on 2018/5/7.
//  Copyright © 2018 Honeywell. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HomeModel;

@interface HWScenarioModel : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) NSInteger scenario;
@property (nonatomic, assign) NSInteger order;
@property (nonatomic, assign) BOOL isDefault;
@property (nonatomic, assign) BOOL isFavorite;
@property (nonatomic, assign) NSInteger iconIndex;
@property (nonatomic, strong) NSArray *deviceList;
@property (nonatomic, weak) HomeModel *homeModel;
@property (nonatomic, assign) BOOL hasZoneDevice;
@property (nonatomic, assign) BOOL notification;
@property (nonatomic, assign) BOOL tunaScenario;
@property (nonatomic, assign) NSInteger nameIndex;
@property (nonatomic, assign) NSInteger nameType;

@property (nonatomic, assign) NSInteger locationId;

- (id)initWithDictionary:(NSDictionary *)dictionary;

- (void)updateWithDictionary:(NSDictionary *)dictionary;

- (NSDictionary *)convertToDictionary;

- (NSString *)imageName;

@end
