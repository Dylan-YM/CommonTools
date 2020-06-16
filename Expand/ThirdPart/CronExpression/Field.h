//
//  CommonPlatform
//
//  Created by Liu, Carl on 29/05/2018.
//
#import <Foundation/Foundation.h>

@interface Field : NSObject

+ (NSCalendar *)calendar;

/**
 * Check to see if a field is satisfied by a value
 *
 * @param dateValue Date value to check
 * @param value Value to test
 *
 * @return bool
 */
-(BOOL)isSatisfied: (NSString*)dateValue withValue:(NSString*)value;

/**
 * Check if a value is a range
 *
 * @param value Value to test
 *
 * @return bool
 */
-(BOOL)isRange: (NSString*)value;

/**
 * Check if a value is an increments of ranges
 *
 * @param value Value to test
 *
 * @return bool
 */
-(BOOL)isIncrementsOfRanges: (NSString*)value;

/**
 * Test if a value is within a range
 *
 * @param dateValue Set date value
 * @param value Value to test
 *
 * @return bool
 */
-(BOOL)isInRange: (NSString*)dateValue withValue:(NSString*)value;

/**
 * Test if a value is within an increments of ranges
 *
 * @param dateValue Set date value
 * @param value Value to test
 *
 * @return bool
 */
-(BOOL)isInIncrementsOfRanges: (NSString*)dateValue withValue:(NSString*)value;

@end
