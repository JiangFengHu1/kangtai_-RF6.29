//
//
/**
 * Copyright (c) www.bugull.com
 */
//
//

#import "SingleVC.h"

#define HEIGHT_BUT 140
#define WIDTH_BUT 120
@interface SingleVC () <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, UIAlertViewDelegate>
{
    UITableView *timerTableView;
    UITableView *absenceTableView;
    UIScrollView *kindScrollView;
    
    CGRect rect;
    
    UIView *addBGView;
    UIButton *addBtn;
    
    NSMutableArray *chooseArr;
    NSArray *pathArr;
    
    UIButton *timerBtn;
    UIButton *absenceBtn;
    UIButton *countdownBtn;
    
    UIView *slider;
    UIImageView *chooseView;
    UIImageView *editImgView;
    UIImageView *energyInfoImgView;
    UIButton *editBtn;
    UIButton *energyInfoBtn;
    UIView *grayView;
    
    UILabel *editLabel;
    UILabel *energyInfoLabel;

    NSString *dayStr;
    int numberOfDaysInMonth;
    int height;
    int minutes;
    
    // 0629
    UILabel *countdownLab;
    UILabel *noteLab;
    NSMutableArray *countdownArr;
    UILabel *secondLab;
    int seconds;
    int countdown;
}

@property (nonatomic, assign) NSInteger tag;
@property (nonatomic, assign) NSInteger back;
@property (nonatomic, assign) NSInteger delete;
@property (nonatomic, assign) NSInteger dismiss;

@property(nonatomic,strong) UIImageView *iconImgView;
// timer
@property(nonatomic,strong)NSMutableArray *numberArray;
@property (nonatomic, assign)BOOL isOFF;
@property (nonatomic, assign)UInt8 hour;
@property (nonatomic, assign)UInt8 min;
@property (nonatomic, assign)UInt8 flag;
// countDown
@property (nonatomic,strong)NSTimer *animationTimer;
@property (nonatomic,copy)NSString *timeString;
@property (nonatomic,copy)NSString * countDownString;
// absence
@property (nonatomic,strong)NSMutableArray *absenceArray;
@property (nonatomic, strong) NSTimer *stateTimer;
@property (nonatomic, strong) NSTimer *countdownTimer;

@end

