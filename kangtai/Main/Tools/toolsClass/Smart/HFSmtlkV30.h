//
//
/**
 * Copyright (c) www.bugull.com
 */
//
//

#import <Foundation/Foundation.h>

@class GCDAsyncUdpSocket;

@protocol SmtlkV30Delegate  <NSObject>
@required//这个可以是required，也可以是optional

/*SmartLink 发送结束后（并非整个SmartLink流程结束），回调函数。建议在第一次收到这个回调时，再调用SmtlkV30StartWithKey:函数
 *完成2次发送流程*/
- (void)SmtlkV30Finished;
/*SmartLink成功收到模块回复时，回调函数。参数为模块MAC地址*/
- (void)SmtlkV30ReceivedRspMAC:(NSString *)mac fromHost:(NSString *)host;

@end

@interface HFSmtlkV30 : NSObject
{
    id<SmtlkV30Delegate> delegate;
    GCDAsyncUdpSocket *udpSock;
    
    NSString *udpHost;
    uint16_t udpLocalPort;
    uint16_t udpRmPort;
    
    BOOL started;
    NSInteger sendLoop;
    NSInteger sendTimes;
    NSString *sendKey;
    Byte sendData[600];

    NSTimer *timer;
}

/*HFSmtlkV30初始化函数，参数为Delegate的类 请在每次进行smartlink的时候调用*/
- (id)initWithDelegate:(id)cls;
/*SmartLink开始发送密码，只发密码，模块会从收到的数据中提取出路由器的SSID*/
- (void)SmtlkV30StartWithKey:(NSString *)key;
/*停止发送 本接口会释放当前正在使用的socket 所以在下次使用smartlink的时候 需要调用 initWithDelegate:(id)cls 进行重新建立socket*/
- (void)SmtlkV30Stop;
/*发送完成后，用这个函数发送查询命令，模块收到这个命令后会回复MAC地址*/
- (void)SendSmtlkFind;

@end
