//
//  ByteUtil.h
//  Utils
//
//  Created by WanquanJi on 16/11/11.
//  Copyright © 2016年 Honeywell. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ByteUtil : NSObject
+ (UInt8)uint8WithData:(NSData *)data from:(int)fromIndex to:(int)toIndex;
+ (UInt16)uint16WithData:(NSData *)data from:(int)fromIndex to:(int)toIndex;
+ (UInt32)uint32WithData:(NSData *)data from:(int)fromIndex to:(int)toIndex;
+ (UInt64)uint64WithData:(NSData *)data from:(int)fromIndex to:(int)toIndex;


+ (UInt32)timestampWithData:(NSData *)data;
+ (NSData *)dataWithTimeStamp:(UInt32)timeStamp;
+ (Byte *)bytesWithTimeStamp:(UInt32)timeStamp;
+ (UInt16)sumofData:(NSData *)data from:(int)fromIndex to:(int)toIndex;


@end
