//
//
/**
 * Copyright (c) www.bugull.com
 */
//
//

#import "RemoteService.h"
#import "GCDAsyncSocket.h"
#import "ProtocolData.h"
#import "Crypt.h"
//#import "TianLiUtil.h"
#import "ResponseAnalysis.h"
#import "DeviceManager.h"
#import "NetworkUtil.h"

#define FirstPartTag        1
#define SecondPartTag       2

static RemoteService * singleton = nil;

@interface RemoteService()<GCDAsyncSocketDelegate>
{
    GCDAsyncSocket * _balanceSocket;
    GCDAsyncSocket * _tcpSocket;
    GCDAsyncSocket * _currentSocket;
    NSData * _key;
    NSMutableData * _response;
    UInt16 _interval;
    BOOL _connecting;
    NSTimer *stopTimer;
}

@property (strong,nonatomic) NSMutableArray * operations;

@property (strong,nonatomic) NSMutableArray * connectedDevices;

@property (strong,nonatomic) NSMutableSet * subscribedDevices;

@property (weak,nonatomic) id delegate;

@end

@implementation RemoteService

+ (RemoteService *)sharedInstance
{
    if (!singleton)
    {
        singleton = [[super allocWithZone:NULL] init];
    }
    return singleton;
}

- (id)init
{
    self = [super init];
    _interval = 10;
    _operations = [NSMutableArray array];
    _connectedDevices = [NSMutableArray array];
    _subscribedDevices = [NSMutableSet set];
    _delegate = DeviceManagerInstance;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(interval:) name:@"_interval" object:nil];
    
    return self;
}

- (BOOL)connect
{
    if ([NetworkUtil networkStatus] != NotReachable && !_connecting)
    {
        _connecting = YES;
        [self performSelector:@selector(resetConnecting) withObject:nil afterDelay:0.5];
        NSError * error = nil;
        _balanceSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
        //        delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)]
        if (![_balanceSocket connectToHost:AppBalanceHost onPort:AppBalancePort error:&error])
        {
            NSLog(@"Error connectToHost: %@", [error localizedDescription]);
        }
        return YES;
    }
    return NO;
}

- (void)resetConnecting
{
    _connecting = NO;
}

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
    NSLog(@"host:%@port:%d",host,port);
    _currentSocket = sock;
    [_currentSocket readDataToLength:TopLen withTimeout:-1 tag:FirstPartTag];
    if (sock == _balanceSocket)
    {
        
        [self sendProtocol:[ProtocolData workingServer:NewIndex] complete:^(OperationResult * result) {
            
        }];
        
        [self performSelector:@selector(seceedTCPToserver) withObject:nil afterDelay:2];
        
    }
    else
    {
        [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(connectToTheTCPServer:) userInfo:nil repeats:YES];
    }
}

- (void)connectToTheTCPServer:(NSTimer *)timer
{
    NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_USERMODEL];
    NSString *pwd = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_PASSWORD];
    
    if (userName != nil && pwd != nil) {
        [self sendProtocol:[ProtocolData requestConnect:NewIndex] complete:^(OperationResult *result) {
            
            [self startHeartBeat];
            
        }];
        [self performSelector:@selector(startHeartBeat) withObject:self afterDelay:8];
        
        [timer invalidate];
        timer = nil;
    }
}

- (void)getTCPServerInfo:(NSTimer *)timer
{
    NSString * host = [[NSUserDefaults standardUserDefaults] objectForKey:BroHost];
    if (host == nil) {
        [self sendProtocol:[ProtocolData workingServer:NewIndex] complete:^(OperationResult * result) {
            
        }];
    } else {
        [timer invalidate];
        [self seceedTCPToserver];
    }
}

- (void)seceedTCPToserver
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([[Util getAppDelegate].connect isEqualToString: @"2"]) {
            [Util getAppDelegate].connect = @"1";
            [MMProgressHUD dismiss];
        }
    });
    
    NSString * host = [[NSUserDefaults standardUserDefaults] objectForKey:BroHost];
    NSError * error = nil;
    NSLog(@"-----开始连接工作服务器:ip = %@",host);
    _tcpSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    if (![_tcpSocket connectToHost:host onPort:BroPort error:&error])
    {
        
        
    }
}


