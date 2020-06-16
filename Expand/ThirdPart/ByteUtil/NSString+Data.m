//
//  NSString+Data.m
//  SafetyCommunicator
//
//  Created by BobYang on 16/10/10.
//  Copyright © 2016年 Honeywell. All rights reserved.
//

#import "NSString+Data.h"

@implementation NSString (Data)

- (NSUInteger)binaryStringIntValue {
    int intValue = 0;
    NSUInteger length = self.length;
    if (length == 0) {
        return 0;
    }
    int powderFactor = 0;
    for (int loc = (int)length - 1; loc >= 0; loc--) {
        NSUInteger location = (NSUInteger)loc;
        NSRange range = NSMakeRange(location, 1);
        NSString * subString = [self substringWithRange:range];
        int bitValue = [subString intValue];
        NSUInteger powder = [[self class]powderByPostiveFactor:powderFactor];
        intValue += bitValue * powder;
        powderFactor++;
    }
    return intValue;
}

+ (NSUInteger)powderByPostiveFactor:(int)postiveFactor {
    int result = 1;
    for (int i = 1; i <= postiveFactor; i++) {
        result *= 2;
    }
    return result;
}



@end
