//
//
/**
 * Copyright (c) www.bugull.com
 */
//
//


#import <Foundation/Foundation.h>

@protocol  OperationResultDelegate<NSObject>

@optional

- (void)operationResultDelegategetCurrentData:(NSDictionary *)dictary;

@end

@interface OperationResult : NSObject

@property (readonly,nonatomic) NSData * responseData;
@property (strong,nonatomic)  id<OperationResultDelegate> delegate;

@property (readonly,nonatomic) NSDictionary * resultInfo;

+ (OperationResult *)resultWithResponse:(NSData *)response Withserver:(NSString *)server;

- (BOOL)resultCodeOK;

@end