@implementation SingleVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tag = 1;
        self.back = 1;
        self.delete = 1;
        self.dismiss = 1;
        countdown = 0;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [MMProgressHUD showWithTitle:NSLocalizedString(@"Tips", nil) status:NSLocalizedString(@"Loading", nil)];
    minutes = 0;
    NSLog(@"ip=== %@ ===", self.devices.host);
    
    self.titlelab.text = [NSString stringWithFormat:@"%@",self.devices.name];
    
    Device *device = [[DeviceManagerInstance getlocalDeviceDictary] objectForKey:self.macString];
    
    if ([device.LockType isEqualToString:@"open"]){
        buttonIsNo = YES;
        self.imageV.image = [UIImage imageNamed:@"unlock_circle.png"];
        self.markImageV.image = [UIImage imageNamed:@"unlock_mark.png"];
    }else{
        buttonIsNo = NO;
        self.imageV.image = [UIImage imageNamed:@"locked__circle.png"];
        self.markImageV.image = [UIImage imageNamed:@"locked_mark.png"];
    }
    if ([self.stateString isEqualToString:@"on"]) {
        [self.iconBtn setBackgroundImage:[Util getImageFile:device.image] forState:UIControlStateNormal];
    } else {
        [self.iconBtn setBackgroundImage:[self grayImage:[Util getImageFile:device.image]] forState:UIControlStateNormal];
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [DeviceManagerInstance getDeviceInfoToMac:device.mac With:device.localContent WIthHost:device.host deviceType:device.deviceType];
        switch (_type) {
            case 1:
                [self reloadTimerList];
                break;
            case 2:
            {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self reloadCountdownList];
                });
            }
                break;
            case 3:
            {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self checkAbsenceResult];
                });
            }
                break;
            default:
                break;
        }
    });
    
    [self performSelector:@selector(dismissPressHUD) withObject:nil afterDelay:2.5f];
    
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 增加一个设备开 关的监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSwitchState) name:@"changeSwitchState" object:nil];
    
    _type = 1;
    chooseArr = [[NSMutableArray alloc] initWithCapacity:0];
    self.numberArray = [[NSMutableArray alloc] initWithCapacity:0];
    self.absenceArray = [[NSMutableArray alloc] initWithCapacity:1];
    self.rightBut.frame = CGRectMake(kScreen_Width - 52, barViewHeight - 44, 50, 44);
    [self.rightBut setBackgroundImage:[UIImage imageNamed:@"more_normal.png"] forState:UIControlStateNormal];
    [self.rightBut setBackgroundImage:[UIImage imageNamed:@"more_click.png"] forState:UIControlStateHighlighted];
    
    [self.barView setFrame:CGRectMake(0, 0, kScreen_Width, barViewHeight + 131)];
    [self.imageVW setFrame:self.barView.frame];
    
    self.iconBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.iconBtn.frame = CGRectMake((kScreen_Width - 82) / 2,barViewHeight + 5, 88, 88);
    self.iconBtn.layer.masksToBounds = YES;
    self.iconBtn.layer.cornerRadius = 44;
    [self.iconBtn addTarget:self action:@selector(iconClickMethod:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.iconBtn];
    
    Device *device = [[DeviceManagerInstance getlocalDeviceDictary] objectForKey:self.macString];
    device.alarm = self.stateString;
    [[DeviceManagerInstance getlocalDeviceDictary] setObject:device forKey:self.macString];
    if ([self.stateString isEqualToString:@"on"]) {
        [self.iconBtn setBackgroundImage:[Util getImageFile:self.devices.image] forState:UIControlStateNormal];
    } else {
        [self.iconBtn setBackgroundImage:[self grayImage:[Util getImageFile:self.devices.image]] forState:UIControlStateNormal];
    }
    
    NSDate *now = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
    NSString *dateString = [dateFormatter stringFromDate:now];
    dayStr = [dateString substringWithRange:NSMakeRange(6, 2)];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSRange dayRange = [calendar rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:[NSDate date]];
    // 当月天数
    numberOfDaysInMonth = (int)dayRange.length;
    
    self.imageV = [[UIImageView alloc] initWithFrame:CGRectMake((kScreen_Width - 82) / 2, barViewHeight + 4, 89, 89)];
    self.imageV.backgroundColor = [UIColor clearColor];
    self.imageV.layer.masksToBounds = YES;
    self.imageV.layer.cornerRadius = 44.5;
    self.markImageV = [[UIImageView alloc] initWithFrame:CGRectMake((kScreen_Width - 82) / 2 + 87, barViewHeight + 10, 40, 80)];
    self.markImageV.userInteractionEnabled = YES;
    UITapGestureRecognizer *lockTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(lockDeviceMethod)];
    [self.markImageV addGestureRecognizer:lockTap];
    [self.view addSubview:self.imageV];
    [self.view addSubview:self.markImageV];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self reloadTimerList];
        [self reloadCountdownList];
        [self checkAbsenceResult];
    });

    // 定时
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(downloadDataToTimer:) name:@"GetTimer" object:nil];
    // 倒计时
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadDataToCountDown:) name:@"countDown" object:nil];
    // 防盗
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadDataToAbsence:) name:@"Absence" object:nil];
    
    height =  ![device.deviceType isEqualToString:@"21"] ? (self.barView.frame.size.height - barViewHeight - 55) : (self.barView.frame.size.height - barViewHeight - 5);
    chooseView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreen_Width - 135, barViewHeight - 5, 135, 0)];
    chooseView.image = [UIImage imageNamed:@"pop_up_box_back.png"];
    [self.view addSubview:chooseView];
    
    editImgView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreen_Width - 130 + 5, 0, 0, 0)];
    editImgView.userInteractionEnabled = YES;
    editImgView.image = [UIImage imageNamed:@"pop_up_box_edit.png"];
    [self.view addSubview:editImgView];
    UITapGestureRecognizer *editImgTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToEditVC)];
    [editImgView addGestureRecognizer:editImgTap];
    
    editLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreen_Width - 130 + 35, 0, 0, 0)];
    editLabel.backgroundColor = [UIColor clearColor];
    editLabel.text = NSLocalizedString(@"Edit", nil);
    editLabel.adjustsFontSizeToFitWidth = YES;
    editLabel.textColor = RGBA(30.0, 180.0, 240.0, 1.0);
    editLabel.textAlignment = NSTextAlignmentLeft;
    editLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *editTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToEditVC)];
    [editLabel addGestureRecognizer:editTap];
    [self.view addSubview:editLabel];
    
    energyInfoImgView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreen_Width - 130 + 5, 0, 0, 0)];
    energyInfoImgView.userInteractionEnabled = YES;
    energyInfoImgView.hidden = ![device.deviceType isEqualToString:@"21"];
    energyInfoImgView.image = [UIImage imageNamed:@"pop_up_box_Energy_Info.png"];
    [self.view addSubview:energyInfoImgView];
    UITapGestureRecognizer *infoTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToEnergyInfoVC)];
    [energyInfoImgView addGestureRecognizer:infoTap];
    
    energyInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreen_Width - 130 + 35, 0, 0, 0)];
    energyInfoLabel.backgroundColor = [UIColor clearColor];
    energyInfoLabel.hidden = ![device.deviceType isEqualToString:@"21"];
    energyInfoLabel.text = NSLocalizedString(@"Energy Info", nil);
    energyInfoLabel.numberOfLines = 0;
    energyInfoLabel.lineBreakMode = NSLineBreakByCharWrapping;
    energyInfoLabel.textColor = RGBA(30.0, 180.0, 240.0, 1.0);
    energyInfoLabel.textAlignment = NSTextAlignmentLeft;
    energyInfoLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *energyInfoTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToEnergyInfoVC)];
    [energyInfoLabel addGestureRecognizer:energyInfoTap];
    [self.view addSubview:energyInfoLabel];
    
    NSArray *nameArray = [NSArray arrayWithObjects:NSLocalizedString(@"Timer", nil),NSLocalizedString(@"Count Down", nil),NSLocalizedString(@"Absence", nil), nil];
    
    UILabel *timerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.imageV.frame.origin.y + self.imageV.frame.size.height + 11, kScreen_Width / 3, 15)];
    timerLabel.backgroundColor = [UIColor clearColor];
    timerLabel.font = [UIFont systemFontOfSize:16];
    timerLabel.adjustsFontSizeToFitWidth = YES;
    timerLabel.textAlignment = NSTextAlignmentCenter;
    timerLabel.textColor = [UIColor whiteColor];
    timerLabel.text = nameArray[0];
    [self.view addSubview:timerLabel];
    
    UILabel *countdownLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreen_Width / 3, self.imageV.frame.origin.y + self.imageV.frame.size.height + 11, kScreen_Width / 3, 15)];
    countdownLabel.backgroundColor = [UIColor clearColor];
    countdownLabel.font = [UIFont systemFontOfSize:16];
    countdownLabel.adjustsFontSizeToFitWidth = YES;
    countdownLabel.textAlignment = NSTextAlignmentCenter;
    countdownLabel.textColor = [UIColor whiteColor];
    countdownLabel.text = nameArray[1];
    [self.view addSubview:countdownLabel];
    
    UILabel *absenceLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreen_Width / 3 * 2, self.imageV.frame.origin.y + self.imageV.frame.size.height + 11, kScreen_Width / 3, 15)];
    absenceLabel.backgroundColor = [UIColor clearColor];
    absenceLabel.font = [UIFont systemFontOfSize:16];
    absenceLabel.adjustsFontSizeToFitWidth = YES;
    absenceLabel.textAlignment = NSTextAlignmentCenter;
    absenceLabel.textColor = [UIColor whiteColor];
    absenceLabel.text = nameArray[2];
    [self.view addSubview:absenceLabel];
    
    slider = [[UIView alloc] initWithFrame:CGRectMake(0, 35 + self.imageV.frame.origin.y + self.imageV.frame.size.height, kScreen_Width / 3, 3)];
    slider .backgroundColor = [UIColor orangeColor];
    [self.view addSubview:slider];
    
    timerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    timerBtn.frame = CGRectMake(0, timerLabel.frame.origin.y, kScreen_Width / 3, 30);
    [timerBtn addTarget:self action:@selector(hideTableView:) forControlEvents:UIControlEventTouchUpInside];
    timerBtn.tag = 100 + 1;
    [self.view addSubview:timerBtn];
    
    countdownBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    countdownBtn.frame = CGRectMake(kScreen_Width / 3, timerLabel.frame.origin.y, kScreen_Width / 3, 30);
    [countdownBtn addTarget:self action:@selector(hideTableView:) forControlEvents:UIControlEventTouchUpInside];
    countdownBtn.tag = 100 + 2;
    [self.view addSubview:countdownBtn];
    
    absenceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    absenceBtn.frame = CGRectMake(kScreen_Width / 3 * 2, timerLabel.frame.origin.y , kScreen_Width / 3, 30);
    [absenceBtn addTarget:self action:@selector(hideTableView:) forControlEvents:UIControlEventTouchUpInside];
    absenceBtn.tag = 100 + 3;
    [self.view addSubview:absenceBtn];
    
    rect = CGRectMake(0, self.barView.frame.size.height, kScreen_Width, kScreen_Height - self.barView.frame.size.height);
    
    kindScrollView = [[UIScrollView alloc] initWithFrame:rect];
    kindScrollView.delegate = self;
    kindScrollView.bounces = NO;
    kindScrollView.pagingEnabled = YES;
    kindScrollView.contentSize = CGSizeMake(kScreen_Width * 3, rect.size.height);
    kindScrollView.backgroundColor = [UIColor whiteColor];
    kindScrollView.showsHorizontalScrollIndicator = NO;
    kindScrollView.showsVerticalScrollIndicator = NO;
    
    timerTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height - ((iOS_version < 7.0) ? 80 : 60)) style:UITableViewStylePlain];
    timerTableView.backgroundColor = [UIColor whiteColor];
    timerTableView.delegate = self;
    timerTableView.dataSource = self;
    timerTableView.separatorStyle = 0;
    timerTableView.userInteractionEnabled = YES;
    [timerTableView addHeaderWithTarget:self action:@selector(timerHeaderReresh)];
    [kindScrollView addSubview:timerTableView];

    countdownLab = [[UILabel alloc] initWithFrame:CGRectMake(kScreen_Width, 90, kScreen_Width, 50)];
    countdownLab.backgroundColor = [UIColor clearColor];
    countdownLab.text = @"06:30";
    countdownLab.textColor = RGB(20, 170, 240);
    countdownLab.textAlignment = NSTextAlignmentCenter;
    countdownLab.font = [UIFont systemFontOfSize:45];
    countdownLab.hidden = YES;
    [kindScrollView addSubview:countdownLab];
    
    secondLab = [[UILabel alloc] initWithFrame:CGRectMake(0, -3, kScreen_Width, 50)];
    secondLab.backgroundColor = [UIColor clearColor];
    secondLab.hidden = YES;
    secondLab.textAlignment = NSTextAlignmentCenter;
    secondLab.text = @":";
    secondLab.font = [UIFont systemFontOfSize:45];
    secondLab.textColor = RGB(20, 170, 240);
    [countdownLab addSubview:secondLab];
    
    noteLab = [[UILabel alloc] initWithFrame:CGRectMake(kScreen_Width, 160, kScreen_Width, 30)];
    noteLab.backgroundColor = [UIColor clearColor];
    noteLab.text = @"后打开电源";
    noteLab.textColor = RGB(20, 170, 240);
    noteLab.font = [UIFont systemFontOfSize:30];
    noteLab.textAlignment = NSTextAlignmentCenter;
    noteLab.hidden = YES;
    [kindScrollView addSubview:noteLab];

    absenceTableView = [[UITableView alloc] initWithFrame:CGRectMake(kScreen_Width * 2, 0, rect.size.width, rect.size.height - 60)  style:UITableViewStylePlain];
    absenceTableView.backgroundColor = [UIColor whiteColor];
    absenceTableView.delegate = self;
    absenceTableView.dataSource = self;
    absenceTableView.separatorStyle = 0;
    absenceTableView.userInteractionEnabled = YES;
    [absenceTableView addHeaderWithTarget:self action:@selector(absenceHeaderReresh)];
    [kindScrollView addSubview:absenceTableView];
    [self.view addSubview:kindScrollView];
    
    // timer底部的view
    addBGView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreen_Height - ((iOS_version < 7.0) ? 80 : 60), kScreen_Width, 60)];
    addBGView.backgroundColor = RGBA(210, 210, 210, 1);
    [self.view addSubview:addBGView];
    
    addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addBtn.frame = CGRectMake(0, 0, 40, 40);
    addBtn.center = CGPointMake(addBGView.frame.size.width / 2, addBGView.frame.size.height / 2);
    [addBtn setBackgroundImage:[UIImage imageNamed:@"add_timer_normal"] forState:UIControlStateNormal];
    [addBtn setBackgroundImage:[UIImage imageNamed:@"add_timer_click"] forState:UIControlStateHighlighted];
    [addBtn addTarget:self action:@selector(addMore:) forControlEvents:UIControlEventTouchUpInside];
    [addBGView addSubview:addBtn];
    
    self.view.backgroundColor = [UIColor colorWithRed:241.0/255 green:241.0/255 blue:240.0/255 alpha:1];
    UITapGestureRecognizer *cancelChooseTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelChoose)];
    self.barView.userInteractionEnabled = YES;
    [self.barView addGestureRecognizer:cancelChooseTap];
    UITapGestureRecognizer *cancelChooseTap_ = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelChoose)];
    kindScrollView.userInteractionEnabled = YES;
    [kindScrollView addGestureRecognizer:cancelChooseTap_];
}

