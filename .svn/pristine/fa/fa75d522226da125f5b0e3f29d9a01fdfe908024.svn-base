//
//
/**
 * Copyright (c) www.bugull.com
 */
//
//

#import "NSCodingUtil.h"
#import <objc/runtime.h>

@implementation NSCodingObject

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [NSCodingUtil encodeWithObj:self coder:aCoder];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    return [NSCodingUtil decodeWithClass:[self class] coder:aDecoder];
}

@end

@interface CodingItem : NSObject

@property (strong,nonatomic) NSString * propertyName;

@property (strong,nonatomic) NSString * ivarName;

@property (strong,nonatomic) NSString * typeEncoding;

@property (nonatomic) Ivar ivar;

@end

@implementation CodingItem

- (NSString *)codingKey
{
    return _propertyName.length > 0 ? _propertyName : _ivarName;
}

- (void)encodeWithObj:(id)obj coder:(NSCoder *)coder
{
    NSString * codingKey = [self codingKey];
    char signiture = [_typeEncoding characterAtIndex:0];
    if (signiture == _C_ID)
    {
        id value = object_getIvar(obj, _ivar);
        if (value && [[value class] conformsToProtocol:@protocol(NSCoding)])
        {
            [coder encodeObject:value forKey:codingKey];
        }
    }
    else
    {
        void * pointer = (void *)((ptrdiff_t)obj +  ivar_getOffset(_ivar));
        if  (signiture == _C_INT)
        {
            [coder encodeInt:*(int *)pointer forKey:codingKey];
        }
        else if (signiture == _C_FLT)
        {
            [coder encodeFloat:*(float *)pointer forKey:codingKey];
        }
        else if (signiture == _C_DBL)
        {
            [coder encodeDouble:*(double *)pointer forKey:codingKey];
        }
        else if (signiture == _C_BOOL)
        {
            [coder encodeBool:*(BOOL *)pointer forKey:codingKey];
        }
        else if (signiture == _C_LNG)
        {
            [coder encodeInteger:*(NSInteger *)pointer forKey:codingKey];
        }
        else if (signiture == _C_LNG_LNG)
        {
            [coder encodeInt64:*(int64_t *)pointer forKey:codingKey];
        }
        else if (signiture == _C_UCHR)
        {
            [coder encodeInt:*(UInt8 *)pointer forKey:codingKey];
        }
    }
}

- (void)decodeWithObj:(id)obj coder:(NSCoder *)coder
{
    NSString * codingKey = [self codingKey];
    char signiture = [_typeEncoding characterAtIndex:0];
    if (signiture == _C_ID)
    {
        object_setIvar(obj, _ivar, [coder decodeObjectForKey:codingKey]);
    }
    else
    {
        void * pointer = (void *)((ptrdiff_t)obj +  ivar_getOffset(_ivar));
        if  (signiture == _C_INT)
        {
            *(int *)pointer = [coder decodeIntForKey:codingKey];
        }
        else if (signiture == _C_FLT)
        {
            *(float *)pointer = [coder decodeFloatForKey:codingKey];
        }
        else if (signiture == _C_DBL)
        {
            *(double *)pointer = [coder decodeDoubleForKey:codingKey];
        }
        else if (signiture == _C_BOOL)
        {
            *(BOOL *)pointer = [coder decodeBoolForKey:codingKey];
        }
        else if (signiture == _C_LNG)
        {
            *(NSInteger *)pointer = [coder decodeIntegerForKey:codingKey];
        }
        else if (signiture == _C_LNG_LNG)
        {
            *(long long *)pointer = [coder decodeInt64ForKey:codingKey];
        }
        else if (signiture == _C_UCHR)
        {
            *(UInt8 *)pointer = [coder decodeIntForKey:codingKey];
        }
    }
}


@end

@implementation NSCodingUtil

+ (void)encodeWithObj:(id)obj coder:(NSCoder *)encoder
{
    for (CodingItem * codingItem in [self codingItemListFromClass:[obj class]])
    {
        [codingItem encodeWithObj:obj coder:encoder];
    }
}

+ (id)decodeWithClass:(Class)cls coder:(NSCoder *)decoder
{
    id obj = [[cls alloc] init];
    for (CodingItem * codingItem in [self codingItemListFromClass:cls])
    {
        [codingItem decodeWithObj:obj coder:decoder];
    }
    return obj;
}

+ (NSArray *)codingItemListFromClass:(Class)cls
{
    NSMutableArray * codingItemArray = [NSMutableArray array];
    NSMutableSet * ivarNameSet = [NSMutableSet set];
    unsigned int propertyCount = 0;
    objc_property_t * propertyList = class_copyPropertyList(cls, &propertyCount);
    for (int index = 0; index < propertyCount; index++)
    {
        objc_property_t property = propertyList[index];
        CodingItem * codingItem = [self codingItemFromProperty:property class:cls];
        [ivarNameSet addObject:codingItem.ivarName];
        [codingItemArray addObject:codingItem];
    }
    unsigned int ivarCount = 0;
    Ivar * ivarList = class_copyIvarList(cls, &ivarCount);
    for (int index = 0; index < ivarCount; index++)
    {
        Ivar ivar = ivarList[index];
        if (![ivarNameSet containsObject:[NSString stringWithUTF8String:ivar_getName(ivar)]])
        {
            [codingItemArray addObject:[self codingItemFromIvar:ivar class:cls]];
        }
    }
    return codingItemArray;
}

+ (CodingItem *)codingItemFromProperty:(objc_property_t)property class:(Class)cls
{
    CodingItem * codingItem = [[CodingItem alloc] init];
    unsigned int attrCount = 0;
    objc_property_attribute_t * attrList = property_copyAttributeList(property,&attrCount);
    codingItem.propertyName = [NSString stringWithUTF8String:property_getName(property)];
    for (int index = 0; index < attrCount; index ++)
    {
        objc_property_attribute_t attr = attrList[index];
        if (strcmp(attr.name, "T") == 0)
        {
            codingItem.typeEncoding = [NSString stringWithUTF8String:attr.value];
        }
        else if (strcmp(attr.name, "V") == 0)
        {
            codingItem.ivar = class_getInstanceVariable(cls, attr.value);
            codingItem.ivarName = [NSString stringWithUTF8String:ivar_getName(codingItem.ivar)];
        }
    }
    return codingItem;
}

+ (CodingItem *)codingItemFromIvar:(Ivar)ivar class:(Class)cls
{
    CodingItem * codingItem = [[CodingItem alloc] init];
    codingItem.ivar = ivar;
    codingItem.ivarName =  [NSString stringWithUTF8String:ivar_getName(ivar)];
    codingItem.typeEncoding = [NSString stringWithUTF8String:ivar_getTypeEncoding(ivar)];
    return codingItem;
}

+ (NSData *)archivedDataOfObject:(id<NSCoding>)obj
{
    return [NSKeyedArchiver archivedDataWithRootObject:obj];
}

+ (id)objectFromArchivedData:(NSData *)data
{
    return [NSKeyedUnarchiver unarchiveObjectWithData:data];
}

@end
