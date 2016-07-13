//
//  WiFiDeviceListCell.m
//  kangtai
//
//  Created by 张群 on 14/12/22.
//
//

#import "WiFiDeviceListCell.h"

@implementation WiFiDeviceListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.nearestLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 15, kScreen_Width - 80 - 60, 20)];
        self.nearestLabel.backgroundColor = [UIColor clearColor];
        self.nearestLabel.font = [UIFont systemFontOfSize:16];
        self.nearestLabel.textColor = RGB(100, 100, 100);
        [self addSubview:self.nearestLabel];
        
        self.imgView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreen_Width - 80 - 40, 12, 26, 26)];
        self.imgView.layer.cornerRadius = 13;
        self.imgView.image = [UIImage imageNamed:@"invalid_2"];
        [self addSubview:self.imgView];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)awakeFromNib
{

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
