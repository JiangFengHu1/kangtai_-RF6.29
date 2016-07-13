
#import "Crypt.h"
#import "aes.h"

#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonDigest.h>
#import "GTMStringEncoding.h"

@implementation Crypt

+ (NSData *)cryptData:(NSData *)data key:(NSData *)key encrypt:(BOOL)encrypt
{
    NSData * resultData = nil;
    size_t dataSize = (size_t)[data length];
    CCOperation operation = encrypt ? kCCEncrypt : kCCDecrypt;
    
    CCCryptorRef cryptor = NULL;
    CCCryptorStatus createStatus = CCCryptorCreate(operation,
                                                   kCCAlgorithmAES128,
                                                   kCCOptionPKCS7Padding,
                                                   [key bytes], [key length],
                                                   [key bytes],
                                                   &cryptor);
    if (createStatus == kCCSuccess)
    {
        size_t bufferSize = CCCryptorGetOutputLength(cryptor, dataSize, true);
        void * resultBuffer = malloc(bufferSize);
        size_t updateSize = 0;
        CCCryptorStatus updateStatus = CCCryptorUpdate(cryptor,
                                                       [data bytes], dataSize,
                                                       resultBuffer, bufferSize,
                                                       &updateSize);
        if (updateStatus == kCCSuccess)
        {
            size_t finalSize = 0;
            CCCryptorStatus finalStatus = CCCryptorFinal(cryptor,
                                                         resultBuffer + updateSize,
                                                         bufferSize - updateSize,
                                                         &finalSize);
            CCCryptorRelease(cryptor);
            if (finalStatus == kCCSuccess)
            {
                resultData = [NSData dataWithBytesNoCopy:resultBuffer length:updateSize + finalSize];
            }
        }
    }
    return resultData;
}

//加密算法

+ (NSData *)encryptData:(NSData *)data key:(NSData *)key
{
    if (!key)
    {
        UInt8 keyBytes[] = "abcdef1234567890";
        key = [NSData dataWithBytes:keyBytes length:16];
    }
    UInt8 bytes[256];
    memcpy(bytes, data.bytes, data.length);
    int len = device_aes_encrypt((UInt8 *)key.bytes, bytes, (int)data.length);
    return [NSData dataWithBytes:bytes length:len];
}

//解密
+ (NSData *)decryptData:(NSData *)data key:(NSData *)key
{
    if (!key)
    {
        UInt8 keyBytes[] = "abcdef1234567890";
        key = [NSData dataWithBytes:keyBytes length:16];
    }
    UInt8 bytes[256];
    memcpy(bytes, data.bytes, data.length);
    int len = device_aes_decrypt((UInt8 *)key.bytes, bytes, (int)data.length);
    return [NSData dataWithBytes:bytes length:len];
}

+ (NSData *)decodeHex:(NSString *)hexString
{
    return [[GTMStringEncoding hexStringEncoding] decode:hexString];
}

//
+ (NSString *)hexEncode:(NSData *)data
{
    return [[GTMStringEncoding hexStringEncoding] encode:data];
}

+ (NSData *)md5Encrypt:(NSString *)string
{
    NSData * value = [string dataUsingEncoding:NSUTF8StringEncoding];
    UInt8 outputBuffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(value.bytes, (CC_LONG)value.length, outputBuffer);
    return [NSData dataWithBytes:outputBuffer length:CC_MD5_DIGEST_LENGTH];
}


@end