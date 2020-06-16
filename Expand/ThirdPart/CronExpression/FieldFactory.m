//
//  CommonPlatform
//
//  Created by Liu, Carl on 29/05/2018.
//

#import "FieldFactory.h"
#import "SecondField.h"
#import "MinutesField.h"
#import "HoursField.h"
#import "DayOfMonthField.h"
#import "MonthField.h"
#import "DayOfWeekField.h"
#import "YearField.h"

@implementation FieldFactory

- (id)init
{
    self = [super init];
    if (self) {
        fields = [NSMutableArray arrayWithObjects:[NSNull null],[NSNull null],[NSNull null],[NSNull null],[NSNull null],[NSNull null],[NSNull null],nil];
    }
    
    return self;
}

-(id<FieldInterface>)getField:(NSUInteger)position
{
    if(position >= [fields count])
    {
        [NSException raise:@"Invalid argument" format:@"%lu is not a valid position", (unsigned long)position];
    }
    
    if([fields objectAtIndex: position] == [NSNull null])
    {
        switch(position)
        {
            case 0:
                [fields insertObject:[[SecondField alloc] init] atIndex:position];
                break;
            case 1:
                [fields insertObject:[[MinutesField alloc] init] atIndex:position];
                break;
            case 2:
                [fields insertObject:[[HoursField alloc] init] atIndex:position];
                break;
            case 3:
                [fields insertObject:[[DayOfMonthField alloc] init] atIndex:position];
                break;
            case 4:
                [fields insertObject:[[MonthField alloc] init] atIndex:position];
                break;
            case 5:
                [fields insertObject:[[DayOfWeekField alloc] init] atIndex:position];
                break;
            case 6:
                [fields insertObject:[[YearField alloc] init] atIndex:position];
                break;
        }
    }
    
    return [fields objectAtIndex: position];
}


@end
