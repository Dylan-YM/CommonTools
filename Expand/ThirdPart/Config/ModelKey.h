//
//  ModelKey.h
//  AirTouch
//
//  Created by Devin on 1/22/15.
//  Copyright (c) 2015 Honeywell. All rights reserved.
//

#ifndef AirTouch_ModelKey_h
#define AirTouch_ModelKey_h

//DeviceModel start
#pragma mark  DeviceModel
#define DeviceID     @"deviceId"
#define DeviceName   @"deviceName"
#define DeviceMode   @"Mode"
#define DevicePm25   @"PM25Value"
#define DeviceTVOC   @"TVOCValue"
#define DeviceSpeed  @"speed"
#define DeviceAlive  @"online"
#define DeviceType   @"productModel"
#define DeviceFirmwareVersion   @"firmwareVersion"
#define DeviceMacId   @"macId"
#define DeviceIsUpgrading   @"isUpgrading"
#define DeviceAqDisplayLevel @"AQDisplayLevel"
#define DeviceCleanTime @"cleanTime"
#define DeviceCleanBeforeHomeEnable @"cleanBeforeHomeEnable"
#define DeviceTimeToHome @"timeToHome"
#define DeviceFanFaultCode @"fanFaultCode"
#define DeviceRunTime3 @"runTime3"
#define DeviceRunTime2 @"runTime2"
#define DeviceRunTime1 @"runTime1"
#define DeviceFilter1Runtime @"filter1Runtime"
#define DeviceFilter2Runtime @"filter2Runtime"
#define DeviceFilter3Runtime @"filter3Runtime"
#define DeviceTiltSensorStatus @"TiltSensorStatus"
#define DeviceMobileCtrlFlags @"MobileCtrlFlags"
#define DeviceCleanTimeArray @"cleanTimeArray"
#define DeviceStatus @"status"
#define DeviceIsMasterDevice @"isMasterDevice"
#define DeviceEnrollmentDate @"enrollmentDate"
#define DevicePermission @"permission"
#define DeviceOwnerName @"ownerName"
#define DeviceErrFlags @"errFlags"
#define DeviceRunStatus @"runStatus"
#define DeviceOn  @"on"
#define DeviceIsFavorite @"isFavorite"
#define DeviceOpenClosePercent @"openClosePercent"
#define DeviceFunctionType @"functionType"
#define DeviceIsDeletable @"isDeletable"
#define DeviceIsMovable @"isMovable"
#define DeviceIsConfig @"isConfig"
#define DeviceOtherAttr @"otherAttr"
#define DeviceStepSpeed @"stepSpeed"
#define DeviceNameType @"nameType"
#define DeviceNameIndex @"nameIndex"

//group
#define GroupId  @"groupId"
#define GroupName  @"groupName"
#define GroupDeviceIds @"deviceIds"
#define GroupList @"groupList"

//add
#define DeviceCategory     @"category"
#define DeviceFeature      @"feature"
#define DeviceFeatureName  @"featureName"
#define DeviceLocationId   @"locationId"
#define DeviceOwnerId      @"ownerId"
#define DeviceProductClass @"productClass"
#define DeviceSku          @"sku"
#define DeviceTag          @"tag"
#define DeviceParentDeviceId    @"parentDeviceId"
#define DeviceSubDevices    @"subDevices"
#define DeviceAuthorizedTo  @"authorizedTo"
#define DeviceArmStatus  @"armed"
#define DeviceEnable     @"enable"

//LocationModel start
#pragma mark  LocationModel
#define kLocation_City            @"city"
#define kLocation_Name            @"name"
#define kLocation_ID              @"locationId"
#define kLocation_Street          @"street"
#define kLocation_State           @"state"
#define kLocation_Country         @"country"
#define kLocation_Devices         @"devices"
#define kLocation_OwnerId         @"ownerId"
#define kLocation_OwnerName       @"ownerName"
#define kLocation_OwnerGender     @"ownerGender"
#define kLocation_OwnerPhone      @"ownerPhoneNumber"
#define kLocation_AuthorizedTo    @"authorizedTo"
#define kLocation_District        @"district"
#define kLocation_IsDefault       @"isDefault"
#define kLocation_Latitude        @"latitude"
#define kLocation_Longitude       @"longitude"
#define kLocation_Categories      @"categories"
#define kLocation_AuthorizedType  @"authorizedType"
#define kLocation_Scenario        @"scenario"
#define kLocation_EnergyScenario  @"energyScenario"
#define kLocation_HealthyScenario  @"healthyScenario"
#define kLocation_LocationScenario  @"locationScenario"
#define kLocation_SecurityScenario  @"securityScenario"

//weather info start
#pragma mark  weather info
#define kAQI @"aqi"
#define kAQI_pm25 @"pm25";
#define kAQI_pm10 @"pm10"
#define kAQI_so2 @"so2"
#define kAQI_no2 @"no2"
#define kAQI_co @"co"
#define kAQI_o3 @"o3"
#define kAQI_quality @"quality"
#define kAQI_last_update @"last_update"

//Water Model start
#pragma mark  Water Model
#define kWaterQualityLevel @"WaterQuality"
#define kWaterSingleWaterMakingTime @"singleWaterMakingTime"
#define kWaterInflowTDS @"inflowTds"
#define kWaterOutflowTDS @"outflowTds"
#define kWaterOutflowVolume @"outflowVolume"
#define kWaterFilters @"filters"

#define kWaterFilterUsageTime @"usageTime"
#define kWaterFilterUsageVolume @"usageVolume"
#define kWaterFilterResetTime @"resetTime"
#define kWaterFilterType @"filterType"
#define kWaterFilterCategory @"filterCategory"
#define kWaterFilterMaxTime @"maxTimeSetting"
#define kWaterFilterMaxVolume @"maxVolumeSetting"
#define kWaterFilterCapability @"capability"

//emotional history data
#define kAirHistoryData @"AirHistoryData"
#define kWaterHistoryData @"WaterHistoryData"
#define kAirHistoryDataBarTotalValue @"AirHistoryDataBarTotalValue"
#define kWaterHistoryDataBarTotalValue @"WaterHistoryDataBarTotalValue"
#define kEmotionalHistoryData @"EmotionalHistoryData"

#endif