- (void)cancelChoose
{
    [UIView animateWithDuration:.2f animations:^{
        if (showMenu == NO) {
            chooseView.frame = CGRectMake(kScreen_Width - 135, barViewHeight - 5, 135, 0);
            editLabel.frame = CGRectMake(kScreen_Width - 130 + 35, 0, 0, 0);
            energyInfoLabel.frame = CGRectMake(kScreen_Width - 130 + 35, 0, 0, 0);
            editImgView.frame = CGRectMake(kScreen_Width - 130 + 5, 0, 0, 0);
            energyInfoImgView.frame = CGRectMake(kScreen_Width - 130 + 5, 0, 0,0);
            showMenu = YES;
        }
    }];
}

- (void)reloadTimerList
{
    Device *device = [[DeviceManagerInstance getlocalDeviceDictary] objectForKey:self.devices.macString];
    for (int i = 0; i < 2; i++) {
        [DeviceManagerInstance  getTimeringWith:device.mac inUDPHost:device.host key:device.key With:device.localContent deviceType:device.deviceType];
    }
}

- (void)dismissPressHUD
{
    [MMProgressHUD dismiss];
}

#pragma mark - reloadCountdownList
- (void)reloadCountdownList
{
    Device *device = [[DeviceManagerInstance getlocalDeviceDictary] objectForKey:self.macString];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (int i = 0; i < 2; i++) {
            [DeviceManagerInstance getCountdownWith:device.mac inUDPHost:device.host key:device.key With:device.localContent deviceType:device.deviceType orderType:@"1"];
        }
    });
}

static bool buttonIsNo = NO;
static bool lock = NO;

- (void)lockDeviceMethod
{
    Device *device = [[DeviceManagerInstance getlocalDeviceDictary] objectForKey:self.macString];
    if (device == nil) {
        return;
    }
    
    if ([device.localContent intValue] == 1) {
        if (buttonIsNo == YES){
            lock = NO;
            self.devices.LockType = @"close";
            buttonIsNo = NO;
            self.imageV.image = [UIImage imageNamed:@"locked__circle.png"];
            self.markImageV.image = [UIImage imageNamed:@"locked_mark.png"];
        } else if (buttonIsNo == NO){
            buttonIsNo = YES;
            lock = YES;
            self.devices.LockType = @"open";
            self.imageV.image = [UIImage imageNamed:@"unlock_circle.png"];
            self.markImageV.image = [UIImage imageNamed:@"unlock_mark.png"];
            
        }
        if (self.devices != nil) {
            [[DeviceManagerInstance getlocalDeviceDictary] setObject:self.devices forKey:self.devices.macString];
        }
        [LocalServiceInstance  sendToUdpLockWithData:self.devices.mac lock:lock isHost:self.devices.host key:self.devices.key deviceType:self.devices.deviceType];
    } else {
        [Util showAlertWithTitle:NSLocalizedString(@"Tips", nil) msg:NSLocalizedString(@"Sorry, this operation is only supported at local.", nil)];
    }
}

- (void)changeSwitchState
{
    if ([_stateTimer isValid]) {
        [_stateTimer invalidate];
        _stateTimer = nil;
    }
    self.stateTimer =  [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timerControlMethod) userInfo:nil repeats:NO];
}
// 及时更新图标的状态
- (void)timerControlMethod
{
    NSMutableArray  *array= [[NSUserDefaults standardUserDefaults] objectForKey:OPEN_CLOSE_INFO];
    NSDictionary *dic = [array objectAtIndex:0];
    NSInteger switchFlag = [[dic objectForKey:@"switch"] integerValue];
    
    Device *device = [[DeviceManagerInstance getlocalDeviceDictary] objectForKey:self.macString];
    NSData *macData = dic[@"mac"];
    
    if (array.count == 0 || ![[Crypt hexEncode:macData] isEqualToString:self.macString] || device == nil) {
        return;
    }
    
    if (switchFlag == 255) {
        selected = YES;
        self.devices.alarm = @"on";
        self.stateString = @"on";
        [self.iconBtn setBackgroundImage:[Util getImageFile:device.image] forState:UIControlStateNormal];
    }
    if (switchFlag == 0) {
        self.devices.alarm = @"off";
        self.stateString = @"off";
        [self.iconBtn setBackgroundImage:[self grayImage:[Util getImageFile:device.image]] forState:UIControlStateNormal];
        selected = NO;
    }
    
    [self performSelector:@selector(stopAnimationWithButton) withObject:nil afterDelay:0.05];;
    if (self.devices != nil) {
        [[DeviceManagerInstance getlocalDeviceDictary] setObject:device forKey:self.macString];
    }
}

#pragma mark - 点击事件
// icon 添加控制开关的点击
static  BOOL selected = NO;
- (void)iconClickMethod:(UIButton *)button
{
    Device *device = [[DeviceManagerInstance getlocalDeviceDictary] objectForKey:self.devices.macString];
    BOOL lock = YES;
    
    selected = !button.isSelected;
    [button setSelected:selected];

    NSData *macData = [[Util getUtitObject]macStrTData:self.devices.macString];
    
    if ([device.alarm isEqualToString:@"on"])
    {
        lock = NO;
    }
    if ([device.alarm isEqualToString:@"off"])
    {
        lock = YES;
    }

    [self.animationTimer invalidate];

    [self startAnimationWithButton:button];
    
    if ([DeviceManagerInstance networkStatus] == ReachableViaWiFi && [device.localContent isEqualToString:@"1"])
    {
        [LocalServiceInstance  setGPIOCloseOrOpenWithDeciceMac:macData index:lock host:device.host key:nil deviceType:device.deviceType];
        [self performSelector:@selector(getDeviceInfo:) withObject:device afterDelay:0.5];
    }
    else {
        
        [RemoteServiceInstance setGPIOCloseOrOpenWithDeciceMac:macData index:lock deviceType:device.deviceType];
    }
    
    [self  performSelector:@selector(stopAnimationWithButton) withObject:nil afterDelay:8.f];
}

