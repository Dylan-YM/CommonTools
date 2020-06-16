#import "Field.h"

@implementation Field

+ (NSCalendar *)calendar {
    static NSCalendar *calendar = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        calendar.timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
    });
    return calendar;
}

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

-(BOOL)isSatisfied: (NSString*)dateValue withValue:(NSString*)value
{
    if([self isIncrementsOfRanges:value])
    {
        return [self isInIncrementsOfRanges:dateValue withValue:value];
    }
    else if([self isRange:value])
    {
        return [self isInRange:dateValue withValue:value];
    }
    BOOL numericCompare = ([self isNumeric:dateValue] &&
                           [self isNumeric:value] &&
                           [dateValue integerValue] == [value integerValue]);
    
    return [value isEqualToString:@"*"] || [value isEqualToString:@"?"] || numericCompare;
}

-(BOOL)isRange: (NSString*)value
{
    /*return strpos($value, '-') !== false;*/
    
    return [value rangeOfString : @"-"].location != NSNotFound;
}

-(BOOL)isIncrementsOfRanges: (NSString*)value
{
    /*return strpos($value, '/') !== false;*/
    
    return [value rangeOfString : @"/"].location != NSNotFound;
}

-(BOOL)isInRange: (NSString*)dateValue withValue:(NSString*)value
{
    /*$parts = array_map('trim', explode('-', $value, 2));
     
     return $dateValue >= $parts[0] && $dateValue <= $parts[1];*/
    
    NSArray *parts = [value componentsSeparatedByString: @"-"];
    
    return [dateValue intValue] >= [[parts objectAtIndex:0] intValue] && [dateValue intValue] <= [[parts objectAtIndex:1] intValue];
}

-(BOOL)isInIncrementsOfRanges: (NSString*)dateValue withValue:(NSString*)value
{
    NSArray *parts = [value componentsSeparatedByString: @"/"];
    if(![[parts objectAtIndex:0] isEqualToString:@"*"] && [[parts objectAtIndex:0] intValue] != 0)
    {
        if([[parts objectAtIndex:0] rangeOfString : @"-"].location == NSNotFound)
        {
            [NSException raise:@"Invalid argument" format:@"Invalid increments of ranges value: %@", value];
        }
        else
        {
            NSArray *range = [[parts objectAtIndex:0] componentsSeparatedByString: @"-"];
            if([dateValue intValue] == [[range objectAtIndex:0] intValue])
            {
                return YES;
            }
            else if([dateValue intValue] < [[range objectAtIndex:0] intValue])
            {
                return NO;
            }
        }
    }
    
    return [dateValue intValue] % [[parts objectAtIndex:1] intValue] == 0;
}

- (BOOL)isNumeric:(NSString *)string {
    NSCharacterSet* notDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    if ([string rangeOfCharacterFromSet:notDigits].location == NSNotFound) {
        return YES;
    }
    return NO;
}

@end
