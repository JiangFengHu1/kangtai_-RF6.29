//
//
/**
 * Copyright (c) www.bugull.com
 */
//
//


#import "LocalService.h"
#import "DeviceManager.h"
#import "GCDAsyncUdpSocket.h"
#import "ProtocolData.h"
//#import "TianLiUtil.h"
#import "ResponseAnalysis.h"
#import "Crypt.h"
#import "Gogle.h"

@interface LocalService()<GCDAsyncUdpSocketDelegate>
{
    GCDAsyncUdpSocket * _udpSocket;
    GCDAsyncUdpSocket * _currentSocket;
    
    NSString * _broadIP;
    NSString * _localIP;
    
    BOOL _connecting;
    NSMutableDictionary * _keyDict;
    
    
    NSMutableDictionary * _dictHert;
    
    BOOL _connected;
}

@property (assign,nonatomic) UInt16 interval;


@property (assign,nonatomic) int  localCount;
@property (strong,nonatomic) NSMutableArray * operations;

@property (strong,nonatomic) NSMutableArray * connectedDevices;

@property (weak,nonatomic) id delegate;

@property (strong,nonatomic) NSMutableDictionary *infoDic;

@property (strong,nonatomic) NSTimer *timer_info;

@property (strong,nonatomic) NSTimer *time_lines;

@property (strong,nonatomic) NSTimer *timer_InterVal;

@property (strong,nonatomic) id observer;//对象

@property (strong,nonatomic) NSTimer * discoveryTimer;//0x23定时器


@end

static LocalService * singleton = nil;

@implementation LocalService

+ (LocalService *)sharedInstance
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
    
    self.interval  = 0.1;
    self.localCount = 0;
    _keyDict = [NSMutableDictionary dictionary];
    _dictHert = [NSMutableDictionary dictionary];
    
    _operations = [NSMutableArray array];
    _connectedDevices = [NSMutableArray array];
    _delegate = DeviceManagerInstance;
    self.deviceArray = [NSMutableArray arrayWithCapacity:0];
    self.infoDic = [NSMutableDictionary dictionary];
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(localinterval:) name:@"local_interval" object:nil];
    
    //    [self devicelinseOn];
    return self;
}
- (void)localinterval:(NSNotification *)notification
{
    
    NSDictionary  *dict =[notification object];
    
    NSData *mac = [dict objectForKey:@"mac_l"];
    NSString *macKey = [Crypt hexEncode:mac];
    
    Device *device = [[DeviceManagerInstance getlocalDeviceDictary] objectForKey:macKey];
    if (device == nil) {
        return;
    }
    device.interval = [[dict objectForKey:@"interval"] intValue];
    if (device != nil) {
        [[DeviceManagerInstance getlocalDeviceDictary] setObject:device forKey:macKey];
        [self startHeartBeatWith:device];
    }
}

- (void)devicelinseOn
{
    
    self.time_lines = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(reloadTableToWifiPage) userInfo:nil repeats:YES];
}

- (void)reloadTableToWifiPage
{
    if (self.localCount>=45) {
        
        self.localCount = 0;
    }
    
    self.localCount ++;
}

//changeCountGetDeviceState:
- (void)connect
{
    _udpSocket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    NSError * error = nil;
    if (iOS_version > 5.1) {
        
        [_udpSocket enableBroadcast:YES error:&error];
        
    }
    if (![_udpSocket bindToPort:DevicePort error:&error])
    {
        [_delegate localConnectFinished:NO msg:[NSString stringWithFormat:@"LocalSocket Error binding: %@", [error localizedDescription]]];
    }
    else if (![_udpSocket enableBroadcast:YES error:&error])
    {
        [_delegate localConnectFinished:NO msg:[NSString stringWithFormat:@"LocalSocket Error enableBroadcast: %@", [error localizedDescription]]];
    }
    else if (![_udpSocket beginReceiving:&error])
    {
        [_delegate localConnectFinished:NO msg:[NSString stringWithFormat:@"LocalSocket Error receiving: %@", [error localizedDescription]]];
    }
    else
    {
        [_delegate localConnectFinished:YES msg:nil];
        _connected = YES;
    }
}

- (BOOL)isConnected
{
    return _connected;
}

- (void)udpSocketDidClose:(GCDAsyncUdpSocket *)sock withError:(NSError *)error
{
    [self disconnect];
}

- (void)disconnect
{
    _connected = NO;

    _udpSocket.delegate = nil;
    [_udpSocket close];
    _udpSocket = nil;
    
}

- (void)lostConnectWithDevice:(Device *)device
{
    [device disConnect];
    [_keyDict removeObjectForKey:device.mac];
    [_connectedDevices removeObject:device];
    [self.delegate localLostConnectionWithDevice:device];
}

- (Device *)deviceFromMac:(NSData *)mac
{
    for (Device * device in DeviceManagerInstance.devices)
    {
        if ([device.mac isEqualToData:mac])
        {
            return device;
        }
    }
    return nil;
}

