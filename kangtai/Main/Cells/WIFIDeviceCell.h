//
//
/**
 * Copyright (c) www.bugull.com
 */
//
//

#import <UIKit/UIKit.h>

@interface WIFIDeviceCell : UITableViewCell

@property (nonatomic, assign) BOOL isOn;

@property(nonatomic,strong)UIImageView *iconImageV;
@property(nonatomic,strong)UIImageView *switchImageV;

@property(nonatomic,strong)UIView *switchView;
@property(nonatomic,strong)UIScrollView *grayView;
@property (nonatomic, strong) UIScrollView *delView;
@property (nonatomic, strong) UIImageView *delImgView;

@property(nonatomic,strong)UIImageView *stateIconImageV;
@property(nonatomic,strong)UIImageView *stateSwitchImageV;

@property(nonatomic,strong)UIButton *switchBut;

@property(nonatomic,strong)UILabel *deviceTimer;
@property(nonatomic,strong)UILabel *deviceName;
@property(nonatomic,strong)UILabel *timerLabel;

@property (nonatomic, strong) UIImageView *switchImgView;
@property (nonatomic, strong) UIImageView *markImgView;

@end
