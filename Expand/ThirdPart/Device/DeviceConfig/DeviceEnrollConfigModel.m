//
//  DeviceEnrollConfigModel.m
//  HomePlatform
//
//  Created by Honeywell on 2018/9/7.
//  Copyright © 2018 Honeywell. All rights reserved.
//

#import "DeviceEnrollConfigModel.h"

@interface DeviceEnrollConfigModel ()

@end

@implementation DeviceEnrollConfigModel

- (id)initWithDictionary:(NSDictionary *)params {
    self = [super init];
    if (self) {
        [self updateWithDictionary:params];
    }
    return self;
}

- (void)updateWithDictionary:(NSDictionary *)params {
    if ([params.allKeys containsObject:@"enrollCategory"]) {
        self.enrollCategory = NSLocalizedString([params objectForKey:@"enrollCategory"], nil);
    }
    if ([params.allKeys containsObject:@"enrollCategoryIcon"]) {
        self.enrollCategoryIconString = [params objectForKey:@"enrollCategoryIcon"];
    }
    if ([params.allKeys containsObject:@"enrollType"]) {
        self.enrollType = [params objectForKey:@"enrollType"];
    }
    if ([params.allKeys containsObject:@"namePlaceholder"]) {
        self.namePlaceholder = NSLocalizedString([params objectForKey:@"namePlaceholder"], nil);
    }
    if ([params.allKeys containsObject:@"deviceWifiIcon"]) {
        self.deviceWifiIconString = [params objectForKey:@"deviceWifiIcon"];
    }
    
    if ([params.allKeys containsObject:@"series"]) {
        self.series = [params objectForKey:@"series"];
    }
    
    if ([params.allKeys containsObject:@"ap"]) {
        NSDictionary *ap = [params objectForKey:@"ap"];
        if ([ap.allKeys containsObject:@"ssid"]) {
            self.ssid = [ap objectForKey:@"ssid"];
        }
        if ([ap.allKeys containsObject:@"pressSconds"]) {
            self.apPressSconds = [[ap objectForKey:@"pressSconds"] integerValue];
        }
        if ([ap.allKeys containsObject:@"chimeCount"]) {
            self.apChimeCount = [[ap objectForKey:@"chimeCount"] integerValue];
        }
        if ([ap.allKeys containsObject:@"tips"]) {
            self.apTips = [ap objectForKey:@"tips"];
        }
        if ([ap.allKeys containsObject:@"timeout"]) {
            self.apTimeoutTips = [ap objectForKey:@"timeout"];
        }
        if ([ap.allKeys containsObject:@"tipsTitle"]) {
            self.apTipsTitle = [ap objectForKey:@"tipsTitle"];
        }
    }
    
    if ([params.allKeys containsObject:@"easylink"]) {
        NSDictionary *easylink = [params objectForKey:@"easylink"];
        if ([easylink.allKeys containsObject:@"pressSconds"]) {
            self.easylinkPressSconds = [[easylink objectForKey:@"pressSconds"] integerValue];
        }
        if ([easylink.allKeys containsObject:@"chimeCount"]) {
            self.easylinkChimeCount = [[easylink objectForKey:@"chimeCount"] integerValue];
        }
        if ([easylink.allKeys containsObject:@"tips"]) {
            self.easylinkTips = [easylink objectForKey:@"tips"];
        }
        if ([easylink.allKeys containsObject:@"tipsTitle"]) {
            self.easylinkTipsTitle = [easylink objectForKey:@"tipsTitle"];
        }
        if ([easylink.allKeys containsObject:@"timeout"]) {
            self.easylinkTimeoutTips = [easylink objectForKey:@"timeout"];
        }
    }
    
    if ([params.allKeys containsObject:@"guides"]) {
        NSDictionary *guides = [params objectForKey:@"guides"];
        if ([guides.allKeys containsObject:@"tips"]) {
            self.tips = [guides objectForKey:@"tips"];
        }
        if ([guides.allKeys containsObject:@"tipsTitle"]) {
            self.tipsTitle = [guides objectForKey:@"tipsTitle"];
        }
        if ([guides.allKeys containsObject:@"duration"]) {
            self.duration = [[guides objectForKey:@"duration"] integerValue];
        }
    }
}

@end