- (BOOL)isConnectedDevice:(Device *)device
{
    return [_connectedDevices containsObject:device] && device.isConnected;
}


- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data fromAddress:(NSData *)address withFilterContext:(id)filterContext
{
    if (data.length < 10) {
        return;
    }
    // 过滤外界设备的回复指令
    NSString *macStr = [Crypt hexEncode:[data subdataWithRange:NSMakeRange(2, 6)]];

    // 0x23命令的回复 如果加密 长度是57 没有加密的话 长度是44
    if (![macStr isEqualToString:@"FFFFFFFFFFFF"] && data.length != ([ResponseAnalysis isResponseEncrypt:data] ? 57 : 44)) {
        
        NSMutableArray *arr = [DataBase selectDataFromDataBaseWithMac:macStr];
        
        if (arr == nil || arr.count == 0) {
            return;
        }
    }
    
    
    NSLog(@"接收到的指令 data ===== %@", data);
    
    
    if (sock == _currentSocket)
    {
        
        
    }else{
        
        if (data.length >= 17)
        {
            if ([ResponseAnalysis isResponseEncrypt:data])
            {
                NSData * mac = [ResponseAnalysis macFromResponse:data];
                NSData * key = [_keyDict objectForKey:mac];
                if (key == nil)
                {
                    NSMutableData * responseData = [NSMutableData dataWithData:[data subdataWithRange:NSMakeRange(0, 9)]];
                    UInt8 dataLen = ((UInt8 *)[data bytes])[8];
                    [responseData appendData:[Crypt decryptData:[data subdataWithRange:NSMakeRange(9, dataLen)] key:key]];
                    
                    UInt8 protocolNo = [ResponseAnalysis protocolNoFromResponse:responseData];
                    if (protocolNo == 0x23)
                    {
                        [self discoveryInfo:responseData];
                    }
                    if (protocolNo == 0x61) {
                        Device *device = [[DeviceManagerInstance getlocalDeviceDictary] objectForKey:macStr];
                        device.heartBeatNumber = 0;
                        [[DeviceManagerInstance getlocalDeviceDictary] setObject:device forKey:macStr];
                    }
                    [self didReceiveResponse:responseData];
                }else{
                    NSMutableData * responseData = [NSMutableData dataWithData:[data subdataWithRange:NSMakeRange(0, 9)]];
                    UInt8 dataLen = ((UInt8 *)[data bytes])[8];
                    [responseData appendData:[Crypt decryptData:[data subdataWithRange:NSMakeRange(9, dataLen)] key:key]];
                    
                    
                    [self didReceiveResponse:responseData];
                    
                }
                
            }
            else//没加密
            {
                [self didReceiveResponse:data];
                
            }
        }
    }
    //    });
}

/*****************23*****/

