//
//  Open_CloseManage.m
//  kangtai
//
//  Created by 胡江峰 on 16/6/27.
//
//

#import "Open_CloseManage.h"
static Open_CloseManage * singleInstance = nil;
@implementation Open_CloseManage

+ (Open_CloseManage *)shareAllDevice
{
    if (singleInstance == nil) {
        singleInstance = [[Open_CloseManage alloc] init];
    }
    return singleInstance;
}



- (instancetype)init
{
    if (self = [super init]) {
        _deviceArray = [NSMutableArray array];

    }
    return self;
}

- (Open_CloseStatu *)getDevicePreFWithRfDataId:(NSString *)rfDataId{
    Open_CloseStatu *deviceStatu =nil;
//    NSLog(@"%lu",(unsigned long)_deviceArray.count);
    
    for (Open_CloseStatu * currentdevice in _deviceArray) {
        if ([currentdevice.rfDataId isEqualToString:rfDataId]) {
            deviceStatu =currentdevice;
            break;
        }
    }
    return deviceStatu;

}
@end
