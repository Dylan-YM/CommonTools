#import "CronExpression.h"
#import "Field.h"

int const SECOND = 0;
int const MINUTE = 1;
int const HOUR = 2;
int const DAY = 3;
int const MONTH = 4;
int const WEEKDAY = 5;
int const YEAR = 6;

@implementation CronExpression

-(id)init:(NSString*)schedule withFieldFactory:(FieldFactory*) fieldFactory
{
    self = [super init];
    if (self) {
        order = [NSArray arrayWithObjects:[NSNumber numberWithInteger:SECOND], [NSNumber numberWithInteger:MINUTE], [NSNumber numberWithInteger:HOUR], [NSNumber numberWithInteger:DAY], [NSNumber numberWithInteger:MONTH], [NSNumber numberWithInteger:WEEKDAY], [NSNumber numberWithInteger:YEAR], nil];
        _fieldFactory = fieldFactory;
        cronParts = [schedule componentsSeparatedByString: @" "];
        
        if([cronParts count] < 6)
        {
            NSLog(@"%@ is not a valid CRON expression", schedule);
        }
        
        [cronParts enumerateObjectsUsingBlock:^(id object, NSUInteger idx, BOOL *stop) {
            if(![[self->_fieldFactory getField: idx] validate: (NSString*)object])
            {
                NSLog(@"Invalid CRON field value %@ as position %lu", object, (unsigned long)idx);
            }
        }];
    }
    
    return self;
}

-(NSDate*)getNextRunDate:(NSDate*)currentTime {
    NSCalendar* calendar = [Field calendar];
    NSDateComponents* components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitWeekday fromDate:currentTime];
    components.second = 0;
    NSDate* nextRun = [calendar dateFromComponents:components];
    
    // Set a hard limit to bail on an impossible date
    for (int i = 0; i < 1000; i++) {
        BOOL satisfied = NO;
        BOOL outerLoop = NO;
        for(NSNumber *position in order) {
            NSString* part = [self getExpression:[position intValue]];
            if (part == nil){
                continue;
            }
            
            id<FieldInterface> field = [_fieldFactory getField: [position intValue]];
            
            if ([part rangeOfString: @","].location == NSNotFound) {
                satisfied = [field isSatisfiedBy:nextRun byValue:part];
            } else {
                NSArray *splits = [part componentsSeparatedByString:@","];
                for (NSString *listPart in splits) {
                    satisfied = [field isSatisfiedBy: nextRun byValue:listPart];
                    if (satisfied) {
                        break;
                    }
                }
            }
            
            // If the field is not satisfied, then start over
            if (!satisfied) {
                nextRun = [field increment: nextRun];
                outerLoop = YES;
                break;
            }
        }
        if (satisfied && !outerLoop) {
            return nextRun;
        }
    }
    
    return nil;
}

-(NSString*)getExpression: (int)part
{
    /*if (null === $part) {
        return implode(' ', $this->cronParts);
     } else if (array_key_exists($part, $this->cronParts)) {
        return $this->cronParts[$part];
     }
     
     return null;*/
    
    if(part < 0)
    {
        return [cronParts componentsJoinedByString:@" "];
    }
    else if(part < [cronParts count])
    {
        return [cronParts objectAtIndex:part];
    }
    
    return nil;
}

@end
