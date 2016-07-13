//
//
/**
 * Copyright (c) www.bugull.com
 */
//
//

#import "WIFIDeviceCell.h"

@implementation WIFIDeviceCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.grayView = [[UIScrollView alloc] init];
        self.grayView.frame = CGRectMake(kScreen_Width - 80, 0,  80, 79);
        self.grayView.backgroundColor = RGBA(250.0, 250.0, 250.0, 1.0);
        [self addSubview:self.grayView];
        
        self.delView = [[UIScrollView alloc] initWithFrame:self.grayView.frame];
        self.delView.backgroundColor = [UIColor redColor];
        self.delView.hidden = YES;
        
        self.delImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        self.delImgView.center = CGPointMake(self.delView.size.width / 2, self.delView.frame.size.height / 2);
        self.delImgView.image = [UIImage imageNamed:@"del.png"];
        [self.delView addSubview:self.delImgView];
        
        // Initialization code
        self.stateIconImageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"on_back.png"]];
        self.stateIconImageV.frame = CGRectMake(5, 8, 64, 64);
//        [self addSubview:self.stateIconImageV];
        
        self.iconImageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bulb_white.png"]];
        self.iconImageV.frame = CGRectMake(10, 12, 56, 56);
        self.iconImageV.layer.cornerRadius = 28;
        self.iconImageV.clipsToBounds = YES;
        [self addSubview:self.iconImageV];
        
        self.markImgView = [[UIImageView alloc] initWithFrame:CGRectMake(55, 14, 22, 22)];
        self.markImgView.layer.masksToBounds = YES;
        self.markImgView.layer.cornerRadius = 11.f;
        self.markImgView.image = [UIImage imageNamed:@"Energy_Info_mark.png"];
        [self addSubview:self.markImgView];
        
        self.switchImageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"power_on.png"]];
        self.switchImageV.frame = CGRectMake(kScreen_Width - 60, 18, 44, 44);
        
        [self addSubview:self.switchImageV];
        
        
        self.switchView = [[UIView alloc] initWithFrame:CGRectMake(kScreen_Width - 60, 18, 44, 44)];
        self.switchView.backgroundColor = [UIColor redColor];
        self.switchView.layer.cornerRadius = 5;
        self.switchView.alpha = 0.0;
        self.switchView.clipsToBounds = YES;
        [self addSubview:self.switchView];
        
        self.switchBut = [UIButton buttonWithType:UIButtonTypeCustom];
        self.switchBut.frame = CGRectMake(kScreen_Width - 60, 18, 44, 44);
        [self addSubview:self.switchBut];
        
        self.deviceName = [[UILabel alloc] initWithFrame:CGRectMake(78, 28, 180, 24)];
        self.deviceName.backgroundColor = [UIColor clearColor];
        self.deviceName.font = [UIFont systemFontOfSize:18];
        self.deviceName.text = @"Buld";
        
        self.deviceName.textColor = [UIColor colorWithRed:60.0/255 green:61.0/255 blue:60.0/255 alpha:1];
        [self addSubview:self.deviceName];
        
        self.deviceTimer = [[UILabel alloc] initWithFrame:CGRectMake(kScreen_Width - 60, 21, 60, 40)];
        self.deviceTimer.backgroundColor = [UIColor clearColor];
        self.deviceTimer.font = [UIFont systemFontOfSize:15];
        self.deviceTimer.text = NSLocalizedString(@"Offline", nil);
        self.deviceTimer.numberOfLines = 0;
        self.deviceTimer.hidden = YES;
        self.deviceTimer.textColor = [UIColor colorWithRed:60.0/255 green:61.0/255 blue:60.0/255 alpha:1];
        [self addSubview:self.deviceTimer];
        
//        self.timerLabel = [[UILabel alloc] initWithFrame:CGRectMake(78, 43, 180, 15)];
//        self.timerLabel.font = [UIFont systemFontOfSize:13];
//        self.timerLabel.textColor = RGBA(100.0, 100.0, 100.0, 1.0);
//        self.timerLabel.backgroundColor = [UIColor clearColor];
//        self.timerLabel.text = @"07:30 ON";
//        self.timerLabel.hidden = YES;
//        [self addSubview:self.timerLabel];
        
        // 自定义加一条分割线
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 79, kScreen_Width, 1)];
        [lineView setBackgroundColor:RGBA(225.0, 225.0, 225.0, 1)];
        [self addSubview:lineView];

        [self addSubview:self.delView];
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
