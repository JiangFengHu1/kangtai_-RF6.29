//
//  RFControlVC.h
//  kangtai
//
//  Created by 张群 on 14/12/15.
//
//

#import "MainVC.h"
#import "AddNewRFDeviceVC.h"
#import "RFTimerVC.h"
#import "Open_CloseStatu.h"

@interface RFControlVC : MainVC

@property (nonatomic,strong) NSMutableArray *RFMacStrArr;
@property (nonatomic,strong) NSMutableArray *modelArr;
@property (nonatomic,copy) NSString *typeStr;
@property (nonatomic,copy) NSString *nameStr;
@property (nonatomic,copy) NSString *iconStr;
@property (nonatomic,copy) NSString *macStr;
@property (nonatomic, strong) RFDataModel *model;
@property (nonatomic, strong) Open_CloseStatu *HJFstatu;
@end