- (void)getTCPstate
{
    if (_tcpSocket.isConnected == YES) {
        
        _tcpSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
        
    } else {
        
        return;
    }
    
    return ;
}

#pragma mark-
#pragma mark 61
- (void)startHeartBeat
{
    [NSTimer scheduledTimerWithTimeInterval:_interval target:self selector:@selector(heartBeat) userInfo:nil repeats:NO];
    
    if (stopTimer != nil) {
        
        [stopTimer invalidate];
        stopTimer = nil;
    }
    stopTimer = [NSTimer scheduledTimerWithTimeInterval:_interval*1.5 target:self selector:@selector(stopTcpServer) userInfo:nil repeats:NO];
}

static int indexhert = 0;
- (void)stopTcpServer
{
    if (indexhert == 0) {
        
        _interval = 3;
        [self startHeartBeat];
        NSArray *arr = [[DeviceManagerInstance getlocalDeviceDictary] allKeys];
        if (arr.count == 0) {
            return;
        }
        for (int i = 0; i < arr.count; i++) {
            Device *device = [[DeviceManagerInstance getlocalDeviceDictary] objectForKey:arr[i]];
            device.remoteContent = 0;
            [[DeviceManagerInstance getlocalDeviceDictary] setObject:device forKey:arr[i]];
        }
        
        NSLog(@"第一次设备断开");
        
        indexhert = 2;
    }else if (indexhert == 2)
    {
        NSLog(@"第二次设备断开");
        NSArray *arr = [[DeviceManagerInstance getlocalDeviceDictary] allKeys];
        if (arr.count != 0) {
            for (int i = 0; i < arr.count; i++) {
                Device *device = [[DeviceManagerInstance getlocalDeviceDictary] objectForKey:arr[i]];
                device.remoteContent = 0;
                [[DeviceManagerInstance getlocalDeviceDictary] setObject:device forKey:arr[i]];
            }
        }

        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:SERVER_KEY];
        [self connect];
        indexhert = 0;
    }
}

- (void)heartBeat
{
    [self sendProtocol:[ProtocolData heartBeat:NewIndex WithUDP:NO] complete:^(OperationResult *result) {
        if (result.resultInfo)
        {
        }
    }];

}
- (void)interval:(NSNotification *)notification
{
    NSDictionary  *dict =[notification object];
    
    
    _interval = [[dict objectForKey:@"interval"] intValue];
    
    [self startHeartBeat];
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    NSLog(@"TCP 接收到的数据 ===== %@", data);
    
    // 查询倒计时 <0102accf 23379350 13000124 cafd6631 12000180 000001e3 000000ff>
    // 
    
    if (tag == FirstPartTag)
    {
        
        _response = [[NSMutableData alloc] initWithData:data];
        
        
        UInt8 secondLen = ((UInt8 *)[data bytes])[8];
        [sock readDataToLength:secondLen withTimeout:-1 tag:SecondPartTag];
    }
    else
    {
        if ([ResponseAnalysis isResponseEncrypt:_response])
        {
            
            NSData *keyData =  [[NSUserDefaults standardUserDefaults] objectForKey:SERVER_KEY];
            
            NSData * secondPart = [Crypt decryptData:data key:keyData];
            [_response appendData:secondPart];
        }
        else
        {
            [_response appendData:data];
        }
        [self didReceiveResponse];
    }
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
    if (sock == _tcpSocket)
    {
        [self disconnect];
        [_delegate remoteDisconnected:[NSString stringWithFormat:@"socketDidDisconnect:%@",[err localizedDescription]]];
    }
}

- (SocketOperation *)sendProtocol:(NSData *)protocol complete:(Complete)complete
{
    NSLog(@"request TCP:%@", protocol);
    SocketOperation * operation = [SocketOperation operationWithIndex:CurrentIndex complete:complete];
    [operation beginTimer:TCPTimeout];
    [_operations addObject:operation];
    [_currentSocket writeData:protocol withTimeout:-1 tag:0];
    //    [self ];
    NSLog(@"=== %@",operation);
    
    return operation;
}

