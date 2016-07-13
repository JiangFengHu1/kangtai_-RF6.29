//
//
/**
 * Copyright (c) www.bugull.com
 */
//
//


#import <Foundation/Foundation.h>
#import "AppDelegate.h"
//c++ 获取mac地址
#include <sys/socket.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>

#import "getgateway.h"
#import <arpa/inet.h>
#import <netdb.h>
#import <netinet/in.h>
#import <netinet6/in6.h>
#import <ifaddrs.h>
#import <SystemConfiguration/SCNetworkReachability.h>
#include <sys/socket.h>

//#import "MBProgressHUD.h"
#import <CommonCrypto/CommonDigest.h>//C++/MD5
@interface Util : NSObject


//#pragma mark-MBProgressHUD
//
//-(void)HUDShowHideText:(NSString *)text delay:(NSTimeInterval)delay;    //只显示text，几秒后隐藏，适合用于显示弹出信息。
//
////不带Hide的Show方法，必须跟HUDHide方法配合使用，或者再新开一个show方法（会自动hide之前的HUD）
//-(void)HUDShowText:(NSString *)text;    //显示indicator+文本,不自动隐藏。
//
//-(void)HUDHide;                         //隐藏，跟上面的方法配合，在任务完成后使用，适合用于显示任务开始和结束
//


//获得对象
+ (Util *)getUtitObject;

//获取当前所在国家/区域
+ (NSString *)getCurrentCountry;

//字符串转颜色
+ (UIColor *) colorWithHexString: (NSString *) stringToConvert;

//去掉空格
+(NSString *) stringByRemoveTrim:(NSString *)str;

//不转webview打不开啊。。
+(NSString *)getWebViewUrlStr:(NSString *)urlStr;

//NSString UTF8转码
+(NSString *)getUTF8Str:(NSString *)str;

//根据文字、字体、文字区域宽度，得到文字自适应的宽高
+ (CGSize)sizeForText:(NSString*)sText Font:(CGFloat)font forWidth:(CGFloat)fWidth;

//view根据原来的frame做调整，重新setFrame，fakeRect的4个参数如果<0，则用原来frame的相关参数，否则就用新值。
+ (void) View:(UIView *)view ReplaceFrameWithRect:(CGRect) fakeRect;

//view根据原来的bounds做调整，重新setBounds，fakeRect的4个参数如果<0，则用原来bounds的相关参数，否则就用新值。
+ (void) View:(UIView *)view ReplaceBoundsWithRect:(CGRect) fakeRect;

//根据@"#eef4f4"得到UIColor
+ (UIColor *) uiColorFromString:(NSString *) clrString;
+ (UIColor *) uiColorFromString:(NSString *) clrString alpha:(double)alpha;

//将原始图片draw到指定大小范围，从而得到并返回新图片。能缩小图片尺寸和大小
+ (UIImage*)ScaleImage:(UIImage*)image ToSize:(CGSize)newSize;
//将图片保存到document目录下
+ (void)saveDocImage:(UIImage *)tempImage WithName:(NSString *)imageName;

//将浮点数转换为NSString，并设置保留小数点位数
+ (NSString *)getStringFromFloat:(float) f withDecimal:(int) decimalPoint;
+ (int) defaultRandom;

+ (UIAlertView *)showAlertWithTitle:(NSString *)title msg:(NSString *)msg;
#pragma mark-scoket的数据转化
+ (UInt16)uint16FromNetData:(NSData *)data;

+ (UInt32)uint32FromNetData:(NSData *)data;



////网络data 转换为 2个字节的整数
//+ (UInt16)uint16FromNetData:(NSData *)data
//{
//    return ntohs(*((UInt16 *)[data bytes]));
//}
////网络data 转换为 4个字节的整数
//+ (UInt32)uint32FromNetData:(NSData *)data
//{
//    return ntohl(*((UInt32 *)[data bytes]));
//}
//+ (void)saveLocalDeviceArray:(NSArray *)deviceArray;


+ (NSString *)macString:(NSData *)mac;

+ (void)setFont:(UILabel *)label;
+ (void)setFontFor:(NSArray *)labelArray;
//获得window
+ (UIWindow *)getAppWindow;

//获取app版本
+ (NSString *)getAppVersion;
//获取app名字
+ (NSString *)getAppName;
//获得ssid
+ (NSString *)getCurrentWifiName;
//字符串转化data
- (NSData *)macStrTData:(NSString *)str;

- (NSString *)getMacStringWith:(NSString *)mac;

+ (NSString *)getMacAddress;

+ (NSMutableArray *)getLocalDeviceArray;

+ (NSData *)netDataFromUint16:(UInt16)number;

+ (void)saveLocalDeviceArray:(NSArray *)deviceArray;

+ (AppDelegate *)getAppDelegate;


//获得本地device字典
+ (NSMutableDictionary *)getlocalDeviceDictary;


#pragma mark-
#pragma mark-转换随机433地址 只适合本项目使用
+ (NSData *)getRFAddressWith:(NSString *)string;


//数组排序临时方法

+ (NSMutableArray *)invertedOrder:(NSMutableArray *)timeArray;

+ (UIImage *)getImageFile:(NSString *)imagePath;

+ (void)deleteCancleImageFileWithPath:(NSString *)path;

#pragma mark-md5

+ (NSString *)getPassWordWithmd5:(NSString *)str;

//数组去重复对象
+ (NSMutableArray *)arraytoreToArray:(NSMutableArray *)aArray;

//获取图片路径
+ (NSString *)getFilePathWithImageName:(NSString *)imageName;


+ (NSString *)getUUID;

+ (NSString *) getBroadcastAddress;

+ (NSString *)hexStringFromString:(NSString *)string;

@end
