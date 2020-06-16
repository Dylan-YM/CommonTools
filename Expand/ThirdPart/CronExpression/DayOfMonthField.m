#import "DayOfMonthField.h"

@interface DayOfMonthField()

/**
 * Get the nearest day of the week for a given day in a month
 *
 * @param currentYear Current year
 * @param currentMonth Current month
 * @param targetDay Target day of the month
 *
 * @return DateTime Returns the nearest date
 */
-(NSDate*)getNearestWeekday:(NSUInteger)currentYear :(NSUInteger)currentMonth : (NSUInteger)targetDay;

@end

@implementation DayOfMonthField

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

+(NSUInteger)getLastDayOfMonth: (NSDate*) date
{
    NSCalendar* cal = [NSCalendar currentCalendar];
    NSDateComponents *comps = [cal components:NSCalendarUnitMonth fromDate:date];
    
    NSRange range = [cal rangeOfUnit:NSCalendarUnitDay
                              inUnit:NSCalendarUnitMonth
                             forDate:[cal dateFromComponents:comps]];
    
    return range.length;
}

-(NSDate*)getNearestWeekday: (NSUInteger)currentYear :(NSUInteger)currentMonth : (NSUInteger)targetDay
{
    NSCalendar* calendar = [Field calendar];
    NSDateComponents* components = [[NSDateComponents alloc]init];
    components.day = targetDay;
    components.month = currentMonth;
    components.year = currentYear;
    
    NSDate* target = [calendar dateFromComponents: components];
    
    NSDateComponents *weekdayComponents = [calendar components: NSCalendarUnitWeekday fromDate: target];
    if(weekdayComponents.weekday < 6)
    {
        return target;
    }
    
    NSUInteger lastDayOfMonth = [DayOfMonthField getLastDayOfMonth: target];
    NSArray* adjustments = [NSArray arrayWithObjects:[NSNumber numberWithInt: -1], [NSNumber numberWithInt: 1], [NSNumber numberWithInt: -2], [NSNumber numberWithInt: 2], nil];
    NSNumber* adjustment;
    
    for (adjustment in adjustments)
    {
        NSUInteger adjusted = targetDay + [adjustment unsignedLongValue];
        
        if(adjusted > 0 && adjusted <= lastDayOfMonth)
        {
            components.day = adjusted;
            
            NSDate* adjustedTarget = [calendar dateFromComponents: components];
            NSDateComponents *adjustedWeekdayComponents = [calendar components: NSCalendarUnitWeekday | NSCalendarUnitMonth fromDate: adjustedTarget];
            
            if(adjustedWeekdayComponents.weekday < 6 && adjustedWeekdayComponents.month == currentMonth)
            {
                return adjustedTarget;
            }
        }
    }
    
    return nil;
}

-(BOOL)isSatisfiedBy: (NSDate*)date byValue:(NSString*)value
{
    NSCalendar* calendar = [Field calendar];
    NSDateComponents* components = [calendar components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date];
    
    if ([value isEqualToString: @"L"])
    {
        return components.day == [DayOfMonthField getLastDayOfMonth: date];
    }
    
    NSRange range = [value rangeOfString : @"W"];
    
    if (range.location != NSNotFound) {
        NSString* targetDay = [value substringWithRange:NSMakeRange(0, range.location)];
        NSDate* nearestWeekday = [self getNearestWeekday:components.year :components.month : [targetDay integerValue]];
        
        NSDateComponents* nearestWeekdayComponents = [calendar components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:nearestWeekday];
        
        return components.day == nearestWeekdayComponents.day;
    }
    
    return [self isSatisfied:[NSString stringWithFormat:@"%02ld", (long)components.day] withValue:value];
}

-(NSDate*) increment:(NSDate*)date
{
    NSCalendar* calendar = [Field calendar];
    
    NSDateComponents* components = [[NSDateComponents alloc] init];
    components.day = 1;
    
    return [calendar dateByAddingComponents:components toDate:date options: 0];
}

-(BOOL) validate:(NSString*)value
{
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[\\*,\\/\\-\\?LW0-9A-Za-z]+" options:NSRegularExpressionCaseInsensitive error:&error];
    
    if(error != NULL)
    {
        NSLog(@"%@", error);
    }
    
    return [regex numberOfMatchesInString:value options:0 range:NSMakeRange(0, [value length])] > 0;
}

@end
