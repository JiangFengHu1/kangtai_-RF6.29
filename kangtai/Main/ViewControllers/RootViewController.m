//
//
/**
 * Copyright (c) www.bugull.com
 */
//
//

#import "RootViewController.h"

@interface RootViewController ()

@end

@implementation RootViewController

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
    // 去掉UITabBar
    for (UIView * v in self.view.subviews) {
        if ([v isKindOfClass:[UITabBar class]]) {
            [v removeFromSuperview];
        }
        else
        {
            self.curView = v;
        }
    }
    [self.curView setFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height)];

    WIFIDeviiceVC *deviceVC = [[WIFIDeviiceVC alloc] init];
    deviceVC.delegate = self;
    UINavigationController *nav1 = [[UINavigationController alloc] initWithRootViewController:deviceVC];
    nav1.navigationBar.hidden = YES;
    
    AboutVC *aboutVC = [[AboutVC alloc] init];
    aboutVC.delegate = self;
    UINavigationController *nav2 = [[UINavigationController alloc] initWithRootViewController:aboutVC];
    nav2.navigationBar.hidden = YES;

    ChangePWSVC *changePWDVC = [[ChangePWSVC alloc] init];
    UINavigationController *nav3 = [[UINavigationController alloc] initWithRootViewController:changePWDVC];
    nav3.navigationBar.hidden = YES;
    
    RFDevicesVC *rfVC = [[RFDevicesVC alloc] init];
    rfVC.delegate = self;
    UINavigationController *nav4 = [[UINavigationController alloc] initWithRootViewController:rfVC];
    nav4.navigationBar.hidden = YES;

    self.viewControllers = @[nav1,nav4,nav2,nav3];
    
    leftVC = [[LiftMenuVC alloc] init];
    [leftVC.view setFrame:CGRectMake(-20 * widthScale, 0, kScreen_Width, kScreen_Height)];
    [self.view insertSubview:leftVC.view atIndex:0];
        
    // 移动手势
    self.pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(myPan:)];
    [self.curView addGestureRecognizer:self.pan];
    
    // 点击手势
    self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click:)];
    self.tap.enabled = NO;
    [self.curView addGestureRecognizer:self.tap];
}

- (void)myPan:(UIPanGestureRecognizer *)panRec
{
    
    CGFloat x = self.curView.frame.origin.x;
    // 偏移
    CGPoint point = [panRec translationInView:self.curView];
    
    // 不让curView往左边 越界
    if (self.curView.center.x+point.x >= 160 * widthScale) {
        self.curView.center = CGPointMake(self.curView.center.x+point.x , kScreen_Height / 2);
    }
    if (self.curView.center.x+point.x >= 390 * widthScale) {
        // 不让curView越过230
        self.curView.center = CGPointMake(390 * widthScale, kScreen_Height / 2);
    }
    
    // 让leftVC 有个移动效果
    [leftVC.view setFrame:CGRectMake((-20 + 20 * (x / (230 * widthScale))) * widthScale, 0, kScreen_Width, kScreen_Height)];

    // 手势结束
    if (panRec.state == UIGestureRecognizerStateEnded) {
        // 如果超过宽度的一半 设置
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        // 展示leftView
        if (x >= 230 * widthScale/2) {
            x = 230 * widthScale;
            self.curView.frame = CGRectMake(230 * widthScale,  0, kScreen_Width, kScreen_Height);
            self.tap.enabled = YES;
        }
        // 展示self.curView
        else if (x > 0 && x < 230 * widthScale/2)
        {
            x = 0;
            self.curView.frame = CGRectMake(0, 0, kScreen_Width, kScreen_Height);
            self.tap.enabled = NO;
        }
        [leftVC.view setFrame:CGRectMake((-20 + 20 * (x / (230 * widthScale))) * widthScale, 0, kScreen_Width, kScreen_Height)];
        [UIView commitAnimations];
    }
    // 坐标转换复原
    [panRec setTranslation:CGPointMake(0, 0) inView:self.curView];
}

- (void)click:(UITapGestureRecognizer *)tapRec
{
    CGFloat x = self.curView.frame.origin.x;
    if (x == 230 * widthScale) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        [leftVC.view setFrame:CGRectMake(-20 * widthScale, 0, kScreen_Width, kScreen_Height)];
        self.curView.frame = CGRectMake(0, 0, kScreen_Width, kScreen_Height);
        [UIView commitAnimations];
        self.tap.enabled = NO;
    }
}

#pragma mark ohbuyMoveDelegate
- (void)ohbuyMoveMethod:(NSInteger)index
{
    CGFloat f;
    CGFloat t;
    if (index == ohbuyResetMove) {
        
        f = 0;
        t = -20 * widthScale;
        self.tap.enabled = NO;
    }
    else
    {
        f = 230 * widthScale;
        t = 0;
        self.tap.enabled = YES;
    }
    
    [UIView animateWithDuration:0.5 animations:^{
        [leftVC.view setFrame:CGRectMake(t, 0, kScreen_Width, kScreen_Height)];
        [self.curView setFrame:CGRectMake(f, 0, kScreen_Width, kScreen_Height)];
    } completion:nil];
}

#pragma mark ohbuyMoveDelegate
- (void)ohBuyMoveMethod:(NSInteger)index
{
    CGFloat f;
    CGFloat t;
    if (index == ohBuyResetMove) {
        f = 0;
        t = -20 * widthScale;
        self.tap.enabled = NO;
    }
    else
    {
        f = 230 * widthScale;
        t = 0;
        self.tap.enabled = YES;
    }
    
    [UIView animateWithDuration:0.5 animations:^{
        [leftVC.view setFrame:CGRectMake(t, 0, kScreen_Width, kScreen_Height)];
        [self.curView setFrame:CGRectMake(f, 0, kScreen_Width, kScreen_Height)];
    } completion:nil];
}

#pragma mark OhBuyMoveDelegate
- (void)OhBuyMoveMethod:(NSInteger)index
{
    CGFloat f;
    CGFloat t;
    if (index == OhBuyResetMove) {
        f = 0;
        t = -20 * widthScale;
        self.tap.enabled = NO;
    }
    else
    {
        f = 230 * widthScale;
        t = 0;
        self.tap.enabled = YES;
    }
    
    [UIView animateWithDuration:0.5 animations:^{
        [leftVC.view setFrame:CGRectMake(t, 0, kScreen_Width, kScreen_Height)];
        [self.curView setFrame:CGRectMake(f, 0, kScreen_Width, kScreen_Height)];
    } completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
