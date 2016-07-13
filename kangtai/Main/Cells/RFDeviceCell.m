//
//  RFDeviceCell.m
//  kangtai
//
//  Created by 张群 on 14/12/16.
//
//

#import "RFDeviceCell.h"

@implementation RFDeviceCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.iconImageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bulb_white.png"]];
        self.iconImageV.frame = CGRectMake(10, 12, 56, 56);
        self.iconImageV.layer.cornerRadius = 28;
        self.iconImageV.clipsToBounds = YES;
        [self addSubview:self.iconImageV];
        
        self.deviceName = [[UILabel alloc] initWithFrame:CGRectMake(78, 20, kScreen_Width - 78, 20)];
        self.deviceName.backgroundColor = [UIColor clearColor];
        self.deviceName.font = [UIFont systemFontOfSize:18];
        self.deviceName.text = @"Buld";
        self.deviceName.textColor = [UIColor colorWithRed:60.0/255 green:61.0/255 blue:60.0/255 alpha:1];
        [self addSubview:self.deviceName];
        
        self.deviceTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(78, 45, kScreen_Width - 78, 20)];
        self.deviceTypeLabel.backgroundColor = [UIColor clearColor];
        self.deviceTypeLabel.font = [UIFont systemFontOfSize:15];
        self.deviceTypeLabel.text = @"Buld";
        self.deviceTypeLabel.textColor = [UIColor colorWithRed:210.0/255 green:211.0/255 blue:211.0/255 alpha:1];
        [self addSubview:self.deviceTypeLabel];

        self.delView = [[UIScrollView alloc] initWithFrame:CGRectMake(kScreen_Width - 80, 0,  80, 79)];
        self.delView.backgroundColor = [UIColor redColor];
        self.delView.hidden = YES;
        
        self.delImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        self.delImgView.center = CGPointMake(self.delView.size.width / 2, self.delView.frame.size.height / 2);
        self.delImgView.image = [UIImage imageNamed:@"del.png"];
        [self.delView addSubview:self.delImgView];
        [self addSubview:self.delView];
        
        UIView *separateLine = [[UIView alloc] initWithFrame:CGRectMake(0,  79, kScreen_Width, 1)];
        separateLine.backgroundColor = RGBA(238.0, 238.0, 238.0, 1.0);
        [self addSubview:separateLine];
        
        self.offlineLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreen_Width - 60, 21, 60, 40)];
        self.offlineLabel.backgroundColor = [UIColor clearColor];
        self.offlineLabel.font = [UIFont systemFontOfSize:15];
        self.offlineLabel.text = NSLocalizedString(@"Offline", nil);
        self.offlineLabel.numberOfLines = 0;
        self.offlineLabel.hidden = YES;
        self.offlineLabel.textColor = [UIColor colorWithRed:60.0/255 green:61.0/255 blue:60.0/255 alpha:1];
        [self addSubview:self.offlineLabel];

    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
