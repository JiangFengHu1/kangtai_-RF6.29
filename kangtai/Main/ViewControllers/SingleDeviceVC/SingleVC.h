//
//
/**
 * Copyright (c) www.bugull.com
 */
//
//


#import "MainVC.h"
#import "EditVC.h"
#import "LockCell.h"
#import "CountDownCell.h"
#import "AbsenceCell.h"
#import "EnergyInfoVC.h"
#import "SetTimerVC.h"
#import "AddCountDownVC.h"
#import "EditAbsenceVC.h"

@interface SingleVC : MainVC

@property(nonatomic,strong)UIImageView *imageV;
@property(nonatomic,strong)UIImageView *markImageV;
@property(nonatomic,strong)NSMutableArray *deviceArr;;
@property (nonatomic, strong) UIButton *iconBtn;

@property(nonatomic,assign)BOOL isNo_Off;
@property (nonatomic, assign) int number;
@property(nonatomic,strong)Device *devices;
@property(nonatomic,strong)NSTimer *secondTimer;

@property(nonatomic,assign)int type;
@property(nonatomic,copy)NSString *imgName;
@property(nonatomic,copy)NSString *stateString;
@property(nonatomic,copy)NSString *macString;
@property(nonatomic,copy)NSString *deviceName;

@end
