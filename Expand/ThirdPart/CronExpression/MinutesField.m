//
//  CommonPlatform
//
//  Created by Liu, Carl on 29/05/2018.
//
#import "MinutesField.h"

@implementation MinutesField

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

-(BOOL)isSatisfiedBy: (NSDate*)date byValue:(NSString*)value
{
    NSCalendar* calendar = [Field calendar];
    NSDateComponents *components = [calendar components: NSCalendarUnitMinute fromDate: date];
    
    return [self isSatisfied: [NSString stringWithFormat:@"%ld", (long)components.minute] withValue:value];
}

-(NSDate*) increment:(NSDate*)date
{
    NSCalendar* calendar = [Field calendar];
    NSDateComponents* components = [[NSDateComponents alloc] init];
    components.minute = 1;
    
    return [calendar dateByAddingComponents: components toDate: date options: 0];
}

-(BOOL) validate:(NSString*)value
{
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[\\?\\*,\\/\\-0-9]+" options:NSRegularExpressionCaseInsensitive error:&error];
    
    if(error != NULL)
    {
        NSLog(@"%@", error);
    }
    
    return [regex numberOfMatchesInString:value options:0 range:NSMakeRange(0, [value length])] > 0;
}

@end
