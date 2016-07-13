//
//
/**
 * Copyright (c) www.bugull.com
 */
//
//

#import "DeviceManager.h"//
#import "Gogle.h"
#import "Reachability.h"
#import "DeviceManager.h"
#import "ProtocolData.h"//数据组装类
#import "GTMStringEncoding.h"//加密AES
#import "ResponseAnalysis.h"//数据分析类

static DeviceManager * singleton = nil;

@interface DeviceManager() //<RemoteDelegate,LocalDelegate>
{
    UInt16 _index;
    NSData * _remoteKey;
}

@property (readonly,nonatomic) ReachabilityNetworkStatus networkingStatus;

@property (strong,nonatomic) NSMutableArray * operations;

@end

@implementation DeviceManager

+ (DeviceManager *)sharedInstance
{
    //    singleton = [super init];
    if (!singleton)
    {
        singleton = [[super allocWithZone:NULL] init];
        //        singleton =[[self alloc] init];
    }
    return singleton;
}


- (NSMutableDictionary *)getlocalDeviceDictary
{
    if (!_devicesDic) {
        
        _devicesDic = [[NSMutableDictionary alloc] init];
    }
    return _devicesDic;
    
}

- (id)init
{
    self = [super init];
    //    if ([super init]) {
    
    //    }
    
    _devices = [Util getLocalDeviceArray];
    
    _devicesDic = [[NSMutableDictionary alloc] init];
    
    return self;
}

- (void)saveDevices
{
    [Util saveLocalDeviceArray:_devices];
}

- (Device *)deviceFromResponse:(NSData *)response
{
    if (response)
    {
        NSData * mac = [ResponseAnalysis macFromResponse:response];
        for (Device * device in _devices)
        {
            if ([device.mac isEqualToData:mac])
            {
                return device;
            }
        }
    }
    return nil;
}

- (ReachabilityNetworkStatus)networkStatus
{
    return [NetworkUtil networkStatus];
}

- (void)connectionStatusChanged
{
    if (self.networkingStatus != NotReachable && !RemoteServiceInstance.isConnected)
    {
        [RemoteServiceInstance connect];
    }
}

- (void)buildConnection
{
    [LocalServiceInstance connect];
    [RemoteServiceInstance connect];
}

- (void)destroyConnection
{
    //    [RemoteServiceInstance disconnect];
}

- (void)localConnectFinished:(BOOL)succeed msg:(NSString *)msg
{
    if (succeed)
    {
        //        [LocalServiceInstance connectDevices];
    }
}

- (void)localDidConnectDevice:(Device *)device
{
    [RemoteServiceInstance removeDevice:device];
}

- (void)remoteDidConnectDevice:(Device *)device
{
    
}

- (void)localLostConnectionWithDevice:(Device *)device
{
    if ([RemoteServiceInstance isConnected])
    {
        [RemoteServiceInstance connectDevice:device];
    }
}

- (void)localUDPClosed
{
    [RemoteServiceInstance connectDevices];
}

- (void)remoteConnectFinished:(BOOL)succeed key:(NSData *)key
{
    if (succeed)
    {
        _remoteKey = key;
        [RemoteServiceInstance performSelector:@selector(connectDevices) withObject:nil afterDelay:3];
    }
}

- (void)newDevicesDiscovered:(NSArray *)newDevices
{
    [self.devices addObjectsFromArray:newDevices];
    [LocalServiceInstance connectDevices];
    [self.delegate newDevicesDiscovered:newDevices];
    [self saveDevices];
    //    for (Device * device in newDevices)
    //    {
    //        [RemoteServiceInstance subscribeDevice:YES device:device];
    //    }
}

- (void)deleteDevice:(Device *)device
{
    if (device)
    {
        [LocalServiceInstance deleteDevice:device];
        [RemoteServiceInstance removeDevice:device];
        [device setObserver:nil];
        [device disConnect];
        [_devices removeObject:device];
        [self saveDevices];
    }
}

