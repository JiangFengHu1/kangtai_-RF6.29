//
//  Open_CloseManage.h
//  kangtai
//
//  Created by 胡江峰 on 16/6/27.
//
//

#import <Foundation/Foundation.h>
#import "Open_CloseStatu.h"
#define Open_CloseManageInstance [Open_CloseManage shareAllDevice]
@interface Open_CloseManage : NSObject
@property (nonatomic,strong) NSMutableArray * deviceArray;
+ (Open_CloseManage *)shareAllDevice;

- (Open_CloseStatu *)getDevicePreFWithRfDataId:(NSString *)rfDataId;
@end
