//
//  NSObject+MultiHook.h
//  AirTouch
//
//  Created by Liu, Carl on 9/21/16.
//  Copyright © 2016 Honeywell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Aspects.h"

/**
 *  This is Just A Work Around solution for Aspects to multi hook
 *  one selector in one Class Hierarchy.
 *
 *  We hook the most super class responds to selector,
 *  such as UIControl with sendAction:to:forEvent:,
 *  with option AspectPositionInstead.
 *  Then UIControl and subclasses can use these convenient
 *  methods to fake hook on sendAction:to:forEvent:,
 *
 *  Limitations: Source selector `SHOULD NOT` be overrided.
 */
@interface NSObject (AspectsMulti)

/**
 *  This is Just A Work Around solution for Aspects to multi hook
 *  one selector in one Class Hierarchy.
 *
 *  We hook the most super class responds to selector,
 *  such as UIControl with sendAction:to:forEvent:,
 *  with option AspectPositionInstead.
 *  Then UIControl and subclasses can use these convenient
 *  methods to fake hook on sendAction:to:forEvent:,
 *
 *  Limitations: Source selector `SHOULD NOT` be overrided.
 */
+ (void)hookOriginSelector:(SEL)originSelector withSelector:(SEL)hookedSelector withOptions:(AspectOptions)options;

/**
 *  This is Just A Work Around solution for Aspects to multi hook
 *  one selector in one Class Hierarchy.
 *
 *  We hook the most super class responds to selector,
 *  such as UIControl with sendAction:to:forEvent:,
 *  with option AspectPositionInstead.
 *  Then UIControl and subclasses can use these convenient
 *  methods to fake hook on sendAction:to:forEvent:,
 *
 *  Limitations: Source selector `SHOULD NOT` be overrided.
 */
- (void)hookOriginSelector:(SEL)originSelector withSelector:(SEL)hookedSelector withOptions:(AspectOptions)options;

/**
 *  This is Just A Work Around solution for Aspects to multi hook
 *  one selector in one Class Hierarchy.
 *
 *  We hook the most super class responds to selector,
 *  such as UIControl with sendAction:to:forEvent:,
 *  with option AspectPositionInstead.
 *  Then UIControl and subclasses can use these convenient
 *  methods to fake hook on sendAction:to:forEvent:,
 *
 *  Limitations: Source selector `SHOULD NOT` be overrided.
 */
+ (void)unhookOriginSelector:(SEL)originSelector withSelector:(SEL)hookedSelector;

/**
 *  This is Just A Work Around solution for Aspects to multi hook
 *  one selector in one Class Hierarchy.
 *
 *  We hook the most super class responds to selector,
 *  such as UIControl with sendAction:to:forEvent:,
 *  with option AspectPositionInstead.
 *  Then UIControl and subclasses can use these convenient
 *  methods to fake hook on sendAction:to:forEvent:,
 *
 *  Limitations: Source selector `SHOULD NOT` be overrided.
 */
- (void)unhookOriginSelector:(SEL)originSelector withSelector:(SEL)hookedSelector;

@end
