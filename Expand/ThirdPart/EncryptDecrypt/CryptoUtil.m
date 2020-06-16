//
//  CryptoUtil.m
//  AirTouch
//
//  Created by Devin on 1/16/15.
//  Copyright (c) 2015 Honeywell. All rights reserved.
//

#import "CryptoUtil.h"
#import <CommonCrypto/CommonCryptor.h>
#import "Base64+Category.h"
#import "JFBCrypt.h"

@implementation CryptoUtil

+ (NSString *)tripleDESEncryptString:(NSString *)inputString {
    return [CryptoUtil TripleDES:inputString encryptOrDecrypt:kCCEncrypt];
}

+ (NSString *)tripleDESDecryptString:(NSString *)inputString {
    return [CryptoUtil TripleDES:inputString encryptOrDecrypt:kCCDecrypt];
}

+ (NSString *)TripleDES:(NSString *)inputString encryptOrDecrypt:(CCOperation)encryptOrDecrypt {
    const void *vplainText;
    NSUInteger plainTextBufferSize;
    
    if (encryptOrDecrypt == kCCDecrypt)
    {
        NSData *EncryptData = [inputString base64DecodedData];
        plainTextBufferSize = [EncryptData length];
        vplainText = [EncryptData bytes];
    }
    else
    {
        NSData *plainData = [inputString dataUsingEncoding:NSUTF8StringEncoding];
        plainTextBufferSize = [plainData length];
        vplainText = (const void *)[plainData bytes];
    }
    
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    
    NSUInteger plusBlockSize = plainTextBufferSize + kCCBlockSize3DES;
    NSUInteger minusBlockSize = kCCBlockSize3DES - 1;
    bufferPtrSize = (plusBlockSize) & ~(minusBlockSize);
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    
    NSString *initVec = @"init Vec";
    const void *vkey = (const void *) [@"AI080R1DILWE288O098KI" UTF8String];
    const void *vinitVec = (const void *) [initVec UTF8String];
    
    CCCrypt(encryptOrDecrypt,
            kCCAlgorithm3DES,
            kCCOptionPKCS7Padding,
            vkey,
            kCCKeySize3DES,
            vinitVec,
            vplainText,
            plainTextBufferSize,
            (void *)bufferPtr,
            bufferPtrSize,
            &movedBytes);
    
    NSString *result;
    
    if (encryptOrDecrypt == kCCDecrypt)
    {
        NSData *resultData = [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes];
        result = [[NSString alloc] initWithData:resultData encoding:NSUTF8StringEncoding];
    }
    else
    {
        NSData *myData = [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes];
        result = [myData base64EncodedString];
    }
    
    free(bufferPtr);
    
    return result;
}

+ (NSString *)bcryptEncryptString:(NSString *)inputString salt:(NSString *)salt {
    return [JFBCrypt hashPassword:inputString withSalt:salt];
}

+ (BOOL)bcryptValidatePassword:(NSString *)inputString hash:(NSString *)hash {
    return [JFBCrypt checkPassword:inputString withHash:hash];
}

+ (uint32_t)randomInt {
    Byte bytes[4];
    int result = SecRandomCopyBytes(kSecRandomDefault, 4, bytes);
    if (result == 0) {
        uint32_t ret;
        memcpy(&ret, bytes, 4);
        return ret;
    }
    return 0;
}

@end
