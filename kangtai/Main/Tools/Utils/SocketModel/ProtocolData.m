//
//
/**
 * Copyright (c) www.bugull.com
 */
//
//

#import "ProtocolData.h"
#import "Crypt.h"
#import "PanelSocket.h"
#import "Gogle.h"

#define Reserved 0x00

@implementation ProtocolData

+ (NSData *)protocolDataWithData:(NSData *)data device:(Device *)device index:(UInt16)index  key:(NSData *)key
{
    PV_Number ++;
    if (PV_Number  >= 0x7fff) {
        PV_Number = 0;
    }

    NSMutableData * protocolData = [[NSMutableData alloc] init];
    UInt8 preData[9];
    preData[0] = 0x01;
    preData[1] = 0x00;
    UInt8 mac[6] = {0xff,0xff,0xff,0xff,0xff,0xff};
    
    NSData *macData = [NSData dataWithBytes:mac length:6];
    memcpy(preData + 2, [macData bytes], 6);
    
    UInt8 shadow[8];
    UInt8 *indexBytes = (UInt8 *)[[Util netDataFromUint16:PV_Number] bytes];
    
    shadow[0] = 0x00;
    memcpy(shadow + 1, indexBytes, 2);
    shadow[3] = 0xA1; // 厂家代码
    shadow[4] = 0xD2; // 授权码
    shadow[5] = 0x6A; // 授权码
    shadow[6] = 0x12; // 设备类型
    memcpy(shadow + 7, [data bytes],1);
    
    NSData * encrptData = [NSData dataWithBytes:shadow length:8];
    
    preData[8] = (UInt8)encrptData.length;
    
    [protocolData appendBytes:preData length:9];
    [protocolData appendData:encrptData];
    
    return protocolData;
}

//23
+ (NSData *)discoveryDevices:(UInt16)index deviceType:(NSString *)type
{
    UInt8 bytes[7] = {0x23,0xff,0xff,0xff,0xff,0xff,0xff};
    return [self protocolDataIComenWithData:[NSData dataWithBytes:bytes length:7] device:[[Device alloc] init] index:index key:nil deviceType:type];
}

+ (NSData *)protocolDataIComenWithData:(NSData *)data device:(Device *)device index:(UInt16)index  key:(NSData *)key deviceType:(NSString *)type
{
    PV_Number ++;
    if (PV_Number  >= 0x7fff) {
        PV_Number = 0;
    }

    NSMutableData * protocolData = [[NSMutableData alloc] init];
    UInt8 preData[9] = {0};
    preData[0] = 0x01;
    preData[1] = 0x00;
    if (device)
    {
        if (!device.mac)
        {
            UInt8 mac[6] = {0xff,0xff,0xff,0xff,0xff,0xff};
            memcpy(preData + 2, mac, 6);
        }
        else
        {
            memcpy(preData + 2, [device.mac bytes], 6);
        }
    }
    else
    {
        UInt8 mac[6] = {0x02,0x00,0x00,0x00,0x00,0x00};
        memcpy(preData + 2, mac, 6);
    }
    
    UInt8 shadowLen = 7 + data.length;
    UInt8 shadow[shadowLen];
    memset(shadow, 0, shadowLen);
    UInt8 * indexBytes = (UInt8 *)[[Util netDataFromUint16:index] bytes];
    shadow[0] = 0x00;
    memcpy(shadow + 1, indexBytes, 2);
    
    if (device)
    {
//        shadow[3] = device.productor;
//        memcpy(shadow + 4, [device.authCode bytes], 2);
        
        BOOL isHF = [[device.macString substringWithRange:NSMakeRange(0, 6)] isEqualToString:@"ACCF23"];
        shadow[3] = isHF ? 0xCA : 0xCB;
        shadow[4] = isHF ? 0xFD : 0x92;
        shadow[5] = isHF ? 0x66 : 0xDA;
        shadow[6] = [type isEqualToString:@"11"] ? 0x11 : ([type isEqualToString:@"21"] ? 0x21 : 0x31);
    }
    else
    {
        shadow[3] = 0xA1; // 厂家代码
        shadow[4] = 0xD2; // 授权码
        shadow[5] = 0x6A; // 授权码
        shadow[6] = 0x12; // 设备类型
    }
    memcpy(shadow + 7, [data bytes], data.length);
    
    //    NSData * encrptData = [Crypt encryptData:[NSData dataWithBytes:shadow length:shadowLen] key:key];
    NSData * encrptData = [NSData dataWithBytes:shadow length:shadowLen];
    preData[8] = (UInt8)encrptData.length;
    
    [protocolData appendBytes:preData length:9];
    [protocolData appendData:encrptData];
    
    return protocolData;
}

static   UInt16  PV_Number = 1;
static UInt16 PV_flag = 0;
static UInt16 flag_Number = 0;

+ (NSData *)uDPprotocolWithData:(NSData *)data device:(Device *)device index:(UInt16)index  key:(NSData *)key Lock:(BOOL)isLock devictType:(NSString *)type
{
    NSData * data0 = [data subdataWithRange:NSMakeRange(1, 6)];
    
    NSString *macStr = [[Crypt hexEncode:data0] uppercaseStringWithLocale:[NSLocale currentLocale]];
    NSString *markStr = [macStr substringWithRange:NSMakeRange(0, 6)];
    BOOL isHF = [markStr isEqualToString:@"ACCF23"];

    PV_Number ++;
    if (PV_Number  >= 0x7fff) {
        PV_Number = 0;
    }
    
    NSMutableData * protocolData = [[NSMutableData alloc] init];
    UInt8 preData[9];
    preData[0] = 0x01;
    
    preData[1] = 0x00;
    
    memcpy(preData + 2, [data0 bytes], 6);
    
    
    UInt8 shadow[8];
    UInt8 *indexBytes = (UInt8 *)[[Util netDataFromUint16:PV_Number] bytes];
    
    shadow[0] = 0x00;
    memcpy(shadow + 1, indexBytes, 2);
    shadow[3] = isHF ? 0xCA : 0xCB;
    shadow[4] = isHF ? 0xFD : 0x92;
    shadow[5] = isHF ? 0x66 : 0xDA;
    shadow[6] = [type isEqualToString:@"11"] ? 0x11 : ([type isEqualToString:@"21"] ? 0x21 : 0x31);
    shadow[7] = 0x23;
    //    memcpy(shadow + 8, [data bytes], 6);
    
    //        NSData * encrptData = [Crypt encryptData:[NSData dataWithBytes:shadow length:shadowLen] key:key];
    NSData * encrptData = [NSData dataWithBytes:shadow length:8];
    
    preData[8] = (UInt8)encrptData.length;
    
    [protocolData appendBytes:preData length:9];
    [protocolData appendData:encrptData];
    
    return protocolData;
}

#pragma mark-add_23

+ (NSData *)UpdataIPTodeviceWithMac:(NSData *)mac
{
    return [self updataDeviceToLocalMac:mac];
}
+ (NSData *)updataDeviceToLocalMac:(NSData *)data
{
    NSMutableData * protocolData = [[NSMutableData alloc] init];
    UInt8 preData[9];
    preData[0] = 0x01;
    preData[1] = 0x00;
    
    memcpy(preData + 2, [data bytes], 6);
    PV_Number ++;
    if (PV_Number  >= 0x7fff) {
        PV_Number = 0;
    }
    
    NSString *macStr = [[Crypt hexEncode:data] uppercaseStringWithLocale:[NSLocale currentLocale]];
    NSString *markStr = [macStr substringWithRange:NSMakeRange(0, 6)];
    BOOL isHF = [markStr isEqualToString:@"ACCF23"];

    UInt8 shadow[8];
    UInt8 *indexBytes = (UInt8 *)[[Util netDataFromUint16:PV_Number] bytes];
    
    shadow[0] = 0x00;
    memcpy(shadow + 1, indexBytes, 2);
    shadow[3] = isHF ? 0xCA : 0xCB;
    shadow[4] = isHF ? 0xFD : 0x92;
    shadow[5] = isHF ? 0x66 : 0xDA;
    shadow[6] = 0x11;
    
    shadow[7] = 0x23;
    //    memcpy(shadow + 8, [data bytes], 6);
    NSData * encrptData = [NSData dataWithBytes:shadow length:8];
    
    preData[8] = (UInt8)encrptData.length;
    
    [protocolData appendBytes:preData length:9];
    [protocolData appendData:encrptData];
    return protocolData;
}


