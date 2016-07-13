//
//
/**
 * Copyright (c) www.bugull.com
 */
//
//

#ifndef kangtai_Gogle_h
#define kangtai_Gogle_h

//适配
#define iOS_version [[[UIDevice currentDevice]systemVersion] floatValue]
#define iOS7 (([[[UIDevice currentDevice]systemVersion] floatValue] >=7.0)?(YES):(NO))
#define barViewHeight (([[[UIDevice currentDevice]systemVersion] floatValue] >=7.0) ? 64: 44)

#define ISiPhone_5 (([UIScreen instancesRespondToSelector:@selector(currentMode)]?CGSizeEqualToSize(CGSizeMake(640, 1136),[[UIScreen mainScreen] currentMode].size):NO))

#define ORIGINAL_MAX_WIDTH 640.0f
#define kScreen_Height ([UIScreen mainScreen].bounds.size.height)
#define kScreen_Width  ([UIScreen mainScreen].bounds.size.width)
#define widthScale  (float)kScreen_Width / 320
#define heightScale  (float)kScreen_Height / 480
#define iOS_6_height ((iOS_version < 7.0) ? 20 : 0)

//邮箱验证
#define EMAILREGEX @"(?:[A-Za-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"@"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"@"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"@"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"@"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"@"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"@"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
//判断邮箱是否有效
#define IS_AVAILABLE_EMAIL(emailString) [[NSPredicate predicateWithFormat:@"SELF MATCHES %@", EMAILREGEX] evaluateWithObject:emailString]

#define RGBA(r,g,b,a) [UIColor colorWithRed:(float)r/255.0f green:(float)g/255.0f blue:(float)b/255.0f alpha:a]
#define RGB(r, g, b)                        [UIColor colorWithRed:(r)/255.f green:(g)/255.f blue:(b)/255.f alpha:1.f]

#define DEFAULT_VOID_COLOR [UIColor whiteColor]


//
#define REQUEST_DATA   @"data"
#define PATH_OF_DOCUMENT    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]

#define dbPath [PATH_OF_DOCUMENT stringByAppendingPathComponent:@"thedb.sqlite"]


//U 口负载均衡服务器
#define AppBalanceHost      @"cloud.kangtai.com.cn"
#define AppBalancePort      29531 // U口端口

#define TopLen              9

#define HEnuS_Timer       @"xmzbc"


#define SERVER_KEY  @"keyvalues"
#define BroHost       @"host"

#define BroPort      29533


#import "MMProgressHUD.h"
#import "MMProgressHUDOverlayView.h"
#import "UIImageView+WebCache.h"


//等待动画
#define DEGREES_TO_RADIANS(__ANGLE) ((__ANGLE) * M_PI / 180.0)
#define RADIANS_TO_DEGREES(__RADIANS) ((__RADIANS) * 180 / M_PI)


//超时时间
#define UDPTimeout          10
#define TCPTimeout          60

#define MainFontColor       RGBColor(0x555555)
#define GrayFontColor       RGBColor(0xaeaeae)
#define GreenFontColor      RGBColor(0xb0c93b)
#define OrangeFontColor     RGBColor(0xfa830d)
#define BackGroundColor     RGBColor(0xf0f0f0)


/*    ----- 宏定义 -----*/


#define IS_LEFT_SHOW ""
#define UI_NAVIGATION_BAR_HEIGHT        44
#define UI_TOOL_BAR_HEIGHT              44
#define UI_TAB_BAR_HEIGHT               49
#define UI_STATUS_BAR_HEIGHT            20
#define BroadcastHost [[NSUserDefaults standardUserDefaults] objectForKey:@"broadcastAddress"]
#define DevicePort          28530 // L口(UDP)端口

//#define PV_NUMBER      0

#define High                0xff
#define Low                 0x00

typedef NS_ENUM(UInt8, BitSwitch){
    kBit8On = 0x01 << 7,
    kBit7On = 0x01 << 6,
    kBit6On = 0x01 << 5,
    kBit5On = 0x01 << 4,
    kBit4On = 0x01 << 3,
    kBit3On = 0x01 << 2,
    kBit2On = 0x01 << 1,
    kBit1On = 0x01,
    kBitAllOn = 0xff,
    kBitAllOff = 0x00
};

typedef NS_ENUM(NSInteger,long_out) {
    long_out_ON = 0,
    long_out_OFF = 1
};


#define OPERARRAY_INFO  @"mutableArray"

#define OPERAbsence_INFO  @"absence"


#define OPER_CLOSE_INFO  @"GPIOState"
#define OPEN_CLOSE_INFO  @"IOState"
#define WATT_INFO  @"DeviceWatt"

//interval

#define INTERVAL__UINT16  @"interval"

#define OPERATION_INFO  @"dictaryArray"


#define ON_LINE__OFFLINE  @"On-line"

//关闭某一位；
#define kBitTurnOff(aBitFlag)  (aBitFlag ^ kBitAllOn)


#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <SystemConfiguration/CaptiveNetwork.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <CFNetwork/CFNetwork.h>
#import <QuartzCore/QuartzCore.h>

#import "Device.h"
#import "NetworkUtil.h"
#import "LocalService.h"
#import "RemoteService.h"
#import "Reachability.h"
#import "UIView+Convenient.h"
#import "Util.h"
#import "DateUtil.h"

#import "RFDataBase.h"
#import "DataBase.h"
#import "EC_UIManager.h"
#import "MJRefresh.h"
#import "UITapGestureRecognizer+tag.h"

/*HTTP*/
#define KEY_USERMODEL @"myUserInfo"//用户是否登陆
#define KEY_PASSWORD @"myUserPWS"//用户密码


#import "HTTPService.h"

#define AccessKey @"K769W08JZ07VS3FR3941WB3PC945LT58"//AccessKey

#define HTTP_URL @"http://cloud.kangtai.com.cn"

#define SignUpURL @"http://cloud.kangtai.com.cn/api/account/signup"//注册

#define LoginURL @"http://cloud.kangtai.com.cn/api/account/login"//登录

#define ChangePSURL @"http://cloud.kangtai.com.cn/api/account/password/change"//修改密码

#define ForgetPSURL @"http://cloud.kangtai.com.cn/api/account/password/forget"//忘记密码

#define GetwifiInfoURL @"http://cloud.kangtai.com.cn/api/device/wifi/list"//获取wifi列表

#define EditWifiURL @"http://cloud.kangtai.com.cn/api/device/wifi/edit"//编辑 WiFi 设备

#define DeleteWifiURL @"http://cloud.kangtai.com.cn/api/device/wifi/delete"//删除 WiFi 设备

#define GetRFInfoURL @"http://cloud.kangtai.com.cn/api/device/rf/list"//获取 RF 设备列表

#define EditRFURL @"http://cloud.kangtai.com.cn/api/device/rf/edit"//编辑 RF 设备

#define DeleteRFURL @"http://cloud.kangtai.com.cn/api/device/rf/delete"// 删除 RF 设备

#define UploadURL @"http://cloud.kangtai.com.cn/device/image/upload"//上传图片

#define UploadedFileImageUrl @"http://cloud.kangtai.com.cn/UploadedFile"//下载图片

#define dayEnergyInfoURL @"http://cloud.kangtai.com.cn/api/device/watt"// 24小时功率

#define monthEnergyInfoURL @"http://cloud.kangtai.com.cn/api/device/energy/day"// 30天功率

#define yearEnergyInfoURL @"http://cloud.kangtai.com.cn/api/device/energy/month"// 12各月功率

#endif