- (void)tryConnectDevice:(Device *)device
{
    if ([LocalServiceInstance isConnected])
    {
        [LocalServiceInstance connectDevice:device];
    }
    else
    {
        [LocalServiceInstance connect];
        if (![RemoteServiceInstance isConnected])
        {
            [RemoteServiceInstance connect];
        }
    }
}

#pragma mark-界限
- (void)remoteDisconnected:(NSString *)msg
{
    //    [LocalServiceInstance connectDevices];
}
//GPIO口0x02 查询 GPIO 状态
- (SocketOperation *)queryAllGPIO:(Device *)device complete:(Complete)complete
{
    if ([LocalServiceInstance isConnectedDevice:device])
    {
        [LocalServiceInstance sendProtocol:[ProtocolData queryGPIOWithSockets:device.socketArray device:device index:NewIndex key:device.key] host:device.host complete:complete];
    }
    else if ([RemoteServiceInstance isConnectedDevice:device])
    {
        [RemoteServiceInstance sendProtocol:[ProtocolData queryGPIOWithSockets:device.socketArray device:device index:NewIndex key:_remoteKey] complete:complete];
    }
    return nil;
}
//当设备 GPIO 的状态发生改变时,Device 会主动上报此事件给用户
- (SocketOperation *)subScribeAllGPIO:(BOOL)sub device:(Device *)device complete:(Complete)complete
{
    if ([RemoteServiceInstance isConnectedDevice:device])
    {
        //        [RemoteServiceInstance sendProtocol:[ProtocolData subscribeGPIO:sub device:device index:NewIndex key:_remoteKey] complete:complete];
    }
    return nil;
}
//0x01 设置 GPIO 状态
- (SocketOperation *)setGPIO:(Device *)device socket:(PanelSocket *)socket on:(BOOL)on complete:(Complete)complete
{
    //    UInt8 duty = on ? 0xff : 0x00;
    if ([LocalServiceInstance isConnectedDevice:device])
    {
        //        return [LocalServiceInstance sendProtocol:[ProtocolData setGPIOWithPinNum:socket.pinNum duty:duty  device:device index:NewIndex key:device.key] host:device.host complete:complete];
    }
    else if ([RemoteServiceInstance isConnectedDevice:device])
    {
        //        return [RemoteServiceInstance sendProtocol:[ProtocolData setGPIOWithPinNum:socket.pinNum duty:duty device:device index:NewIndex key:_remoteKey] complete:complete];
    }
    return nil;
}
//设备锁定
- (SocketOperation *)lockOrUnlockDevice:(NSData *)data complete:(Complete)complete withType:(BOOL)type
{
    //    if ([LocalServiceInstance isConnectedDevice:device])
    //    {
    //    return [LocalServiceInstance sendProtocol:[ProtocolData lockOrUnlockDevice:data index:NewIndex key:nil lock:type] host:@"192.168.199.234" complete:complete];
    //    }
    //    else if ([RemoteServiceInstance isConnectedDevice:device])
    //    {
    //        return [RemoteServiceInstance sendProtocol:[ProtocolData lockOrUnlockDevice:device index:NewIndex key:_remoteKey lock:type] complete:complete];
    //    }
    return nil;
}
//设备离线上线事件

- (BOOL)processResult:(OperationResult *)result
{
    UInt8 protocolNo = [ResponseAnalysis protocolNoFromResponse:result.responseData];
    Device * device = [self deviceFromResponse:result.responseData];
    if (protocolNo == 0x85)
    {
        UInt8 status = [[result.resultInfo objectForKey:@"status"] intValue];
        if (status == 0x01)
        {
            [device didConnect:result.responseData];
        }
        else
        {
            [device disConnect];
        }
        [RemoteServiceInstance refreshConnectStatus:device];
    }
    else if (protocolNo == 0x06 || protocolNo == 0x02)
    {
        NSArray * pinArray = [result.resultInfo objectForKey:@"pinArray"];
        [device updateGPIOWithPinArray:pinArray];
    }
    else if (protocolNo == 0x01)
    {
        NSData * pin = [result.resultInfo objectForKey:@"pin"];
        [device updatePin:pin];
    }
    else if (protocolNo == 0x24)
    {
        if ([result resultCodeOK])
        {
            device.locked = !device.locked;
        }
    }
    return protocolNo == 0x85 || protocolNo == 0x06 || protocolNo == 0x07;
    return YES;
}

