//
//  HWDevice.h
//  AirTouch
//
//  Created by Devin on 4/25/16.
//  Copyright © 2016 Honeywell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppConfig.h"
#import "DeviceRole.h"
#import "HWRequestProtocol.h"
#import "DeviceConfigModel.h"
#import "DeviceEnrollConfigModel.h"

@class HomeModel,HWFilterItem;

typedef enum : NSInteger {
    DeviceArmStatusTypeInvalid = -1,
    DeviceArmStatusTypeDisarm,
    DeviceArmStatusTypeArm
} DeviceArmStatusType;

typedef enum : NSInteger {
    DevicePowerOff,
    DevicePowerPartiallyOn,
    DevicePowerOn,
} DevicePowerStatus;

@protocol HWDevice <NSObject>

@property (nonatomic,   copy)       NSString        *name;
@property (nonatomic,   assign)     NSInteger       deviceID;
@property (nonatomic,   copy)     NSString        *deviceType;
@property (nonatomic,   copy)       NSString        *firmwareVersion;
@property (nonatomic,   assign)     BOOL            isUpgrading;
@property (nonatomic,   copy)       NSString        *macID;

@property (nonatomic,   readonly)   BOOL            canBeMasterDevice;
@property (nonatomic,   assign)     BOOL            isMasterDevice;
@property (nonatomic,   assign)     AuthorizeRole   permission;
@property (nonatomic,   strong)     NSString        *ownerName;

@property (nonatomic,   copy)       NSString        *enrollmentDate;
@property (nonatomic,   weak)       HomeModel       *homeModel;
@property (nonatomic,   assign)     BOOL            unSupport;
@property (nonatomic,   assign)     BOOL            isFavorite;
@property (nonatomic,   strong)     NSString        *functionType;
@property (nonatomic,   assign)     BOOL            isDeletable;
@property (nonatomic,   assign)     BOOL            isMovable;
@property (nonatomic,   assign)     BOOL            isConfig;
@property (nonatomic,   strong)     NSDictionary    *otherAttr;
@property (nonatomic,   assign)     NSInteger       nameType;
@property (nonatomic,   assign)     NSInteger       nameIndex;

@property (nonatomic,   assign)     double       lastUpdate;

//add
@property (nonatomic, strong) NSMutableArray *authorizedTo;
@property (nonatomic, strong) NSArray *category;  //设备所属的分类，安全，能源，环境等
@property (nonatomic, strong) NSArray *feature;
@property (nonatomic, strong) NSArray *featureName;
@property (nonatomic, assign) NSInteger locationId;
@property (nonatomic, assign) NSInteger ownerId;
@property (nonatomic, assign) NSInteger productClass;  //产品型号，空净，水净，homepanel等
@property (nonatomic, strong) NSString *sku;
@property (nonatomic, strong) NSArray *tag;
@property (nonatomic, assign) NSInteger parentDeviceId;
@property (nonatomic, strong) NSMutableArray *subDevices; //下挂设备


//runstatus
@property (nonatomic, strong) NSMutableDictionary *runStatus;
@property (nonatomic, readonly) BOOL enable;
@property (nonatomic, readonly) BOOL armStatus;
@property (nonatomic, readonly) BOOL isAlive;
@property (nonatomic, readonly) BOOL isPowerOn;

//config
@property (nonatomic, strong) DeviceConfigModel *configModel;
@property (nonatomic, strong) DeviceEnrollConfigModel *enrollModel;

+ (HWDeviceCategory)deviceCategory;

- (NSString *)deviceCategoryString;

- (NSString *)deviceSmallIconImageName;

- (void)updateDeviceRunStatus:(HWAPICallBack)callback;

- (void)checkOnlineWithTimeout:(NSInteger)timeout callBack:(HWAPICallBack)callBack;

- (DevicePowerStatus)switchDevicePowerStatus;

//enroll
- (NSArray *)guideImageName;

- (BOOL)supportAP20;
- (BOOL)supportEasylink;

- (BOOL)supportBroadAP;
- (BOOL)supportBroadSL;

@end
