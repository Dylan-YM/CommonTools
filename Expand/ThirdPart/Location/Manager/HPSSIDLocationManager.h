//
//  HPSSIDLocationManager.h
//  CommonPlatform
//
//  Created by HoneyWell on 2019/11/11.
//  Copyright © 2019 Honeywell. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HPSSIDLocationManager : NSObject
+ (instancetype)sharedInstance;
- (void)getcurrentLocation:(void (^)())block;
@end

NS_ASSUME_NONNULL_END
