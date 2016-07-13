//
//
/**
 * Copyright (c) www.bugull.com
 */
//
//

#import "AbsenceCell.h"

@implementation AbsenceCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        self.detailLab = [[UILabel alloc] initWithFrame:CGRectMake(65, 40, 220, 40)];
        self.detailLab.backgroundColor = [UIColor clearColor];
        self.detailLab.font = [UIFont systemFontOfSize:18];
        self.detailLab.text =  @"No data'";
        self.detailLab.textColor = [UIColor colorWithRed:20/255 green:170.0/255 blue:240.0/255 alpha:1];
        [self addSubview:self.detailLab];
        
        self.titleName = [[UILabel alloc] initWithFrame:CGRectMake(65, 0, 220, 40)];
        self.titleName.backgroundColor = [UIColor clearColor];
        
        self.titleName.font = [UIFont systemFontOfSize:18];
        self.titleName.text = @"From Time To Time";
        self.titleName.textColor = [UIColor colorWithRed:20/255 green:170.0/255 blue:240.0/255 alpha:1];
        [self addSubview:self.titleName];
    
        UILabel *fromLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 41, 220, 40)];
        fromLab.backgroundColor = [UIColor clearColor];
        fromLab.font = [UIFont systemFontOfSize:16];
        fromLab.text =  NSLocalizedString(@"To", nil);
        
        fromLab.textColor =  [UIColor colorWithRed:151.0/255 green:151.0/255 blue:151.0/255 alpha:1] ;
        [self addSubview:fromLab];
        
         UILabel * toLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 1, 40, 40)];
         toLab.backgroundColor = [UIColor clearColor];
        
         toLab.font = [UIFont systemFontOfSize:16];
         toLab.text = NSLocalizedString(@"From", nil);
         toLab.textColor = [UIColor colorWithRed:151.0/255 green:151.0/255 blue:151.0/255 alpha:1] ;
         [self addSubview:toLab];
        
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
        
        UIView *separateLine = [[UIView alloc] initWithFrame:CGRectMake(0,  79, kScreen_Width, 1)];
        separateLine.backgroundColor = RGBA(238.0, 238.0, 238.0, 1.0);
        [self addSubview:separateLine];

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
