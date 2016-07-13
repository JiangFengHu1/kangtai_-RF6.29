//
//
/**
 * Copyright (c) www.bugull.com
 */
//
//

#import "Util.h"
@interface Util ()
//{
//    MBProgressHUD *HUD;
//}
@end
static Util *class = nil;
@implementation Util


- (void)dealloc
{
//    HUD = nil;
}
#pragma mark - HUD show and shide

//-(void)HUDShowHideText:(NSString *)text delay:(NSTimeInterval)delay{
//    [HUD hide:YES];
//    HUD = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
//	HUD.mode = MBProgressHUDModeText;
//	HUD.labelText = text;
//    HUD.offsetY = -35.f;
//	HUD.margin = 40.f;
//	HUD.removeFromSuperViewOnHide = YES;
//	[HUD hide:YES afterDelay:delay];
//}
//
////不带Hide的show方法，必须跟HUDHide方法配合使用，或者再新开一个show方法（会自动hide之前的HUD）
//-(void)HUDShowText:(NSString *)text{
//    [HUD hide:YES];
//    HUD = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
//	HUD.labelText = text;
//    HUD.offsetY = -35.f;
//	HUD.margin = 10.f;
//	HUD.removeFromSuperViewOnHide = YES;
//}
//
//-(void)HUDHide{
//    [HUD hide:YES];
//}
//
//#pragma mark MBProgressHUDDelegate methods
//- (void)hudWasHidden:(MBProgressHUD *)hud {
//	HUD = nil;
//}



#pragma mark-utit
+ (Util *)getUtitObject
{
    if (class == nil) {
        class = [[Util alloc] init];
    }
    return class;
}

