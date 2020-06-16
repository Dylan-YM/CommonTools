//
//  HomeViewController.h
//  AirTouch
//
//  Created by Devin on 1/13/15.
//  Copyright (c) 2015 Honeywell. All rights reserved.
//

#import <Foundation/Foundation.h>
#ifdef __cplusplus
extern "C" {
#endif

typedef void(^HWBlockDelayHandle)(BOOL cancel);

static HWBlockDelayHandle dispatch_block_after_delay(CGFloat seconds, dispatch_block_t block) {
	
	if (nil == block) {
		return nil;
	}
	
	__block dispatch_block_t blockToBeExecute = [block copy];
	__block HWBlockDelayHandle handleCopy = nil;
	
	HWBlockDelayHandle delayedHandle = ^(BOOL cancel){		
		if (NO == cancel && nil != blockToBeExecute) {
			dispatch_async(dispatch_get_main_queue(), blockToBeExecute);
		}
		
		blockToBeExecute = nil;
		handleCopy = nil;
	};
		
	handleCopy = [delayedHandle copy];
	
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, seconds * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
		if (nil != handleCopy) {
			handleCopy(NO);
		}
	});

	return handleCopy;
};

static void cancel_block(HWBlockDelayHandle delayedHandle) {
	if (nil == delayedHandle) {
		return;
	}
	
	delayedHandle(YES);
}

#ifdef __cplusplus
}
#endif