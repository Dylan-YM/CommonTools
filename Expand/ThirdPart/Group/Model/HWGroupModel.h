//
//  HWGroupModel.h
//  HomePlatform
//
//  Created by Honeywell on 2017/12/6.
//  Copyright © 2017年 Honeywell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AuthorizedToModel.h"
#import "HWGroupUpdateAPIManager.h"
#import "HWScenarioModel.h"

typedef NS_ENUM(NSInteger, HWGroupModelType){
    HWGroupModelTypeRoom = 1,
    HWGroupModelTypeGroup = 2,
};

@class HomeModel;
@interface HWGroupModel : NSObject

@property (nonatomic, assign) NSInteger groupId;
@property (nonatomic, strong) NSString *groupName;
@property (nonatomic, assign) NSInteger scenarioId;
@property (nonatomic, assign) HWGroupModelType type;
@property (nonatomic, assign) NSInteger iconIndex;
@property (nonatomic, assign) BOOL gatewayCreated;
@property (nonatomic, strong) AuthorizedToModel * authorizedTo;
@property (nonatomic, strong) NSArray *deviceIds;
@property (nonatomic, weak) HomeModel *homeModel;
@property (nonatomic, strong, readonly) NSString * imageName;
@property (nonatomic, strong) NSMutableArray <HWScenarioModel *>*scenarioList;
@property (nonatomic, assign) NSInteger nameIndex;
@property (nonatomic, assign) NSInteger nameType;

- (id)initWithDictionary:(NSDictionary *)dictionary;

- (void)updateWithDictionary:(NSDictionary *)dictionary;

- (void)updateScenarioWithDictionary:(NSDictionary *)scenarioDict;

- (BOOL)containsDeviceId:(NSInteger)deviceId;

- (NSDictionary *)convertToHtml;

- (NSDictionary *)convertScenarioToDictionary;

- (void)groupUpdateWithParams:(NSDictionary *)params callBack:(HWAPICallBack)callBack;

- (NSUInteger)numberOfTotalDevices;

- (NSUInteger)numberOfActiveDevices;

- (HWScenarioModel *)getScenarioById:(NSInteger)scenario;

- (NSArray *)getAllDeviceDicts;

- (NSArray *)getAllDevices;

- (NSString *)getRoomTemp;   //温度
- (NSString *)getRoomHum;    //湿度
- (NSString *)getRoomPM25;   //pm25

@end