- (NSDictionary *)discoveryInfo:(NSData *)response
{
    
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:0];
    
    NSData * tempMac = [response subdataWithRange:NSMakeRange(2, 6)];
    NSData *deviceType = [response subdataWithRange:NSMakeRange(15, 1)];
    NSString *deviceTypeStr = [[NSString stringWithFormat:@"%@",deviceType] substringWithRange:NSMakeRange(1, 2)];
    
    
    if (response.length < 27)
    {
        return nil;
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([[Util getAppDelegate].connect isEqualToString: @"2"]) {
            [Util getAppDelegate].connect = @"1";
            [MMProgressHUD dismiss];
        }
    });
    
    NSMutableArray *tempArray =  (NSMutableArray *)[[DeviceManagerInstance getlocalDeviceDictary] allKeys];
    
    UInt8 * bytes = (UInt8 *)[response bytes];
    NSMutableString * host = [[NSMutableString alloc] init];
    for (int i = 17; i < 21; i++)
    {
        UInt8 no = ((UInt8 *)response.bytes)[i];
        [host appendFormat:@"%d.",no];
    }
    
    NSString *tempHost = [host substringWithRange:NSMakeRange(0, host.length-1)];
    UInt8 keyLen = bytes[27];
    NSData * key = [response subdataWithRange:NSMakeRange(28, keyLen)];
    
    if (tempArray.count > 0) {
        
        for (int i = 0; i < tempArray.count; i ++) {
            
            NSString  *macstr = [tempArray objectAtIndex:i];
            
            
            NSData *mac=  [Crypt decodeHex:macstr];
            [array addObject:mac];
        }
        
        NSMutableArray *arr = [DataBase selectDataFromDataBaseWithMac:[Crypt hexEncode:tempMac]];
        if ([array containsObject:tempMac] && [[DeviceManagerInstance getlocalDeviceDictary] objectForKey:[Crypt hexEncode:tempMac]] != nil && arr.count != 0) {
            // 找到相同对象的索引值
            NSInteger ind=  [array indexOfObject:tempMac];
            NSString *macKey = [tempArray objectAtIndex:ind];
            
            Device *devic = [[DeviceManagerInstance getlocalDeviceDictary] objectForKey:macKey];
            if (devic == nil) {
                return nil;
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:@"localState" object:nil];
            devic.mac = tempMac;
            devic.host = tempHost;
            devic.key = key;
            devic.localContent = @"1";
            devic.remoteContent = @"0";
            devic.hver = @"1";
            devic.heartBeatNumber = 0;
            
            [[DeviceManagerInstance getlocalDeviceDictary] setObject:devic forKey:macKey];

            [LocalServiceInstance queryGPIOEventToMac:tempMac withhost:tempHost deviceType:deviceTypeStr];

            if (devic.deviceRespons == NO) {
                
                devic.deviceRespons = YES;
                [self startHeartBeatWith:devic];
                
            }
            [NSThread sleepForTimeInterval:0.1];
            if (devic != nil) {
                [[DeviceManagerInstance getlocalDeviceDictary] setObject:devic forKey:macKey];
            }
            //            NSLog(@"dic=%@==key=%@===data=%@",@{@"host":tempHost,
            //                              @"mac":tempMac,
            //                              @"keyLen":[NSString stringWithFormat:@"%d",keyLen],
            //                              @"key":key},[NSString stringWithUTF8String:key.bytes],[[NSString stringWithUTF8String:key.bytes] dataUsingEncoding:NSUTF8StringEncoding]);
            return @{@"host":tempHost,
                     @"mac":tempMac,
                     @"keyLen":[NSString stringWithFormat:@"%d",keyLen],
                     @"key":key};
        }else{
            
            [self insterInTOFMDBWithMacString:tempMac withHost:tempHost Key:[[NSString alloc] initWithData:key encoding:NSUTF8StringEncoding] WithData:key withDeviceType:deviceTypeStr];
        }
        
    } else {
        
        [self insterInTOFMDBWithMacString:tempMac withHost:tempHost Key:[[NSString alloc] initWithData:key encoding:NSUTF8StringEncoding] WithData:key withDeviceType:deviceTypeStr];
    }
    
    
    return @{@"host":tempHost,
             @"mac":tempMac,
             @"keyLen":[NSString stringWithFormat:@"%d",keyLen],
             @"key":key};
}

- (void)insterInTOFMDBWithMacString:(NSData *)macDat withHost:(NSString *)host Key:(NSString *)key WithData:(NSData *)dataKey withDeviceType:(NSString *)deviceType
{
    NSLog(@"=== %@ %@ %@ %@",macDat, host, key, dataKey);
    
    Device * device = [[Device alloc] init];
    
    int orderNumber = 0;
    NSMutableArray *tempArray = [DataBase ascWithRFtableINOrderNumber];
    for (int i = 0; i < tempArray.count; i++) {
        Device *model = tempArray[i];
        orderNumber = MAX(orderNumber, (int)model.orderNumber);
    }
    
    NSString *macStr = [[Crypt hexEncode:macDat] uppercaseStringWithLocale:[NSLocale currentLocale]];
    NSString *markStr = [macStr substringWithRange:NSMakeRange(0, 6)];
    BOOL isHF = [markStr isEqualToString:@"ACCF23"];
    device.macString = macStr;
    device.orderNumber = orderNumber + 1;
    device.codeString = isHF ? @"CA" : @"CB";
    device.authCodeString = isHF ? @"FD66" : @"92DA";
    device.image = @"0.png";
    device.name = @"kangtai";
    device.deviceType = deviceType;

    // 添加设备到数据库
    [DataBase insertIntoDataBase:device];
    
    device.heartBeatNumber = 0;
    device.localContent = @"1";
    device.remoteContent = @"0";
    device.LockType = @"open";
    device.alarm = @"off";
    device.interval = 0;
    device.host = host;
    device.hver = @"1";
    device.keyString = key;
    device.deviceRespons = NO;
    device.key = dataKey;
    device.mac = [Crypt decodeHex:device.macString];
    
    // 添加设备到单例字典
    [[DeviceManagerInstance  getlocalDeviceDictary] setObject:device  forKey:device.macString];
    if (device.deviceRespons == NO) {
        device.deviceRespons = YES;
        
        [self startHeartBeatWith:device];
        
        [[DeviceManagerInstance  getlocalDeviceDictary] setObject:device  forKey:device.macString];
    }
    [RemoteServiceInstance subscribetoeventsWith:YES WithMac:device.mac with:0x85 deviceType:deviceType];
    [self getDeviceInfoToMac:device.mac WithHost:device.host deviceType:device.deviceType];
    NSMutableArray *tempArr = [[NSMutableArray alloc] initWithCapacity:0];
    [tempArr removeAllObjects];
    [tempArr addObject:deviceType];
    [tempArr addObject:device.mac];
    [self performSelector:@selector(sendGPIOEventToServer:) withObject:tempArr afterDelay:0.5];
    
    [self editWifiDeviceSendToServer:device];
}

