//
//  HWRequestManager.h
//  HTTPClient
//
//  Created by Honeywell on 2017/1/4.
//  Copyright © 2017年 Honeywell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HWRequestProtocol.h"

@interface HWRequestManager : NSObject

+ (id<HWRequestProtocol>)HTTPManagerWithMode:(HWRequestMode)mode;

@end
