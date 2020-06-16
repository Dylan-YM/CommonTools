//
//  RecogTimeUtil.m
//  AirTouch
//
//  Created by huangfujun on 15/1/29.
//  Copyright (c) 2015年 Honeywell. All rights reserved.
//

#import "RecogTimeUtil.h"

// eric start
static NSTimeInterval proiorTime = 0;
// eric end

@implementation RecogTimeUtil

+(void)setProiorTime:(NSTimeInterval)time
{
    proiorTime = time;
}

+(BOOL)isCrazyClick
{
    NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
    BOOL isQuick = (currentTime - proiorTime < 1.0);
    if (isQuick) {
        return isQuick;
    }
    proiorTime = currentTime;
    
    return isQuick;
}

@end
