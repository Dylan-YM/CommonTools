//
//  NSData+byte.h
//  SafetyCommunicator
//
//  Created by BobYang on 16/7/5.
//  Copyright © 2016年 Honeywell. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (byte)

- (Byte *)getBytes;

- (UInt8)getUInt8;

- (SInt8)getSInt8;

- (UInt16)getUInt16;

- (UInt32)getUInt32;

- (UInt64)getUInt64;

- (Float32)getFloat32;

- (NSData *)inverseData;

- (NSString *)dataToBinaryString;

- (NSString *)convertToBinaryStringFromHexString:(NSString *)hexString;

- (UInt16)convertDataToInt:(NSRange)range bigLittle:(BOOL)change;

- (NSString *)dataToHexString;
@end
