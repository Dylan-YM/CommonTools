//
//  NSData+Byte.m
//  SafetyCommunicator
//
//  Created by BobYang on 16/7/5.
//  Copyright © 2016年 Honeywell. All rights reserved.
//

#import "NSData+byte.h"
#import "NSString+Data.h"

@implementation NSData (Byte)

- (Byte *)getBytes {
    NSUInteger length = self.length;
    Byte * bytes = malloc(length);
    NSRange range = NSMakeRange(0, length);
    [self getBytes:bytes range:range];
    return bytes;
}

- (NSUInteger)getUInteger {
//    NSData * inversData = [self inverseData];
    NSString * binaryString = [self dataToBinaryString];
    NSUInteger uIntegerValue = [binaryString binaryStringIntValue];
    return uIntegerValue;
}

- (UInt8)getUInt8 {
    Byte * bytes = [self getBytes];
    UInt8 result = (UInt8)bytes[0];
    free(bytes);
    return result;
}

- (SInt8)getSInt8 {
    Byte * bytes = [self getBytes];
    SInt8 result = (SInt8)bytes[0];
    free(bytes);
    return result;
}

- (UInt16)getUInt16 {
    NSUInteger uintValue = [self getUInteger];
    UInt16 uint16Value = (UInt16)uintValue;
    return uint16Value;
}

- (UInt32)getUInt32 {
    NSUInteger uintValue = [self getUInteger];
    UInt32 uint32Value = (UInt32)uintValue;
    return uint32Value;
}

- (UInt64)getUInt64 {
    NSUInteger uintValue = [self getUInteger];
    UInt64 uint64Value = (UInt64)uintValue;
    return uint64Value;
}

- (Float32)getFloat32 {
    Byte * bytes = (Byte *)[self bytes];
    uint32_t hostData = CFSwapInt32LittleToHost(*(const uint32_t *)bytes);
    float floatValue = *(float *)(&hostData);
    return floatValue;
}

- (NSData *)inverseData {
    NSUInteger length = self.length;
    NSMutableData * mutableData = [NSMutableData data];
    NSRange range;
    for (NSUInteger loc = 0; loc < length; loc++) {
        NSUInteger location = length - 1 - loc;
        range = NSMakeRange(location, 1);
        NSData * subData = [self subdataWithRange:range];
        [mutableData appendData:subData];
    }
    return mutableData;
}

- (NSString *)dataToBinaryString {
    NSString * hexString = [self dataToHexString];
    NSString * binaryString = [self convertToBinaryStringFromHexString:hexString];
    return binaryString;
}

- (NSString *)convertToBinaryStringFromHexString:(NSString *)hexString {
    NSMutableString * resultString = [NSMutableString string];
    NSUInteger length = hexString.length;
    for (NSUInteger loc = 0; loc < length; loc++) {
        NSRange range = NSMakeRange(loc, 1);
        NSString * singalHexString = [hexString substringWithRange:range];
        NSString * binarySubstring = [self convertToBinaryStringFromSingalHexString:singalHexString];
        [resultString appendString:binarySubstring];
    }
    return resultString;
}

- (NSString *)convertToBinaryStringFromSingalHexString:(NSString *)singalHexString {
    if ([singalHexString isEqualToString:@"0"]) {
        return @"0000";
    } else if ([singalHexString isEqualToString:@"1"]) {
        return @"0001";
    } else if ([singalHexString isEqualToString:@"2"]) {
        return @"0010";
    } else if ([singalHexString isEqualToString:@"3"]) {
        return @"0011";
    } else if ([singalHexString isEqualToString:@"4"]) {
        return @"0100";
    } else if ([singalHexString isEqualToString:@"5"]) {
        return @"0101";
    } else if ([singalHexString isEqualToString:@"6"]) {
        return @"0110";
    } else if ([singalHexString isEqualToString:@"7"]) {
        return @"0111";
    }  else if ([singalHexString isEqualToString:@"8"]) {
        return @"1000";
    } else if ([singalHexString isEqualToString:@"9"]) {
        return @"1001";
    } else if ([singalHexString isEqualToString:@"A"] || [singalHexString isEqualToString:@"a"]) {
        return @"1010";
    } else if ([singalHexString isEqualToString:@"B"] || [singalHexString isEqualToString:@"b"]) {
        return @"1011";
    } else if ([singalHexString isEqualToString:@"C"] || [singalHexString isEqualToString:@"c"]) {
        return @"1100";
    } else if ([singalHexString isEqualToString:@"D"] || [singalHexString isEqualToString:@"d"]) {
        return @"1101";
    } else if ([singalHexString isEqualToString:@"E"] || [singalHexString isEqualToString:@"e"]) {
        return @"1110";
    } else if ([singalHexString isEqualToString:@"F"] || [singalHexString isEqualToString:@"f"]) {
        return @"1111";
    } else {
        return @"";
    }
}

- (UInt16)convertDataToInt:(NSRange)range bigLittle:(BOOL)change {
    NSData *resultData = [self subdataWithRange:range];
    if (change) {
        return [resultData getUInt16];
    } else {
        NSString * binaryString = [resultData dataToBinaryString];
        NSUInteger uIntegerValue = [binaryString binaryStringIntValue];
        return (UInt16)uIntegerValue;
    }
}

- (NSString *)dataToHexString {
    NSUInteger len = [self length];
    char * chars = (char *)[self bytes];
    NSMutableString * hexString = [[NSMutableString alloc] init];
    for(NSUInteger i = 0; i < len; i++ ) {
        [hexString appendString:[NSString stringWithFormat:@"%0.2hhx", chars[i]]];
    }
    return hexString;
}

@end
