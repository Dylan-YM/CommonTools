//
//  TimerUtil.h
//  AirTouch
//
//  Created by Devin on 1/19/15.
//  Copyright (c) 2015 Honeywell. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimerUtil : NSObject

+(BOOL)isValid:(NSString *)timerName;

+(void)scheduledDispatchTimerWithName:(NSString *)timerName timeInterval:(double)interval repeats:(BOOL)repeats action:(dispatch_block_t)action;

+(void)scheduledDispatchTimerWithQueue:(dispatch_queue_t)queue name:(NSString *)timerName timeInterval:(double)interval repeats:(BOOL)repeats action:(dispatch_block_t)action;

+(void)cancelTimerWithName:(NSString *)timerName;

@end
