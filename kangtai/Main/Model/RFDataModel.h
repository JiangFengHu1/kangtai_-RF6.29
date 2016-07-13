//
//
/**
 * Copyright (c) www.bugull.com
 */
//
//

#import <Foundation/Foundation.h>

@interface RFDataModel : NSObject

@property(nonatomic,strong)NSString *rfDataId;

@property(nonatomic,strong)NSString *rfDataMac;
@property(nonatomic,strong)NSString *rfDataName;
@property(nonatomic,strong)NSString *rfDataLogo;
@property(nonatomic,strong)NSString *rfDataState;
@property(nonatomic,strong)NSString *address;
@property (assign,nonatomic)NSInteger  orderNumber;
@property(nonatomic,copy)NSString * typeRF;


@end
