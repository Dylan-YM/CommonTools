//
//  NSNull+JSON.m
//  AirTouch
//
//  Created by Liu, Carl on 9/8/16.
//  Copyright © 2016 Honeywell. All rights reserved.
//

#import "NSNull+JSON.h"

@implementation NSNull (JSON)

- (NSUInteger)length { return 0; }

- (NSInteger)integerValue { return 0; }

- (int)intValue { return 0; }

- (long long)longLongValue { return 0; }

- (float)floatValue { return 0; }

- (double)doubleValue { return 0; }

- (BOOL)boolValue { return NO; }

- (BOOL)isEqualToString:(NSString *)aString { return NO; }

- (NSString *)description { return @""; }

- (NSArray *)componentsSeparatedByString:(NSString *)separator { return @[]; }

- (NSArray *)allKeys { return nil; }

- (NSArray *)allValues { return nil; }

- (id)objectForKey:(id)key { return nil; }

- (id)objectForKeyedSubscript:(id)key { return nil; }

- (NSUInteger)count { return 0; }

- (id)objectAtIndex:(NSUInteger)index { return nil; }

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id *)stackbuf count:(NSUInteger)len { return 0; }

- (NSRange)rangeOfCharacterFromSet:(NSCharacterSet *)searchSet {
    return NSMakeRange(0, 0);
}

@end