//NSString UTF8转码
+(NSString *)getUTF8Str:(NSString *)str{
    return [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

//不转webview打不开啊。。
+(NSString *)getWebViewUrlStr:(NSString *)urlStr{
    return [urlStr stringByAddingPercentEscapesUsingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)];
}

//获取当前所在国家/区域
+ (NSString *)getCurrentCountry
{
    
    NSLocale *currentLocale = [NSLocale currentLocale];
    
    NSLog(@"Country Code is %@", [currentLocale objectForKey:NSLocaleCountryCode]);
    
    return  [currentLocale objectForKey:NSLocaleCountryCode];
}

//去掉空格
+(NSString *) stringByRemoveTrim:(NSString *)str{
    return [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

//根据文字、字体、文字区域宽度，得到文字区域高度
+ (CGSize)sizeForText:(NSString*)sText Font:(CGFloat)font forWidth:(CGFloat)fWidth{
    CGSize szContent = [sText sizeWithFont:[UIFont systemFontOfSize:font] constrainedToSize:CGSizeMake(fWidth, CGFLOAT_MAX)
                             lineBreakMode:NSLineBreakByWordWrapping];
    return  szContent;
}

//根据文字信息和url，得到最终的文字message（总长度不超过140）。 url可以为nil。
-(NSString *)getMessageWithText:(NSString *)text url:(NSString *)url{
    if (text == nil && url == nil) {
        return nil;
    }
    if (text == nil) {
        return url;
    }
    
    //text != nil
    NSMutableString *messageText  = [[NSMutableString alloc] init];
    if (url == nil) {
        int trimlength =  (int)[text length]- 140;
        if (trimlength > 0) {
            [messageText appendFormat:@"%@",[text substringWithRange:NSMakeRange(0, [text length]-trimlength)]];
        }else{
            [messageText appendFormat:@"%@",text];
        }
//        NSLog(@"%u%@",[messageText length],messageText);
        return messageText;
    }else{
        int trimlength =  (int)[text length] + (int)[url length] - 140;
        if (trimlength > 0) {
            [messageText appendFormat:@"%@%@",[text substringWithRange:NSMakeRange(0, [text length]-trimlength)],url];
        }else{
            [messageText appendFormat:@"%@%@",text,url];
        }
//        NSLog(@"%u%@",[messageText length],messageText);
        return messageText;
    }
    
}

//view根据原来的frame做调整，重新setFrame，fakeRect的4个参数如果<0，则用原来frame的相关参数，否则就用新值。
+ (void) View:(UIView *)view ReplaceFrameWithRect:(CGRect) fakeRect{
    CGRect frame = view.frame;
    CGRect newRect;
    newRect.origin.x = fakeRect.origin.x > 0 ? fakeRect.origin.x : frame.origin.x;
    newRect.origin.y = fakeRect.origin.y > 0 ? fakeRect.origin.y : frame.origin.y;
    newRect.size.width = fakeRect.size.width > 0 ? fakeRect.size.width : frame.size.width;
    newRect.size.height = fakeRect.size.height > 0 ? fakeRect.size.height : frame.size.height;
    [view setFrame:newRect];
}

//view根据原来的bounds做调整，重新setBounds，fakeRect的4个参数如果<0，则用原来bounds的相关参数，否则就用新值。
+ (void) View:(UIView *)view ReplaceBoundsWithRect:(CGRect) fakeRect{
    CGRect bounds = view.bounds;
    CGRect newRect;
    newRect.origin.x = fakeRect.origin.x > 0 ? fakeRect.origin.x : bounds.origin.x;
    newRect.origin.y = fakeRect.origin.y > 0 ? fakeRect.origin.y : bounds.origin.y;
    newRect.size.width = fakeRect.size.width > 0 ? fakeRect.size.width : bounds.size.width;
    newRect.size.height = fakeRect.size.height > 0 ? fakeRect.size.height : bounds.size.height;
    [view setBounds:newRect];
}



//根据@"#eef4f4"得到UIColor
+ (UIColor *) uiColorFromString:(NSString *) clrString
{
	return [Util uiColorFromString:clrString alpha:1.0];
}

//将原始图片draw到指定大小范围，从而得到并返回新图片。能缩小图片尺寸和大小
+ (UIImage*)ScaleImage:(UIImage*)image ToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

//将图片保存到document目录下
+ (void)saveDocImage:(UIImage *)tempImage WithName:(NSString *)imageName
{
    NSData* imageData = UIImageJPEGRepresentation(tempImage, 0.4);
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:imageName];
    [imageData writeToFile:fullPathToFile atomically:NO];
}

+ (UIColor *) uiColorFromString:(NSString *) clrString alpha:(double)alpha
{
	if ([clrString length] == 0) {
		return [UIColor clearColor];
	}
	
	if ( [clrString caseInsensitiveCompare:@"clear"] == NSOrderedSame) {
		return [UIColor clearColor];
	}
	
	if([clrString characterAtIndex:0] == 0x0023 && [clrString length]<8)
	{
		const char * strBuf= [clrString UTF8String];
		
		int iColor = (int)(strtol((strBuf+1), NULL, 16));
		typedef struct colorByte
		{
			unsigned char b;
			unsigned char g;
			unsigned char r;
		}CLRBYTE;
		CLRBYTE * pclr = (CLRBYTE *)&iColor;
		return [UIColor colorWithRed:((double)pclr->r/255) green:((double)pclr->g/255) blue:((double)pclr->b/255) alpha:alpha];
	}
	return [UIColor blackColor];
}

//字符串转颜色
+ (UIColor *) colorWithHexString: (NSString *) stringToConvert
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    
    if ([cString length] < 6)
        return DEFAULT_VOID_COLOR;
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return DEFAULT_VOID_COLOR;
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

//将浮点数转换为NSString，并设置保留小数点位数
+ (NSString *)getStringFromFloat:(float) f withDecimal:(int) decimalPoint{
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:kCFNumberFormatterDecimalStyle];
    [numberFormatter setMaximumFractionDigits:decimalPoint];

    return  [numberFormatter stringFromNumber:[NSNumber numberWithFloat:f]];
}

+ (int) randomFromMin:(int)min ToMax:(int)max
{
    int randNum = arc4random() % (max-min) + min; //create the random number.
    return randNum;
}

+ (int) defaultRandom
{
    return [self randomFromMin:1 ToMax:9999];
}
#pragma mark-scoket的数据转化

+ (UInt16)uint16FromNetData:(NSData *)data
{
    return ntohs(*((UInt16 *)[data bytes]));
}

+ (UInt32)uint32FromNetData:(NSData *)data
{
    return ntohl(*((UInt32 *)[data bytes]));
}


+ (void)setFont:(UILabel *)label
{
    //@"AvantGardeITCbyBT-Medium"
    [label setFont:[UIFont fontWithName:@"AvantGardeITCbyBT-Book" size:label.font.pointSize]];
}

+ (void)setFontFor:(NSArray *)labelArray
{
    for (UILabel * label in labelArray)
    {
        [self setFont:label];
    }
}
//mac地址 转换
+ (NSString *)macString:(NSData *)mac
{
//    NSLog(@"%@");
    if (mac.length == 12)
    {
        NSMutableString * result = [NSMutableString string];
        Byte * bytes = (Byte *)mac.bytes;
        for (NSInteger index = 0; index < mac.length; index ++)
        {
            [result appendFormat:@"%02x:",bytes[index]];
        }
        return [result substringToIndex:result.length - 1];
    }
    return @"";
}

- (NSString *)getMacStringWith:(NSString *)mac
{
    
    NSString *temp = nil;
    for (int i = 0; i < mac.length; i++) {
       NSString *str = [mac substringFromIndex:2];
        
        [temp stringByAppendingString:[NSString stringWithFormat:@"%@:",str]];
    }
    return temp;
}


+ (UIWindow *)getAppWindow
{
    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    if (!window) {
        window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    }
    return window;
}

//获取到当前wifi名字
+ (NSString *)getCurrentWifiName
{
    NSString *wifiName = NSLocalizedString(@"Not Found", nil);
    CFArrayRef myArray = CNCopySupportedInterfaces();
    if (myArray != nil) {
        CFDictionaryRef myDict = CNCopyCurrentNetworkInfo(CFArrayGetValueAtIndex(myArray, 0));
        if (myDict != nil) {
            NSDictionary *dict = (NSDictionary*)CFBridgingRelease(myDict);
            wifiName = [dict valueForKey:@"SSID"];
            NSLog(@"qqq== %@ ==", dict);
            
        }
    }
    //    NSLog(@"wifiName:%@", wifiName);
    return wifiName;
}
+ (NSString *)getAppVersion
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
}