+ (NSData *)addDeviceWithFF_FFTolocalisUpData:(BOOL)isUpData WithMac:(NSData *)mac key:(NSData *)key companyCode:(UInt8)company
{
    if (isUpData == YES) {
        
        return  [self addDeviceToLocal:mac key:key companyCode:company];
    }
    
    UInt8 macs[6];
    macs [0] = 0xFF;
    macs [1] = 0xFF;
    macs [2] = 0xFF;
    macs [3] = 0xFF;
    macs [4] = 0xFF;
    macs [5] = 0xFF;
    NSData * macData = [NSData dataWithBytes:macs length:6];
    
    return  [self addDeviceToLocal:macData key:key companyCode:company];
}
+ (NSData *)addDeviceToLocal:(NSData *)data key:(NSData *)key companyCode:(UInt8)company
{
    NSMutableData * protocolData = [[NSMutableData alloc] init];
    UInt8 preData[9];
    preData[0] = 0x01;
    preData[1] = 0x00;

    memcpy(preData + 2, [data bytes], 6);
    PV_Number ++;
    if (PV_Number ==0x7fff) {
        PV_Number = 0;
    }
    
    NSString *macStr = [[Crypt hexEncode:data] uppercaseStringWithLocale:[NSLocale currentLocale]];
    NSString *markStr = [macStr substringWithRange:NSMakeRange(0, 6)];

    UInt8 shadow[14];
    UInt8 *indexBytes = (UInt8 *)[[Util netDataFromUint16:PV_Number] bytes];
    
    shadow[0] = 0x00;
    memcpy(shadow + 1, indexBytes, 2);
    if ([markStr isEqualToString:@"FFFFFF"]) {
        shadow[3] = company;
        shadow[4] =  company == 0xCA ?  0xFD : 0x92;
        shadow[5] = company == 0xCA ? 0x66 : 0xDA;
    } else {
        BOOL isHF = [markStr isEqualToString:@"ACCF23"];
        shadow[3] = isHF ? 0xCA : 0xCB;
        shadow[4] = isHF ? 0xFD : 0x92;
        shadow[5] = isHF ? 0x66 : 0xDA;
    }
    shadow[6] = 0x11;
    shadow[7] = 0x23;
    memcpy(shadow + 8, [data bytes], 6);
    
    // NSData * encrptData = [Crypt encryptData:[NSData dataWithBytes:shadow length:14] key:key];
    NSData *localData = [NSData dataWithBytes:shadow length:14];
    
    preData[8] = (UInt8)localData.length;
    [protocolData appendBytes:preData length:9];
    [protocolData appendData:localData];

    NSLog(@"%@==",protocolData);
    
    return protocolData;
}

// 有计量功能
+ (NSData *)UpdataIPToEnergyDeviceWithMac:(NSData *)mac
{
    return [self updataEnergyDeviceToLocalMac:mac];
}
+ (NSData *)updataEnergyDeviceToLocalMac:(NSData *)data
{
    NSMutableData * protocolData = [[NSMutableData alloc] init];
    UInt8 preData[9];
    preData[0] = 0x01;
    preData[1] = 0x00;
    
    memcpy(preData + 2, [data bytes], 6);
    PV_Number ++;
    if (PV_Number  >= 0x7fff) {
        PV_Number = 0;
    }
    
    NSString *macStr = [[Crypt hexEncode:data] uppercaseStringWithLocale:[NSLocale currentLocale]];
    NSString *markStr = [macStr substringWithRange:NSMakeRange(0, 6)];
    BOOL isHF = [markStr isEqualToString:@"ACCF23"];

    UInt8 shadow[8];
    UInt8 *indexBytes = (UInt8 *)[[Util netDataFromUint16:PV_Number] bytes];
    
    shadow[0] = 0x00;
    memcpy(shadow + 1, indexBytes, 2);
    shadow[3] = isHF ? 0xCA : 0xCB;
    shadow[4] = isHF ? 0xFD : 0x92;
    shadow[5] = isHF ? 0x66 : 0xDA;
    shadow[6] = 0x21;
    
    shadow[7] = 0x23;
    //    memcpy(shadow + 8, [data bytes], 6);
    NSData * encrptData = [NSData dataWithBytes:shadow length:8];
    
    preData[8] = (UInt8)encrptData.length;
    
    [protocolData appendBytes:preData length:9];
    [protocolData appendData:encrptData];
    return protocolData;
}

+ (NSData *)addEnergyDeviceWithFF_FFTolocalisUpData:(BOOL)isUpData WithMac:(NSData *)mac key:(NSData *)key companyCode:(UInt8)company
{
    if (isUpData == YES) {
        
        return  [self addEnergyDeviceToLocal:mac key:key companyCode:company];
    }
    
    UInt8 macs[6];
    macs [0] = 0xFF;
    macs [1] = 0xFF;
    macs [2] = 0xFF;
    macs [3] = 0xFF;
    macs [4] = 0xFF;
    macs [5] = 0xFF;
    NSData * macData = [NSData dataWithBytes:macs length:6];
    
    return  [self addEnergyDeviceToLocal:macData key:key companyCode:company];
}

+ (NSData *)addEnergyDeviceToLocal:(NSData *)data key:(NSData *)key companyCode:(UInt8)company
{
    NSMutableData * protocolData = [[NSMutableData alloc] init];
    UInt8 preData[9];
    preData[0] = 0x01;
    preData[1] = 0x00;
    
    NSString *macStr = [[Crypt hexEncode:data] uppercaseStringWithLocale:[NSLocale currentLocale]];
    NSString *markStr = [macStr substringWithRange:NSMakeRange(0, 6)];
    
    memcpy(preData + 2, [data bytes], 6);
    PV_Number ++;
    if (PV_Number ==0x7fff) {
        PV_Number = 0;
    }
    
    UInt8 shadow[14];
    UInt8 *indexBytes = (UInt8 *)[[Util netDataFromUint16:PV_Number] bytes];
    
    shadow[0] = 0x00;
    memcpy(shadow + 1, indexBytes, 2);
    if ([markStr isEqualToString:@"FFFFFF"]) {
        shadow[3] = company;
        shadow[4] =  company == 0xCA ?  0xFD : 0x92;
        shadow[5] = company == 0xCA ? 0x66 : 0xDA;
    } else {
        BOOL isHF = [markStr isEqualToString:@"ACCF23"];
        shadow[3] = isHF ? 0xCA : 0xCB;
        shadow[4] = isHF ? 0xFD : 0x92;
        shadow[5] = isHF ? 0x66 : 0xDA;
    }
    shadow[6] = 0x21;
    shadow[7] = 0x23;
    memcpy(shadow + 8, [data bytes], 6);
    
    // NSData * encrptData = [Crypt encryptData:[NSData dataWithBytes:shadow length:14] key:key];
    NSData *localData = [NSData dataWithBytes:shadow length:14];
    
    preData[8] = (UInt8)localData.length;
    [protocolData appendBytes:preData length:9];
    [protocolData appendData:localData];
    
    NSLog(@"%@==",protocolData);
    
    return protocolData;
}

// 有RF功能
+ (NSData *)UpdataIPToRFDeviceWithMac:(NSData *)mac
{
    return [self updataRFDeviceToLocalMac:mac];
}
+ (NSData *)updataRFDeviceToLocalMac:(NSData *)data
{
    NSMutableData * protocolData = [[NSMutableData alloc] init];
    UInt8 preData[9];
    preData[0] = 0x01;
    preData[1] = 0x00;
    
    memcpy(preData + 2, [data bytes], 6);
    PV_Number ++;
    if (PV_Number  >= 0x7fff) {
        PV_Number = 0;
    }
    
    NSString *macStr = [[Crypt hexEncode:data] uppercaseStringWithLocale:[NSLocale currentLocale]];
    NSString *markStr = [macStr substringWithRange:NSMakeRange(0, 6)];
    BOOL isHF = [markStr isEqualToString:@"ACCF23"];

    UInt8 shadow[8];
    UInt8 *indexBytes = (UInt8 *)[[Util netDataFromUint16:PV_Number] bytes];
    
    shadow[0] = 0x00;
    memcpy(shadow + 1, indexBytes, 2);
    shadow[3] = isHF ? 0xCA : 0xCB;
    shadow[4] = isHF ? 0xFD : 0x92;
    shadow[5] = isHF ? 0x66 : 0xDA;
    shadow[6] = 0x31;
    
    shadow[7] = 0x23;
    //    memcpy(shadow + 8, [data bytes], 6);
    NSData * encrptData = [NSData dataWithBytes:shadow length:8];
    
    preData[8] = (UInt8)encrptData.length;
    
    [protocolData appendBytes:preData length:9];
    [protocolData appendData:encrptData];
    return protocolData;
}

