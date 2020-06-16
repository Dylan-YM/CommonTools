//
//  ByteUtil.m
//  Utils
//
//  Created by WanquanJi on 16/11/11.
//  Copyright © 2016年 Honeywell. All rights reserved.
//

#import "ByteUtil.h"
#import "NSData+byte.h"

@implementation ByteUtil

+ (NSData *)subDataWithData:(NSData *)data from:(int)fromIndex to:(int)toIndex {
    int loc = fromIndex;
    int len = toIndex - fromIndex + 1;
    NSRange range = NSMakeRange(loc, len);
    NSData * subData = [data subdataWithRange:range];
    return subData;
}

+ (UInt8)uint8WithData:(NSData *)data from:(int)fromIndex to:(int)toIndex {
    NSData * subData = [self subDataWithData:data from:fromIndex to:toIndex];
    UInt8 result = [subData getUInt8];
    return result;
}

+ (UInt16)uint16WithData:(NSData *)data from:(int)fromIndex to:(int)toIndex {
    NSData * subData = [self subDataWithData:data from:fromIndex to:toIndex];
    UInt16 result = [subData getUInt16];
    return result;
}

+ (UInt32)uint32WithData:(NSData *)data from:(int)fromIndex to:(int)toIndex{
    NSData * subData = [self subDataWithData:data from:fromIndex to:toIndex];
    UInt32 result = [subData getUInt32];
    return result;
}

+ (UInt64)uint64WithData:(NSData *)data from:(int)fromIndex to:(int)toIndex{
    NSData * subData = [self subDataWithData:data from:fromIndex to:toIndex];
    UInt64 result = [subData getUInt64];
    return result;
}

#pragma mark -- 2byte

+ (UInt32)timestampWithData:(NSData *)data {
    Byte * bytes = (Byte *)[data bytes];
    UInt32 value = CFSwapInt32LittleToHost(*(int*)bytes);
    return value;
}

+ (NSData *)dataWithTimeStamp:(UInt32)timeStamp {
    Byte * bytes = malloc(4);
    Byte * p = bytes;
    for (int i = 0; i < 4 ; i++) {
        *p = timeStamp & 0xFF;
        timeStamp /= 256;
        p++;
    }
    NSData * data = [NSData dataWithBytes:bytes length:4];
    NSData * inverseData = [data inverseData];
    free(bytes);
    bytes = NULL;
    p = NULL;
    return inverseData;
}

+ (Byte *)bytesWithTimeStamp:(UInt32)timeStamp {
    NSData * data = [self dataWithTimeStamp:timeStamp];
    Byte * bytes = (Byte *)[data bytes];
    return bytes;
}

+ (UInt16)sumofData:(NSData *)data from:(int)fromIndex to:(int)toIndex {
    UInt16 sum = 0;
    for (int i = fromIndex; i <= toIndex; i++) {
        NSRange range = NSMakeRange(i, 1);
        NSData * subData = [data subdataWithRange:range];
        UInt8 uint8Value = [subData getUInt8];
        sum += uint8Value;
    }
    return sum;
}

@end
