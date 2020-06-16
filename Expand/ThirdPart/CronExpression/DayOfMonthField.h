//
//  CommonPlatform
//
//  Created by Liu, Carl on 29/05/2018.
//
#import "Field.h"
#import "FieldInterface.h"

@interface DayOfMonthField : Field<FieldInterface>

/**
 * Get the last day of the month
 *
 * @param date Date object to check
 *
 * @return returns the last day of the month
 */
+(NSUInteger)getLastDayOfMonth: (NSDate*) date;

@end