- (void)didReceiveResponse
{
    NSLog(@" zq response ===== %@",_response);
    
    OperationResult * result = [OperationResult resultWithResponse:_response Withserver:@"remote"];
    if (![DeviceManagerInstance processResult:result])
    {
        SocketOperation * operation = [self operationWithIndex:[ResponseAnalysis indexFromResponse:_response]];
        if (operation)
        {
            
            [_operations removeObject:operation];
            [operation didReceiveResponse:result];
        }
    }
    [self readNextResponse];
}

- (SocketOperation *)operationWithIndex:(UInt16)index
{
    for (SocketOperation * operation in _operations)
    {
        if (operation.index == index)
        {
            return operation;
        }
    }
    return nil;
}

- (void)readNextResponse
{
    [_currentSocket readDataToLength:TopLen withTimeout:-1 tag:FirstPartTag];
}

- (void)disconnect
{
    for (Device * device in _connectedDevices)
    {
        [device disConnect];
    }
    [_connectedDevices removeAllObjects];
    
    [_balanceSocket disconnect];
    _balanceSocket = nil;
    [_tcpSocket disconnect];
    _tcpSocket = nil;
    [_currentSocket disconnect];
    _currentSocket = nil;
}

- (BOOL)isConnected
{
    return _tcpSocket.isConnected;
}

- (BOOL)isConnectedDevice:(Device *)device
{
    return [_connectedDevices containsObject:device] && device.isConnected;
    
}

- (void)refreshConnectStatus:(Device *)device
{
    if (device.isConnected && ![_connectedDevices containsObject:device])
    {
        
        [_connectedDevices addObject:device];
        [self.delegate remoteDidConnectDevice:device];
    }
    else if (!device.isConnected && [_connectedDevices containsObject:device])
    {
        [_connectedDevices removeObject:device];
    }
}

- (void)connectDevices
{
    if ([self isConnected])
    {
        for (Device * device in DeviceManagerInstance.devices)
        {
            if (!device.isConnected)
            {
                [self connectDevice:device];
            }
        }
    }
}

- (void)connectDevice:(Device *)device
{
    //    [self sendProtocol:[ProtocolData queryConnection:device index:NewIndex key:_key] complete:^(OperationResult *result) {
    //        if (result.resultInfo)
    //        {
    //            UInt8 resultCode = [[result.resultInfo objectForKey:@"result"] intValue];
    //            if (resultCode == 0x01)
    //            {
    //                [device didConnect:result.responseData];
    //            }
    //            else
    //            {
    //                [device disConnect];
    //            }
    //            [self subscribeDevice:YES device:device];
    //            [self refreshConnectStatus:device];
    //        }
    //    }];
}

- (void)subscribeDevice:(BOOL)sub device:(Device *)device
{
    //    if ((sub && ![_subscribedDevices containsObject:device]) || (!sub && [_subscribedDevices containsObject:device]))
    //    {
    //        [self sendProtocol:[ProtocolData subscribeConnection:YES device:device index:NewIndex key:_key] complete:^(OperationResult *result) {
    //            if ([result resultCodeOK])
    //            {
    //                [_subscribedDevices addObject:device];
    //            }
    //        }];
    //    }
}

- (void)removeDevice:(Device *)device
{
    [_connectedDevices removeObject:device];
    [self subscribeDevice:NO device:device];
}

#pragma mark-0x01 GPIO
- (void)setGPIOCloseOrOpenWithDeciceMac:(NSData *)data index:(BOOL)indx deviceType:(NSString *)type
{
    
    NSString * host = [[NSUserDefaults standardUserDefaults] objectForKey:BroHost];
    
    NSData *key =  [[NSUserDefaults standardUserDefaults]  objectForKey:SERVER_KEY];
    
    NSLog(@"ip%@===mac-=%@",host,data);
    UInt8 buyt = indx ? 0xff : 0x00;
    
    [self sendProtocol:[ProtocolData setGPIOWithdevice:data index:NewIndex linex:buyt key:key deviceType:type] complete:^(OperationResult *result) {
        
        //        NSLog(@"%@=-=-=-=result",result.resultInfo);
    }];
}