- (void)getDeviceInfo:(Device *)device
{
    NSData *mac = [Crypt decodeHex:self.devices.macString];
    [LocalServiceInstance queryGPIOEventToMac:mac withhost:self.devices.host deviceType:self.devices.deviceType];
}

- (void)startAnimationWithButton:(UIButton *)btn
{
    self.iconBtn.transform = CGAffineTransformIdentity;
    self.animationTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(animate) userInfo:nil repeats:YES];
}

- (void)animate
{
    self.iconBtn.transform = CGAffineTransformRotate(self.iconBtn.transform, DEGREES_TO_RADIANS(50));
}

- (void)stopAnimationWithButton
{
    [self.animationTimer invalidate];
    self.animationTimer = nil;
    self.iconBtn.transform = CGAffineTransformIdentity;
}

// 删除cell
- (void)deleteTimerCell:(UITapGestureRecognizer *)tap
{
    self.delete = 2;
    [chooseArr removeObjectAtIndex:[tap.tag intValue] - 100000];
    NSDictionary *tempDic = [self.numberArray objectAtIndex:[tap.tag intValue] - 100000];
    NSString *indexStr =  [tempDic objectForKey:@"indx"];
    Device *device = [[DeviceManagerInstance getlocalDeviceDictary] objectForKey:self.devices.macString];
    [DeviceManagerInstance deleteDeviceTimeingWith:device.mac Withhost:device.host InToNum:[indexStr intValue] With:device.localContent deviceType:device.deviceType];
    [self.numberArray removeObjectAtIndex:[tap.tag intValue] - 100000];
    
    [timerTableView reloadData];

    if (self.numberArray.count == 0) {
        self.back = 1;
        self.delete = 1;
        self.rightBut.hidden = NO;
        [timerTableView reloadData];
        [timerTableView setFrame:CGRectMake(kScreen_Width * 0, 0, rect.size.width, rect.size.height - 60)];
        countdownBtn.userInteractionEnabled = YES;
        absenceBtn.userInteractionEnabled = YES;
        timerTableView.headerHidden = NO;
        kindScrollView.scrollEnabled = YES;
        addBGView.hidden = NO;
    }
}

- (void)deleteCountdown
{
    [self.countdownTimer invalidate];
    [_secondTimer invalidate];
    self.countdownTimer = nil;
    _secondTimer = nil;
    
    [addBtn setBackgroundImage:[UIImage imageNamed:@"add_timer_normal"] forState:UIControlStateNormal];
    [addBtn setBackgroundImage:[UIImage imageNamed:@"add_timer_click"] forState:UIControlStateHighlighted];
    
    Device *device = [[DeviceManagerInstance getlocalDeviceDictary] objectForKey:self.devices.macString];
    [DeviceManagerInstance getCountdownWith:device.mac inUDPHost:device.host key:device.key With:device.localContent deviceType:device.deviceType orderType:@"2"];
    
    countdownLab.hidden = YES;
    secondLab.hidden = YES;
    noteLab.hidden = YES;
    seconds = 0;
    countdown = 0;
}

- (void)deleteAbsenceCell:(UITapGestureRecognizer *)tap
{
    AbsenceCell *cell = (AbsenceCell *)[self.view viewWithTag:[tap.tag intValue]];
    cell.delView.hidden = YES;
    self.rightBut.hidden = NO;
    NSDictionary *tempDic = [self.absenceArray objectAtIndex:[tap.tag intValue] - 1000];
    //    NSMutableArray *temparray = [DataBase selectDataFromDataBaseWithId:self.devices.deviceId];
    //    Device *mode =  [temparray objectAtIndex:0];
    
    Device *device = [[DeviceManagerInstance getlocalDeviceDictary] objectForKey:self.devices.macString];
    [DeviceManagerInstance absenceToDeviceWith:device.mac Withhost:device.host ToOpen:NO WithState:[tempDic objectForKey:@"from"] WithTodate:[tempDic objectForKey:@"to"]  key:device.key With:device.localContent deviceType:device.deviceType];
    
    self.back = 1;
    addBGView.hidden = NO;
    absenceTableView.headerHidden = NO;
    kindScrollView.scrollEnabled = YES;
    timerBtn.userInteractionEnabled = YES;
    countdownBtn.userInteractionEnabled = YES;
    [absenceTableView setFrame:CGRectMake(kScreen_Width * 2, 0, rect.size.width, rect.size.height - 60)];
    
    [self.absenceArray removeObjectAtIndex:[tap.tag intValue] - 1000];
    [absenceTableView reloadData];
}

// 添加更多的定时 倒计时 防盗
- (void)addMore:(UIButton *)btn
{
    if (self.tag == 1) {
        if ([self.numberArray count]>9) {
            
            [Util showAlertWithTitle:NSLocalizedString(@"Tips", nil) msg:NSLocalizedString(@"Ten groups timer are limited", nil)];
            return;
        }
        SetTimerVC *addTimerVC = [[SetTimerVC alloc] init];
        addTimerVC.typeStr = @"add";
        addTimerVC.indexArray = self.numberArray;
        addTimerVC.macString = self.devices.macString;
        [self.navigationController pushViewController:addTimerVC animated:YES];
    } else if (self.tag == 2) {
        if (!secondLab.hidden) {
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Tips", nil) message:NSLocalizedString(@"One group countdown is limited,want to delete it and add a new one?", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) otherButtonTitles:NSLocalizedString(@"Confirm", nil), nil];
            [alertView show];
        } else {
            AddCountDownVC *addCDVC = [[AddCountDownVC alloc] init];
            addCDVC.macString = self.devices.macString;
            [self.navigationController pushViewController:addCDVC animated:YES];
        }
    } else if (self.tag == 3) {
        if ([self.absenceArray count]>0) {
            [Util showAlertWithTitle:NSLocalizedString(@"Tips", nil) msg:NSLocalizedString(@"One group absence is limited", nil)];
        } else {
            EditAbsenceVC *editVC = [[EditAbsenceVC alloc] init];
            editVC.macString = self.devices.macString;
            [self.navigationController pushViewController:editVC animated:YES];
        }
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self deleteCountdown];
    }
}

// cell的长按手势
- (void)timerLongPressed:(UILongPressGestureRecognizer *)longPress
{
    if (longPress.state == 1) {
        
        self.rightBut.hidden = YES;
        [timerTableView setFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
        kindScrollView.scrollEnabled = NO;
        countdownBtn.userInteractionEnabled = NO;
        absenceBtn.userInteractionEnabled = NO;
        addBGView.hidden = YES;
        timerTableView.headerHidden = YES;
        self.back = 2;
        self.delete = 2;
        [timerTableView reloadData];
    }
}

- (void)absenceLongPress:(UILongPressGestureRecognizer *)longPress
{
    if (longPress.state == 1){
        AbsenceCell *cell;
        for (int i = 0; i < self.absenceArray.count; i++) {
            cell = (AbsenceCell *)[self.view viewWithTag:i + 1000];
            cell.delView.hidden = NO;
        }
        self.rightBut.hidden = YES;
        [absenceTableView setFrame:CGRectMake(kScreen_Width * 2, 0, rect.size.width, rect.size.height)];
        cell.delView.hidden = NO;
        kindScrollView.scrollEnabled = NO;
        countdownBtn.userInteractionEnabled = NO;
        timerBtn.userInteractionEnabled = NO;
        addBGView.hidden = YES;
        absenceTableView.headerHidden = YES;
        self.back = 2;
    }
}

- (void)timerHeaderReresh
{
    // 刷新表格
    [self reloadTimerList];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

        [timerTableView reloadData];
        [timerTableView headerEndRefreshing];
    });
}

