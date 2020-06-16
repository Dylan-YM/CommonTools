//
//  CommonPlatform
//
//  Created by Liu, Carl on 29/05/2018.
//

#import <Foundation/Foundation.h>
#import "FieldInterface.h"

@interface FieldFactory : NSObject{
        
@private	
	NSMutableArray *fields;
}

/**
 * Get an instance of a field object for a cron expression position
 *
 * @param position CRON expression position value to retrieve
 *
 * @return FieldInterface
 * @throws InvalidArgumentException if a position is not valide
 */
-(id<FieldInterface>)getField:(NSUInteger)position;

@end
