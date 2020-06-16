//
//  AppManager.h
//  AirTouch
//
//  Created by Carl on 3/10/16.
//  Copyright © 2016 Honeywell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LocalizationProtocol.h"

@class TTTAttributedLabel;
@interface AppManager : NSObject

+ (id<LocalizationProtocol>)getLocalProtocol;

+ (void)configSMSTermLabel:(TTTAttributedLabel *)label;

@end
