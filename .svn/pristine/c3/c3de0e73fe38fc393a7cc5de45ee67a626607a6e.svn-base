//
//
/**
 * Copyright (c) www.bugull.com
 */
//
//

#import "LeftVCCell.h"

@implementation LeftVCCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.grayView = [[UIView alloc] initWithFrame:CGRectMake(5, 0, kScreen_Width - 5, 60)];
        self.grayView.backgroundColor = RGBA(238.0, 238.0, 238.0, 1);
        self.grayView.hidden = YES;
        [self addSubview:self.grayView];
        
        self.iconImageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bulb_white.png"]];
        self.iconImageV.frame = CGRectMake(18, 18, 24, 24);;
        [self addSubview:self.iconImageV];

        self.devName = [[UILabel alloc] initWithFrame:CGRectMake(50, 18, 120, 24)];
        self.devName.backgroundColor = [UIColor clearColor];
        self.devName.font = [UIFont systemFontOfSize:19];
        self.devName.textColor = RGBA(71.0, 183.0, 233.0, 1);
        self.devName.text = @"Buld";
        [self addSubview:self.devName];
        
        self.choosenView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 60)];
        self.choosenView.backgroundColor = RGBA(45.0, 177.0, 250.0, 1.0);
        self.choosenView.hidden = YES;
        [self addSubview:self.choosenView];
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
