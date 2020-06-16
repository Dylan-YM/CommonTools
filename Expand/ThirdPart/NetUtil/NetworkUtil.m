//
//  NetworkUtil.m
//  AirTouch
//
//  Created by Devin on 1/8/16.
//  Copyright © 2016 Honeywell. All rights reserved.
//

#import "NetworkUtil.h"
#import <SystemConfiguration/CaptiveNetwork.h>
#import "HPSSIDLocationManager.h"

#include <ifaddrs.h>
#include <arpa/inet.h>

NSString * const kSendRequestDuringNetworkError = @"kSendRequestDuringNetworkError";

static Reachability *reachability=nil;
@implementation NetworkUtil

+ (void)initialize
{
    [super initialize];
    if (!reachability) {
        reachability = [Reachability reachabilityForInternetConnection];
        [self startNotifier];
    }
}

+(void)networkConnectedInternet:(NetworkBlock)connected notConnected:(NetworkBlock)notConnected
{
    if ([self isReachable]) {
        connected();
    } else {
        notConnected();
    }
//    NSString *stringUrl = @"https://www.baidu.com";
//    NSURL *url = [NSURL URLWithString:stringUrl];
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:15];
//    [request setHTTPMethod:@"GET"];
//    NSOperationQueue * _queue = [[NSOperationQueue alloc]init];
//    _queue.maxConcurrentOperationCount = 1;
//    [NSURLConnection sendAsynchronousRequest:request queue:_queue completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if (((NSHTTPURLResponse *)response).statusCode == 200) {
//                connected();
//            } else {
//                notConnected();
//            }
//        });
//    }];
}

+(void)networkConnectedInternetByWiFi:(NetworkBlock)connected notConnected:(NetworkBlock)notConnected
{
    [self networkConnectedInternet:^{
        if ([self networkTypeWiFi]) {
            connected();
        }else
        {
            notConnected();
        }
    } notConnected:^{
        notConnected();
    }];
}

+(BOOL)networkTypeWiFi
{
    [self initialize];
    return reachability.currentReachabilityStatus == ReachableViaWiFi;
}

+(BOOL)networkByCellular
{
    [self initialize];
    return reachability.currentReachabilityStatus == ReachableViaWWAN;
}

+ (BOOL)startNotifier
{
    [self initialize];
   return [reachability startNotifier];
}

+ (void)stopNotifier
{
    [self initialize];
    [reachability stopNotifier];
}

+ (NSString *)currentWifiSSID {
    // Does not work on the simulator.
    
    HPSSIDLocationManager * locationManager = [HPSSIDLocationManager sharedInstance];
        NSString *ssid = nil;
    __block typeof(ssid)blockSSid = ssid;
    [locationManager getcurrentLocation:^{
        NSArray *ifs = (id)CFBridgingRelease(CNCopySupportedInterfaces());

        for (NSString *ifnam in ifs) {
            NSDictionary *info = (id)CFBridgingRelease(CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam));
            if (info[@"SSID"]) {
                blockSSid = info[@"SSID"];
            }
        }
    }];
    return blockSSid;
}

+ (BOOL)isReachable {
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    BOOL hasNetwork;
    if (networkStatus == NotReachable) {
        hasNetwork = NO;
    } else {
        hasNetwork = YES;
    }
    return hasNetwork;
}

+ (NSString *)getIPAddress {
    NSString *address = nil;
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0)
    {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL)
        {
            if(temp_addr->ifa_addr->sa_family == AF_INET)
            {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"])
                {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    
    // Free memory
    freeifaddrs(interfaces);
    
    return address;
}

@end
