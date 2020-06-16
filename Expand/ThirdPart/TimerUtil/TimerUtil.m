//
//  TimerUtil.m
//  AirTouch
//
//  Created by Devin on 1/19/15.
//  Copyright (c) 2015 Honeywell. All rights reserved.
//

#import "TimerUtil.h"

static NSMutableDictionary *gcdTimerContainer=nil;

@implementation TimerUtil

+(BOOL)isValid:(NSString *)timerName {
    return [[gcdTimerContainer allKeys] containsObject:timerName];
}

+(void)scheduledDispatchTimerWithName:(NSString *)timerName timeInterval:(double)interval repeats:(BOOL)repeats action:(dispatch_block_t)action {
    [self scheduledDispatchTimerWithQueue:dispatch_get_main_queue() name:timerName timeInterval:interval repeats:repeats action:action];
}

+(void)scheduledDispatchTimerWithQueue:(dispatch_queue_t)queue name:(NSString *)timerName timeInterval:(double)interval repeats:(BOOL)repeats action:(dispatch_block_t)action {
    if (!gcdTimerContainer) {
        gcdTimerContainer=[NSMutableDictionary dictionary];
    }
    if (nil == timerName) {
        return;
    }
    [self cancelTimerWithName:timerName];
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_resume(timer);
    [gcdTimerContainer setObject:timer forKey:timerName];
    dispatch_source_set_timer(timer, dispatch_time(DISPATCH_TIME_NOW, interval*NSEC_PER_SEC), interval*NSEC_PER_SEC, interval*NSEC_PER_SEC/10);
    __weak typeof (self) weakSelf = self;
    dispatch_source_set_event_handler(timer, ^{
        action();
        if (!repeats) {
            [weakSelf cancelTimerWithName:timerName];
        }
    });
}

+(void)cancelTimerWithName:(NSString *)timerName {
    dispatch_source_t timer = [gcdTimerContainer objectForKey:timerName];
    if (!timer) {
        return;
    }
    [gcdTimerContainer removeObjectForKey:timerName];
    dispatch_source_cancel(timer);
}

@end
