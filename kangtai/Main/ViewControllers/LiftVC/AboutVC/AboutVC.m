//
//
/**
 * Copyright (c) www.bugull.com
 */
//
//

#import "AboutVC.h"
#import "RootViewController.h"

@interface AboutVC ()
{
    NSString *trackViewURL;
}

@end

@implementation AboutVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor  =[UIColor colorWithRed:241.0/255 green:241.0/255 blue:240.0/255 alpha:1];
    
    [self loadUI];
    // Do any additional setup after loading the view.
}

- (void)loadUI
{
    self.titlelab.text = NSLocalizedString(@"About Us", nil);
    self.rightBut.hidden = YES;
    [self.backButton setBackgroundImage:[UIImage imageNamed:@"list_menu_normal.png"] forState:UIControlStateNormal];
    [self.backButton setBackgroundImage:[UIImage imageNamed:@"list_menu_click.png"] forState:UIControlStateHighlighted];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, barViewHeight, kScreen_Width, kScreen_Height-barViewHeight)];
    view.backgroundColor =[UIColor colorWithRed:241.0/255 green:241.0/255 blue:240.0/255 alpha:1];
    [self.view addSubview:view];
    
    float y = (kScreen_Width > 320) ? 130 : 90;
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo.png"]];
    imageView.frame = CGRectMake((kScreen_Width - 185) / 2, y, 185 , 75);
    [view addSubview:imageView];
    
    NSArray *arr = [NSArray arrayWithObjects:@"Copyright © 2014 KANGTAI ELECTRIC CO.,LTD.",@"Tel China: +86 577 55770218", nil];
    for (int i = 0; i < arr.count; i ++) {
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(15, view.frame.size.height - 40 - i * 27, kScreen_Width - 15, 20)];
        lab.backgroundColor = [UIColor clearColor];
        lab.numberOfLines = 0;
        lab.font = [UIFont systemFontOfSize:13];
        lab.text = [arr objectAtIndex:i];
        lab.textColor = [UIColor colorWithRed:151.0/255 green:151.0/255 blue:151.0/255 alpha:1];
        [view addSubview:lab];
    }
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // app版本
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    
    self.versonLab = [[UILabel alloc] initWithFrame:CGRectMake(0, y + 95, kScreen_Width, 30)];
    self.versonLab.backgroundColor = [UIColor clearColor];
    self.versonLab.font = [UIFont systemFontOfSize:18];
    self.versonLab.text = [NSString stringWithFormat:@"%@ V%@", NSLocalizedString(@"WiFi Socket", nil), app_Version];
    self.versonLab.textAlignment = NSTextAlignmentCenter;
    self.versonLab.numberOfLines = 0;
    self.versonLab.textColor = [UIColor colorWithRed:90.0/255 green:90.0/255 blue:90.0/255 alpha:1];
    [view addSubview:self.versonLab];
}

- (void)leftButtonMethod:(UIButton *)but
{
    RootViewController *root = [Util getAppDelegate].rootVC;
    if (self.delegate && [self.delegate respondsToSelector:@selector(ohbuyMoveMethod:)]) {
        if (root.curView.frame.origin.x == 0) {
            [self.delegate ohbuyMoveMethod:ohbuyRightMove];
            
        } else {
            [self.delegate ohbuyMoveMethod:ohbuyResetMove];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
