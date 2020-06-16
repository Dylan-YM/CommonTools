//
//  NSNumber+JSON.m
//  AirTouch
//
//  Created by Liu, Carl on 9/9/16.
//  Copyright © 2016 Honeywell. All rights reserved.
//

#import "NSNumber+JSON.h"

@implementation NSNumber (JSON)

- (BOOL)isEqualToString:(NSString *)string {
    return [[self description] isEqualToString:string];
}

@end
