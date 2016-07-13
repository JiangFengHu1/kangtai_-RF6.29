//
//
/**
 * Copyright (c) www.bugull.com
 */
//
//

#import <Foundation/Foundation.h>

@interface ResponseAnalysis : NSObject



//@property (nonatomic,copy)NSString *hertString;
+ (NSDictionary *)analysisResponse:(NSData *)response ;


+ (NSDictionary *)analysisLocalServer:(NSData *)response ;

+ (NSData *)macFromResponse:(NSData *)response;

+ (BOOL)isResponseEncrypt:(NSData *)response;

+ (UInt16)indexFromResponse:(NSData *)response;

+ (UInt8)protocolNoFromResponse:(NSData *)response;

+ (void)connectDevice:(Device *)device response:(NSData *)response;

@end