#pragma mark-0x02
- (void)queryGPIOEventToMac:(NSData *)mac deviceType:(NSString *)type
{
    
    NSLog(@"mac=%@",mac);
    [self sendProtocol:[ProtocolData queryGPIOWithdevice:mac deviceType:type]  complete:^(OperationResult *result) {
        
    }];
    
}

#pragma mark-0x0D 433
- (void)set433CloseOrOpenWithDeciceMac:(NSData *)data index:(BOOL)indx adderss:(NSData *)adders type:(NSString *)type timerDic:(NSDictionary *)dic
{
    
    NSLog(@"ip===mac-=%@",data);
    UInt8 buyt = indx ? 0x01 : 0x02;
    
    [self sendProtocol:[ProtocolData onAndOffTo433WithMac:data UDP:NO address:adders cmd:buyt type:type timerDic:dic] complete:nil];
}

#pragma mark-0x03 GPIO
- (void)setGPIOaleamWithDeciceMac:(NSData *)mac index:(BOOL)indx socketType:(BOOL)type  flag:(UInt8)flag Hour:(UInt8)hour min:(UInt8)min numberTaks:(UInt8)task key:(NSData *)key deviceType:(NSString *)Type
{
    
    UInt8 buyt = indx ? 0xff : 0x00;
    
    [self sendProtocol:[ProtocolData timingDataWith:mac flag:flag Hour:hour min:min switchcc:buyt isUDP:type numberTaks:task key:key deviceType:Type]  complete:^(OperationResult *result) {
        
        NSLog(@"%@result",result.resultInfo);
    }];
}

#pragma mark-0x04 GPIO

- (void)getGPIOTimerInfoDeviceMac:(NSData *)mac deviceType:(NSString *)type
{
    
    NSLog(@"pi===mac-=%@",mac);
    
    NSData *remoteKey = [[NSUserDefaults standardUserDefaults] objectForKey:SERVER_KEY];
    
    [self sendProtocol:[ProtocolData gettimingDataWith:mac key:remoteKey deviceType:type]  complete:^(OperationResult *result) {
        NSLog(@"timer%@result",result.resultInfo);
    }];
}

#pragma mark-0x05 GPIO
- (void)deleteGPIOTimerDeviceMac:(NSData *)mac Num:(UInt8)number deviceType:(NSString *)type
{
    [self sendProtocol:[ProtocolData deleteGPIOWithMac:mac Num:number deviceType:type]  complete:^(OperationResult *result) {
        NSLog(@"delete%@result",result.resultInfo);
    }];
}

#pragma mark-
#pragma mark-0x62
- (void)getDeviceInfoToMac:(NSData *)mac deviceType:(NSString *)type
{
    [self sendProtocol:[ProtocolData getDeviceInfoToMac:mac deviceType:type] complete:^(OperationResult *result) {
        
    }];
}

#pragma mark-
#pragma mark-0x65
- (void)firmwareUpgradeToMac:(NSData *)mac WithUrlLen:(UInt8)len WithUrl:(NSData *)urlData key:(NSData *)key deviceType:(NSString *)type
{
    [self sendProtocol:[ProtocolData firmwareUpgradeWithMac:mac WithUrlLen:len WithUrl:urlData WithKey:key deviceType:type] complete:^(OperationResult *result) {
        //        65
    }];
}

#pragma mark-
#pragma mark-0x83 U口
-(void)subscribetoeventsWith:(BOOL)isOpen WithMac:(NSData *)mac with:(UInt8)cmd deviceType:(NSString *)type
{
    UInt8 buyt = isOpen ? 0x01 : 0x00;
    
    [self sendProtocol:[ProtocolData subscribetoevents:mac WithSwitch:buyt WithCmd:cmd deviceType:type] complete:^(OperationResult *result) {
        
    }];
}