- (void)sendGPIOEventToServer:(NSMutableArray *)arr
{
    NSData *mac = arr[1];
    NSString *type = arr[0];
    [RemoteServiceInstance subscribetoeventsWith:YES WithMac:mac with:0x06 deviceType:type];
    
}

- (void)editWifiDeviceSendToServer:(Device *)devices_
{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *tempString = [Util getPassWordWithmd5:[defaults objectForKey:KEY_PASSWORD]];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:AccessKey forKey:@"accessKey"];
    [dict setValue:[defaults objectForKey:KEY_USERMODEL] forKey:@"username"];
    [dict setValue:tempString forKey:@"password"];
    [dict setValue:[devices_.macString uppercaseStringWithLocale:[NSLocale currentLocale]]  forKey:@"macAddress"];
    [dict setValue:devices_.name forKey:@"deviceName"];
    [dict setValue:devices_.codeString  forKey:@"companyCode"];
    [dict setValue:devices_.deviceType forKey:@"deviceType"];
    [dict setValue:devices_.authCodeString forKey:@"authCode"];
    [dict setValue:devices_.image forKey:@"imageName"];
    
    [dict setValue:[NSString stringWithFormat:@"%ld",(long)devices_.orderNumber] forKey:@"orderNumber"];
    NSString *timeSp = [NSString stringWithFormat:@"%f", (double)[[NSDate date] timeIntervalSince1970]*1000];
    
    NSArray *temp =   [timeSp componentsSeparatedByString:@"."];
    [dict setValue:[temp objectAtIndex:0] forKey:@"lastOperation"];
    
    
    [HTTPService POSTHttpToServerWith:EditWifiURL WithParameters:dict   success:^(NSDictionary *dic) {
        
        NSString * success = [dic objectForKey:@"success"];
        
        if ([success boolValue] == true) {
            NSLog(@"成功");
            
            
        }
        if ([success boolValue] == false) {
            
//            [Util showAlertWithTitle:NSLocalizedString(@"Tips", nil) msg:[dic objectForKey:@"msg"]];
            
        }
        
        
    } error:^(NSError *error) {
        //        [[Util getUtitObject] HUDHide];
        
//        [Util showAlertWithTitle:NSLocalizedString(@"Tips", nil) msg:@"Link Timeout"];
        
    }];
    
    
    
}

/*****************23*****/

- (void)didReceiveResponse:(NSData *)responseData
{
    UInt8 protocolNo = [ResponseAnalysis protocolNoFromResponse:responseData];
    if (protocolNo == 0x23)
    {
        [self discoveryInfo:responseData];
    }
    
    OperationResult * result = [OperationResult resultWithResponse:responseData Withserver:@"local"];
    
    
    if ([[result.resultInfo allKeys] containsObject:@"interval"])
    {
        
        NSString *str = [result.resultInfo objectForKey:@"interval"];
        //        NSData *macData = [result.resultInfo objectForKey:@"mac_l"];
        
        self.interval = [str intValue];
        //        NSString *macString = [Crypt hexEncode:macData];
        
        //        NSString *tString = [NSString stringWithFormat:@"%@",macData];
        
        //        NSString *tempMacString =  [tString stringByReplacingOccurrencesOfString:@" " withString:@""];
        //       tempMacString = [[tempMacString substringWithRange:NSMakeRange(1, 12)] uppercaseStringWithLocale:[NSLocale currentLocale]];
        
        //
        //        if (temp.count >0) {
        //
        //        Device *decive = [temp objectAtIndex:0];
        //        decive.interval = [str intValue];;
        //
        //
        //
        
        
        
        
        
        //        }
        
        
    }
    
}


- (void)changeCountGetDeviceState:(NSTimer *)timer
{
    NSLog(@"timeStop");
    //    [self.timer_InterVal invalidate];
    Device *device = timer.userInfo;
    
    [device.heartTimer invalidate];
    
}
#pragma mark-----23 Ad
// 无计量功能
- (void)updataIPWith23_withMac:(NSData *)mac
{
    [self sendProtocol:[ProtocolData UpdataIPTodeviceWithMac:mac] host:BroadcastHost complete:^(OperationResult *result) {
    }];
}
- (void)addDeviceToFMDBWithisAdd:(BOOL)isAdd WithMac:(NSData *)mac
{
    if (isAdd) {
        [self sendProtocol:[ProtocolData addDeviceWithFF_FFTolocalisUpData:isAdd WithMac:mac key:nil companyCode:0] host:BroadcastHost complete:^(OperationResult *result) {
            
        }];
    } else {
        [self sendProtocol:[ProtocolData addDeviceWithFF_FFTolocalisUpData:isAdd WithMac:mac key:nil companyCode:0xCA] host:BroadcastHost complete:^(OperationResult *result) {
            
        }];
//        for (int i = 0; i < 3; i++) {
            [self sendProtocol:[ProtocolData addDeviceWithFF_FFTolocalisUpData:isAdd WithMac:mac key:nil companyCode:0xCB] host:BroadcastHost complete:^(OperationResult *result) {
                
            }];
//        }
    }
}

