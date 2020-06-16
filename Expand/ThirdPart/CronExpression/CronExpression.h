//
//  CommonPlatform
//
//  Created by Liu, Carl on 29/05/2018.
//
#import <Foundation/Foundation.h>
#import "FieldFactory.h"

@interface CronExpression : NSObject{
    /**
     * @var array CRON expression parts
     */
    NSArray* cronParts;
    
    /**
     * @var FieldFactory CRON field factory
     */
    FieldFactory* _fieldFactory;
    
    /**
     * @var array Order in which to test of cron parts
     */
    NSArray* order;
}

extern int const SECOND;
extern int const MINUTE;
extern int const HOUR;
extern int const DAY;
extern int const MONTH;
extern int const WEEKDAY;
extern int const YEAR;

/**
 * Parse a CRON expression
 *
 * @param schedule CRON expression schedule string (e.g. '8 * * * *')
 * @param fieldFactory Factory to create cron fields
 *
 * @throws InvalidArgumentException if not a valid CRON expression
 */
-(id)init:(NSString*)schedule withFieldFactory:(FieldFactory*) fieldFactory;

/**
 * Get the date in which the CRON will run next
 *
 * @param currentTime (optional) Optionally set the current date
 *     time for testing purposes or disregarding the current second
 *
 * @return DateTime
 */
-(NSDate*)getNextRunDate:(NSDate*)currentTime;

/**
 * Get all or part of the CRON expression
 *
 * @param part (optional) Specify the part to retrieve or NULL to
 *      get the full cron schedule string.
 *
 * @return string|null Returns the CRON expression, a part of the
 *      CRON expression, or NULL if the part was specified but not found
 */
-(NSString*)getExpression: (int)part;

@end
