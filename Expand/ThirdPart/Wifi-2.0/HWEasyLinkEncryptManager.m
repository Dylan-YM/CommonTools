//
//  ABS128CBC.m
//  MICO
//
//  Created by Honeywell on 2017/4/11.
//  Copyright © 2017年 MXCHIP Co;Ltd. All rights reserved.
//

#import "HWEasyLinkEncryptManager.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonHMAC.h>  

@interface HWEasyLinkEncryptManager ()

@end

@implementation HWEasyLinkEncryptManager

- (id)init {
    self = [super init];
    if (self) {
        [self reset];
    }
    return self;
}

- (NSData *)getGIV {
    NSData *sha256MacId = [self getSha256String:self.macId];
    return [self getPre16:sha256MacId];
}

- (NSData *)getKey {
    NSString *randMacId = [NSString stringWithFormat:@"%@%@%@",[self.randString substringToIndex:8],self.macId,[self.randString substringFromIndex:8]];
    NSData *shaRandMacId = [self getSha256String:randMacId];
    return [self getPre16:shaRandMacId];
}

- (NSString *)getRandString {
    NSString *strRandom = @"";
    
    for(NSInteger i = 0; i < 16; i++)
    {
        strRandom = [strRandom stringByAppendingFormat:@"%i",(arc4random() % 9)];
    }
    return strRandom;
}

- (NSData *)randStringEncryptWithSSid:(NSString *)ssidString password:(NSString *)password {
    //加密random
    self.randKey = [self getRandKey:self.macId];
    self.ivData = [self getGIV];
    NSData *randomStringData = [self.randString dataUsingEncoding:NSUTF8StringEncoding];
    NSData *randomStringEncryptData = [self AES128CBC_NoPadding:randomStringData key:self.randKey gIv:self.ivData operation:kCCEncrypt];
    
    //加密ssid password random
    NSMutableString *fullString = [NSMutableString string];
    [fullString appendString:ssidString];
    [fullString appendString:password];
    [fullString appendString:self.randString];
    NSData *sha1FullData = [self getSha256String:fullString];
    NSData *hmacSha2FullData = [self hmac:sha1FullData withKey:self.ssidKey];
    
    NSMutableData *resultData = [NSMutableData data];
    [resultData appendData:randomStringEncryptData];
    [resultData appendData:hmacSha2FullData];
    
    return resultData;
}

- (NSData *)SSIDInfoEncrypt:(NSString *)info {
    self.ssidKey = [self getKey];
    self.ivData = [self getGIV];
    NSString *paddingString = [self ssidPasswordPadding:info];
    NSData *contentData = [paddingString dataUsingEncoding:NSUTF8StringEncoding];
    NSData *result = [self AES128CBC_NoPadding:contentData key:self.ssidKey gIv:self.ivData operation:kCCEncrypt];
    return result;
}

- (NSData *)AES128CBC_NoPadding:(NSData *)contentData key:(NSData *)key gIv:(NSData *)gIv operation:(CCOperation)operation {
    NSUInteger dataLength = contentData.length;
    
    // 密文长度 <= 明文长度 + BlockSize
    size_t encryptSize = dataLength + kCCBlockSizeAES128;
    void *encryptedBytes = malloc(encryptSize);
    size_t actualOutSize = 0;
    
    CCCryptorStatus cryptStatus = CCCrypt(operation,
                                          kCCAlgorithmAES,
                                          0x0000,
                                          key.bytes,
                                          kCCKeySizeAES128,
                                          gIv.bytes,
                                          contentData.bytes,
                                          dataLength,
                                          encryptedBytes,
                                          encryptSize,
                                          &actualOutSize);
    
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:encryptedBytes length:actualOutSize];
    }
    free(encryptedBytes);
    return nil;
}

