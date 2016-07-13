//
//
/**
 * Copyright (c) www.bugull.com
 */
//
//

#import "MainVC.h"
#import "RFVC.h"
#import "AddRFVC.h"
#import "UITapGestureRecognizer+tag.h"
@interface RFPageVC : MainVC


@property (nonatomic,strong)NSMutableArray *dataName;
@property (nonatomic,copy)NSString *macString;
//@property (nonatomic,copy)NSString *databaseId;


@property (nonatomic,strong)NSMutableArray *dataWhiteDAY;
@property (nonatomic,strong)NSMutableArray *dataDAY;
@property (nonatomic,assign)BOOL isShowPW;
@property (nonatomic,strong)UILabel *deviceName;
@property (nonatomic,strong)UIScrollView *scrollView;
@end
