//
//
/**
 * Copyright (c) www.bugull.com
 */
//
//

#import "OperationResult.h"
#import "ResponseAnalysis.h"
#import "DataBase.h"
@implementation OperationResult



- (id)initWithResponse:(NSData *)response Withserver:(NSString *)server
{
    self = [super init];
    _responseData = response;
    if ([server isEqualToString:@"local"]) {
    _resultInfo = [ResponseAnalysis analysisLocalServer:response];

    }
    else if ([server isEqualToString:@"remote"])
    {
    _resultInfo = [ResponseAnalysis analysisResponse:response];
  
    }
    
    [self getCurrentData:_resultInfo];
    NSLog(@"zq == %@ == %@",response,_resultInfo);
    
    
//    NSString *host = [_resultInfo objectForKey:@"host"];
//    [DataBase insertDataBaseWithHostTolocal:host];
    return self;
}

+ (OperationResult *)resultWithResponse:(NSData *)response Withserver:(NSString *)server
{
    return [[self alloc] initWithResponse:response Withserver:server];
}

- (void)getCurrentData:(NSDictionary *)dis
{
    

    if ([self.delegate respondsToSelector:@selector(operationResultDelegategetCurrentData:)])
    {
        [self.delegate operationResultDelegategetCurrentData:dis];
    }
}


- (BOOL)resultCodeOK
{
    if ([[_resultInfo allKeys] containsObject:@"result"])
    {
        UInt8 resultCode = [[_resultInfo objectForKey:@"result"] intValue];
        return resultCode == 0x00;
    }
    return NO;
}


@end
