//
//  NetworkUtil.h
//  AirTouch
//
//  Created by Devin on 1/8/16.
//  Copyright © 2016 Honeywell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"

extern NSString * const kSendRequestDuringNetworkError;

typedef void (^NetworkBlock)(void);
@interface NetworkUtil : NSObject

+ (void)networkConnectedInternet:(NetworkBlock)connected notConnected:(NetworkBlock)notConnected;
+ (void)networkConnectedInternetByWiFi:(NetworkBlock)connected notConnected:(NetworkBlock)notConnected;
+ (BOOL)networkTypeWiFi;

+ (NSString *)currentWifiSSID;

+ (BOOL)isReachable;

+ (NSString *)getIPAddress;

@end