#pragma mark-
#pragma mark-0x84 U口上线离线
- (void)queryEquipmentOnlineWithMac:(NSData *)mac deviceType:(NSString *)type
{
    
    [self sendProtocol:[ProtocolData queryEquipmentOnlineWithMac:mac deviceType:type] complete:^(OperationResult *result) {
        NSLog(@"0x84");
    }];
}

//#pragma mark-
//#pragma mark-0x85 U口
//- (void)deviceOnlineWithmac:(NSData *)mac Withopen:(BOOL)isopen
//{
//
//    UInt8 buyt = isopen ? 0x01 : 0x00;
//    [self sendProtocol:[ProtocolData deviceOnlineWithMac:mac withSwitch:buyt] complete:^(OperationResult *result) {
//
//    }];
//
//}

#pragma mark-
#pragma mark-0x86 U口

- (void)getFirwareVersionNumberMAC:(NSData *)mac deviceType:(NSString *)type
{
    [self sendProtocol:[ProtocolData getFirwareVersionNumberWithMac:mac deviceType:type] complete:^(OperationResult *result) {
        
    }];
}

#pragma mark-0x09 防盗
- (void)setAbseceWithDeciceMac:(NSData *)data index:(BOOL)indx FromStateData:(NSData *)from ToData:(NSData *)ToData key:(NSData *)key deviceType:(NSString *)type
{
    NSLog(@"ip、、TCP===mac-=%@",data);
    UInt8 buyt = indx ? 0x80 : 0x00;
    
    [self sendProtocol:[ProtocolData setAbsenceDataWith:data WithFlag:buyt WithFromStateData:from WithToData:ToData key:key deviceType:type] complete:^(OperationResult *result) {
        
        //        NSLog(@"%@=-=-=-=result",result.resultInfo);
    }];
}

#pragma mark-0x0A 防盗查询
- (void)getQueryTheftModeDeciceremoteMac:(NSData *)data key:(NSData *)key deviceType:(NSString *)type
{
    NSLog(@"i..TCP===mac-=%@",data);
    
    [self sendProtocol:[ProtocolData getQueryTheftModeWith:data key:key deviceType:type] complete:^(OperationResult *result) {
        
        //        NSLog(@"%@=-=-=-=result",result.resultInfo);
    }];
}

#pragma mark-0x11 设置倒计时
- (void)setGPIOCountdownWithDeciceMac:(NSData *)mac index:(BOOL)indx socketType:(BOOL)type  flag:(UInt8)flag Hour:(UInt8)hour min:(UInt8)min numberTaks:(UInt8)task key:(NSData *)key deviceType:(NSString *)Type
{
    UInt8 buyt = indx ? 0xff : 0x00;
    
    [self sendProtocol:[ProtocolData countdownDataWith:mac flag:flag Hour:hour min:min switchcc:buyt isUDP:type numberTaks:task key:key deviceType:Type]  complete:^(OperationResult *result) {
        
        NSLog(@"%@result",result.resultInfo);
    }];
}

#pragma mark-0x12 查询倒计时
- (void)getGPIOCountdownDeviceMac:(NSData *)mac deviceType:(NSString *)type orderType:(NSString *)order
{
    NSData *remoteKey = [[NSUserDefaults standardUserDefaults] objectForKey:SERVER_KEY];
    
    [self sendProtocol:[ProtocolData getCountdownDataWith:mac key:remoteKey deviceType:type orderType:order]  complete:^(OperationResult *result) {
        NSLog(@"timer%@result",result.resultInfo);
    }];
    
}

#pragma mark-0x0B 电量查询
- (void)getQueryDeviceWattInfoWithRemoteMac:(NSData *)data key:(NSData *)key
{
    NSLog(@"i..TCP===mac-=%@",data);
    
    [self sendProtocol:[ProtocolData getDeviceWattInfoWithMac:data key:key] complete:^(OperationResult *result) {
        
        //        NSLog(@"%@=-=-=-=result",result.resultInfo);
    }];
}

@end