- (void)absenceHeaderReresh
{
    [self checkAbsenceResult];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

        [[NSNotificationCenter defaultCenter] postNotificationName:@"Absence" object:nil];
        [absenceTableView reloadData];
        
        [absenceTableView headerEndRefreshing];
    });
}


- (void)downloadDataToTimer:(NSNotification *)notifiaction
{
    [self.numberArray removeAllObjects];
    [chooseArr removeAllObjects];
    NSMutableArray *tempArray = [notifiaction object];
    
    Device *device = [[DeviceManagerInstance getlocalDeviceDictary] objectForKey:self.macString];
    
    if ([device.LockType isEqualToString:@"open"]){
        buttonIsNo = YES;
        self.imageV.image = [UIImage imageNamed:@"unlock_circle.png"];
        self.markImageV.image = [UIImage imageNamed:@"unlock_mark.png"];
    }else{
        buttonIsNo = NO;
        self.imageV.image = [UIImage imageNamed:@"locked__circle.png"];
        self.markImageV.image = [UIImage imageNamed:@"locked_mark.png"];
    }
    
    for (NSDictionary *dict in tempArray)
    {
        
        NSString *number = [dict objectForKey:@"indx"];
        if ([number intValue] > 10) {
            continue;
        }
        
        NSString * hour = [dict objectForKey:@"hour"];
        
        if ([hour intValue] == 0xff || [hour intValue] == 255) {
            
            continue;
        }else{
            [self.numberArray addObject:dict];
            [chooseArr addObject:@"0"];
        }
    }
    
    [timerTableView reloadData];
}

#pragma mark - reloadDataToCountDown
- (void)reloadDataToCountDown:(NSNotification *)notification
{
    NSMutableArray *tempArray = [notification object];
    
    NSDictionary *dict = tempArray[0];
    NSString *flag =  [dict objectForKey:@"flag"];
    seconds = [dict[@"seconds"] intValue];
    if ([flag intValue] == 0 || seconds >= 86340) {
        return;
    } else {
        
        seconds = [dict[@"seconds"] intValue] + 2;
        
        NSLog(@"seconds ===== %d", seconds);
        
        NSLog(@"=== %@ === %d", dict, [dict[@"switch"] intValue]);
        
        noteLab.text = ([[dict objectForKey:@"switch"] intValue] == 255) ? NSLocalizedString(@"ON", nil) : NSLocalizedString(@"OFF", nil);
        if (self.tag == 2) {
            [addBtn setBackgroundImage:[UIImage imageNamed:@"del_blue_normal"] forState:UIControlStateNormal];
            [addBtn setBackgroundImage:[UIImage imageNamed:@"del_blue_click"] forState:UIControlStateHighlighted];
        }
        if ([_secondTimer isValid]) {
            [_secondTimer invalidate];
            _secondTimer = nil;
        }
        _secondTimer = [NSTimer scheduledTimerWithTimeInterval:0.5f target:self selector:@selector(perSecond) userInfo:nil repeats:YES];
    }
}

#pragma mark - perSecond
- (void)perSecond
{
//    NSLog(@"countdown == %d  %@", countdown, _macString);
    
    if (countdown % 2 == 0) {
        secondLab.text = @"";
    } else {
        secondLab.text = @":";
    }
    
    if (countdown % 120 == 0) {
        countdownLab.text = [NSString stringWithFormat:@"%02d   %02d", (int)seconds / 3600, (int)(seconds % 3600 / 60)];
        
        seconds -= 60;
        if (seconds < 0) {
            [_secondTimer invalidate];
            _secondTimer = nil;
            countdownLab.hidden = YES;
            noteLab.hidden = YES;
            secondLab.hidden = YES;
            
            [addBtn setBackgroundImage:[UIImage imageNamed:@"add_timer_normal"] forState:UIControlStateNormal];
            [addBtn setBackgroundImage:[UIImage imageNamed:@"add_timer_click"] forState:UIControlStateHighlighted];
            return;
        }
    }
    
    countdownLab.hidden = NO;
    noteLab.hidden = NO;
    secondLab.hidden = NO;

    countdown++;
}

#pragma mark - timerFiredMethod
- (void)timerFiredMethod:(NSTimer*)theTimer
{
}

- (void)checkAbsenceResult
{
    Device *device = [[DeviceManagerInstance getlocalDeviceDictary] objectForKey:self.devices.macString];
    
    [DeviceManagerInstance getQueryTheftModeDeviceMToDeviceWith:device.mac Withhost:device.host key:device.key With:device.localContent deviceType:device.deviceType];
}

- (void)reloadDataToAbsence:(NSNotification *)notification
{
    NSDictionary *dictary  = [notification object];
    if (dictary) {
        [self.absenceArray removeAllObjects];
        
        NSLog(@"before === absence array = %@ == %@", _absenceArray, dictary);
        
        
        NSString *flag =  [dictary objectForKey:@"flag"];
        if ([flag intValue] != 0) {
            
            int toInt = [Util uint32FromNetData:[dictary objectForKey:@"to"]];
            
            NSDate *toDate  = [NSDate dateWithTimeIntervalSince1970:toInt];
            NSDate *systemTo = [DateUtil getNowDateFromatAnDate:toDate];
            
            NSDate *nowDate = [NSDate date];
            NSComparisonResult resulir = [systemTo compare:nowDate];
            if (resulir == NSOrderedAscending) {
                
            }else{
                [self.absenceArray addObject:dictary];
            }
        }
        
        NSLog(@"after === absence array = %@", _absenceArray);
        
        [absenceTableView reloadData];
    }
    
}

#pragma mark - to EditVC & EnergyInfoVC
- (void)goToEditVC
{
    showMenu = YES;
    [UIView animateWithDuration:.2f animations:^{

        chooseView.frame = CGRectMake(kScreen_Width - 135, barViewHeight - 5, 135, 0);
        editLabel.frame = CGRectMake(kScreen_Width - 130 + 35, 0, 0, 0);
        energyInfoLabel.frame = CGRectMake(kScreen_Width - 130 + 35, 0, 0, 0);
        editImgView.frame = CGRectMake(kScreen_Width - 130 + 5, 0, 0, 0);
        energyInfoImgView.frame = CGRectMake(kScreen_Width - 130 + 5, 0, 0, 0);
    }completion:nil];

    EditVC *editVC = [[EditVC alloc] init];
    editVC.editstateType = EditStateWFpush;
    editVC.macStr = self.devices.macString;
    [self.stateTimer invalidate];
    [self.countdownTimer invalidate];
    [_secondTimer invalidate];
    [self.navigationController pushViewController:editVC animated:YES];
}

- (void)goToEnergyInfoVC
{
    showMenu = YES;
    [UIView animateWithDuration:.2f animations:^{
        //        grayView.hidden = YES;
        chooseView.frame = CGRectMake(kScreen_Width - 135, barViewHeight - 5, 135, 0);
        editLabel.frame = CGRectMake(kScreen_Width - 130 + 35, 0, 0, 0);
        energyInfoLabel.frame = CGRectMake(kScreen_Width - 130 + 35, 0, 0, 0);
        editImgView.frame = CGRectMake(kScreen_Width - 130 + 5, 0, 0, 0);
        energyInfoImgView.frame = CGRectMake(kScreen_Width - 130 + 5, 0, 0, 0);
    }completion:nil];

    [self.stateTimer invalidate];
    [self.countdownTimer invalidate];
    [_secondTimer invalidate];
    
    EnergyInfoVC *energyInfoVC = [[EnergyInfoVC alloc] init];
    energyInfoVC.macStr = self.devices.macString;
    energyInfoVC.type = 1;
    [self.navigationController pushViewController:energyInfoVC animated:YES];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == timerTableView)
    {
        return 70;
    }
    else if (tableView == absenceTableView)
    {
        return 80;
    }
    return 0;
}

