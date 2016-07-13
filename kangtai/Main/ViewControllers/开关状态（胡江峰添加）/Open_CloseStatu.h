//
//  Open_CloseStatu.h
//  kangtai
//
//  Created by 胡江峰 on 16/6/27.
//
//

#import <Foundation/Foundation.h>

@interface Open_CloseStatu : NSObject
//@property (nonatomic,copy) NSString * rfDataMac;
@property(nonatomic, copy)NSString *rfDataId;
@property (nonatomic ,assign) BOOL deviceOpen;
@property (nonatomic ,assign) BOOL deviceClose;
@end