// 有计量功能
- (void)updataIPWith23_Energy_withMac:(NSData *)mac
{
    [self sendProtocol:[ProtocolData UpdataIPToEnergyDeviceWithMac:mac] host:BroadcastHost complete:^(OperationResult *result) {
        
    }];
    
}

- (void)addEnergyDeviceToFMDBWithisAdd:(BOOL)isAdd WithMac:(NSData *)mac
{
    if (isAdd) {
        [self sendProtocol:[ProtocolData addEnergyDeviceWithFF_FFTolocalisUpData:isAdd WithMac:mac key:nil companyCode:0] host:BroadcastHost complete:^(OperationResult *result) {
            
        }];
    } else {
        [self sendProtocol:[ProtocolData addEnergyDeviceWithFF_FFTolocalisUpData:isAdd WithMac:mac key:nil companyCode:0xCA] host:BroadcastHost complete:^(OperationResult *result) {
            
        }];
//        for (int i = 0; i < 3; i++) {
            [self sendProtocol:[ProtocolData addEnergyDeviceWithFF_FFTolocalisUpData:isAdd WithMac:mac key:nil companyCode:0xCB] host:BroadcastHost complete:^(OperationResult *result) {
                
            }];

//        }
    }
}

// RF功能
- (void)updataIPWith23_RF_withMac:(NSData *)mac
{
    [self sendProtocol:[ProtocolData UpdataIPToRFDeviceWithMac:mac] host:BroadcastHost complete:^(OperationResult *result) {
        
    }];
    
}

