//
//  UIDevice+YMExtend.m
//  thirdDemo
//
//  Created by Richard on 2018/3/13.
//  Copyright © 2018年 Richard. All rights reserved.
//

#import "UIDevice+YMExtend.h"
#import "YMSizeConstant.h"
#include <sys/sysctl.h>

#include <sys/types.h>
#include <ifaddrs.h>
#include <net/if.h>
#include <netdb.h>

#import <CommonCrypto/CommonDigest.h>
#import <ifaddrs.h>
#import <arpa/inet.h>
@implementation UIDevice (YMExtend)

+ (NSString *)deviceCode {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        return @"3";
    } else {
        return @"2";
    }
}

+ (NSString *)deviceModel {
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *model = malloc(size);
    sysctlbyname("hw.machine", model, &size, NULL, 0);
    NSString *deviceModel = [NSString stringWithCString:model encoding:NSUTF8StringEncoding];
    free(model);
    return deviceModel;
}


+ (NSArray *)localIPAddresses
{
    NSMutableArray *ipAddresses = [NSMutableArray array] ;
    struct ifaddrs *allInterfaces;
    
    // Get list of all interfaces on the local machine:
    if (getifaddrs(&allInterfaces) == 0) {
        struct ifaddrs *interface;
        
        // For each interface ...
        for (interface = allInterfaces; interface != NULL; interface = interface->ifa_next) {
            unsigned int flags = interface->ifa_flags;
            struct sockaddr *addr = interface->ifa_addr;
            
            // Check for running IPv4, IPv6 interfaces. Skip the loopback interface.
            if (((flags & (IFF_UP|IFF_RUNNING|IFF_LOOPBACK)) == (IFF_UP|IFF_RUNNING)) && addr->sa_family == AF_INET) {
                // Convert interface address to a human readable string:
                char host[NI_MAXHOST];
                getnameinfo(addr, addr->sa_len, host, sizeof(host), NULL, 0, NI_NUMERICHOST);
                
                [ipAddresses addObject:[[NSString alloc] initWithUTF8String:host]];
            }
        }
        
        freeifaddrs(allInterfaces);
    }
    
    return ipAddresses;
}

// 获取当前的运行的app的机器的地址
+ (NSString *)getClientIpAddress {
    //    if ([SFUserConfigurator sharedInstance].clientIp && ![[SFUserConfigurator sharedInstance].clientIp isEqualToString:@""]) {
    //        return [SFUserConfigurator sharedInstance].clientIp;
    //    }
    NSArray *ipAddresses = [self localIPAddresses];
    NSString *clientIp = @"127.0.0.1";
    if(ipAddresses != nil && [ipAddresses count] > 0) {
        clientIp = [ipAddresses objectAtIndex:0];
    }
    //    [SFUserConfigurator sharedInstance].clientIp = clientIp;
    return clientIp;
}

+ (NSString *)getIpAddresses{
    NSString *address = @"error";
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
            if(temp_addr->ifa_addr->sa_family == AF_INET && [[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"])
            {
                // Check if interface is en0 which is the wifi connection on the iPhone
                // Get NSString from C String
                address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
}
+ (BOOL)isRetina4inch{
    return (568 == SCREEN_HEIGHT && 320 == SCREEN_WIDTH) || (1136 == SCREEN_HEIGHT && 640 == SCREEN_WIDTH);
}

+ (BOOL)isPhone5 {
    if (PHONE5_HEIGHT == SCREEN_HEIGHT && PHONE5_WIDTH == SCREEN_WIDTH) {
        return YES;
    }
    return NO;
}

+ (BOOL)isPhone6 {
    if (PHONE6_WIDTH == SCREEN_WIDTH) {
        return YES;
    }
    return NO;
}

+ (BOOL)isPhone6p {
    if (PHONE6P_WIDTH == SCREEN_WIDTH) {
        return YES;
    }
    return NO;
}

@end
