//
//  NSString+Data.h
//  SafetyCommunicator
//
//  Created by BobYang on 16/10/10.
//  Copyright © 2016年 Honeywell. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Data)

- (NSUInteger)binaryStringIntValue;

+ (NSUInteger)powderByPostiveFactor:(int)postiveFactor;

@end