- (void)addRFDeviceToFMDBWithisAdd:(BOOL)isAdd WithMac:(NSData *)mac
{
    if (isAdd) {
        [self sendProtocol:[ProtocolData addRFDeviceWithFF_FFTolocalisUpData:isAdd WithMac:mac key:nil companyCode:0] host:BroadcastHost complete:^(OperationResult *result) {
            
        }];
    } else  {
        [self sendProtocol:[ProtocolData addRFDeviceWithFF_FFTolocalisUpData:isAdd WithMac:mac key:nil companyCode:0xCA] host:BroadcastHost complete:^(OperationResult *result) {
            
        }];
        for (int i = 0; i < 3; i++) {
            [self sendProtocol:[ProtocolData addRFDeviceWithFF_FFTolocalisUpData:isAdd WithMac:mac key:nil companyCode:0xCB] host:BroadcastHost complete:^(OperationResult *result) {
                
            }];
        }
    }
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


- (SocketOperation *)sendProtocol:(NSData *)protocol host:(NSString *)host complete:(Complete)complete
{
    NSLog(@"local request:%@;;;;;;%@", protocol,host);
    
    SocketOperation * operation = [SocketOperation operationWithIndex:CurrentIndex complete:complete];
    [operation beginTimer:UDPTimeout];
    [_operations addObject:operation];
    int sendTimes = [host isEqualToString:BroadcastHost] ? 3: 1;
    for (int i = 0; i < sendTimes; i++)
    {
        [_udpSocket sendData:protocol toHost:host port:DevicePort withTimeout:-1 tag:0];
    }
    return operation;
}

#pragma mark-0x23 Host

- (void)getDeviceMacAddressip:(NSString *)Mac deviceType:(NSString *)type
{
    NSData *data = [[Util getUtitObject] macStrTData:Mac];
    
    [self sendProtocol:[ProtocolData discoveryDevicesWithMac:data index:NewIndex deviceType:type] host:BroadcastHost complete:^(OperationResult *result) {
        
        
        NSLog(@"请求ip");
        
    }];
}
#pragma mark-0x24 Lock
- (void)sendToUdpLockWithData:(NSData *)data lock:(BOOL)islock isHost:(NSString *)host key:(NSData *)key deviceType:(NSString *)type
{
    UInt8  lindex = islock ? 0x44 : 0x40;
    
    [self sendProtocol:[ProtocolData lockWithdevice:data linex:lindex key:key deviceType:type] host:host complete:^(OperationResult *result) {
        //        NSLog(@"%@=-=-=-=",result.resultInfo);
    }];
    
    
}


#pragma mark-0x01 GPIO
- (void)setGPIOCloseOrOpenWithDeciceMac:(NSData *)data index:(BOOL)indx host:(NSString *)host key:(NSData *)key deviceType:(NSString *)type
{
    
    
    NSLog(@"ip%@===mac-=%@",host,data);
    UInt8 buyt = indx ? 0xff : 0x00;
    
    [self sendProtocol:[ProtocolData setGPIOWithdevice:data index:NewIndex linex:buyt key:key deviceType:type] host:host complete:^(OperationResult *result) {
        
    }];
}


#pragma mark-0x02 GPIO

- (void)queryGPIOEventToMac:(NSData *)mac withhost:(NSString *)host deviceType:(NSString *)type
{
    NSLog(@"mac=%@=host=%@",mac,host);
    [self sendProtocol:[ProtocolData queryGPIOWithdevice:mac deviceType:type] host:host complete:^(OperationResult *result) {
        
    }];
}

#pragma mark-0x03 GPIO
- (void)setGPIOaleamWithDeciceMac:(NSData *)mac index:(BOOL)indx host:(NSString *)host socketType:(BOOL)type  flag:(UInt8)flag Hour:(UInt8)hour min:(UInt8)min numberTaks:(UInt8)task key:(NSData *)key deviceType:(NSString *)Type
{
    UInt8 buyt = indx ? 0xff : 0x00;
    
    [self sendProtocol:[ProtocolData timingDataWith:mac flag:flag Hour:hour min:min switchcc:buyt isUDP:type numberTaks:task key:key deviceType:Type] host:host complete:^(OperationResult *result) {
        
        NSLog(@"%@result",result.resultInfo);
    }];
}
#pragma mark-0x04 GPIO
- (void)getGPIOTimerInfoDeviceMac:(NSData *)mac host:(NSString *)host key:(NSData *)key deviceType:(NSString *)type
{
    
    NSLog(@"pi%@===mac-=%@==%@",host,mac, type);
    
    [self sendProtocol:[ProtocolData gettimingDataWith:mac key:key deviceType:type] host:host complete:^(OperationResult *result) {
        NSLog(@"timer%@result",result.resultInfo);
        
    }];
}

#pragma mark-0x05 GPIO
- (void)deleteGPIOTimerDeviceMac:(NSData *)mac host:(NSString *)host Num:(UInt8)number deviceType:(NSString *)type
{
    [self sendProtocol:[ProtocolData deleteGPIOWithMac:mac Num:number deviceType:type] host:host complete:^(OperationResult *result) {
        NSLog(@"delete%@result",result.resultInfo);
        
    }];
}

#pragma mark-0x0D 433
- (void)set433CloseOrOpenWithDeciceMac:(NSData *)data index:(BOOL)indx host:(NSString *)host adderss:(NSData *)adders type:(NSString *)type timerDic:(NSDictionary *)dic
{
    NSLog(@"ip%@===mac-=%@",host,data);
    UInt8 buyt = indx ? 0x01 : 0x02;
    
    [self sendProtocol:[ProtocolData onAndOffTo433WithMac:data UDP:YES address:adders cmd:buyt type:type timerDic:dic] host:host complete:nil];
}


#pragma mark-0x09 防盗
- (void)setAbseceWithDeciceMac:(NSData *)data index:(BOOL)indx host:(NSString *)host FromStateData:(NSData *)from ToData:(NSData *)ToData key:(NSData *)key deviceType:(NSString *)type
{
    
    NSLog(@"ip%@===mac-=%@",host,data);
    UInt8 buyt = indx ? 0x80 : 0x00;
    
    [self sendProtocol:[ProtocolData setAbsenceDataWith:data WithFlag:buyt WithFromStateData:from WithToData:ToData key:key deviceType:type] host:host complete:^(OperationResult *result) {
    }];
}

#pragma mark-0x11 设置倒计时
- (void)setGPIOCountdownWithDeciceMac:(NSData *)mac index:(BOOL)indx host:(NSString *)host socketType:(BOOL)type  flag:(UInt8)flag Hour:(UInt8)hour min:(UInt8)min numberTaks:(UInt8)task key:(NSData *)key deviceType:(NSString *)Type
{
    UInt8 buyt = indx ? 0xff : 0x00;
    
    [self sendProtocol:[ProtocolData countdownDataWith:mac flag:flag Hour:hour min:min switchcc:buyt isUDP:type numberTaks:task key:key deviceType:Type] host:host complete:^(OperationResult *result) {
        
    }];
}

#pragma mark-0x12 查询倒计时
- (void)getGPIOCountdownDeviceMac:(NSData *)mac host:(NSString *)host key:(NSData *)key deviceType:(NSString *)type orderType:(NSString *)order
{
    [self sendProtocol:[ProtocolData getCountdownDataWith:mac key:key deviceType:type orderType:order] host:host complete:^(OperationResult *result) {
        NSLog(@"timer%@result",result.resultInfo);
        
    }];
}

#pragma mark-0x0A 防盗查询
- (void)getQueryTheftModeDeciceLocalMac:(NSData *)data host:(NSString *)host  key:(NSData *)key deviceType:(NSString *)type
{
    
    [self sendProtocol:[ProtocolData getQueryTheftModeWith:data key:key deviceType:type] host:host complete:^(OperationResult *result) {
        
    }];
}

#pragma mark-0x0B 电量查询
- (void)getQueryDeviceWattInfoWithLocalMac:(NSData *)data host:(NSString *)host  key:(NSData *)key
{
    
    [self sendProtocol:[ProtocolData getDeviceWattInfoWithMac:data key:key] host:host complete:^(OperationResult *result) {
        
    }];
}

//#pragma mark -- 0x61
//- (void)startHeartBeatWith:(Device *)device
//{
//    Device *dev = [[DeviceManagerInstance getlocalDeviceDictary] objectForKey:device.macString];
//    if (dev == nil || device.macString == nil) {
//        [dev.heartTimer invalidate];
//        dev.heartTimer = nil;
//        [dev.heartbeatTimer invalidate];
//        dev.heartbeatTimer = nil;
//        [dev.heartNumberTimer invalidate];
//        dev.heartNumberTimer = nil;
//        return;
//    }
//    
//    NSLog(@"sdsd");
//    
//    [dev.heartTimer invalidate];
//    device.heartTimer = [NSTimer scheduledTimerWithTimeInterval:device.interval target:self selector:@selector(heartBeatWith:) userInfo:device repeats:NO];
//    [dev.heartbeatTimer invalidate];
//    device.heartbeatTimer = [NSTimer scheduledTimerWithTimeInterval:device.interval*1.5 target:self selector:@selector(stopTcpServer:) userInfo:device repeats:NO];
//}
//
//- (void)heartBeatWith:(NSTimer *)timer
//{
//    Device *dev = timer.userInfo;
//    
//    Device *devie = [[DeviceManagerInstance getlocalDeviceDictary] objectForKey:dev.macString];
//    if (devie == nil || dev.macString == nil) {
//        [timer invalidate];
//        timer = nil;
//        return;
//    }
//    
//    [devie.heartNumberTimer invalidate];
//    devie.heartNumberTimer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(countHeartNumber:) userInfo:devie repeats:YES];
//    
//    [self sendProtocol:[ProtocolData  heartBeatWithUDPWithMac:devie.mac withDeviceType:devie.deviceType] host:devie.host complete:^(OperationResult *result) {
//        
//    }];
//}
//
//- (void)countHeartNumber:(NSTimer *)timer
//{
//    Device *dev = timer.userInfo;
//    
//    Device *devie = [[DeviceManagerInstance getlocalDeviceDictary] objectForKey:dev.macString];
//    if (devie == nil || dev.macString == nil) {
//        [timer invalidate];
//        timer = nil;
//        return;
//    }
//    
//    devie.heartBeatNumber += 10;
//    
//    NSLog(@"===heart beat number == %d", devie.heartBeatNumber);
//    if (devie != nil || devie != NULL) {
//        [[DeviceManagerInstance getlocalDeviceDictary] setObject:devie forKey:dev.macString];
//    }
//}
//
////static int indexhert = 0;
//- (void)stopTcpServer:(NSTimer *)timer
//{
//    Device *dev = timer.userInfo;
//    Device *devie = [[DeviceManagerInstance getlocalDeviceDictary] objectForKey:dev.macString];
//    
//    if (devie == nil) {
//        [timer invalidate];
//        timer = nil;
//        return;
//    }
//    devie.localContent = @"0";
//    
//    for (int i = 0; i < 2; i ++) {
//        
//        [LocalServiceInstance addDeviceToFMDBWithisAdd:YES WithMac:devie.mac];
//        [NSThread sleepForTimeInterval:0.005];
//        [LocalServiceInstance addEnergyDeviceToFMDBWithisAdd:YES WithMac:devie.mac];
//        [NSThread sleepForTimeInterval:0.005];
//        [LocalServiceInstance addRFDeviceToFMDBWithisAdd:YES WithMac:devie.mac];
//        [NSThread sleepForTimeInterval:0.005];
//    }
//    
//    if (devie != nil || devie != NULL) {
//        [[DeviceManagerInstance getlocalDeviceDictary] setObject:devie forKey:devie.macString];
//    }
//    
//    [NSThread sleepForTimeInterval:0.1];
//    if (devie.remoteContent != nil && ![devie.remoteContent isEqualToString:@""] && devie.mac != nil) {
//        
//        if (devie.heartBeatNumber > 40) {
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"OPERATION_INFO" object:@{@"result":devie.remoteContent,@"mac":devie.mac}];
//        }
//    }
//    
//    NSLog(@"本地第一次设备断开");
//}


