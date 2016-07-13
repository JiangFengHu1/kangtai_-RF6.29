//
//
/**
 * Copyright (c) www.bugull.com
 */
//
//

#import <Foundation/Foundation.h>

@interface NSCodingObject : NSObject <NSCoding>
@end

@interface NSCodingUtil : NSObject

+ (void)encodeWithObj:(id)obj coder:(NSCoder *)encoder;

+ (id)decodeWithClass:(Class)cls coder:(NSCoder *)decoder;

+ (NSData *)archivedDataOfObject:(id<NSCoding>)obj;

+ (id)objectFromArchivedData:(NSData *)data;

@end
