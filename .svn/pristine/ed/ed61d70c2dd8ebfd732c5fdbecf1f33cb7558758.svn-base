//
//
/**
 * Copyright (c) www.bugull.com
 */
//
//


#import "CountDownCell.h"

@implementation CountDownCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        
        self.detailLab = [[UILabel alloc] initWithFrame:CGRectMake(130, 20, 48, 40)];
        self.detailLab.backgroundColor = [UIColor clearColor];
        self.detailLab.font = [UIFont systemFontOfSize:26];
        self.detailLab.text = @"2014-07-30";
        self.detailLab.textAlignment = NSTextAlignmentCenter;
        self.detailLab.textColor = [UIColor colorWithRed:20/255 green:170.0/255 blue:240.0/255 alpha:1];
        [self addSubview:self.detailLab];

        NSArray *tempArray = [NSArray arrayWithObjects:NSLocalizedString(@"After", nil),NSLocalizedString(@"Hour", nil),NSLocalizedString(@"Minute", nil), nil];
        for (int i = 0; i <3; i ++) {
          
            UILabel *after = [[UILabel alloc] initWithFrame:CGRectMake(80*i+15, 20, 50, 40)];
            after.backgroundColor = [UIColor clearColor];
            after.font = [UIFont systemFontOfSize:15];
            after.text =  [tempArray objectAtIndex:i];
            
            after.textColor = [UIColor colorWithRed:151.0/255 green:151.0/255 blue:151.0/255 alpha:1];
            [self addSubview:after];
 
        }
        
        self.switchLab = [[UILabel alloc] initWithFrame:CGRectMake(230, 20, 70, 40)];
        self.switchLab.backgroundColor = [UIColor clearColor];
        self.switchLab.font = [UIFont systemFontOfSize:22];
        self.switchLab.text = @"";
        self.switchLab.textColor = [UIColor colorWithRed:29.0/255 green:130.0/255 blue:226.0/255 alpha:1];
        [self addSubview:self.switchLab];
        
        self.titleName = [[UILabel alloc] initWithFrame:CGRectMake(47, 20, 48, 40)];
        self.titleName.backgroundColor = [UIColor clearColor];
        self.titleName.textAlignment = NSTextAlignmentCenter;
        self.titleName.font = [UIFont systemFontOfSize:26];
        self.titleName.text = @"8:00";
        self.titleName.numberOfLines = 0;
        self.titleName.textColor = [UIColor colorWithRed:20/255 green:170.0/255 blue:240.0/255 alpha:1];
        [self addSubview:self.titleName];
        
        UIView *separateLine = [[UIView alloc] initWithFrame:CGRectMake(0,  79, kScreen_Width, 1)];
        separateLine.backgroundColor = RGBA(238.0, 238.0, 238.0, 1.0);
        [self addSubview:separateLine];
        
        self.delView = [[UIView alloc] initWithFrame:CGRectMake(kScreen_Width / 4 * 3, 0, kScreen_Width / 4, 79)];
        self.delView.backgroundColor = [UIColor redColor];
        self.delView.hidden = YES;
        self.delView.userInteractionEnabled = YES;
        [self addSubview:self.delView];
        self.delImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        self.delImgView .center = CGPointMake(self.delView.frame.size.width / 2, 35);
        self.delImgView .userInteractionEnabled = YES;
        self.delImgView .image = [UIImage imageNamed:@"del.png"];
        [self.delView addSubview:self.delImgView ];
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
