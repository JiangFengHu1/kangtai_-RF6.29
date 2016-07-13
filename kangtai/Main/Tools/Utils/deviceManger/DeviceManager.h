//
//
/**
 * Copyright (c) www.bugull.com
 */
//
//

#import <Foundation/Foundation.h>
#import "SocketOperation.h"
#import "PanelSocket.h"//设备信息model类

#define DeviceManagerInstance  [DeviceManager sharedInstance]
#define NewIndex                [DeviceManagerInstance newIndex]
#define CurrentIndex            [DeviceManagerInstance getIndex]

@protocol DeviceManagerDelegate <NSObject>

- (void)newDevicesDiscovered:(NSArray *)newDevices;

@end

@interface DeviceManager : NSObject

@property (strong,nonatomic) NSMutableArray * devices;


@property (strong,nonatomic)NSMutableDictionary *devicesDic;

@property (weak,nonatomic) id delegate;

+ (DeviceManager *)sharedInstance;
//链接状态改变
- (void)connectionStatusChanged;

//链接TCP和UDP口
- (void)buildConnection;
//断开链接
- (void)destroyConnection;
//保存设备信息
- (void)saveDevices;
//根据数据返回设备信息
- (Device *)deviceFromResponse:(NSData *)response;


- (NSMutableDictionary *)getlocalDeviceDictary;

//过程
- (BOOL)processResult:(OperationResult *)result;
//获得网络状态
- (ReachabilityNetworkStatus)networkStatus;

//获得下标
- (UInt16)getIndex;
//获得新的下标
- (UInt16)newIndex;
//GPIO口0x02 查询 GPIO 状态
- (SocketOperation *)queryAllGPIO:(Device *)device complete:(Complete)complete;
//当设备 GPIO 的状态发生改变时,Device 会主动上报此事件给用户
- (SocketOperation *)subScribeAllGPIO:(BOOL)sub device:(Device *)device complete:(Complete)complete;
//0x01 设置 GPIO 状态
- (SocketOperation *)setGPIO:(Device *)device socket:(PanelSocket *)socket on:(BOOL)on complete:(Complete)complete;
//设备锁定
//- (SocketOperation *)lockOrUnlockDevice:(Device *)device complete:(Complete)complete;

- (void)newDevicesDiscovered:(NSArray *)newDevices;


#pragma mark-
#pragma mark-0x0D 433

- (void)set433TodeviceWithMacString:(NSData *)mac WithHost:(NSString *)host  Open:(BOOL)onOrOff withArc4Address:(NSString *)address  deviceType:(NSString *)type  With:(NSString *)localString timerDic:(NSDictionary *)dic;


- (void)setsliderTodeviceid:(NSData *)mac WithHost:(NSString *)host Open:(BOOL)onOrOff withArc4Address:(NSString *)address  deviceType:(BOOL)isDimmerValue  value:(UInt8)values  With:(NSString *)localString;


#pragma mark-
#pragma mark-0x04 GPIO
- (void)getTimeringWith:(NSData *)mac inUDPHost:(NSString *)host key:(NSData *)key With:(NSString *)localString deviceType:(NSString *)type;
#pragma mark-
#pragma mark-0x03 GPIO

- (void)setTimeringAlermWithMacString:(NSData *)mac Withhost:(NSString *)host flag:(UInt8)flag Hour:(UInt8)hour min:(UInt8)min TaskCount:(UInt8)task Switch:(BOOL)ON_OFF key:(NSData *)key  With:(NSString *)localString deviceType:(NSString *)type;


#pragma mark-0x02
- (void)queryGPIOEventToMacDevice:(NSData *)mac withHost:(NSString *)host withloaclContent:(NSString *)localContent deviceType:(NSString *)type;

#pragma mark-
#pragma mark-0x05 GPIO

- (void)deleteDeviceTimeingWith:(NSData *)mac Withhost:(NSString *)host  InToNum:(UInt8)num With:(NSString *)localContent deviceType:(NSString *)type;

#pragma mark-
#pragma mark-0x09 防盗

- (void)absenceToDeviceWith:(NSData *)mac Withhost:(NSString *)host  ToOpen:(BOOL)open WithState:(NSData *)from WithTodate:(NSData *)toDate key:(NSData *)key With:(NSString *)localContent deviceType:(NSString *)type;

#pragma mark-0x11 设置倒计时
- (void)setCountdownWithMacString:(NSData *)mac Withhost:(NSString *)host flag:(UInt8)flag Hour:(UInt8)hour min:(UInt8)min TaskCount:(UInt8)task Switch:(BOOL)ON_OFF key:(NSData *)key  With:(NSString *)localString deviceType:(NSString *)type;

#pragma mark-0x12 查询倒计时
- (void)getCountdownWith:(NSData *)mac inUDPHost:(NSString *)host key:(NSData *)key With:(NSString *)localString deviceType:(NSString *)type orderType:(NSString *)order;

#pragma mark-
#pragma mark-0x0A 防盗查询

- (void)getQueryTheftModeDeviceMToDeviceWith:(NSData *)mac Withhost:(NSString *)host key:(NSData *)key With:(NSString *)localContent deviceType:(NSString *)type;

#pragma mark-0x0B 电量查询
- (void)getQueryDeviceWattInfoWith:(NSData *)mac Withhost:(NSString *)host key:(NSData *)key With:(NSString *)localContent;

#pragma mark-
#pragma mark-0x62

- (void)getDeviceInfoToMac:(NSData *)mac With:(NSString *)localContent WIthHost:(NSString *)host deviceType:(NSString *)type;


#pragma mark-
#pragma mark-0x65

- (void)firmwareUpgradeToDeviceMessageMac:(NSData *)mac WIthHost:(NSString *)host WithUrlLen:(UInt8)len WithUrl:(NSData *)urlData key:(NSData *)key With:(NSString *)localContent deviceType:(NSString *)type;

@end