#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == timerTableView)
    {
        return self.numberArray.count;
    }
    else if (tableView == absenceTableView)
    {
        return self.absenceArray.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == timerTableView) {
        
        static NSString *cellID = @"cellId";
        LockCell*cell = [tableView dequeueReusableCellWithIdentifier:
                         cellID];
        if (cell == nil) {
            cell = [[LockCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                   reuseIdentifier:cellID];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (self.delete == 1) {
            cell.delView.hidden = YES;
        } else if (self.delete == 2) {
            cell.delView.hidden = NO;
        }
        
        NSDictionary *dict = [self.numberArray objectAtIndex:indexPath.row];
        
        NSString *string = [self systemTimeZoneWithFlag:[[dict objectForKey:@"flag"] intValue] WithHour:[dict objectForKey:@"hour"] Minent:[dict objectForKey:@"min"]];
        
        cell.titleName.textColor = RGBA(30.0, 180.0, 240.0, 1.0);
        NSString *time = [self dateStingWithHoutAndMinWith:[dict objectForKey:@"hour"] WIthMin:[dict objectForKey:@"min"]];
        
        if ([[dict objectForKey:@"switch"] intValue] == 0xff) {
            cell.switchLab.text = NSLocalizedString(@"ON",nil);
        }else{
            cell.switchLab.text = NSLocalizedString(@"OFF",nil);
        }
        cell.titleName.text = time;
        cell.detailLab.text = string;
        
        if (self.isOFF == YES) {
            [chooseArr replaceObjectAtIndex:indexPath.row withObject:@"1"];
            [cell.switchBut setImage:[UIImage imageNamed:@"button_open.png"] forState:UIControlStateNormal];
        } else {
            [chooseArr replaceObjectAtIndex:indexPath.row withObject:@"0"];
            [cell.switchBut setImage:[UIImage imageNamed:@"button_close.png"] forState:UIControlStateNormal];
        }
        
        cell.switchBut.hidden = NO;
        cell.switchBut.tag = indexPath.row + 2000;
        [cell.switchBut addTarget:self action:@selector(switchClickedMethod:) forControlEvents:UIControlEventTouchUpInside];
        cell.tag = indexPath.row + 100000;
        
        UITapGestureRecognizer *timerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(deleteTimerCell:)];
        timerTap.tag = [NSString stringWithFormat:@"%ld",(long)cell.tag];
        [cell.delView addGestureRecognizer:timerTap];
        
        UILongPressGestureRecognizer *timerLongPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(timerLongPressed:)];
        [timerLongPress setMinimumPressDuration:0.5f];
        cell.userInteractionEnabled = YES;
        [cell addGestureRecognizer:timerLongPress];
        
        timerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editTimer:)];
        timerTap.tag = [NSString stringWithFormat:@"%ld",(long)cell.tag + 100];
        [cell addGestureRecognizer:timerTap];

        return cell;
        
    } else if (tableView == absenceTableView) {
        static NSString *SimpleTableIdentifier = @"SimpleTableIdentifier";
        
        AbsenceCell*cell = [tableView dequeueReusableCellWithIdentifier:
                            SimpleTableIdentifier];
        if (cell == nil) {
            cell = [[AbsenceCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier: SimpleTableIdentifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        NSDictionary *dict = [self.absenceArray objectAtIndex:indexPath.row];
        
        int fromInt = [Util uint32FromNetData:[dict objectForKey:@"from"]];
        int toInt = [Util uint32FromNetData:[dict objectForKey:@"to"]];
        
        NSDate *fromDate  = [NSDate dateWithTimeIntervalSince1970:fromInt];
        NSDate *toDate  = [NSDate dateWithTimeIntervalSince1970:toInt];
        
        NSDate *systemFrom = [DateUtil getNowDateFromatAnDate:fromDate];
        NSDate *systemTo = [DateUtil getNowDateFromatAnDate:toDate];
        
        
        cell.titleName.text = [[NSString stringWithFormat:@"%@",systemFrom] substringWithRange:NSMakeRange(0, 16)];
        cell.detailLab.text =[[NSString stringWithFormat:@"%@",systemTo] substringWithRange:NSMakeRange(0, 16)];
        
        UILongPressGestureRecognizer *absencePress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(absenceLongPress:)];
        [absencePress setMinimumPressDuration:0.5f];
        cell.userInteractionEnabled = YES;
        [cell addGestureRecognizer:absencePress];
        
        UITapGestureRecognizer *absenceTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(deleteAbsenceCell:)];
        [cell.delView addGestureRecognizer:absenceTap];
        
        cell.tag = indexPath.row + 1000;
        absenceTap.tag = [NSString stringWithFormat:@"%ld",(long)cell.tag];
        
        return cell;
        
    }
    return nil;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

#pragma mark - edtTimer
- (void)editTimer:(UITapGestureRecognizer *)tap
{
    int index = [tap.tag intValue] - 100100;
    if (self.back == 1) {
        
        NSDictionary *dict = [self.numberArray objectAtIndex:index];
        
        NSString *repeatStr = [self systemTimeZoneWithFlag:[[dict objectForKey:@"flag"] intValue] WithHour:[dict objectForKey:@"hour"] Minent:[dict objectForKey:@"min"]];
        
        NSString *timeStr = [self dateStingWithHoutAndMinWith:[dict objectForKey:@"hour"] WIthMin:[dict objectForKey:@"min"]];
        
        NSString *switchStr = [dict objectForKey:@"switch"];
        
        SetTimerVC *setTimerVC = [[SetTimerVC alloc] init];
        setTimerVC.typeStr = @"edit";
        setTimerVC.indexArray = [NSMutableArray arrayWithArray:@[timeStr, repeatStr, switchStr]];
        setTimerVC.macString = self.macString;
        setTimerVC.taskNumber = [dict[@"indx"] intValue];
        [self.navigationController pushViewController:setTimerVC animated:YES];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == kindScrollView) {
        CGFloat current_x = scrollView.contentOffset.x;
        NSInteger current = current_x / [UIScreen mainScreen].bounds.size.width;
        
        if (current == 1 && [_secondTimer isValid]) {
            [addBtn setBackgroundImage:[UIImage imageNamed:@"del_blue_normal"] forState:UIControlStateNormal];
            [addBtn setBackgroundImage:[UIImage imageNamed:@"del_blue_click"] forState:UIControlStateHighlighted];
        } else {
            [addBtn setBackgroundImage:[UIImage imageNamed:@"add_timer_normal"] forState:UIControlStateNormal];
            [addBtn setBackgroundImage:[UIImage imageNamed:@"add_timer_click"] forState:UIControlStateHighlighted];
        }
        self.tag = current + 1;
        _type = (int)self.tag;
        [slider setFrame:CGRectMake(kScreen_Width / 3 * current, 35 + self.imageV.frame.origin.y + self.imageV.frame.size.height , kScreen_Width / 3, 3)];
    }
}

- (void)hideTableView:(UIButton *)btn
{
    self.tag = btn.tag - 100;
    _type = (int)self.tag;
    if (self.tag == 2 && [_secondTimer isValid]) {
        [addBtn setBackgroundImage:[UIImage imageNamed:@"del_blue_normal"] forState:UIControlStateNormal];
        [addBtn setBackgroundImage:[UIImage imageNamed:@"del_blue_click"] forState:UIControlStateHighlighted];
    } else {
        [addBtn setBackgroundImage:[UIImage imageNamed:@"add_timer_normal"] forState:UIControlStateNormal];
        [addBtn setBackgroundImage:[UIImage imageNamed:@"add_timer_click"] forState:UIControlStateHighlighted];
    }

    [slider setFrame:CGRectMake(kScreen_Width / 3 * (btn.tag - 101), 35 + self.imageV.frame.origin.y + self.imageV.frame.size.height , kScreen_Width / 3, 3)];
    [kindScrollView setContentOffset:CGPointMake(kScreen_Width * (btn.tag - 101), 0) animated:YES];
}

- (void)switchClickedMethod:(UIButton *)but
{
    NSDictionary *dic = [self.numberArray objectAtIndex:but.tag - 2000];
    self.flag = [[dic objectForKey:@"flag"] intValue];
    self.hour = [[dic objectForKey:@"hour"] intValue];
    self.min = [[dic objectForKey:@"min"] intValue];
    
    BitSwitch bitFlag = kBit8On;
    
    if ([chooseArr[but.tag - 2000] isEqualToString:@"1"]) {
        self.flag = self.flag & kBitTurnOff(bitFlag);
        [chooseArr replaceObjectAtIndex:but.tag - 2000 withObject:@"0"];
        [but setImage:[UIImage imageNamed:@"button_close.png"] forState:UIControlStateNormal];
    } else {
        self.flag = self.flag | bitFlag;
        [chooseArr replaceObjectAtIndex:but.tag - 2000 withObject:@"1"];
        [but setImage:[UIImage imageNamed:@"button_open.png"] forState:UIControlStateNormal];
    }

    BOOL isON = NO;
    if ([[dic objectForKey:@"switch"] intValue] == 0xff) {
        isON = YES;
    }else{
        isON = NO;
    }
    
    Device *device = [[DeviceManagerInstance getlocalDeviceDictary] objectForKey:self.devices.macString];
    
    // 设置定时
    [DeviceManagerInstance setTimeringAlermWithMacString:device.mac Withhost:device.host flag:self.flag Hour:self.hour min:self.min TaskCount:[[dic objectForKey:@"indx"] intValue] Switch:isON  key:device.key With:device.localContent deviceType:device.deviceType];
}

#pragma mark-图片去色
//图片去色
- (UIImage *)grayImage:(UIImage *)sourceImage
{
    int bitmapInfo = kCGImageAlphaNone;
    int width = sourceImage.size.width;
    int Height = sourceImage.size.height;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    CGContextRef context = CGBitmapContextCreate (nil,
                                                  width,
                                                  Height,
                                                  8,      // bits per component
                                                  0,
                                                  colorSpace,
                                                  bitmapInfo);
    CGColorSpaceRelease(colorSpace);
    if (context == NULL) {
        return nil;
    }
    CGContextDrawImage(context,
                       CGRectMake(0, 0, width, Height), sourceImage.CGImage);
    UIImage *grayImage = [UIImage imageWithCGImage:CGBitmapContextCreateImage(context)];
    CGContextRelease(context);
    return grayImage;
}

#pragma mark-NSDate
- (NSString *)dateStingWithHoutAndMinWith:(NSString *)hour WIthMin:(NSString *)min
{
    NSString *string;
    
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.timeZone = [NSTimeZone systemTimeZone];//系统所在时区
    NSTimeZone *localZone = [NSTimeZone localTimeZone];
    
    [df setTimeZone:localZone];
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit |NSCalendarUnitMinute |NSCalendarUnitSecond | NSCalendarUnitHour fromDate:[NSDate date]];
    
    df.dateFormat = @"yyyy-MM-dd HH:mm:ssZ";
    NSDate *datessss =[df dateFromString:[NSString stringWithFormat:@"%ld-%ld-%ld %@:%@:30+0000",(long)[components year],(long)[components month],(long)[components day],hour,min]];
    
    
    NSDate *data = [DateUtil getNowDateFromatAnDate:datessss];
    
    NSString *temp =  [NSString stringWithFormat:@"%@",data];
    NSArray *array = [temp componentsSeparatedByString:@" "];
    
    string = [array objectAtIndex:1];
    return  [string substringWithRange:NSMakeRange(0, 5)];
}