+ (NSData *)addRFDeviceWithFF_FFTolocalisUpData:(BOOL)isUpData WithMac:(NSData *)mac key:(NSData *)key companyCode:(UInt8)company
{
    
    if (isUpData == YES) {
        
        return  [self addRFDeviceToLocal:mac key:key companyCode:company];
    }
    
    
    UInt8 macs[6];
    macs [0] = 0xFF;
    macs [1] = 0xFF;
    macs [2] = 0xFF;
    macs [3] = 0xFF;
    macs [4] = 0xFF;
    macs [5] = 0xFF;
    NSData * macData = [NSData dataWithBytes:macs length:6];
    
    return  [self addRFDeviceToLocal:macData key:key companyCode:company];
}

+ (NSData *)addRFDeviceToLocal:(NSData *)data key:(NSData *)key companyCode:(UInt8)company
{
    NSMutableData * protocolData = [[NSMutableData alloc] init];
    UInt8 preData[9];
    preData[0] = 0x01;
    preData[1] = 0x00;
    
    memcpy(preData + 2, [data bytes], 6);
    PV_Number ++;
    if (PV_Number ==0x7fff) {
        PV_Number = 0;
    }
    
    NSString *macStr = [[Crypt hexEncode:data] uppercaseStringWithLocale:[NSLocale currentLocale]];
    NSString *markStr = [macStr substringWithRange:NSMakeRange(0, 6)];

    UInt8 shadow[14];
    UInt8 *indexBytes = (UInt8 *)[[Util netDataFromUint16:PV_Number] bytes];
    
    shadow[0] = 0x00;
    memcpy(shadow + 1, indexBytes, 2);
    if ([markStr isEqualToString:@"FFFFFF"]) {
        shadow[3] = company;
        shadow[4] =  company == 0xCA ?  0xFD : 0x92;
        shadow[5] = company == 0xCA ? 0x66 : 0xDA;
    } else {
        BOOL isHF = [markStr isEqualToString:@"ACCF23"];
        shadow[3] = isHF ? 0xCA : 0xCB;
        shadow[4] = isHF ? 0xFD : 0x92;
        shadow[5] = isHF ? 0x66 : 0xDA;
    }
    shadow[6] = 0x31;
    shadow[7] = 0x23;
    memcpy(shadow + 8, [data bytes], 6);
    
    // NSData * encrptData = [Crypt encryptData:[NSData dataWithBytes:shadow length:14] key:key];
    NSData *localData = [NSData dataWithBytes:shadow length:14];
    
    preData[8] = (UInt8)localData.length;
    [protocolData appendBytes:preData length:9];
    [protocolData appendData:localData];
    
    NSLog(@"%@==",protocolData);
    
    return protocolData;
}

#pragma mark-0x81

+ (NSData *)workingServer:(UInt16)index
{
    UInt8 bytes[1] = {0x81};
    return [self protocolDataWithData:[NSData dataWithBytes:bytes length:1] device:nil index:index key:nil];
}

#pragma mark-0x82
+ (NSData *)requestConnect:(UInt16)index
{
    PV_Number ++;
    if (PV_Number  >= 0x7fff) {
        PV_Number = 0;
    }
    
    NSMutableData * protocolData = [[NSMutableData alloc] init];
    UInt8 preData[9];
    preData[0] = 0x01;
    preData[1] = 0x00;
    UInt8 mac[6] = {0xff,0xff,0xff,0xff,0xff,0xff};
    
    NSData *macData = [NSData dataWithBytes:mac length:6];
    memcpy(preData + 2, [macData bytes], 6);
    
    UInt8 *indexBytes = (UInt8 *)[[Util netDataFromUint16:PV_Number] bytes];
    
    NSString *name = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_USERMODEL];
    NSString *pwd_md5 = [Util getPassWordWithmd5:[[NSUserDefaults standardUserDefaults] objectForKey:KEY_PASSWORD]];
    int nameLen = (int)name.length;
    int pwdLen = (int)pwd_md5.length;
    
    UInt8 shadow[10 + nameLen + pwdLen];
    shadow[0] = 0x00;
    memcpy(shadow + 1, indexBytes, 2);
    shadow[3] = 0xA1; // 厂家代码
    shadow[4] = 0xD2; // 授权码
    shadow[5] = 0x6A; // 授权码
    shadow[6] = 0x12; // 设备类型
    shadow[7] = 0x82;
    shadow[8] = nameLen;
    
    for (int i = 1; i <= nameLen; i++) {
        NSString *tempStr = [Util hexStringFromString:[name substringWithRange:NSMakeRange(i - 1, 1)]];
        shadow[8 + i] = strtoul([tempStr UTF8String], 0, 16);
    }
    
    shadow[9 + nameLen] = pwdLen;
    
    for (int i = 1; i <= pwdLen; i++) {
        NSString *tempStr = [Util hexStringFromString:[pwd_md5 substringWithRange:NSMakeRange(i - 1, 1)]];
        shadow[9 + nameLen + i] = strtoul([tempStr UTF8String], 0, 16);
    }
    
        NSData * encrptData = [NSData dataWithBytes:shadow length:10 + nameLen + pwdLen];
    
//    NSData * encrptData = [Crypt encryptData:[NSData dataWithBytes:shadow length:10 + nameLen + pwdLen] key:nil];
    
    
    preData[8] = (UInt8)encrptData.length;
    
    [protocolData appendBytes:preData length:9];
    [protocolData appendData:encrptData];
    
    return protocolData;
}




+ (NSData *)discoveryDevicesWithMac:(NSData *)mac index:(UInt16)index deviceType:(NSString *)type
{
    UInt8 bytes[7];
    bytes[0] = 0x23;
    if (mac)
    {
        memcpy(bytes + 1, mac.bytes, 6);
    }
    return [self uDPprotocolWithData:[NSData dataWithBytes:bytes length:7] device:nil index:index key:nil Lock:NO devictType:type];
}


void setGPIO(UInt8 * bytes, UInt8 pinNum, UInt8 duty, UInt8 last)
{
    UInt8 gpio[4] = {pinNum,0x00,duty,last};
    memcpy(bytes, gpio, 4);
}

+ (NSData *)queryGPIOWithSockets:(NSArray *)sockets device:(Device *)device index:(UInt16)index key:(NSData *)key
{
    UInt8 bytes[1 + sockets.count * 4];
    bytes[0] = 0x02;
    int offset = 1;
    for (PanelSocket * socket in sockets)
    {
        setGPIO(bytes + offset, socket.pinNum, 0x00, 0x00);
        offset += 4;
    }
    return [self protocolDataWithData:[NSData dataWithBytes:bytes length:1 + sockets.count * 4] device:device index:index key:key];
}


#pragma mark-data 0x01
#pragma mark-

+ (NSData *)setGPIOMac:(NSData *)data index:(UInt16)index linex:(UInt8)pinNum key:(NSData *)key deviceType:(NSString *)type
{
    NSMutableData * protocolData = [[NSMutableData alloc] init];
    UInt8 preData[9];
    preData[0] = 0x01;
    
    preData[1] = 0x00;
    
    memcpy(preData + 2,[data bytes],6);
    if (PV_Number >= 0x7fff) {
        PV_Number =0;
    }
    PV_Number ++;
    
    NSString *macStr = [[Crypt hexEncode:data] uppercaseStringWithLocale:[NSLocale currentLocale]];
    NSString *markStr = [macStr substringWithRange:NSMakeRange(0, 6)];
    BOOL isHF = [markStr isEqualToString:@"ACCF23"];

    UInt8 shadow[12];
    UInt8 *indexBytes = (UInt8 *)[[Util netDataFromUint16:PV_Number] bytes];
    
    shadow[0] = 0x00;
    memcpy(shadow + 1, indexBytes, 2);
    shadow[3] = isHF ? 0xCA : 0xCB;
    shadow[4] = isHF ? 0xFD : 0x92;
    shadow[5] = isHF ? 0x66 : 0xDA;
    shadow[6] = [type isEqualToString:@"11"] ? 0x11 : ([type isEqualToString:@"21"] ? 0x21 : 0x31);
    
    shadow[7] = 0x01;
    shadow[8] = 0x00;
    
    shadow[9] = 0x00;
    //    开关
    shadow[10] = pinNum;
    
    shadow [11]= 0xff;
    
    
//    NSData * encrptData = [Crypt encryptData:[NSData dataWithBytes:shadow length:12] key:key];
    NSData *setData = [NSData dataWithBytes:shadow length:12];
    
    preData[8] = (UInt8)setData.length;
    
    [protocolData appendBytes:preData length:9];
    
    [protocolData appendData:setData];

    NSLog(@"%@==========",protocolData);
    return protocolData;
}

