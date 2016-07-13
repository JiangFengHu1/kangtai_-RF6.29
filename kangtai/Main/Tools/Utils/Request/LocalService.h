//
//
/**
 * Copyright (c) www.bugull.com
 */
//
//

#import <Foundation/Foundation.h>
#import "SocketOperation.h"
#import "Gogle.h"
#define LocalServiceInstance    [LocalService sharedInstance]

@protocol LocalDelegate <NSObject>

- (void)localConnectFinished:(BOOL)succeed msg:(NSString *)msg;

- (void)localLostConnectionWithDevice:(Device *)device;

- (void)localDidConnectDevice:(Device *)device;

- (void)localUDPClosed;

@end

@interface LocalService : NSObject

@property(strong,nonatomic)NSMutableArray *deviceArray;

+ (LocalService *)sharedInstance;

- (BOOL)isConnected;

#pragma mark-GCDSocketUDPDelegate open

- (void)connect;

#pragma mark-GCDSocketUDPDelegate close

- (void)disconnect;

- (SocketOperation *)sendProtocol:(NSData *)protocol host:(NSString *)host complete:(Complete)complete;

- (void)getDeviceMacAddressip:(NSString *)Mac deviceType:(NSString *)type;

- (BOOL)isConnectedDevice:(Device *)device;

#pragma mark-
#pragma mark-han

//搜素设备23
- (void)discoverDevices:(id)observer deviceType:(NSString *)type;

#pragma mark-----
- (void)updataIPWith23_withMac:(NSData *)mac;
- (void)addDeviceToFMDBWithisAdd:(BOOL)isAdd WithMac:(NSData *)mac;

- (void)updataIPWith23_Energy_withMac:(NSData *)mac;
- (void)addEnergyDeviceToFMDBWithisAdd:(BOOL)isAdd WithMac:(NSData *)mac;

- (void)updataIPWith23_RF_withMac:(NSData *)mac;
- (void)addRFDeviceToFMDBWithisAdd:(BOOL)isAdd WithMac:(NSData *)mac;

#pragma mark-
#pragma mark- 0x24
- (void)sendToUdpLockWithData:(NSData *)data lock:(BOOL)islock isHost:(NSString *)host key:(NSData *)key deviceType:(NSString *)type;

#pragma mark-
#pragma mark- 0x01 GPIO
- (void)setGPIOCloseOrOpenWithDeciceMac:(NSData *)data index:(BOOL)indx host:(NSString *)host key:(NSData *)key deviceType:(NSString *)type;
#pragma mark-0x02 GPIO

- (void)queryGPIOEventToMac:(NSData *)mac withhost:(NSString *)host deviceType:(NSString *)type;
#pragma mark-
#pragma mark-0x03 GPIO
- (void)setGPIOaleamWithDeciceMac:(NSData *)mac index:(BOOL)indx host:(NSString *)host socketType:(BOOL)type  flag:(UInt8)flag Hour:(UInt8)hour min:(UInt8)min numberTaks:(UInt8)task key:(NSData *)key deviceType:(NSString *)Type
;

#pragma mark-
#pragma mark-0x04 GPIO
- (void)getGPIOTimerInfoDeviceMac:(NSData *)mac host:(NSString *)host key:(NSData *)key deviceType:(NSString *)type;

#pragma mark-
#pragma mark-0x05 GPIO
- (void)deleteGPIOTimerDeviceMac:(NSData *)mac host:(NSString *)host Num:(UInt8)number deviceType:(NSString *)type;

#pragma mark-
#pragma mark-0x0D 433
- (void)set433CloseOrOpenWithDeciceMac:(NSData *)data index:(BOOL)indx host:(NSString *)host adderss:(NSData *)adders type:(NSString *)type timerDic:(NSDictionary *)dic;

#pragma mark-
#pragma mark-0x62

- (void)getDeviceInfoToMac:(NSData *)mac WithHost:(NSString *)host deviceType:(NSString *)type;

#pragma mark-
#pragma mark-0x65

- (void)firmwareUpgradeToMac:(NSData *)mac WithHost:(NSString *)host WithUrlLen:(UInt8)len WithUrl:(NSData *)urlData key:(NSData *)key deviceType:(NSString *)type;


#pragma mark-0x09 防盗
- (void)setAbseceWithDeciceMac:(NSData *)data index:(BOOL)indx host:(NSString *)host FromStateData:(NSData *)from ToData:(NSData *)ToData key:(NSData *)key deviceType:(NSString *)type;


#pragma mark-0x0A 防盗查询
- (void)getQueryTheftModeDeciceLocalMac:(NSData *)data host:(NSString *)host  key:(NSData *)key deviceType:(NSString *)type;

#pragma mark-0x11 设置倒计时
- (void)setGPIOCountdownWithDeciceMac:(NSData *)mac index:(BOOL)indx host:(NSString *)host socketType:(BOOL)type  flag:(UInt8)flag Hour:(UInt8)hour min:(UInt8)min numberTaks:(UInt8)task key:(NSData *)key deviceType:(NSString *)Type;

#pragma mark-
#pragma mark-0x12 查询倒计时
- (void)getGPIOCountdownDeviceMac:(NSData *)mac host:(NSString *)host key:(NSData *)key deviceType:(NSString *)type orderType:(NSString *)order;

#pragma mark-0x0B 电量查询
- (void)getQueryDeviceWattInfoWithLocalMac:(NSData *)data host:(NSString *)host  key:(NSData *)key;

#pragma mark-_
- (void)connectDevice:(Device *)device;
- (void)connectDevices;
- (void)deleteDevice:(Device *)device;

- (void)stopScan;
@end