- (UInt16)getIndex
{
    return _index;
}

- (UInt16)newIndex
{
    return _index++;
}

//- (void)newDevicesDiscovered:(NSArray *)newDevices
//{
//
//    [self.devices addObjectsFromArray:newDevices];
//
////    [LocalServiceInstance connectDevices];
//    [self.delegate newDevicesDiscovered:newDevices];
//}


#pragma mark-
#pragma mark-0x0D 433

- (void)set433TodeviceWithMacString:(NSData *)mac WithHost:(NSString *)host  Open:(BOOL)onOrOff withArc4Address:(NSString *)address  deviceType:(NSString *)type With:(NSString *)localString timerDic:(NSDictionary *)dic
{
    
    NSData * addressData = [[Util getUtitObject] macStrTData:address];
    
    if ([DeviceManagerInstance networkStatus] == ReachableViaWiFi && [localString isEqualToString:@"1"]) {
        
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0),^{
        
//            for (int i = 0; i < 2; i ++) {
        
                [LocalServiceInstance set433CloseOrOpenWithDeciceMac:mac index:onOrOff host:host adderss:addressData type:type timerDic:dic];
                
//                [NSThread sleepForTimeInterval:.1f];
//            }
//        });
        
    } else {
        
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^ {
        
//            for (int i = 0 ; i < 2; i++) {
        
                [RemoteServiceInstance  set433CloseOrOpenWithDeciceMac:mac index:onOrOff adderss:addressData type:type timerDic:dic];
                
//                [NSThread sleepForTimeInterval:.1f];
//            }
//        });
    }
}

- (void)setsliderTodeviceid:(NSData *)mac WithHost:(NSString *)host Open:(BOOL)onOrOff withArc4Address:(NSString *)address  deviceType:(BOOL)isDimmerValue  value:(UInt8)values  With:(NSString *)localString
{
    
    //    NSData *addressData = [address dataUsingEncoding:NSUTF8StringEncoding];
//    NSData * addressData = [[Util getUtitObject] macStrTData:address];
    
    if ([DeviceManagerInstance networkStatus] == ReachableViaWiFi && [localString isEqualToString:@"1"])
    {
        
        //        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0),^{
        for (int i = 0; i < 3; i ++) {
            
            //        NSLog(@"value=%d",values);
//            [LocalServiceInstance set433CloseOrOpenWithDeciceMac:mac index:onOrOff host:host adderss:addressData type:isDimmerValue value:values];
            
            [NSThread sleepForTimeInterval:0.005];
        }
        //
        //
        //        });
        
        
    }
    else
    {
        //        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0),^{
        //            for (int i = 0; i < 6; i ++) {
        
//        [RemoteServiceInstance  set433CloseOrOpenWithDeciceMac:mac index:onOrOff adderss:addressData type:isDimmerValue value:values];
        
        //                [NSThread sleepForTimeInterval:0.05];
        //            }
        
        
        //        });
        
        
        
        
    }
    
}

#pragma mark-
#pragma mark-0x04 GPIO
- (void)getTimeringWith:(NSData *)mac inUDPHost:(NSString *)host key:(NSData *)key With:(NSString *)localString deviceType:(NSString *)type
{
    if ([DeviceManagerInstance networkStatus] == ReachableViaWiFi && [localString isEqualToString:@"1"])
    {
        NSLog(@"=== %@ %@ %@ %@",mac, host, key, type);
        
        [LocalServiceInstance getGPIOTimerInfoDeviceMac:mac host:host key:key deviceType:type];
    }
    else
    {
        [RemoteServiceInstance getGPIOTimerInfoDeviceMac:mac deviceType:type];
    }
}

#pragma mark-0x02
- (void)queryGPIOEventToMacDevice:(NSData *)mac withHost:(NSString *)host withloaclContent:(NSString *)localContent deviceType:(NSString *)type
{
    if ([DeviceManagerInstance networkStatus] == ReachableViaWiFi && [localContent isEqualToString:@"1"])
    {
        [LocalServiceInstance queryGPIOEventToMac:mac withhost:host deviceType:type];
        
        [NSThread sleepForTimeInterval:0.01];
    }
    else
    {
        
        [RemoteServiceInstance queryGPIOEventToMac:mac deviceType:type];
    }
}


#pragma mark-
#pragma mark-0x03 GPIO

- (void)setTimeringAlermWithMacString:(NSData *)mac Withhost:(NSString *)host flag:(UInt8)flag Hour:(UInt8)hour min:(UInt8)min TaskCount:(UInt8)task Switch:(BOOL)ON_OFF key:(NSData *)key  With:(NSString *)localString deviceType:(NSString *)type
{
    if ([DeviceManagerInstance networkStatus] == ReachableViaWiFi && [localString isEqualToString:@"1"])
    {
        [LocalServiceInstance setGPIOaleamWithDeciceMac:mac index:ON_OFF host:host socketType:YES flag:flag Hour:hour min:min numberTaks:task key:key deviceType:type];
        
    } else {
        
        NSData *remoteKey = [[NSUserDefaults standardUserDefaults] objectForKey:SERVER_KEY];
        
        [RemoteServiceInstance  setGPIOaleamWithDeciceMac:mac index:ON_OFF socketType:NO flag:flag Hour:hour min:min numberTaks:task key:remoteKey deviceType:type];
    }
}

#pragma mark-
#pragma mark-0x05 GPIO

- (void)deleteDeviceTimeingWith:(NSData *)mac Withhost:(NSString *)host  InToNum:(UInt8)num With:(NSString *)localContent deviceType:(NSString *)type
{
    if ([DeviceManagerInstance networkStatus] == ReachableViaWiFi && [localContent isEqualToString:@"1"])
    {
        
        [LocalServiceInstance deleteGPIOTimerDeviceMac:mac host:host Num:num deviceType:type];
        
        
    }else{
        [RemoteServiceInstance deleteGPIOTimerDeviceMac:mac Num:num deviceType:type];
        
    }
    
    
}

#pragma mark-
#pragma mark-0x09 防盗

- (void)absenceToDeviceWith:(NSData *)mac Withhost:(NSString *)host  ToOpen:(BOOL)open WithState:(NSData *)from WithTodate:(NSData *)toDate key:(NSData *)key With:(NSString *)localContent deviceType:(NSString *)type

{
    if ([DeviceManagerInstance networkStatus] == ReachableViaWiFi && [localContent isEqualToString:@"1"])
    {
        [LocalServiceInstance setAbseceWithDeciceMac:mac index:open host:host FromStateData:from ToData:toDate key:key deviceType:type];
        
    }else{
        NSData *remoteKey = [[NSUserDefaults standardUserDefaults] objectForKey:SERVER_KEY];
        
        [RemoteServiceInstance setAbseceWithDeciceMac:mac index:open FromStateData:from ToData:toDate key:remoteKey deviceType:type];
    }
}

#pragma mark-0x11 设置倒计时
- (void)setCountdownWithMacString:(NSData *)mac Withhost:(NSString *)host flag:(UInt8)flag Hour:(UInt8)hour min:(UInt8)min TaskCount:(UInt8)task Switch:(BOOL)ON_OFF key:(NSData *)key  With:(NSString *)localString deviceType:(NSString *)type
{
    if ([DeviceManagerInstance networkStatus] == ReachableViaWiFi && [localString isEqualToString:@"1"])
    {
        for (int i = 0; i < 2; i++) {
            [LocalServiceInstance setGPIOCountdownWithDeciceMac:mac index:ON_OFF host:host socketType:YES flag:flag Hour:hour min:min numberTaks:task key:key deviceType:type];
        }
        
    }else {
        
        NSData *remoteKey = [[NSUserDefaults standardUserDefaults] objectForKey:SERVER_KEY];
        
        for (int i = 0; i < 3; i++) {
            [RemoteServiceInstance  setGPIOCountdownWithDeciceMac:mac index:ON_OFF socketType:NO flag:flag Hour:hour min:min numberTaks:task key:remoteKey deviceType:type];
        }
    }
}

#pragma mark-0x12 查询倒计时
- (void)getCountdownWith:(NSData *)mac inUDPHost:(NSString *)host key:(NSData *)key With:(NSString *)localString deviceType:(NSString *)type orderType:(NSString *)order
{
    
    if ([DeviceManagerInstance networkStatus] == ReachableViaWiFi && [localString isEqualToString:@"1"])
    {        
        [LocalServiceInstance getGPIOCountdownDeviceMac:mac host:host key:key deviceType:type orderType:order];
    }
    else
    {
        for (int i = 0; i < 2; i++) {
            [RemoteServiceInstance getGPIOCountdownDeviceMac:mac deviceType:type orderType:order];
        }
    }
}


#pragma mark-
#pragma mark-0x0A 防盗查询

- (void)getQueryTheftModeDeviceMToDeviceWith:(NSData *)mac Withhost:(NSString *)host key:(NSData *)key With:(NSString *)localContent deviceType:(NSString *)type
{
    if ([DeviceManagerInstance networkStatus] == ReachableViaWiFi && [localContent isEqualToString:@"1"])
    {
        
        [LocalServiceInstance getQueryTheftModeDeciceLocalMac:mac host:host key:key deviceType:type];
        
    }else{
        
        NSData *remoteKey = [[NSUserDefaults standardUserDefaults] objectForKey:SERVER_KEY];
        
        [RemoteServiceInstance getQueryTheftModeDeciceremoteMac :mac key:remoteKey deviceType:type];
    }
}


#pragma mark-0x0B 电量查询
- (void)getQueryDeviceWattInfoWith:(NSData *)mac Withhost:(NSString *)host key:(NSData *)key With:(NSString *)localContent
{
    if ([DeviceManagerInstance networkStatus] == ReachableViaWiFi && [localContent isEqualToString:@"1"])
    {
        
        [LocalServiceInstance getQueryDeviceWattInfoWithLocalMac:mac host:host key:key];
        
    }else{
        
        NSData *remoteKey = [[NSUserDefaults standardUserDefaults] objectForKey:SERVER_KEY];
        
        [RemoteServiceInstance getQueryDeviceWattInfoWithRemoteMac:mac key:remoteKey];
    }
}

#pragma mark-
#pragma mark-0x62

- (void)getDeviceInfoToMac:(NSData *)mac With:(NSString *)localContent WIthHost:(NSString *)host deviceType:(NSString *)type

{
    if ([DeviceManagerInstance networkStatus] == ReachableViaWiFi && [localContent isEqualToString:@"1"])
    {
        
        [LocalServiceInstance getDeviceInfoToMac:mac WithHost:host deviceType:type];
        
    }else{
        
        
        [RemoteServiceInstance getDeviceInfoToMac:mac deviceType:type];
        
    }
    
    
    
}

#pragma mark-
#pragma mark-0x65

- (void)firmwareUpgradeToDeviceMessageMac:(NSData *)mac WIthHost:(NSString *)host WithUrlLen:(UInt8)len WithUrl:(NSData *)urlData key:(NSData *)key With:(NSString *)localContent deviceType:(NSString *)type

{
    
    if ([DeviceManagerInstance networkStatus] == ReachableViaWiFi && [localContent isEqualToString:@"1"])
    {
        
        [LocalServiceInstance firmwareUpgradeToMac:mac WithHost:host WithUrlLen:len WithUrl:urlData key:key deviceType:type];
        
    } else {
        
        NSData *remoteKey = [[NSUserDefaults standardUserDefaults] objectForKey:SERVER_KEY];
        
        [RemoteServiceInstance firmwareUpgradeToMac:mac WithUrlLen:len WithUrl:urlData key:remoteKey deviceType:type];
        
    }
    
    
}

@end