#pragma mark--0x61
- (void)startHeartBeatWith:(Device *)device
{
    Device *dev = [[DeviceManagerInstance getlocalDeviceDictary] objectForKey:device.macString];
    if (dev == nil) {
        return;
    }
    NSLog(@"sdsd");
    if (device.heartTimer != nil) {
        
        [device.heartTimer  invalidate];
        device.heartTimer = nil;
    }
    device.heartTimer = [NSTimer scheduledTimerWithTimeInterval:device.interval target:self selector:@selector(heartBeatWith:) userInfo:device repeats:NO];
    if (device.heartbeatTimer != nil) {
        
        [device.heartbeatTimer  invalidate];
        device.heartbeatTimer = nil;
    }
    
    device.heartbeatTimer = [NSTimer scheduledTimerWithTimeInterval:device.interval*1.5 target:self selector:@selector(stopTcpServer:) userInfo:device repeats:NO];
}

- (void)heartBeatWith:(NSTimer *)timer
{
    Device *dev = timer.userInfo;
    Device *devie = [[DeviceManagerInstance getlocalDeviceDictary] objectForKey:dev.macString];
    if (devie == nil || !self.isConnected) {
        [timer invalidate];
        timer = nil;
        return;
    }
    
    [self sendProtocol:[ProtocolData  heartBeatWithUDPWithMac:devie.mac withDeviceType:devie.deviceType] host:devie.host complete:^(OperationResult *result) {
        
    }];
}