+ (NSData *)setGPIOWithdevice:(NSData *)mac index:(UInt16)index linex:(UInt8)line key:(NSData *)key deviceType:(NSString *)type
{
    return [self setGPIOMac:mac  index:index linex:line key:key deviceType:type];
}



#pragma mark-data 0x24
#pragma mark-

+ (NSData *)lockWithdevice:(NSData *)mac  linex:(UInt8)line key:(NSData *)key deviceType:(NSString *)type
{
    return [self lockWithdataToDevice:mac index:line key:key deviceType:type];
}

+ (NSData *)lockWithdataToDevice:(NSData *)mac index:(UInt8)index key:(NSData *)key deviceType:(NSString *)type
{
    NSMutableData * protocolData = [[NSMutableData alloc] init];
    UInt8 preData[9];
    preData[0] = 0x01;
    
    preData[1] = index;
    
    PV_Number ++;
    if (PV_Number  >= 0x7fff) {
        PV_Number = 0;
    }

    NSString *macStr = [[Crypt hexEncode:mac] uppercaseStringWithLocale:[NSLocale currentLocale]];
    NSString *markStr = [macStr substringWithRange:NSMakeRange(0, 6)];
    BOOL isHF = [markStr isEqualToString:@"ACCF23"];

    memcpy(preData + 2, [mac bytes], 6);
    //    UInt8 shadowLen = 7 + data.length;
    UInt8 shadow[14];
    UInt8 *indexBytes = (UInt8 *)[[Util netDataFromUint16:PV_Number] bytes];
    
    shadow[0] = 0x00;
    memcpy(shadow + 1, indexBytes, 2);
    shadow[3] = isHF ? 0xCA : 0xCB;
    shadow[4] = isHF ? 0xFD : 0x92;
    shadow[5] = isHF ? 0x66 : 0xDA;
    shadow[6] = [type isEqualToString:@"11"] ? 0x11 : ([type isEqualToString:@"21"] ? 0x21 : 0x31);
    
    shadow[7] = 0x24;
    
    memcpy(shadow + 8, [mac bytes], 6);
    
    NSData * lockData = [Crypt encryptData:[NSData dataWithBytes:shadow length:14] key:key];
//    NSData *lockData = [NSData dataWithBytes:shadow length:14];
    
    preData[8] = (UInt8)lockData.length;
    
    [protocolData appendBytes:preData length:9];
    
    [protocolData appendData:lockData];
    //
    //    NSLog(@"%@==========",encrptData);
    return protocolData;
    
}

#pragma mark-data 0x02
#pragma mark-

+ (NSData *)queryGPIOMac:(NSData *)data deviceType:(NSString *)type
{
    NSMutableData * protocolData = [[NSMutableData alloc] init];
    UInt8 preData[9];
    preData[0] = 0x01;
    
    preData[1] = 0x00;
    
    memcpy(preData + 2,[data bytes],6);
    
    NSString *macStr = [[Crypt hexEncode:data] uppercaseStringWithLocale:[NSLocale currentLocale]];
    NSString *markStr = [macStr substringWithRange:NSMakeRange(0, 6)];
    BOOL isHF = [markStr isEqualToString:@"ACCF23"];

    PV_Number ++;
    if (PV_Number  >= 0x7fff) {
        PV_Number = 0;
    }

    UInt8 shadow[12];
    UInt8 *indexBytes = (UInt8 *)[[Util netDataFromUint16:PV_Number] bytes];
    
    shadow[0] = 0x00;
    memcpy(shadow + 1, indexBytes, 2);
    shadow[3] = isHF ? 0xCA : 0xCB;
    shadow[4] = isHF ? 0xFD : 0x92;
    shadow[5] = isHF ? 0x66 : 0xDA;
    shadow[6] = [type isEqualToString:@"11"] ? 0x11 : ([type isEqualToString:@"21"] ? 0x21 : 0x31);
    
    shadow[7] = 0x02;
    shadow[8] = 0x00;
    
    shadow[9] = 0x00;
    //    开关
    shadow[10] = 0x00;
    
    shadow [11]= 0x00;
    
    NSData *endData = [NSData dataWithBytes:shadow length:12];
    preData[8] = (UInt8)endData.length;
    
    [protocolData appendBytes:preData length:9];
    
    [protocolData appendData:endData];
    //    NSLog(@"%@==========",protocolData);
    return protocolData;
}

+ (NSData *)queryGPIOWithdevice:(NSData *)mac deviceType:(NSString *)type
{
    return [self queryGPIOMac:mac deviceType:type];
}



#pragma mark-Timing 0x03
#pragma mark-
+ (NSData *)timingDataWith:(NSData *)mac flag:(UInt8)flag Hour:(UInt8)hour  min:(UInt8)min  switchcc:(UInt8)on_off  isUDP:(BOOL)UDP  numberTaks:(UInt8)task  key:(NSData *)key deviceType:(NSString *)type

{
    return [self timingDateToDevice:mac withflag:flag Hour:hour power:on_off min:min isUDP:UDP numberTaks:task key:key deviceType:type];
}

+ (NSData *)timingDateToDevice:(NSData *)mac withflag:(UInt8)flag  Hour:(UInt8)hour  power:(UInt8)on_off min:(UInt8)min isUDP:(BOOL)UDP  numberTaks:(UInt8)task  key:(NSData *)key deviceType:(NSString *)type
{
    NSMutableData * protocolData = [[NSMutableData alloc] init];
    UInt8 preData[9];
    preData[0] = 0x01;
    
    preData[1] = 0x00;
    
    NSString *macStr = [[Crypt hexEncode:mac] uppercaseStringWithLocale:[NSLocale currentLocale]];
    NSString *markStr = [macStr substringWithRange:NSMakeRange(0, 6)];
    BOOL isHF = [markStr isEqualToString:@"ACCF23"];

    if (PV_Number >=0x7fff) {
        PV_Number = 0;
    }
    
    PV_Number ++;
    memcpy(preData + 2, [mac bytes], 6);
    UInt8 shadow[17];
    UInt8 *indexBytes = (UInt8 *)[[Util netDataFromUint16:PV_Number] bytes];
    
    shadow[0] = 0x00;
    memcpy(shadow + 1, indexBytes, 2);
    shadow[3] = isHF ? 0xCA : 0xCB;
    shadow[4] = isHF ? 0xFD : 0x92;
    shadow[5] = isHF ? 0x66 : 0xDA;
    shadow[6] = [type isEqualToString:@"11"] ? 0x11 : ([type isEqualToString:@"21"] ? 0x21 : 0x31);
    
    shadow[7] = 0x03;
    shadow[8] = 0x00;
    
    shadow[9] = task;//任务数
    shadow[10] = flag;
    shadow[11] = hour;
    shadow[12] = min;
    shadow[13] = 0x00;
    shadow[14] = 0x00;
    
    shadow[15] = on_off;//闹钟开关
    
    shadow[16] = 0xff;
    
//    NSData * encrptData = [Crypt encryptData:[NSData dataWithBytes:shadow length:17] key:key];
    
    NSData *endData = [NSData dataWithBytes:shadow length:17];
    
    preData[8] = (UInt8)endData.length;
    
    [protocolData appendBytes:preData length:9];
    
    [protocolData appendData:endData];
    
    NSLog(@"=== %@", protocolData);
    
    return protocolData;
}
#pragma mark-Timing 0x04 GPIO 查询

+ (NSData *)gettimingDataWith:(NSData *)mac key:(NSData *)key deviceType:(NSString *)type
{
    return [self getGPIOTimingDataWithMac:mac key:key deviceType:type];
}