- (NSData *)AES128CBC_PKCS7Padding:(NSData *)contentData key:(NSData *)key gIv:(NSData *)gIv operation:(CCOperation)operation {
    NSUInteger dataLength = contentData.length;
    
    // 密文长度 <= 明文长度 + BlockSize
    size_t encryptSize = dataLength + kCCBlockSizeAES128;
    void *encryptedBytes = malloc(encryptSize);
    size_t actualOutSize = 0;
    
    CCCryptorStatus cryptStatus = CCCrypt(operation,
                                          kCCAlgorithmAES,
                                          kCCOptionPKCS7Padding,  // 系统默认使用 CBC，然后指明使用 PKCS7Padding
                                          key.bytes,
                                          kCCKeySizeAES128,
                                          gIv.bytes,
                                          contentData.bytes,
                                          dataLength,
                                          encryptedBytes,
                                          encryptSize,
                                          &actualOutSize);
    
    if (cryptStatus == kCCSuccess) {
        // 对加密后的数据进行 base64 编码
        return [NSData dataWithBytesNoCopy:encryptedBytes length:actualOutSize];
    }
    free(encryptedBytes);
    return nil;
}

- (NSData *)getSha256String:(NSString *)srcString {
    const char *cstr = [srcString cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:srcString.length];
    
    uint8_t digest[CC_SHA256_DIGEST_LENGTH];
    
    CC_SHA256(data.bytes, (CC_LONG)data.length, digest);
    
    NSMutableString* result = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA256_DIGEST_LENGTH; i++) {
        [result appendFormat:@"%02x", digest[i]];
    }
    
    NSData *resultData = [NSData dataWithBytes:(const void *)digest length:CC_SHA256_DIGEST_LENGTH];
    
    return resultData;
}

- (NSData *)getSha128String:(NSString *)srcString {
    const char *cstr = [srcString cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:srcString.length];
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(data.bytes, (unsigned int)data.length, digest);
    NSMutableString *outputStr = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    for(int i=0; i<CC_SHA1_DIGEST_LENGTH; i++) {
        [outputStr appendFormat:@"%02x", digest[i]];
    }
    NSData *resultData = [NSData dataWithBytes:(const void *)digest length:CC_SHA1_DIGEST_LENGTH];
    return resultData;
}

- (NSData *)getPre16:(NSData *)data {
    Byte *dataByte = (Byte *)[data bytes];
    Byte byte[16];//16存多少声明多少
    memcpy(&byte, &dataByte[0], 16);//byte数据接收者，dataByte数据源，16要copy的数据长度。
    NSData *resultData = [NSData dataWithBytes:byte length: sizeof(byte)];
    return resultData;
}

- (NSData *)getRandKey:(NSString *)macId {
    NSData *macIdData = [macId dataUsingEncoding:NSUTF8StringEncoding];
    Byte *dataByte = (Byte *)[macIdData bytes];
    Byte byte[16];
    for (NSInteger i = 0; i < 16; i++) {
        if (i >= macIdData.length) {
            byte[i] = 0x00;
        } else {
            byte[i] = dataByte[i];
        }
    }
    NSData *resultData = [NSData dataWithBytes:byte length: sizeof(byte)];
    return resultData;
}

- (NSString *)ssidPasswordPadding:(NSString *)info {
    NSInteger length = info.length;
    NSInteger paddingLength = ((length%16 == 0)? 0 : (16-length%16));
    NSMutableString *mutableInfo = [NSMutableString stringWithString:info];
    for (NSInteger i = 0; i < paddingLength; i++) {
        [mutableInfo appendString:@"\0"];
    }
    return mutableInfo;
}

#pragma mark - HMAC SHA 256 hashing
- (NSData *)hmac:(NSData *)plainData withKey:(NSData *)keyData
{
    NSMutableData* hash = [NSMutableData dataWithLength:CC_SHA256_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA256, keyData.bytes, keyData.length, plainData.bytes, plainData.length, hash.mutableBytes);
    
    return hash;
}

#pragma mark - 解密
- (NSString *)randStringDecrypt:(NSData *)data {
    self.randKey = [self getRandKey:self.macId];
    self.ivData = [self getGIV];
    NSData *result = [self AES128CBC_NoPadding:data key:self.randKey gIv:self.ivData operation:kCCDecrypt];
    NSString *resultString = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
    return resultString;
}

- (NSString *)SSIDInfoDecrypt:(NSData *)info {
    self.ssidKey = [self getKey];
    
    NSData *result = [self AES128CBC_PKCS7Padding:info key:self.ssidKey gIv:self.ivData operation:kCCDecrypt];
    NSString *resultString = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
    return resultString;
}

- (void)reset {
    self.randString = [self getRandString];
    
    self.ivData = nil;
    self.randKey = nil;
    self.ssidKey = nil;
    self.macId = nil;
}

@end
