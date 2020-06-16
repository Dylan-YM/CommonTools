//
//  PushNotificationManager.h
//  HomePlatform
//
//  Created by Liu, Carl on 02/08/2017.
//  Copyright © 2017 Honeywell. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HWNotificationObject;

typedef void(^PushNotificationBlock)(HWNotificationObject *);

@interface PushNotificationManager : NSObject

@property (strong, nonatomic) PushNotificationBlock handleNotification;

@property (assign, nonatomic) BOOL localNotification;

+ (PushNotificationManager *)instance;

- (void)registerPushNotification;

- (void)setDevicePushToken:(NSData *)deviceToken;

- (void)handleNotification:(NSDictionary *)userInfo clickNotification:(BOOL)clickNotification;

- (void)stopVideoCallLocalNofiticaiton;

- (void)vibratePhone;

- (void)cancelVibrate;

@end