+ (NSData *)getGPIOTimingDataWithMac:(NSData *)mac key:(NSData *)key deviceType:(NSString *)type
{
    NSMutableData * protocolData = [[NSMutableData alloc] init];
    UInt8 preData[9];
    preData[0] = 0x01;
    
    preData[1] = 0x00;
    
    memcpy(preData + 2, [mac bytes], 6);
    
    PV_Number ++;
    if (PV_Number >=0x7fff) {
        PV_Number = 0;
    }

    NSString *macStr = [[Crypt hexEncode:mac] uppercaseStringWithLocale:[NSLocale currentLocale]];
    NSString *markStr = [macStr substringWithRange:NSMakeRange(0, 6)];
    BOOL isHF = [markStr isEqualToString:@"ACCF23"];

    UInt8 shadow[10];
    UInt8 *indexBytes = (UInt8 *)[[Util netDataFromUint16:PV_Number] bytes];
    
    shadow[0] = 0x00;
    memcpy(shadow + 1, indexBytes, 2);
    shadow[3] = isHF ? 0xCA : 0xCB;
    shadow[4] = isHF ? 0xFD : 0x92;
    shadow[5] = isHF ? 0x66 : 0xDA;
    shadow[6] = [type isEqualToString:@"11"] ? 0x11 : ([type isEqualToString:@"21"] ? 0x21 : 0x31);
    shadow[7] = 0x04;
    shadow[8] = 0x00;
    shadow[9] = 0x00;
//    NSData * encrptData = [Crypt encryptData:[NSData dataWithBytes:shadow length:10] key:key];
    NSData *timingData = [NSData dataWithBytes:shadow length:10];
    preData[8] = (UInt8)timingData.length;
    
    [protocolData appendBytes:preData length:9];
    
    [protocolData appendData:timingData];
    
        NSLog(@"%@==========",protocolData);
    
    return protocolData;
}

#pragma mark-0x05 GPIO 删除
+ (NSData *)deleteGPIOWithMac:(NSData *)mac Num:(UInt8)number deviceType:(NSString *)type
{
    return [self setGPIODeleteData:mac Num:number deviceType:type];
}

+ (NSData *)setGPIODeleteData:(NSData *)mac Num:(UInt8)number deviceType:(NSString *)type
{
    PV_Number ++;
    if (PV_Number  >= 0x7fff) {
        PV_Number = 0;
    }
    
    NSString *macStr = [[Crypt hexEncode:mac] uppercaseStringWithLocale:[NSLocale currentLocale]];
    NSString *markStr = [macStr substringWithRange:NSMakeRange(0, 6)];
    BOOL isHF = [markStr isEqualToString:@"ACCF23"];

    NSMutableData * protocolData = [[NSMutableData alloc] init];
    UInt8 preData[9];
    preData[0] = 0x01;
    
    preData[1] = 0x00;
    
    memcpy(preData + 2, [mac bytes], 6);
    
    UInt8 shadow[10];
    UInt8 *indexBytes = (UInt8 *)[[Util netDataFromUint16:PV_Number] bytes];
    
    shadow[0] = 0x00;
    memcpy(shadow + 1, indexBytes, 2);
    shadow[3] = isHF ? 0xCA : 0xCB;
    shadow[4] = isHF ? 0xFD : 0x92;
    shadow[5] = isHF ? 0x66 : 0xDA;
    shadow[6] = [type isEqualToString:@"11"] ? 0x11 : ([type isEqualToString:@"21"] ? 0x21 : 0x31);
    shadow[7] = 0x05;
    shadow[8] = 0x00;
    shadow[9] = number;
    
    NSData *endData = [NSData dataWithBytes:shadow length:10];
    preData[8] = (UInt8)endData.length;
    
    [protocolData appendBytes:preData length:9];
    
    [protocolData appendData:endData];
    
    //    NSLog(@"%@==========",protocolData);
    return protocolData;
    
    
}

#pragma mark-0x0D 433
+ (NSData *)onAndOffTo433WithMac:(NSData *)mac  UDP:(BOOL)udp address:(NSData *)addres cmd:(UInt8)cmd type:(NSString *)type timerDic:(NSDictionary *)dic
{
    //    int buy = dimmer ? 13 : 12;
    return [self set433deviceData:mac address:addres cmd:cmd type:type UDP:udp timerDic:dic];
}

+ (NSData *)set433deviceData:(NSData *)mac address:(NSData *)addres cmd:(UInt8)cmd type:(NSString *)type  UDP:(BOOL)udp timerDic:(NSDictionary *)dic
{
    
    NSString *macStr = [[Crypt hexEncode:mac] uppercaseStringWithLocale:[NSLocale currentLocale]];
    NSString *markStr = [macStr substringWithRange:NSMakeRange(0, 6)];
    BOOL isHF = [markStr isEqualToString:@"ACCF23"];

    NSMutableData * protocolData = [[NSMutableData alloc] init];
    UInt8 preData[9];
    preData[0] = 0x01;
    
    preData[1] = 0x00;
    
    memcpy(preData + 2, [mac bytes], 6);
    
    PV_Number ++;
    if (PV_Number >=0x7fff) {
        PV_Number = 0;
    }
    
    int number = dic ? (dic.count == 4 ? 22 : 11) : 16;
    
    UInt8 shadow[number];
    UInt8 *indexBytes = (UInt8 *)[[Util netDataFromUint16:PV_Number] bytes];
    
    shadow[0] = 0x00;
    memcpy(shadow + 1, indexBytes, 2);
    shadow[3] = isHF ? 0xCA : 0xCB;
    shadow[4] = isHF ? 0xFD : 0x92;
    shadow[5] = isHF ? 0x66 : 0xDA;
    shadow[6] = 0x31;
    
    shadow[7] = dic ? 0x0E : 0x0D;
    
    if (dic.count == 4) {
        memcpy(shadow + 8,[addres bytes], 2);
        shadow[10] = [dic[@"Num"] intValue];
        shadow[11] = [dic[@"Flag"] intValue];
        shadow[12] = [dic[@"Hour"] intValue];
        shadow[13] = [dic[@"Min"] intValue];
    } else if (dic.count == 2) {
        NSString *orderStr = dic[@"Order"];
        shadow[7] = strtoul([orderStr UTF8String], 0, 16);
        memcpy(shadow + 8,[addres bytes], 2);
        shadow[10] = [dic[@"Num"] intValue];
    }
    
    if (dic.count == 4 || dic == nil) {
        // 以下为data部分
        shadow[number - 8] = 0xA6;
        memcpy(shadow + number - 7,[addres bytes], 2);
        shadow[number - 5] = cmd;
        shadow[number - 4] = 0x00;
        shadow[number - 3] = 0x00;
        shadow[number - 2] = [type isEqualToString:@"4"] ? 0x8C : 0x08;
        shadow[number - 1] = 0x00; // 异或校验位
        for (int i = number - 8; i < number - 1; i ++) {
            shadow[number - 1] = shadow[number - 1] ^ shadow[i];
        }
    }
    
    NSData *endData = [NSData dataWithBytes:shadow length:number];
    preData[8] = (UInt8)endData.length;
    
    [protocolData appendBytes:preData length:9];
    
    [protocolData appendData:endData];
    
    NSLog(@"zzzzzzz === %@ =======",protocolData);
    
    // 0100accf 23379382 10000028 cafd6631 0da6a49b 01000008 90
    return protocolData;
}

#pragma mark-
#pragma mark-0x61
+ (NSData *)stopToDataBytesData
{    
    NSDate *datessss = [NSDate date];
    
//    datessss = [DateUtil getNowDateFromatAnDate:[NSDate date]];
    
    NSLog(@"=datessss==%@",datessss);
    
    NSTimeInterval time=[datessss timeIntervalSince1970];
    
    int i=time;
    
    NSData *doubleData =  [self intToData:i withDataLength:4];

    return doubleData;
}

#pragma mark-from
+ (NSData *)intToData:(long long)transInt withDataLength:(int)n
{
    Byte byte[n];
    for (int i = 0; i < n; i++) {
        UInt8 k = (transInt & (0xff << (8 * i))) >> (8 * i);
        byte[n - i - 1] = k;
    }
    NSData *data = [NSData dataWithBytes:byte length:n];
    return data;
}
// UDP心跳包
+(NSData *)heartBeatWithUDPWithMac:(NSData *)mac withDeviceType:(NSString *)type
{
    if (mac == nil) {
        return nil;
    }
    return [self heartDateToUdpWithMac:mac withDeviceType:type];
}

