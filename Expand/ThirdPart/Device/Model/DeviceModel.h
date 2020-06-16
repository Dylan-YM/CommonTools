//
//  DeviceModel.h
//  AirTouch
//
//  Created by Devin on 1/22/15.
//  Copyright (c) 2015 Honeywell. All rights reserved.
//

#import "HWDevice.h"

@interface DeviceModel : NSObject<HWDevice>

- (id)initWithDictionary:(NSDictionary *)params NS_REQUIRES_SUPER;

- (void)updateWithDictionary:(NSDictionary *)params NS_REQUIRES_SUPER;

- (NSDictionary *)convertToDictionary NS_REQUIRES_SUPER;

- (NSDictionary *)convertToHtml;

- (NSDictionary *)convertRunStatusToHtml;

- (NSDictionary *)convertSubDevicesToHtml;

- (NSDictionary *)convertPairedSubDeviceToHtml;

@end
