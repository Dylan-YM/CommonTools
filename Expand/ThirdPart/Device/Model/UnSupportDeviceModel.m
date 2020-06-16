//
//  UnSupportDeviceModel.m
//  AirTouch
//
//  Created by Liu, Carl on 8/10/16.
//  Copyright © 2016 Honeywell. All rights reserved.
//

#import "UnSupportDeviceModel.h"

@implementation UnSupportDeviceModel

+ (HWDeviceCategory)deviceCategory {
    return HWDeviceCategoryNone;
}

- (NSString *)deviceCategoryString {
    return NSLocalizedString(@"common_unsupported_device", nil);
}

- (void)updateWithDictionary:(NSDictionary *)params {
    [super updateWithDictionary:params];
    
    self.unSupport = YES;
}

-(NSString *)deviceSmallIconImageName {
    return @"AllDevice_Unknow_Small_Icon";
}

@end