- (NSDate *)getNextTimer:(NSDate *)date
{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    formatter.timeZone = [NSTimeZone systemTimeZone];//系统所在时区
    NSTimeZone *localZone = [NSTimeZone localTimeZone];
    
    [formatter setTimeZone:localZone];
    
    NSString *string = [NSString stringWithFormat:@"%@",date];
    NSArray *dateArray = [string componentsSeparatedByString:@" "];
    NSString *yearstring = [dateArray objectAtIndex:0];
    NSArray * yearArray=  [yearstring componentsSeparatedByString:@"-"];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ssZ";
    
    
    
    NSLog(@"====%@",[NSString stringWithFormat:@"%@-%@-%d %@+0000",[yearArray objectAtIndex:0],[yearArray objectAtIndex:1],([[yearArray objectAtIndex:2] intValue] +1),[dateArray objectAtIndex:1]]);
    
    
    NSDate *newDate = [formatter dateFromString:[NSString stringWithFormat:@"%@-%@-%d %@+0000",[yearArray objectAtIndex:0],[yearArray objectAtIndex:1],[[yearArray objectAtIndex:2] intValue] +1,[dateArray objectAtIndex:1]]];
    
    NSLog(@"year==%@",newDate);
    
    return [DateUtil getNowDateFromatAnDate:newDate];
}

- (NSString *)dateStringWithHour:(NSString *)hour WIthMin:(NSString *)min
{
    NSLog(@"hour min === %@ %@", hour, min);
    
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.timeZone = [NSTimeZone systemTimeZone];//系统所在时区
    NSTimeZone *localZone = [NSTimeZone localTimeZone];
    //    获取当前时间
    NSDate *nowDate = [NSDate date];
    NSDate *neDate =  [DateUtil getNowDateFromatAnDate:nowDate];
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit |NSCalendarUnitMinute |NSCalendarUnitSecond | NSCalendarUnitHour fromDate:neDate];
    
    [df setTimeZone:localZone];
    
    df.dateFormat = @"yyyy-MM-dd HH:mm:ssZ";
    NSDate *datessss = [df dateFromString:[NSString stringWithFormat:@"%ld-%ld-%ld %d:%@:00+0000",(long)[components year],(long)[components month],(long)[components day] + 1,[hour intValue],min]];
    
    NSDate *data = [DateUtil getNowDateFromatAnDate:datessss];
    
    NSString *temp =  [NSString stringWithFormat:@"%@",data];
    
    return temp;
}

- (NSString *)systemTimeZoneWithFlag:(UInt8)flag WithHour:(NSString *)hour Minent:(NSString *)min
{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit |NSCalendarUnitMinute |NSCalendarUnitSecond | NSCalendarUnitHour fromDate:[NSDate date]];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.timeZone = [NSTimeZone systemTimeZone];//系统所在时区
    NSTimeZone *localZone = [NSTimeZone localTimeZone];
    
    [df setTimeZone:localZone];
    df.dateFormat = @"yyyy-MM-dd HH:mm:ssZ";
    NSDate *datessss =[df dateFromString:[NSString stringWithFormat:@"%ld-%ld-%ld %@:%@:30+0000",(long)[components year],(long)[components month],(long)[components day],hour,min]];
    
    NSDate * UTCTime= [self loadDataWithDate:datessss WithDateOrTime:NO];
    NSLog(@"=== %@", UTCTime);
    // === 2014-12-02 02:10:30 +0000
    NSDateComponents *compon = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit |NSCalendarUnitMinute |NSCalendarUnitSecond | NSCalendarUnitHour fromDate:UTCTime];
    
    
//    NSDate *data = [DateUtil getNowDateFromatAnDate:datessss];
    
