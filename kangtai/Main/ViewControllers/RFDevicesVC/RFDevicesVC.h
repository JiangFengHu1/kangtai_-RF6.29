//
//  RFDevicesVC.h
//  kangtai
//
//  Created by 张群 on 14/12/15.
//
//

#import "MainVC.h"
#import "AddNewRFDeviceVC.h"
#import "RootViewController.h"
#import "RFControlVC.h"
#import "RFDeviceCell.h"
#import "EditableTableController.h"
#import "UITapGestureRecognizer+tag.h"

enum{
    OhBuyRightMove = 1,
    OhBuyResetMove,
};

@protocol OhBuyMoveDelegate <NSObject>

- (void)OhBuyMoveMethod:(NSInteger)index;

@end

@interface RFDevicesVC : MainVC

@property (nonatomic, assign) id <OhBuyMoveDelegate> delegate;

@property (nonatomic,strong)NSMutableArray *dataName;
@property (nonatomic,copy)NSString *macString;
@property (nonatomic,strong)NSMutableArray *dataWhiteDAY;
@property (nonatomic,strong)NSMutableArray *dataDAY;
@property (nonatomic,assign) int hide;
@property (nonatomic,assign) BOOL isClicked;
@property (nonatomic,strong)UILabel *deviceName;
@property (nonatomic,strong)UIScrollView *scrollView;
@property (nonatomic,strong) NSMutableArray *RFMacStrArr;


@end
