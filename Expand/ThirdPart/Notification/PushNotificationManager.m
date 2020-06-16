//
//  PushNotificationManager.m
//  HomePlatform
//
//  Created by Liu, Carl on 02/08/2017.
//  Copyright © 2017 Honeywell. All rights reserved.
//

#import "PushNotificationManager.h"
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
#import <PushKit/PushKit.h>
#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import "NotificationHubConfig.h"
#import "LogUtil.h"
#import "TimerUtil.h"
#import "AppMarco.h"
#import "HWNotificationObject.h"

@interface PushNotificationManager() <PKPushRegistryDelegate, UNUserNotificationCenterDelegate>

@property (assign, nonatomic) BOOL viberating;
@property (assign, nonatomic) NSInteger vibrateTimes;

@end

@implementation PushNotificationManager

+ (PushNotificationManager *)instance {
    static PushNotificationManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[PushNotificationManager alloc] init];
    });
    return instance;
}

#pragma mark - Register Notifications
- (void)registerPushNotification {
    if (IOS10ORLATER) {
        //iOS10特有
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert | UNAuthorizationOptionBadge | UNAuthorizationOptionSound) completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (granted) {
                // 点击允许
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[UIApplication sharedApplication] registerForRemoteNotifications];
                });
            }
        }];
    } else {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
}

- (void)registerVoipNotifications {
    PKPushRegistry *pushRegistry = [[PKPushRegistry alloc] initWithQueue:dispatch_get_main_queue()];
    pushRegistry.delegate = self;
    pushRegistry.desiredPushTypes = [NSSet setWithObject:PKPushTypeVoIP];
}

- (void)setDevicePushToken:(NSData *)deviceToken {
    [NotificationHubConfig setDevicePushToken:deviceToken];
    [NotificationHubConfig registerNotificationWithCompeletion:^(NSError *error) {
        if (error) {
            [LogUtil Debug:@"Notification_Register_HUB_Error" message:error];
        }
    }];
}

#pragma mark - iOS10 Notification
// iOS10 收到通知
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler{
    UNNotificationAction * callAction = nil;
    UNNotificationAction * readAction = nil;
    BOOL showCall = NO;
     callAction = [UNNotificationAction actionWithIdentifier:@"action-call"
                                                             title:@"你好"
                                                           options:UNNotificationActionOptionForeground];
    readAction = [UNNotificationAction actionWithIdentifier:@"action-read"
                                                      title:NSLocalizedString(@"common_markasread", nil)
                                                    options:UNNotificationActionOptionAuthenticationRequired];
    NSArray *actions =  @[callAction, readAction] ;
    UNNotificationCategory * category = [UNNotificationCategory categoryWithIdentifier:@"CallPrimaryContact"
                                                                               actions:actions
                                                                     intentIdentifiers:@[]
                                                                               options:UNNotificationCategoryOptionNone];
    NSSet * sets = [NSSet setWithObjects:category, nil];
    [[UNUserNotificationCenter currentNotificationCenter] setNotificationCategories:sets];
//    NSDictionary * userInfo = notification.request.content.userInfo;
//    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
//        NSLog(@"iOS10 App内收到远程通知:%@", userInfo);
//        [[PushNotificationManager instance] handleNotification:userInfo clickNotification:NO];
//    }
    completionHandler(UNNotificationPresentationOptionNone);
}

// iOS10 通知的点击事件
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)(void))completionHandler{
    

    [UIApplication sharedApplication].applicationIconBadgeNumber = 1;
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if ([response.actionIdentifier isEqualToString:@"com.apple.UNNotificationDefaultActionIdentifier"]) {
        if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
            NSLog(@"iOS10 点击远程通知:%@", userInfo);
            [[PushNotificationManager instance] handleNotification:userInfo clickNotification:YES];
        } else {
            //本地推送
            [[PushNotificationManager instance] setLocalNotification:YES];
        }
    } else {
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:userInfo];
        [dic setObject:response.actionIdentifier forKey:@"actionIdentifier"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationDidReceiveAction" object:nil userInfo:dic];
    }
    
    completionHandler();  // 系统要求执行这个方法
}

#pragma mark - Handle Notifications
- (void)handleNotification:(NSDictionary *)userInfo clickNotification:(BOOL)clickNotification {
    NSObject *object = userInfo[@"aps"][@"alert"];
    if ([object isKindOfClass:[NSString class]]) {
        HWNotificationObject *pushNotificationObject = [[HWNotificationObject alloc] initWithDictionary:userInfo];
        pushNotificationObject.clickNotification = clickNotification;
        if (self.handleNotification) {
            self.handleNotification(pushNotificationObject);
        }
    }
}

#pragma mark - PKPushRegistry Delegate
- (void)pushRegistry:(PKPushRegistry *)registry didUpdatePushCredentials:(PKPushCredentials *)credentials forType:(PKPushType)type {
    [NotificationHubConfig setDeviceVoipToken:credentials.token];
    [NotificationHubConfig registerNotificationWithCompeletion:^(NSError *error) {
        if (error) {
            [LogUtil Debug:@"Notification_Register_HUB_Error" message:error];
        }
    }];
}



- (void)setLocalNotification:(BOOL)localNotification {
    _localNotification = localNotification;
    if (_localNotification) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_VideoCallComming object:nil];
        });
    }
}


@end
