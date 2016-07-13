//
//
/**
 * Copyright (c) www.bugull.com
 */
//
//

#import <Foundation/Foundation.h>
#import "OperationResult.h"

typedef void (^Complete)(OperationResult * result);

@interface SocketOperation : NSObject

@property (readonly,nonatomic) UInt16 index;

@property (readonly,nonatomic,getter = isCanceled) BOOL canceled;

+ (SocketOperation *)operationWithIndex:(UInt16)index complete:(Complete)complete;

- (void)beginTimer:(NSTimeInterval)timeout;

- (void)cancel;

- (void)didReceiveResponse:(OperationResult *)result;

- (void)invokeWithResult:(OperationResult *)result;


@end
