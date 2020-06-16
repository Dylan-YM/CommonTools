//
//  AppConnector.h
//  iOSCommonAppPlatform
//
//  Created by Liu, Carl on 23/03/2017.
//  Copyright © 2017 Honeywell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HWDataBaseManager.h"

@interface AppConnector : NSObject

+ (AppConnector *)sharedInstance;

- (void)setDBManager:(HWDataBaseManager *)manager;

@end