+ (NSData *)heartDateToUdpWithMac:(NSData *)mac withDeviceType:(NSString *)type
{
    NSString *macStr = [[Crypt hexEncode:mac] uppercaseStringWithLocale:[NSLocale currentLocale]];
    NSString *markStr = [macStr substringWithRange:NSMakeRange(0, 6)];
    BOOL isHF = [markStr isEqualToString:@"ACCF23"];

    NSMutableData * protocolData = [[NSMutableData alloc] init];
    UInt8 preData[9];
    preData[0] = 0x01;
    
    preData[1] = 0x00;
    
    //    UInt8 mac[6] = {0xff,0xff,0xff,0xff,0xff,0xff};
    memcpy(preData + 2, [mac bytes], 6);
    flag_Number ++;
    if (flag_Number  >= 0x7fff) {
        flag_Number = 0;
    }
    UInt8 shadow[12];
    UInt8 *indexBytes = (UInt8 *)[[Util netDataFromUint16:flag_Number] bytes];
    
    shadow[0] = 0x00;
    memcpy(shadow + 1, indexBytes, 2);
    shadow[3] = isHF ? 0xCA : 0xCB;
    shadow[4] = isHF ? 0xFD : 0x92;
    shadow[5] = isHF ? 0x66 : 0xDA;
    shadow[6] = [type isEqualToString:@"11"] ? 0x11 : ([type isEqualToString:@"21"] ? 0x21 : 0x31);
    
    shadow[7] = 0x61;
    memcpy(shadow + 8, [self stopToDataBytesData].bytes, 4);
    
    NSData *endData = [NSData dataWithBytes:shadow length:12];
    preData[8] = (UInt8)endData.length;
    
    [protocolData appendBytes:preData length:9];
    
    [protocolData appendData:endData];
    
    return protocolData;
    
}
// TCP 心跳包
+ (NSData *)heartBeat:(UInt16)index WithUDP:(BOOL)Type
{
    //    UInt8 bytes[1] = {0x61};
    return [self heartDateToDeviceHourWithUDP:Type];
}

+ (NSData *)heartDateToDeviceHourWithUDP:(BOOL)Type
{
    NSMutableData * protocolData = [[NSMutableData alloc] init];
    UInt8 preData[9];
    preData[0] = 0x01;
    
    preData[1] = 0x00;
    
    UInt8 mac[6] = {0xff,0xff,0xff,0xff,0xff,0xff};
    memcpy(preData + 2, mac, 6);
   
    flag_Number ++;
    if (flag_Number  >= 0x7fff) {
        flag_Number = 0;
    }
    
    UInt8 shadow[8];
    UInt8 *indexBytes = (UInt8 *)[[Util netDataFromUint16:PV_Number] bytes];
    
    shadow[0] = 0x00;
    memcpy(shadow + 1, indexBytes, 2);
    if (Type == YES) {
//        shadow[3] = isHF ? 0xCA : 0xCB;
//        shadow[4] = isHF ? 0xFD : 0x92;
//        shadow[5] = isHF ? 0x66 : 0xDA;
//        shadow[6] = 0x11;
        
    }else{
        shadow[3] = 0xA1; // 厂家代码
        shadow[4] = 0xD2; // 授权码
        shadow[5] = 0x6A; // 授权码
        shadow[6] = 0x12; // 设备类型
    }
    
    shadow[7] = 0x61;
    
    NSData *endData = [NSData dataWithBytes:shadow length:8];
    preData[8] = (UInt8)endData.length;
    
    [protocolData appendBytes:preData length:9];
    
    [protocolData appendData:endData];
    
    //    NSLog(@"%@==========",protocolData);
    return protocolData;
    
}

#pragma mark-
#pragma mark-0x65

+ (NSData *)firmwareUpgradeWithMac:(NSData *)mac WithUrlLen:(UInt8)len WithUrl:(NSData *)urlData WithKey:(NSData *)key deviceType:(NSString *)type

{
    return [self firmwareUpgradeToMacAddress:mac WithUrlLen:len WithUrl:urlData WithKey:key deviceType:type];
    
}
+ (NSData *)firmwareUpgradeToMacAddress:(NSData *)mac WithUrlLen:(UInt8)len WithUrl:(NSData *)urlData WithKey:(NSData *)key deviceType:(NSString *)type
{
    NSString *macStr = [[Crypt hexEncode:mac] uppercaseStringWithLocale:[NSLocale currentLocale]];
    NSString *markStr = [macStr substringWithRange:NSMakeRange(0, 6)];
    BOOL isHF = [markStr isEqualToString:@"ACCF23"];

    NSMutableData * protocolData = [[NSMutableData alloc] init];
    UInt8 preData[9];
    preData[0] = 0x01;
    
    preData[1] = 0x00;
    memcpy(preData + 2, [mac bytes], 6);
    
    PV_Number ++;
    if (PV_Number  >= 0x7fff) {
        PV_Number = 0;
    }

    UInt8 shadow[9+len];
    UInt8 *indexBytes = (UInt8 *)[[Util netDataFromUint16:PV_Number] bytes];
    
    shadow[0] = 0x00;
    memcpy(shadow + 1, indexBytes, 2);
    shadow[3] = isHF ? 0xCA : 0xCB;
    shadow[4] = isHF ? 0xFD : 0x92;
    shadow[5] = isHF ? 0x66 : 0xDA;
    shadow[6] = [type isEqualToString:@"11"] ? 0x11 : ([type isEqualToString:@"21"] ? 0x21 : 0x31);
    
    shadow[7] = 0x65;
    shadow[8] = len;
    memcpy(shadow+9, [urlData bytes], len);
//    NSData * encrptData = [Crypt encryptData:[NSData dataWithBytes:shadow length:9+len] key:key];
    NSData *firewareData = [NSData dataWithBytes:shadow length:9+len];
    preData[8] = (UInt8)firewareData.length;
    
    [protocolData appendBytes:preData length:9];
    
    [protocolData appendData:firewareData];

    return protocolData;
}

#pragma mark-
#pragma mark-0x62

+ (NSData *)getDeviceInfoToMac:(NSData *)mac deviceType:(NSString *)type
{
    return [self getDeviceInfoToMacAddress:mac deviceType:type];
    
}
+ (NSData *)getDeviceInfoToMacAddress:(NSData *)mac deviceType:(NSString *)type
{
    NSString *macStr = [[Crypt hexEncode:mac] uppercaseStringWithLocale:[NSLocale currentLocale]];
    NSString *markStr = [macStr substringWithRange:NSMakeRange(0, 6)];
    BOOL isHF = [markStr isEqualToString:@"ACCF23"];

    NSMutableData * protocolData = [[NSMutableData alloc] init];
    UInt8 preData[9];
    preData[0] = 0x01;
    
    preData[1] = 0x00;
    memcpy(preData + 2, [mac bytes], 6);
    
    PV_Number ++;
    if (PV_Number  >= 0x7fff) {
        PV_Number = 0;
    }

    UInt8 shadow[8];
    UInt8 *indexBytes = (UInt8 *)[[Util netDataFromUint16:PV_Number] bytes];
    
    shadow[0] = 0x00;
    memcpy(shadow + 1, indexBytes, 2);
    shadow[3] = isHF ? 0xCA : 0xCB;
    shadow[4] = isHF ? 0xFD : 0x92;
    shadow[5] = isHF ? 0x66 : 0xDA;
    shadow[6] = [type isEqualToString:@"11"] ? 0x11 : ([type isEqualToString:@"21"] ? 0x21 : 0x31);
    shadow[7] = 0x62;
    
    
    NSData *endData = [NSData dataWithBytes:shadow length:8];
    preData[8] = (UInt8)endData.length;
    
    [protocolData appendBytes:preData length:9];
    
    [protocolData appendData:endData];
    
    NSLog(@"%@====",protocolData);
    
    return protocolData;
    
    
}
#pragma mark-0x83
+ (NSData *)subscribetoevents:(NSData *)mac WithSwitch:(UInt8)indx WithCmd:(UInt8)cmd deviceType:(NSString *)type
{
    return [self subscribetoeventsDataWith:mac With:indx WithCmd:cmd deviceType:type];
}
+ (NSData *)subscribetoeventsDataWith:(NSData *)mac With:(UInt8)index WithCmd:(UInt8)cmd deviceType:(NSString *)type
{
    NSString *macStr = [[Crypt hexEncode:mac] uppercaseStringWithLocale:[NSLocale currentLocale]];
    NSString *markStr = [macStr substringWithRange:NSMakeRange(0, 6)];
    BOOL isHF = [markStr isEqualToString:@"ACCF23"];

    PV_Number ++;
    if (PV_Number  >= 0x7fff) {
        PV_Number = 0;
    }

    NSMutableData * protocolData = [[NSMutableData alloc] init];
    UInt8 preData[9];
    preData[0] = 0x01;
    
    preData[1] = 0x00;
    memcpy(preData + 2, [mac bytes], 6);
    UInt8 shadow[11];
    UInt8 *indexBytes = (UInt8 *)[[Util netDataFromUint16:PV_Number] bytes];
    
    shadow[0] = 0x00;
    memcpy(shadow + 1, indexBytes, 2);
    
    shadow[3] = isHF ? 0xCA : 0xCB;
    shadow[4] = isHF ? 0xFD : 0x92;
    shadow[5] = isHF ? 0x66 : 0xDA;
    shadow[6] = [type isEqualToString:@"11"] ? 0x11 : ([type isEqualToString:@"21"] ? 0x21 : 0x31);
    shadow[7] = 0x83;
    shadow[8] = index;
    shadow [9] = cmd;
    shadow[10] = 0x00;
    
    NSData *endData = [NSData dataWithBytes:shadow length:11];
    preData[8] = (UInt8)endData.length;
    
    [protocolData appendBytes:preData length:9];
    
    [protocolData appendData:endData];
    
    return protocolData;
    
    
}

