//
//  HWDeviceFeature.h
//  Services
//
//  Created by Liu, Carl on 10/20/16.
//  Copyright © 2016 Honeywell. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HWDeviceFeature<NSObject>

- (instancetype)initWithDictionary:(NSDictionary *)params;

- (void)updateWithDictionary:(NSDictionary *)params;

- (NSDictionary *)convertToDictionary;

@end