//    NSString *system =  [NSString stringWithFormat:@"%@",data];
    
    NSDateFormatter* formate=[[NSDateFormatter alloc]init];
    [formate setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
//    NSString *tempStr = [system substringWithRange:NSMakeRange(0, 10)];
//    NSArray *  temp = [tempStr componentsSeparatedByString:@"-"];
//    NSString *indeStr =  [temp objectAtIndex:2];
    
    NSString *string = @"";
    int currentWeekDay = (int)[compon weekday];
    
    if (kBit8On & flag) {
        
        self.isOFF = YES;
    }else{
        self.isOFF = NO;
    }
    
    int indexx = (int)[components weekday];
    
//    NSLog(@" == %d %d %d %d %d %d %d %d %d", currentWeekDay, indexx, kBit1On, kBit2On, kBit3On, kBit4On, kBit5On, kBit6On,kBit7On);
    
    if (currentWeekDay - indexx == 0) {
        
        
        if (kBit1On & flag) {
            
            /*"Mon" = "周一";
             "Tue" = "周二";
             "Wed" = "周三";
             "Thu" = "周四";
             "Fri" = "周五";
             "Sat" = "周六";
             "Sun" = "周日";*/
            string = [string stringByAppendingString:[NSString stringWithFormat:@"%@、",NSLocalizedString(@"Mon",nil)]];
        }
        if (kBit2On & flag) {
            string = [string stringByAppendingString:[NSString stringWithFormat:@"%@、",NSLocalizedString(@"Tue",nil)]];
        }
        if (kBit3On & flag) {
            string = [string stringByAppendingString:[NSString stringWithFormat:@"%@、",NSLocalizedString(@"Wed",nil)]];
        }
        if (kBit4On & flag) {
            string = [string stringByAppendingString:[NSString stringWithFormat:@"%@、",NSLocalizedString(@"Thu",nil)]];
        }
        if (kBit5On & flag) {
            string = [string stringByAppendingString:[NSString stringWithFormat:@"%@、",NSLocalizedString(@"Fri",nil)]];
        }
        if (kBit6On & flag) {
            string = [string stringByAppendingString:[NSString stringWithFormat:@"%@、",NSLocalizedString(@"Sat",nil)]];
        }
        if (kBit7On & flag) {
            string = [string stringByAppendingString:[NSString stringWithFormat:@"%@、",NSLocalizedString(@"Sun",nil)]];
        }
        
        
    }
    if ((currentWeekDay - indexx ) == -1 || (currentWeekDay - indexx ) == 6) {
        
        
        if (kBit7On & flag) {
            string = [string stringByAppendingString:[NSString stringWithFormat:@"%@、",NSLocalizedString(@"Mon",nil)]];
        }
        
        
        if (kBit1On & flag) {
            string = [string stringByAppendingString:[NSString stringWithFormat:@"%@、",NSLocalizedString(@"Tue",nil)]];
        }
        
        
        if (kBit2On & flag) {
            string = [string stringByAppendingString:[NSString stringWithFormat:@"%@、",NSLocalizedString(@"Wed",nil)]];
        }
        
        if (kBit3On & flag) {
            string = [string stringByAppendingString:[NSString stringWithFormat:@"%@、",NSLocalizedString(@"Thu",nil)]];
        }
        
        
        if (kBit4On & flag) {
            string = [string stringByAppendingString:[NSString stringWithFormat:@"%@、",NSLocalizedString(@"Fri",nil)]];
        }
        
        
        
        if (kBit5On & flag) {
            string = [string stringByAppendingString:[NSString stringWithFormat:@"%@、",NSLocalizedString(@"Sat",nil)]];
        }
        
        if (kBit6On & flag) {
            string = [string stringByAppendingString:[NSString stringWithFormat:@"%@、",NSLocalizedString(@"Sun",nil)]];
        }
        
    }
    if ((currentWeekDay - indexx ) == 1 || (currentWeekDay - indexx ) == -6) {
        
        
        
        if (kBit2On & flag) {
            string = [string stringByAppendingString:[NSString stringWithFormat:@"%@、",NSLocalizedString(@"Tue",nil)]];
        }
        if (kBit3On & flag) {
            string = [string stringByAppendingString:[NSString stringWithFormat:@"%@、",NSLocalizedString(@"Wed",nil)]];
        }
        if (kBit4On & flag) {
            string = [string stringByAppendingString:[NSString stringWithFormat:@"%@、",NSLocalizedString(@"Thu",nil)]];
        }
        if (kBit5On & flag) {
            string = [string stringByAppendingString:[NSString stringWithFormat:@"%@、",NSLocalizedString(@"Fri",nil)]];
        }
        if (kBit6On & flag) {
            string = [string stringByAppendingString:[NSString stringWithFormat:@"%@、",NSLocalizedString(@"Sat",nil)]];
        }
        if (kBit1On & flag) {
            string = [string stringByAppendingString:[NSString stringWithFormat:@"%@、",NSLocalizedString(@"Mon",nil)]];
        }
        if (kBit7On & flag) {
            string = [string stringByAppendingString:[NSString stringWithFormat:@"%@、",NSLocalizedString(@"Sun",nil)]];
        }
    }
    
    if ([string hasSuffix:@"、"]) {
        
        string = [string substringWithRange:NSMakeRange(0, string.length-1)];
    }
    return string;
}

- (void)leftButtonMethod:(UIButton *)but
{
    if (self.back == 1) {
        [self.stateTimer invalidate];
        [_secondTimer invalidate];
        self.stateTimer = nil;
        _secondTimer = nil;
        [Util getAppDelegate].rootVC.pan.enabled = YES;
        [self.navigationController popViewControllerAnimated:YES];
    } else if (self.back == 2) {
        self.back = 1;
        self.delete = 1;
        self.rightBut.hidden = NO;
        [timerTableView reloadData];
        [timerTableView setFrame:CGRectMake(kScreen_Width * 0, 0, rect.size.width, rect.size.height - 60)];
        timerBtn.userInteractionEnabled = YES;
        timerTableView.headerHidden = NO;
        
        [absenceTableView setFrame:CGRectMake(kScreen_Width * 2, 0, rect.size.width, rect.size.height)];
        absenceBtn.userInteractionEnabled = YES;
        absenceTableView.headerHidden = NO;
        
        kindScrollView.scrollEnabled = YES;
        addBGView.hidden = NO;
        
        for (int i = 0; i < self.numberArray.count; i++) {
            LockCell *cell = (LockCell *)[self.view viewWithTag:100000 + i];
            cell.delView.hidden = YES;
        }
        
        for (int i = 0; i < self.absenceArray.count; i++) {
            AbsenceCell *cell = (AbsenceCell *)[self.view viewWithTag:1000 + i];
            cell.delView.hidden = YES;
        }
    }
}

static bool showMenu = YES;
- (void)reloadButtonMethod:(UIButton *)sender
{
    [UIView animateWithDuration:.2f animations:^{
        chooseView.frame = CGRectMake(kScreen_Width - 135, barViewHeight - 5, 135, ((showMenu == YES) ? height : 0));
        editLabel.frame = CGRectMake(kScreen_Width - 130 + 35, ((showMenu == YES) ? barViewHeight + 5 : 0), ((showMenu == YES) ? 95 : 0), ((showMenu == YES) ? 50 : 0));
        energyInfoLabel.frame = CGRectMake(kScreen_Width - 130 + 35, ((showMenu == YES) ? barViewHeight + 55 : 0), ((showMenu == YES) ? 90 : 0), ((showMenu == YES) ? 50 : 0));
        editImgView.frame = CGRectMake(kScreen_Width - 130 + 5, ((showMenu == YES) ? barViewHeight + 18 : 0), ((showMenu == YES) ? 25 : 0), ((showMenu == YES) ? 25 : 0));
        energyInfoImgView.frame = CGRectMake(kScreen_Width - 130 + 5, ((showMenu == YES) ? barViewHeight + 67 : 0), ((showMenu == YES) ? 25 : 0), ((showMenu == YES) ? 25 : 0));
    }completion:nil];
    
    showMenu = !showMenu;
}

#pragma mark-转换GMT+0时间

- (NSDate *)loadDataWithDate:(NSDate *)date WithDateOrTime:(BOOL)isDate
{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit |NSCalendarUnitMinute |NSCalendarUnitSecond | NSCalendarUnitHour fromDate:date];
    
    NSDateFormatter* dateFo = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
    
    [dateFo setDateFormat:@"yyyy-MM-dd HH:mm:ss"];//设定时间格式,这里可以设置成自己需要的格式
    
    
    NSDate *datessss =[dateFo dateFromString:[NSString stringWithFormat:@"%ld-%ld-%ld %ld:%ld:%ld",(long)[components year],(long)[components month],(long)[components day],(long)[components hour],(long)[components minute],(long)[components second]]];
    dateFo.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];//这就是GMT+0时区了
    
    return datessss;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
