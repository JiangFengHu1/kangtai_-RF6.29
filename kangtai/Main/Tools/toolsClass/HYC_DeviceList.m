//
//
/**
 * Copyright (c) www.bugull.com
 */
//
//


#import "HYC_DeviceList.h"
static HYC_DeviceList *hyc_list = nil;

@implementation HYC_DeviceList


+(HYC_DeviceList *)listObject
{
    if (hyc_list == nil) {
        hyc_list = [[HYC_DeviceList alloc] init];
        
    }
    
    return hyc_list;
}

- (void)addDeviceObjectTolistWith:(Device *)device

{
    
    
    
    
}

@end