#pragma mark-0x84
+ (NSData *)queryEquipmentOnlineWithMac:(NSData *)mac deviceType:(NSString *)type
{
    return [self queryEquipmentOnlineWithDataMac:mac deviceType:type];
}
+ (NSData *)queryEquipmentOnlineWithDataMac:(NSData *)mac deviceType:(NSString *)type
{
    NSString *macStr = [[Crypt hexEncode:mac] uppercaseStringWithLocale:[NSLocale currentLocale]];
    NSString *markStr = [macStr substringWithRange:NSMakeRange(0, 6)];
    BOOL isHF = [markStr isEqualToString:@"ACCF23"];

    NSMutableData * protocolData = [[NSMutableData alloc] init];
    UInt8 preData[9];
    preData[0] = 0x01;
    
    preData[1] = 0x00;
    memcpy(preData + 2, [mac bytes], 6);
    
    PV_Number ++;
    if (PV_Number  >= 0x7fff) {
        PV_Number = 0;
    }

    UInt8 shadow[8];
    UInt8 *indexBytes = (UInt8 *)[[Util netDataFromUint16:PV_Number] bytes];
    
    shadow[0] = 0x00;
    memcpy(shadow + 1, indexBytes, 2);
    shadow[3] = isHF ? 0xCA : 0xCB;
    shadow[4] = isHF ? 0xFD : 0x92;
    shadow[5] = isHF ? 0x66 : 0xDA;
    shadow[6] = [type isEqualToString:@"11"] ? 0x11 : ([type isEqualToString:@"21"] ? 0x21 : 0x31);
    shadow[7] = 0x84;
    
    NSData *endData = [NSData dataWithBytes:shadow length:8];
    preData[8] = (UInt8)endData.length;
    
    [protocolData appendBytes:preData length:9];
    
    [protocolData appendData:endData];
    
    //    NSLog(@"%@==84=====",protocolData);
    return protocolData;
}



#pragma mark-0x86
+ (NSData *)getFirwareVersionNumberWithMac:(NSData *)mac deviceType:(NSString *)type
{
    return [self getFirwareVersionNumberStitchingDataWithMac:mac deviceType:type];
}
+ (NSData *)getFirwareVersionNumberStitchingDataWithMac:(NSData *)mac deviceType:(NSString *)type
{

    NSString *macStr = [[Crypt hexEncode:mac] uppercaseStringWithLocale:[NSLocale currentLocale]];
    NSString *markStr = [macStr substringWithRange:NSMakeRange(0, 6)];
    BOOL isHF = [markStr isEqualToString:@"ACCF23"];

    PV_flag++;
    if (PV_flag  >= 0x7fff) {
        PV_flag = 0;
    }
    
    NSMutableData * protocolData = [[NSMutableData alloc] init];
    UInt8 preData[9];
    preData[0] = 0x01;
    
    preData[1] = 0x00;
    memcpy(preData + 2, [mac bytes], 6);
    UInt8 shadow[8];
    UInt8 *indexBytes = (UInt8 *)[[Util netDataFromUint16:PV_Number] bytes];
    
    shadow[0] = 0x00;
    memcpy(shadow + 1, indexBytes, 2);
    shadow[3] = isHF ? 0xCA : 0xCB;
    shadow[4] = isHF ? 0xFD : 0x92;
    shadow[5] = isHF ? 0x66 : 0xDA;
    shadow[6] = [type isEqualToString:@"11"] ? 0x11 : ([type isEqualToString:@"21"] ? 0x21 : 0x31);
    
    shadow[7] = 0x86;
    
    
    NSData *endData = [NSData dataWithBytes:shadow length:8] ;
    preData[8] = (UInt8)endData.length;
    
    [protocolData appendBytes:preData length:9];
    
    [protocolData appendData:endData];
    
    NSLog(@"%@======",protocolData);
    return protocolData;
    
}

#pragma mark-Timing 0x09 防盗

+ (NSData *)setAbsenceDataWith:(NSData *)mac WithFlag:(UInt8)flag  WithFromStateData:(NSData *)fromData WithToData:(NSData *)toData key:(NSData *)key deviceType:(NSString *)type

{
    return [self setAbsenceDataTodeviceWithMac:mac WithFlag:flag WithFromStateData:fromData WithToData:toData key:key deviceType:type];
}

+ (NSData *)setAbsenceDataTodeviceWithMac:(NSData *)mac WithFlag:(UInt8)flag WithFromStateData:(NSData *)fromData WithToData:(NSData *)toData  key:(NSData *)key deviceType:(NSString *)type

{
    NSString *macStr = [[Crypt hexEncode:mac] uppercaseStringWithLocale:[NSLocale currentLocale]];
    NSString *markStr = [macStr substringWithRange:NSMakeRange(0, 6)];
    BOOL isHF = [markStr isEqualToString:@"ACCF23"];

    NSMutableData * protocolData = [[NSMutableData alloc] init];
    UInt8 preData[9];
    preData[0] = 0x01;
    
    preData[1] = 0x00;
    
    
    PV_Number ++;
    if (PV_Number  >= 0x7fff) {
        PV_Number = 0;
    }
    
    
    memcpy(preData + 2, [mac bytes], 6);
    
    UInt8 shadow[18];
    UInt8 *indexBytes = (UInt8 *)[[Util netDataFromUint16:PV_Number] bytes];
    
    shadow[0] = 0x00;
    memcpy(shadow + 1, indexBytes, 2);
    shadow[3] = isHF ? 0xCA : 0xCB;
    shadow[4] = isHF ? 0xFD : 0x92;
    shadow[5] = isHF ? 0x66 : 0xDA;
    shadow[6] = [type isEqualToString:@"11"] ? 0x11 : ([type isEqualToString:@"21"] ? 0x21 : 0x31);
    
    shadow[7] = 0x09;
    shadow[8] = flag;
    memcpy(shadow + 9, [fromData bytes], 4);
    memcpy(shadow + 13, [toData bytes], 4);
    
    shadow[17] = 0x1E;
    
//    NSData * absenseData = [Crypt encryptData:[NSData dataWithBytes:shadow length:18] key:key];
    NSData *absenseData = [NSData dataWithBytes:shadow length:18];
    preData[8] = (UInt8)absenseData.length;
    
    [protocolData appendBytes:preData length:9];
    
    [protocolData appendData:absenseData];
    
    NSLog(@"endData=%@",protocolData);
    return protocolData;
    
}
//QueryTheftMode

#pragma mark-Timing 0x0A 防盗查询

+ (NSData *)getQueryTheftModeWith:(NSData *)mac key:(NSData *)key deviceType:(NSString *)type
{
    return [self getQueryTheftModeTodeviceWithMac:mac key:key deviceType:type];
}

