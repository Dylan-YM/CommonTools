//
//  ATWapiNetworkInfo.h
//  Enrollment
//
//  Created by liunan on 12/30/14.
//  Copyright (c) 2014 honeywell. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kWapiNetworkNoPasswordSecurity @"OPEN"

@interface ATWapiNetworkInfo : NSObject
@property (strong, nonatomic) NSString *ssid;
@property (strong, nonatomic) NSString *security;
@property (strong, nonatomic) NSString *password;
@property (strong, nonatomic) NSString *signalStrength;

@end
