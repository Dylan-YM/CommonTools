//
//  NotificationHubConfig.h
//  AirTouch
//
//  Created by Rich on 15/10/26.
//  Copyright © 2015年 Honeywell. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NotificationHubConfig : NSObject
+ (void)setDevicePushToken:(NSData *)deviceToken;
+ (void)setDeviceVoipToken:(NSData *)deviceToken;
+ (void)registerNotificationWithCompeletion:(void(^)(NSError *error))compeletion;

+ (NSString *)getPostPushToken;
+ (NSString *)getPostVoipToken;
@end
