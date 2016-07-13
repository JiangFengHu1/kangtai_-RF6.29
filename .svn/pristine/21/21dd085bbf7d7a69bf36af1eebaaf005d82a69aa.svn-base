//
//  ZASyncURLConnection.m
//  ARC-Blocks-GCD
//
//  Created by mapboo on 4/10/14.
//  Copyright (c) 2014 mapboo. All rights reserved.
//

#import "ZASyncURLConnection.h"

@implementation ZASyncURLConnection

+ (id)request:(NSString *)requestUrl completeBlock:(CompleteBlock_t)compleBlock completePathBlock:(CompletePathBolck_t)pathBlock errorBlock:(ErrorBlock_t)errorBlock;
{
    return [[self alloc] initWithRequest:requestUrl completeBlock:compleBlock completePathBlock:pathBlock  errorBlock:errorBlock];
}

- (id)initWithRequest:(NSString *)requestUrl completeBlock:(CompleteBlock_t)compleBlock completePathBlock:(CompletePathBolck_t)pathBlock errorBlock:(ErrorBlock_t)errorBlock
{
    NSURL *url = [NSURL URLWithString:requestUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    if (self = [super initWithRequest:request delegate:self startImmediately:NO]) {
        data_ = [[NSMutableData alloc] init];
        filePathStr = requestUrl;
        completeBlock_ = [compleBlock copy];
        errorBlock_ = [errorBlock copy];
        completePathBolck_ = [pathBlock copy];
        [self start];
    }
    
    return self;
}

#pragma mark- NSURLConnectionDataDelegate

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [data_ setLength:0];
    
    NSString *lastPathStr = [[filePathStr componentsSeparatedByString:@"/"] lastObject];
    NSString *formatStr = [[filePathStr componentsSeparatedByString:@"."] lastObject];
    
    
    NSArray *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path = [documentPath objectAtIndex:0];
    NSString *myPath;
    if (![formatStr isEqualToString:@"txt"]) {
        myPath = [path stringByAppendingPathComponent:lastPathStr];
    } else {
        myPath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@&&%@", [Util getUUID], lastPathStr]];
        // UTF8转为汉字
        myPath = [myPath stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    completePathBolck_(myPath);
    // 创建一个空的文件 到 沙盒中
    NSFileManager *mgr = [NSFileManager defaultManager];
    
    [mgr createFileAtPath:myPath contents:nil attributes: nil];

    fileHandle = [NSFileHandle fileHandleForWritingAtPath:myPath];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    
    [data_ appendData:data];
    [fileHandle seekToEndOfFile];
    [fileHandle writeData:data];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    completeBlock_(data_);
    fileHandle = nil;
    [fileHandle closeFile];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    errorBlock_(error);
}

@end