//static int indexhert = 0;
- (void)stopTcpServer:(NSTimer *)timer
{
    Device *dev = timer.userInfo;
    Device *device = [[DeviceManagerInstance getlocalDeviceDictary] objectForKey:dev.macString];
    if (device == nil) {
        [timer invalidate];
        timer = nil;
        return;
    }
    device.localContent = @"0";

    for (int i = 0; i < 2; i ++) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [LocalServiceInstance addDeviceToFMDBWithisAdd:YES WithMac:device.mac];
            [LocalServiceInstance addEnergyDeviceToFMDBWithisAdd:YES WithMac:device.mac];
            [LocalServiceInstance addRFDeviceToFMDBWithisAdd:YES WithMac:device.mac];
        });
    }
    
    if (device.remoteContent != nil && ![device.remoteContent isEqualToString:@""] && device.mac != nil) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"OPERATION_INFO" object:@{@"result":device.remoteContent,@"mac":device.mac}];
    }
    
    if (device != nil || device != NULL) {
        [[DeviceManagerInstance getlocalDeviceDictary] setObject:device forKey:device.macString];
    }
    NSLog(@"本地第一次设备断开");
}


#pragma mark-
#pragma mark-0x62

- (void)getDeviceInfoToMac:(NSData *)mac WithHost:(NSString *)host deviceType:(NSString *)type
{
    
    [self sendProtocol:[ProtocolData getDeviceInfoToMac:mac deviceType:type] host:host complete:^(OperationResult *result) {
        
        NSLog(@"resuit%@",result.resultInfo);
        
    }];
}

#pragma mark-
#pragma mark-0x65

- (void)firmwareUpgradeToMac:(NSData *)mac WithHost:(NSString *)host WithUrlLen:(UInt8)len WithUrl:(NSData *)urlData key:(NSData *)key deviceType:(NSString *)type
{
    [self sendProtocol:[ProtocolData firmwareUpgradeWithMac:mac WithUrlLen:len WithUrl:urlData WithKey:key deviceType:type] host:host complete:^(OperationResult *result) {
        
        NSLog(@"resuit%@",result.resultInfo);
        
    }];
}

#pragma mark 界限
#pragma mark-

//搜素设备23
- (void)discoverDevices:(id)observer deviceType:(NSString *)type
{
    _observer = observer;
    _discoveryTimer = [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(sendDiscoveryProtocol:) userInfo:type repeats:YES];
}
- (void)sendDiscoveryProtocol:(NSTimer *)timer
{
    if (_connected)
    {
        for (int i = 0; i < 5; i++)
        {
            [_udpSocket sendData:[ProtocolData discoveryDevices:NewIndex deviceType:timer.userInfo] toHost:_broadIP port:DevicePort withTimeout:-1 tag:NewIndex];
        }
    }
}

- (void)stopScan
{
    _observer = nil;
    [self.discoveryTimer invalidate];
}

- (void)connectDevices
{
    if ([self isConnected])
    {
        for (Device * device in DeviceManagerInstance.devices)
        {
            if (![_connectedDevices containsObject:device] && device.mac)
            {
                [self connectDevice:device];
            }
        }
    }
}

- (void)connectDevice:(Device *)device
{
    
    [self sendProtocol:[ProtocolData addDeviceWithFF_FFTolocalisUpData:YES WithMac:device.mac key:device.key companyCode:0] host:BroadcastHost complete:^(OperationResult *result) {
        NSData * mac = [result.resultInfo objectForKey:@"mac"];
        NSData * key = [result.resultInfo objectForKey:@"key"];
        if (key && mac)
        {
            [_keyDict setObject:key forKey:mac];
            Device * device = [self deviceFromMac:mac];
            device.key = key;
            device.host = [result.resultInfo objectForKey:@"host"];
            [device didConnect:result.responseData];
            [_connectedDevices addObject:device];
            [self.delegate localDidConnectDevice:device];
            device.interval = 0;
            //            [self startHeartBeat:device];
        }
        else
        {
            [RemoteServiceInstance connectDevice:device];
        }
    }];
}

- (void)deleteDevice:(Device *)device
{
    if (device.mac)
    {
        [_keyDict removeObjectForKey:device.mac];
    }
    [_connectedDevices removeObject:device];
}

@end
