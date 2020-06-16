//
//  DeviceConfigModel.m
//  HomePlatform
//
//  Created by Honeywell on 2018/9/7.
//  Copyright © 2018 Honeywell. All rights reserved.
//

#import "DeviceConfigModel.h"

@interface DeviceConfigModel ()

@end

@implementation DeviceConfigModel

- (id)initWithDictionary:(NSDictionary *)params {
    self = [super init];
    if (self) {
        [self updateWithDictionary:params];
    }
    return self;
}

- (void)updateWithDictionary:(NSDictionary *)params {
    if ([params.allKeys containsObject:@"renamePlaceholder"]) {
        self.renamePlaceholder = NSLocalizedString([params objectForKey:@"renamePlaceholder"], nil);
    }
    if ([params.allKeys containsObject:@"deviceCategoryString"]) {
        self.deviceCategoryString = NSLocalizedString([params objectForKey:@"deviceCategoryString"], nil);
    }
    if ([params.allKeys containsObject:@"sku"]) {
        self.sku = [params objectForKey:@"sku"];
    }
    if ([params.allKeys containsObject:@"control"] && [[params[@"control"] allKeys] containsObject:@"controlPage"]) {
        self.controlPageName = [[params objectForKey:@"control"] objectForKey:@"controlPage"];
    }
    if ([params.allKeys containsObject:@"onlineAsParent"]) {
        self.onlineAsParent = [[params objectForKey:@"onlineAsParent"] boolValue];
    }
    if ([params.allKeys containsObject:@"powerAsParent"]) {
        self.powerAsParent = [[params objectForKey:@"powerAsParent"] boolValue];
    }
}

@end
