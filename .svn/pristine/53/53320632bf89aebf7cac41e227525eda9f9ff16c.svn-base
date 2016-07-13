//
//
/**
 * Copyright (c) www.bugull.com
 */
//
//

#import "SocketOperation.h"

@interface SocketOperation()

@property (strong,readonly,nonatomic) Complete complete;

@property (strong,nonatomic) NSTimer * timer;

@end

@implementation SocketOperation

- (id)initWithIndex:(UInt16)index complete:(Complete)complete
{
    self = [super init];
    _index = index;
    _complete = complete;
    return self;
}

+ (SocketOperation *)operationWithIndex:(UInt16)index complete:(Complete)complete
{
    return [[self alloc] initWithIndex:index complete:complete];
}

- (void)beginTimer:(NSTimeInterval)timeout
{
    _timer = [NSTimer scheduledTimerWithTimeInterval:timeout target:self selector:@selector(timeout) userInfo:nil repeats:NO];
}

- (void)timeout
{
    [self invokeWithResult:nil];
}

- (void)cancel
{
    _canceled = YES;
    _complete = nil;
    [_timer invalidate];
}

- (void)didReceiveResponse:(OperationResult *)result
{
    if (!_canceled)
    {
        [self invokeWithResult:result];
    }
}

- (void)invokeWithResult:(OperationResult *)result
{
    [_timer invalidate];
    if (_complete)
    {
        _complete(result);
        _complete = nil;
    }
}

@end
