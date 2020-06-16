//
//  HPSSIDLocationManager.m
//  CommonPlatform
//
//  Created by HoneyWell on 2019/11/11.
//  Copyright © 2019 Honeywell. All rights reserved.
//

#import "HPSSIDLocationManager.h"
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>
#import "NetworkUtil.h"

typedef void(^LocationRequstBlock)(void);
@interface HPSSIDLocationManager ()<CLLocationManagerDelegate>
@property (nonatomic,strong)  CLLocationManager *locManager;
@property (nonatomic,copy) LocationRequstBlock LocationRequstBlock;
@end
@implementation HPSSIDLocationManager

+ (instancetype)sharedInstance
{
    static id _sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}
- (void)getcurrentLocation:(void (^)())block {
    self.LocationRequstBlock = block;
    if (@available(iOS 13.0, *)) {
        //用户明确拒绝，可以弹窗提示用户到设置中手动打开权限
        if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
            //使用下面接口可以打开当前应用的设置页面
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }
        if (self.locManager) {
            self.locManager = [[CLLocationManager alloc] init];
        }
         self.locManager.delegate = self;
        if(![CLLocationManager locationServicesEnabled] || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined){
            //弹框提示用户是否开启位置权限
            [self.locManager requestWhenInUseAuthorization];
            return;
        }
    }
     self.LocationRequstBlock();
}
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse ||
        status == kCLAuthorizationStatusAuthorizedAlways) {
        //再重新获取ssid
        self.LocationRequstBlock();
    }
}



@end
