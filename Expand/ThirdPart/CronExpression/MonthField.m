#import "MonthField.h"

@implementation MonthField

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

-(BOOL)isSatisfiedBy:(NSDate*)date byValue:(NSString*)value
{
    NSCalendar* calendar = [Field calendar];
    NSDateComponents *components = [calendar components: NSCalendarUnitMonth fromDate: date];
    return [self isSatisfied:[NSString stringWithFormat:@"%ld", (long)components.month] withValue:value];
}

-(NSDate*) increment:(NSDate*)date
{
    NSCalendar* calendar = [Field calendar];
    NSDateComponents* components = [[NSDateComponents alloc] init];
    components.month = 1;
    
    return [calendar dateByAddingComponents: components toDate:date options: 0];
}

-(BOOL) validate:(NSString*)value
{
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[\\?\\*,\\/\\-0-9A-Z]+" options:NSRegularExpressionCaseInsensitive error:&error];
    
    if(error != NULL)
    {
        NSLog(@"%@", error);
    }
    
    return [regex numberOfMatchesInString:value options:0 range:NSMakeRange(0, [value length])] > 0;
}

@end
