//
//  YearField.m
//  Vision
//
//  Created by c 4 on 11/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "YearField.h"

@implementation YearField

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
    NSDateComponents *components = [calendar components: NSCalendarUnitYear fromDate: date];
    
    return [self isSatisfied: [NSString stringWithFormat:@"%ld", (long)components.year] withValue:value];
}

-(NSDate*) increment:(NSDate*)date {
    NSCalendar* calendar = [Field calendar];
    NSDateComponents* components = [[NSDateComponents alloc] init];
    components.year = 1;
    
    return [calendar dateByAddingComponents:components toDate:date options: 0];
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