+ (NSData *)getQueryTheftModeTodeviceWithMac:(NSData *)mac  key:(NSData *)key deviceType:(NSString *)type
{
    NSString *macStr = [[Crypt hexEncode:mac] uppercaseStringWithLocale:[NSLocale currentLocale]];
    NSString *markStr = [macStr substringWithRange:NSMakeRange(0, 6)];
    BOOL isHF = [markStr isEqualToString:@"ACCF23"];

    NSMutableData * protocolData = [[NSMutableData alloc] init];
    UInt8 preData[9];
    preData[0] = 0x01;
    preData[1] = 0x00;
    PV_Number ++;
    if (PV_Number  >= 0x7fff) {
        PV_Number = 0;
    }
    
    
    memcpy(preData + 2, [mac bytes], 6);
    
    UInt8 shadow[8];
    UInt8 *indexBytes = (UInt8 *)[[Util netDataFromUint16:PV_Number] bytes];
    
    shadow[0] = 0x00;
    memcpy(shadow + 1, indexBytes, 2);
    shadow[3] = isHF ? 0xCA : 0xCB;
    shadow[4] = isHF ? 0xFD : 0x92;
    shadow[5] = isHF ? 0x66 : 0xDA;
    shadow[6] = [type isEqualToString:@"11"] ? 0x11 : ([type isEqualToString:@"21"] ? 0x21 : 0x31);
    shadow[7] = 0x0A;
    
//    NSData * queryData = [Crypt encryptData:[NSData dataWithBytes:shadow length:8] key:key];
    NSData *queryData = [NSData dataWithBytes:shadow length:8];
    preData[8] = (UInt8)queryData.length;
    
    [protocolData appendBytes:preData length:9];
    
    [protocolData appendData:queryData];
    return protocolData;
}

#pragma mark- 0x12 查询倒计时  0x13 删除倒计时
+ (NSData *)getCountdownDataWith:(NSData *)mac key:(NSData *)key deviceType:(NSString *)type orderType:(NSString *)order
{
    return [self getGPIOCountdownDataWithMac:mac key:key deviceType:type orderType:order];
}

+ (NSData *)getGPIOCountdownDataWithMac:(NSData *)mac key:(NSData *)key deviceType:(NSString *)type orderType:(NSString *)order
{
    if (mac == nil) {
        return nil;
    }
    
    NSString *macStr = [[Crypt hexEncode:mac] uppercaseStringWithLocale:[NSLocale currentLocale]];
    NSString *markStr = [macStr substringWithRange:NSMakeRange(0, 6)];
    BOOL isHF = [markStr isEqualToString:@"ACCF23"];

    NSMutableData * protocolData = [[NSMutableData alloc] init];
    UInt8 preData[9];
    preData[0] = 0x01;
    
    preData[1] = 0x00;
    
    memcpy(preData + 2, [mac bytes], 6);
    
    PV_Number ++;
    if (PV_Number >=0x7fff) {
        PV_Number = 0;
    }
    
    UInt8 shadow[10];
    UInt8 *indexBytes = (UInt8 *)[[Util netDataFromUint16:PV_Number] bytes];
    shadow[0] = 0x00;
    memcpy(shadow + 1, indexBytes, 2);
    shadow[3] = isHF ? 0xCA : 0xCB;
    shadow[4] = isHF ? 0xFD : 0x92;
    shadow[5] = isHF ? 0x66 : 0xDA;
    shadow[6] = [type isEqualToString:@"11"] ? 0x11 : ([type isEqualToString:@"21"] ? 0x21 : 0x31);
    shadow[7] = [order isEqualToString:@"1"] ? 0x12 : 0x13;
    shadow[8] = 0x00;
    shadow[9] = 0x01;
    
//    NSData *encrptData = [Crypt encryptData:[NSData dataWithBytes:shadow length:10] key:key];
    
    NSData *encrptData = [NSData dataWithBytes:shadow length:10];
    
    
    preData[8] = (UInt8)encrptData.length;
    
    [protocolData appendBytes:preData length:9];
    
    [protocolData appendData:encrptData];
    
    return protocolData;
}

#pragma mark-Timing 0x11 设置倒计时
#pragma mark-
+ (NSData *)countdownDataWith:(NSData *)mac flag:(UInt8)flag Hour:(UInt8)hour  min:(UInt8)min  switchcc:(UInt8)on_off  isUDP:(BOOL)UDP  numberTaks:(UInt8)task  key:(NSData *)key deviceType:(NSString *)type
{
    return [self countdownDateToDevice:mac withflag:flag Hour:hour power:on_off min:min isUDP:UDP numberTaks:task key:key deviceType:type];
}

+ (NSData *)countdownDateToDevice:(NSData *)mac withflag:(UInt8)flag  Hour:(UInt8)hour power:(UInt8)on_off min:(UInt8)min isUDP:(BOOL)UDP numberTaks:(UInt8)Num  key:(NSData *)key deviceType:(NSString *)type
{
    if (mac == nil) {
        return nil;
    }
    
    NSString *macStr = [[Crypt hexEncode:mac] uppercaseStringWithLocale:[NSLocale currentLocale]];
    NSString *markStr = [macStr substringWithRange:NSMakeRange(0, 6)];
    BOOL isHF = [markStr isEqualToString:@"ACCF23"];

    NSMutableData * protocolData = [[NSMutableData alloc] init];
    UInt8 preData[9];
    preData[0] = 0x01;
    
    preData[1] = 0x00;
    
    PV_Number ++;
    
    if (PV_Number >=0x7fff) {
        PV_Number = 0;
    }
    
    memcpy(preData + 2, [mac bytes], 6);
    UInt8 *indexBytes = (UInt8 *)[[Util netDataFromUint16:PV_Number] bytes];
    
    int seconds = (int)(hour * 3600 + min * 60);
    
    UInt8 shadow[19];
    shadow[0] = 0x00;
    memcpy(shadow + 1, indexBytes, 2);
    shadow[3] = isHF ? 0xCA : 0xCB;
    shadow[4] = isHF ? 0xFD : 0x92;
    shadow[5] = isHF ? 0x66 : 0xDA;
    shadow[6] = [type isEqualToString:@"11"] ? 0x11 : ([type isEqualToString:@"21"] ? 0x21 : 0x31);
    
    shadow[7] = 0x11;
    shadow[8] = 0x00;
    shadow[9] = Num;// 组数
    shadow[10] = flag;
    
    shadow[11] = 0x00;
    shadow[12] = (seconds > 65535) ? 0x01 :0x00;
    UInt8 *remain_time = (UInt8 *)[[Util netDataFromUint16:(seconds > 65535) ? (seconds - 65536) : seconds] bytes];
    memcpy(shadow + 13, remain_time, 2);

    shadow[15] = 0x00;
    shadow[16] = 0x00;
    shadow[17] = on_off;//闹钟开关
    shadow[18] = 0xff;

    
//    NSData *encrptData = [Crypt encryptData:[NSData dataWithBytes:shadow length:19] key:key];
    
    NSData *encrptData = [NSData dataWithBytes:shadow length:19];
    
    preData[8] = (UInt8)encrptData.length;
    
    [protocolData appendBytes:preData length:9];
    
    [protocolData appendData:encrptData];
    
    NSLog(@"protocolData === %@ == ", protocolData);
    
    return protocolData;
}

#pragma mark - 0x0B 电量查询
+ (NSData *)getDeviceWattInfoWithMac:(NSData *)mac key:(NSData *)key
{
    return [self getWattInfoToDeviceWithMac:mac key:key];
}

+ (NSData *)getWattInfoToDeviceWithMac:(NSData *)mac  key:(NSData *)key
{
    NSMutableData * protocolData = [[NSMutableData alloc] init];
    UInt8 preData[9];
    preData[0] = 0x01;
    preData[1] = 0x00;
    PV_Number ++;
    if (PV_Number  >= 0x7fff) {
        PV_Number = 0;
    }
    
    NSString *macStr = [[Crypt hexEncode:mac] uppercaseStringWithLocale:[NSLocale currentLocale]];
    NSString *markStr = [macStr substringWithRange:NSMakeRange(0, 6)];
    BOOL isHF = [markStr isEqualToString:@"ACCF23"];

    memcpy(preData + 2, [mac bytes], 6);
    
    UInt8 shadow[8];
    UInt8 *indexBytes = (UInt8 *)[[Util netDataFromUint16:PV_Number] bytes];

    shadow[0] = 0x00;
    memcpy(shadow + 1, indexBytes, 2);
    shadow[3] = isHF ? 0xCA : 0xCB;
    shadow[4] = isHF ? 0xFD : 0x92;
    shadow[5] = isHF ? 0x66 : 0xDA;
    shadow[6] = 0x21;
    shadow[7] = 0x0B;
        
//    NSData * queryData = [Crypt encryptData:[NSData dataWithBytes:shadow length:8] key:key];
    NSData *queryData = [NSData dataWithBytes:shadow length:8];
    preData[8] = (UInt8)queryData.length;
    
    [protocolData appendBytes:preData length:9];
    
    [protocolData appendData:queryData];
    NSLog(@"%@",protocolData);
    
    return protocolData;
}

@end
