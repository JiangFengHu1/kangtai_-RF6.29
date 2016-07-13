

#import <Foundation/Foundation.h>

@interface Crypt : NSObject

+ (NSData *)encryptData:(NSData *)data key:(NSData *)key;

+ (NSData *)decryptData:(NSData *)data key:(NSData *)key;

+ (NSData *)decodeHex:(NSString *)hexString;

+ (NSString *)hexEncode:(NSData *)data;

+ (NSData *)md5Encrypt:(NSString *)string;


@end