+ (NSString *)getAppName
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
}


//警告框
+ (UIAlertView *)showAlertWithTitle:(NSString *)title msg:(NSString *)msg
{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:NSLocalizedString(@"Confirm",nil ) otherButtonTitles:nil];
    [alert show];
    return alert;
}
//delegate对象
+ (AppDelegate *)getAppDelegate
{
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

- (NSData *)macStrTData:(NSString *)str
{
    int byteLen = (int)((str.length % 2 == 0) ? str.length / 2 : str.length / 2 + 1);
    
    UInt8 bytes[byteLen];
    for (int i = byteLen - 1; i >= 0; i--)
    {
        int rangeLocation = MAX(i * 2, 0);
        int rangeLength = rangeLocation + 2 > str.length ? 1 : 2;
        NSString *aStr = [str substringWithRange:NSMakeRange(rangeLocation ,rangeLength)];
        bytes[i] = strtol([aStr UTF8String], NULL, 16);
    }
    
    NSData *data = [NSData dataWithBytes:bytes length:byteLen];
    return data;
}

+ (NSString *)getMacAddress
{
    int                 mgmtInfoBase[6];
    char                *msgBuffer = NULL;
    size_t              length;
    unsigned char       macAddress[6];
    struct if_msghdr    *interfaceMsgStruct;
    struct sockaddr_dl  *socketStruct;
    NSString            *errorFlag = NULL;
    
    // Setup the management Information Base (mib)
    mgmtInfoBase[0] = CTL_NET;        // Request network subsystem
    mgmtInfoBase[1] = AF_ROUTE;       // Routing table info
    mgmtInfoBase[2] = 0;
    mgmtInfoBase[3] = AF_LINK;        // Request link layer information
    mgmtInfoBase[4] = NET_RT_IFLIST;  // Request all configured interfaces
    
    // With all configured interfaces requested, get handle index
    if ((mgmtInfoBase[5] = if_nametoindex("en0")) == 0)
        errorFlag = @"if_nametoindex failure";
    else
    {
        // Get the size of the data available (store in len)
        if (sysctl(mgmtInfoBase, 6, NULL, &length, NULL, 0) < 0)
            errorFlag = @"sysctl mgmtInfoBase failure";
        else
        {
            // Alloc memory based on above call
            if ((msgBuffer = malloc(length)) == NULL)
                errorFlag = @"buffer allocation failure";
            else
            {
                // Get system information, store in buffer
                if (sysctl(mgmtInfoBase, 6, msgBuffer, &length, NULL, 0) < 0)
                    errorFlag = @"sysctl msgBuffer failure";
            }
        }
    }
    
    // Befor going any further...
    if (errorFlag != NULL)
    {
        NSLog(@"Error: %@", errorFlag);
        return errorFlag;
    }
    
    // Map msgbuffer to interface message structure
    interfaceMsgStruct = (struct if_msghdr *) msgBuffer;
    
    // Map to link-level socket structure
    socketStruct = (struct sockaddr_dl *) (interfaceMsgStruct + 1);
    
    // Copy link layer address data in socket structure to an array
    memcpy(&macAddress, socketStruct->sdl_data + socketStruct->sdl_nlen, 6);
    
    // Read from char array into a string object, into traditional Mac address format
    NSString *macAddressString = [NSString stringWithFormat:@"%02x:%02x:%02x:%02x:%02x:%02x",
                                  macAddress[0], macAddress[1], macAddress[2],
                                  macAddress[3], macAddress[4], macAddress[5]];
    NSLog(@"Mac Address: %@", macAddressString);
    
    // Release the buffer memory
    free(msgBuffer);
    
    return macAddressString;
}

+ (NSData *)netDataFromUint16:(UInt16)number
{
    UInt16 netNumber = htons(number);
    NSData * data = [NSData dataWithBytes:(Byte *)&netNumber length:2];
    return data;
}


+ (NSData *)macStrTData:(NSString *)str
{
    int byteLen = (int)((str.length % 2 == 0) ? str.length / 2 : str.length / 2 + 1);
    
    UInt8 bytes[byteLen];
    for (int i = byteLen - 1; i >= 0; i--)
    {
        int rangeLocation = MAX(i * 2, 0);
        int rangeLength = rangeLocation + 2 > str.length ? 1 : 2;
        NSString *aStr = [str substringWithRange:NSMakeRange(rangeLocation ,rangeLength)];
        bytes[i] = strtol([aStr UTF8String], NULL, 16);
    }
    
    NSData *data = [NSData dataWithBytes:bytes length:byteLen];
    return data;
}

//获得本地device字典
+ (NSMutableDictionary *)getlocalDeviceDictary
{
    NSMutableDictionary *deviceDictary = [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceDictary"];
    
    return deviceDictary;
    
}
//获得本地device数组
+ (NSMutableArray *)getLocalDeviceArray
{
    NSArray * deviceArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceArray"];
    NSMutableArray * resultArray = [NSMutableArray arrayWithCapacity:0];
    for (NSData * data in deviceArray)
    {
        Device * device = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        [resultArray addObject:device];
        if (!device.socketArray)
        {
            [device initSocketArray];
        }
    }
    if (resultArray.count == 0)
    {
        Device * testDevice = [[Device alloc] init];
        testDevice.name = @"controller1";
        testDevice.type = 0x14;
        testDevice.pk = @"1";
        [testDevice initSocketArray];
        Device * testDevice1 = [[Device alloc] init];
        testDevice1.name = @"controller2";
        testDevice1.type = 0x18;
        testDevice1.pk = @"2";
        [testDevice1 initSocketArray];
        Device * testDevice3 = [[Device alloc] init];
        testDevice3.name = @"controller3";
        testDevice3.type = 0x0c;
        testDevice3.locked = YES;
        testDevice3.pk = @"3";
        [testDevice3 initSocketArray];
        return [@[testDevice,testDevice1,testDevice3] mutableCopy];
    }
    return resultArray;
}
+(void)saveLocalDevicedictary:(Device *)device With:(NSString *)macString
{
    NSMutableDictionary *dictary = [NSMutableDictionary dictionaryWithCapacity:0];
    
    [[NSUserDefaults standardUserDefaults] setObject:dictary forKey:@"deviceDictary"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    
}

+ (void)saveLocalDeviceArray:(NSArray *)deviceArray
{
    NSMutableArray * dataArray = [NSMutableArray arrayWithCapacity:deviceArray.count];
    for (UIDevice * device in deviceArray)
    {
        [dataArray addObject:[NSKeyedArchiver archivedDataWithRootObject:device]];
    }
    [[NSUserDefaults standardUserDefaults] setObject:dataArray forKey:@"deviceArray"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark-
#pragma mark-转换随机433地址 只适合本项目使用
+ (NSData *)getRFAddressWith:(NSString *)string
{
    NSArray * tempArray = [string componentsSeparatedByString:@":"];
    UInt8 byt[2];
    for (int i = 0; i < [tempArray count]; i ++) {
        byt[i] = [[tempArray objectAtIndex:i] intValue];
    }
    
    NSData *data = [NSData dataWithBytes:byt length:2];
    
    return data;
}

+ (UIImage *)getImageFile:(NSString *)imagePath
{
    UIImage *endImage;
    NSString *dataPath = [[[NSBundle mainBundle] bundlePath] stringByAppendingString:[NSString stringWithFormat:@"/%@",imagePath]];//获取程序包中相应文件的路径
    NSFileManager *fileMa = [NSFileManager defaultManager];
    
    if(![fileMa fileExistsAtPath:dataPath]){

        NSFileManager *fileManager = [NSFileManager defaultManager];
        if (![fileManager fileExistsAtPath:[Util getFilePathWithImageName:imagePath]]) {
            NSLog(@"找不到图片");
            
        } else {
            endImage = [[UIImage alloc] initWithContentsOfFile:[Util getFilePathWithImageName:imagePath]];
        }
            
    }else{
        endImage = [UIImage imageNamed:imagePath];

    }
    
    return endImage;
}

+ (void)deleteCancleImageFileWithPath:(NSString *)path
{
    if ([path hasPrefix:@"/"]) {
        
        NSError *error = nil;
        if([[NSFileManager defaultManager] removeItemAtPath:path error:&error]){
            NSLog(@"文件移除成功");
        }
        else {
            NSLog(@"error=%@", error);
        }
    }else{
        
        return;
    }
    
    

}

//数组排序临时方法

+ (NSMutableArray *)invertedOrder:(NSMutableArray *)timeArray
{
    
    for (int i = 0; i<[timeArray count]; i++)
    {
        for (int j=i+1; j<[timeArray count]; j++)
        {
            
            Device *dici = timeArray[i];
            Device *dicj = timeArray[j];
            
//            int a = [dici.orderNumber intValue];
//            int b = [dicj.orderNumber intValue];
            if (dici.orderNumber > dicj.orderNumber)
            {
                [timeArray replaceObjectAtIndex:i withObject:dicj];
                [timeArray replaceObjectAtIndex:j withObject:dici];
            }
        }
    }
    return timeArray;
}

#pragma mark-md5

/*
 - (NSString *)getFilePathWithPath:(NSString *)path
 {
 
 NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
 NSString *docDir = [paths objectAtIndex:0];
 
 return [docDir stringByAppendingString:[NSString stringWithFormat:@"/%@",path]];
 }

 */
//获取图片路径
+ (NSString *)getFilePathWithImageName:(NSString *)imageName
{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex:0];
    
    return [docDir stringByAppendingString:[NSString stringWithFormat:@"/%@",imageName]];
}

+ (NSString *)getPassWordWithmd5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (unsigned int)strlen(cStr), result); // This is the md5 call
   NSString * string = [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
    return [string uppercaseStringWithLocale:[NSLocale currentLocale]];
}

//数组去重复对象
+ (NSMutableArray *)arraytoreToArray:(NSMutableArray *)aArray
{
    NSMutableArray *array = [ NSMutableArray arrayWithCapacity:0];
    
    for (int i = 0; i<aArray.count; i++)
    {
        id str = [aArray objectAtIndex:i];
        
        if ([array containsObject:str])
        {
            
        }
        else
        {
            [array addObject:str];
        }
    }
    
    return array;
}
+ (NSString *)getUUID
{
    
    CFUUIDRef cfuuid = CFUUIDCreate(kCFAllocatorDefault);
    NSString *cfuuidString = (NSString *)CFBridgingRelease(CFUUIDCreateString(kCFAllocatorDefault, cfuuid));
    
//    NSString *timeSp = [NSString stringWithFormat:@"%li", (long)[[NSDate date] timeIntervalSince1970] ];
    

    cfuuidString  = [cfuuidString lowercaseString];
    
    return cfuuidString;
}

#pragma mark - 获取路由器地址 子网掩码 广播地址等信息
+ (NSString *) getBroadcastAddress {
    
    NSString *broadcastAddress = nil;
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    
    
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0)
    {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        //*/
        while(temp_addr != NULL)
        /*/
         int i=255;
         while((i--)>0)
         //*/
        {
            if(temp_addr->ifa_addr->sa_family == AF_INET)
            {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"])
                {
                    // Get NSString from C String //ifa_addr
                    //ifa->ifa_dstaddr is the broadcast address, which explains the "255's"
                    //                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_dstaddr)->sin_addr)];
                    
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                    
                    //--192.168.1.255 广播地址
//                    NSLog(@"broadcast address--%@",[NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_dstaddr)->sin_addr)]);
                    //--192.168.1.106 本机地址
//                    NSLog(@"local device ip--%@",[NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)]);
                    //--255.255.255.0 子网掩码地址
//                    NSLog(@"netmask--%@",[NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_netmask)->sin_addr)]);
                    //--en0 端口地址
//                    NSLog(@"interface--%@",[NSString stringWithUTF8String:temp_addr->ifa_name]);
                    
                    broadcastAddress = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_dstaddr)->sin_addr)];
                }
                
            }
            
            temp_addr = temp_addr->ifa_next;
        }
    }
    
//    // Free memory
//    freeifaddrs(interfaces);
//
//    in_addr_t i =inet_addr([address cStringUsingEncoding:NSUTF8StringEncoding]);
//    in_addr_t* x =&i;
//    
//    unsigned char *s=getdefaultgateway(x);
//    // --路由器Ip
//    NSString *ip=[NSString stringWithFormat:@"%d.%d.%d.%d",s[0],s[1],s[2],s[3]];
//    free(s);
    
    return broadcastAddress;
}

//普通字符串转换为十六进制的。
+ (NSString *)hexStringFromString:(NSString *)string{
    NSData *myD = [string dataUsingEncoding:NSUTF8StringEncoding];
    Byte *bytes = (Byte *)[myD bytes];
    //下面是Byte 转换为16进制。
    NSString *hexStr=@"";
    for(int i=0;i<[myD length];i++)
    {
        NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i]&0xff];///16进制数
        
        if([newHexStr length]==1)
            
            hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
        
        else
            
            hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
    }
    return hexStr;
}

@end
