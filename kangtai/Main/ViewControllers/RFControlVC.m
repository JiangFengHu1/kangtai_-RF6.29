//
//  RFControlVC.m
//  kangtai
//
//  Created by 张群 on 14/12/15.
//
//

#import "RFControlVC.h"
#import "Open_CloseManage.h"
#import "Open_CloseStatu.h"
#import "UIImage+CH.h"
enum {
    TopViewTag               = 0,
    LeftViewTag              = 1,
    BottomViewTag            = 2,
    RightViewTag           = 3,
};

@interface RFControlVC ()<UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource>
{
    NSString *leftStr;
    NSString *rightStr;
    UILabel *leftLab;
    UILabel *rightLab;
//    UIImageView *centerImgView;
    BOOL onOrOff;
    // 6.29
    UIView *addBGView;
    UIView *slider;
    UIButton *rfControlBtn;
    UIButton *timerBtn;
    UIScrollView *kindScrollView;
    
    // 6.30
    UITableView *timerTableView;
    NSMutableArray *chooseArr;
    CGRect rect;
    
    NSString *onStr;
    NSString *offStr;
}

@property (nonatomic, assign) int back;
@property (nonatomic, assign) int delete;
@property (nonatomic, assign) BOOL isOFF;
@property (nonatomic, strong) NSMutableArray *rfTimerArray;

@property (nonatomic ,weak) UIButton *openBtn;
@property (nonatomic ,weak) UIButton *closeBtn;
@property (nonatomic ,strong) UIImage *onImage;
@property (nonatomic ,strong) UIImage *offImage;
@property (nonatomic ,weak) UIImageView *centerImgView;
@end

@implementation RFControlVC

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    [MMProgressHUD showWithStatus:NSLocalizedString(@"Refreshing...", nil)];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [MMProgressHUD dismiss];
    });
    
    self.modelArr = [RFDataBase selectDataFromDataBaseWithAddress:self.model.address];
    self.model = self.modelArr[0];
    [self updateCenterImgView];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self reloadTimerList];
    });
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.HJFstatu = [Open_CloseManageInstance getDevicePreFWithRfDataId:self.model.rfDataId];
    if (self.HJFstatu  == nil) {
//        NSLog(@"没找到设备");
        self.HJFstatu = [[Open_CloseStatu alloc] init];
        self.HJFstatu.deviceClose = NO;
        self.HJFstatu.deviceOpen = NO;
        self.HJFstatu.rfDataId =self.model.rfDataId;
//        NSLog(@"添加设备");
        [Open_CloseManageInstance.deviceArray addObject:self.HJFstatu];
    }
    
    _back = 1;
    _delete = 1;
    _rfTimerArray = [NSMutableArray array];
    chooseArr = [NSMutableArray array];
    
    onStr = [self.model.typeRF isEqualToString:@"3"] ? NSLocalizedString(@"Up", nil) : ([self.model.typeRF isEqualToString:@"4"] ? NSLocalizedString(@"High", nil) : NSLocalizedString(@"ON", nil));

    offStr = [self.model.typeRF isEqualToString:@"3"] ? NSLocalizedString(@"Down", nil) : ([self.model.typeRF isEqualToString:@"4"] ? NSLocalizedString(@"Low", nil) : NSLocalizedString(@"OFF", nil));

    // 查询定时
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(downloadDataTheRFTimer:) name:@"GetRFTimer" object:nil];
    
    [self initUI];
}

#pragma mark - reloadTimerList
- (void)reloadTimerList
{
    Device *device = [[DeviceManagerInstance getlocalDeviceDictary] objectForKey:self.model.rfDataMac];

    for (int i = 0; i < 2; i++) {
        NSMutableDictionary *checkDic = [NSMutableDictionary dictionary];
        [checkDic setObject:@"0F" forKey:@"Order"];
        [checkDic setObject:@"0" forKey:@"Num"];

        [DeviceManagerInstance set433TodeviceWithMacString:device.mac WithHost:device.host Open:YES withArc4Address:self.model.address deviceType:self.model.typeRF With:device.localContent timerDic:checkDic];
    }
}

#pragma mark - downloadDataTheRFTimer
- (void)downloadDataTheRFTimer:(NSNotification *)notification
{
    [self.rfTimerArray removeAllObjects];
    [chooseArr removeAllObjects];
    NSMutableArray *tempArray = [notification object];
    
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
            [_rfTimerArray addObject:dict];
            [chooseArr addObject:@"0"];
        }
    }
    
    [timerTableView reloadData];
}

#pragma mark - updateCenterImgView
- (void)updateCenterImgView
{
    self.titlelab.text = self.model.rfDataName;
    self.nameStr = self.model.rfDataName;
    
    self.typeStr = self.model.typeRF;
    if ([self.typeStr isEqualToString:@"1"] || [self.typeStr isEqualToString:@"2"]) {
        leftStr = NSLocalizedString(@"ON", nil);
        rightStr = NSLocalizedString(@"OFF", nil);
    } else if ([self.typeStr isEqualToString:@"3"]) {
        leftStr = NSLocalizedString(@"Up", nil);
        rightStr = NSLocalizedString(@"Down", nil);
    } else {
        leftStr = NSLocalizedString(@"High", nil);
        rightStr = NSLocalizedString(@"Low", nil);
    }
    
    leftLab.text = leftStr;
    rightLab.text = rightStr;
    
    UIImage *iconLogo;
    NSString *dataPath = [[[NSBundle mainBundle] bundlePath] stringByAppendingString:[NSString stringWithFormat:@"/%@",self.model.rfDataLogo]];//获取程序包中相应文件的路径
    //    NSError *error;
    NSFileManager *fileMa = [NSFileManager defaultManager];
    
    if (self.model.rfDataLogo.length != 0) {
        if(![fileMa fileExistsAtPath:dataPath]){
            
            NSData *imgData = [NSData dataWithContentsOfFile:[Util getFilePathWithImageName:self.model.rfDataLogo]];
            if (imgData.length == 0) {
                iconLogo = [UIImage imageNamed:@"13.png"];
            } else {
                iconLogo = [[UIImage alloc] initWithContentsOfFile:[Util getFilePathWithImageName:self.model.rfDataLogo]];
            }
        }else{
            iconLogo = [UIImage imageNamed:self.model.rfDataLogo];
        }
    } else {
        iconLogo = [UIImage imageNamed:@"13.png"];
    }

//    if(![fileMa fileExistsAtPath:dataPath]) //
//    {
//        NSFileManager *fileManager = [NSFileManager defaultManager];
//        if (![fileManager fileExistsAtPath:[Util getFilePathWithImageName:self.model.rfDataLogo]]) {
//            iconLogo =  [[UIImage alloc] initWithContentsOfFile:[Util getFilePathWithImageName:self.model.rfDataLogo]];
//        } else {
//            iconLogo = [Util getImageFile:self.model.rfDataLogo];
//        }
//    }
//    else
//    {
//        iconLogo = [UIImage imageNamed:self.model.rfDataLogo];
//    }
    UIImage *grayImage = [UIImage grayImage:iconLogo];
    _offImage = grayImage;
    _onImage = iconLogo;
    if (_HJFstatu.deviceOpen) {
        _centerImgView.image = _onImage;
    }
    else
    {
        _centerImgView.image = _offImage;
        
    }
    

}

#pragma mark - initUI
- (void)initUI
{
    self.rightBut.hidden = YES;
    
    [self.barView setFrame:CGRectMake(0, 0, kScreen_Width, barViewHeight + 60)];
    [self.imageVW setFrame:self.barView.frame];

    NSArray *nameArray = [NSArray arrayWithObjects:NSLocalizedString(@"RF Control", nil),NSLocalizedString(@"Timer", nil), nil];
    
    UILabel *rfControlLab = [[UILabel alloc] initWithFrame:CGRectMake(0, barViewHeight + 25, kScreen_Width / 2, 15)];
    rfControlLab.backgroundColor = [UIColor clearColor];
    rfControlLab.font = [UIFont systemFontOfSize:16];
    rfControlLab.textAlignment = NSTextAlignmentCenter;
    rfControlLab.textColor = [UIColor whiteColor];
    rfControlLab.adjustsFontSizeToFitWidth = YES;
    rfControlLab.text = nameArray[0];
    [self.view addSubview:rfControlLab];
    
    UILabel *timerLab = [[UILabel alloc] initWithFrame:CGRectMake(kScreen_Width / 2, barViewHeight + 25, kScreen_Width / 2, 15)];
    timerLab.backgroundColor = [UIColor clearColor];
    timerLab.font = [UIFont systemFontOfSize:16];
    timerLab.textAlignment = NSTextAlignmentCenter;
    timerLab.textColor = [UIColor whiteColor];
    timerLab.adjustsFontSizeToFitWidth = YES;
    timerLab.text = nameArray[1];
    [self.view addSubview:timerLab];
    
    slider = [[UIView alloc] initWithFrame:CGRectMake(0, barViewHeight + 55, kScreen_Width / 2, 3)];
    slider .backgroundColor = [UIColor orangeColor];
    [self.view addSubview:slider];
    
    rfControlBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rfControlBtn.frame = CGRectMake(0, rfControlLab.frame.origin.y, kScreen_Width / 3, 30);
    [rfControlBtn addTarget:self action:@selector(hideTableView:) forControlEvents:UIControlEventTouchUpInside];
    rfControlBtn.tag = 100 + 1;
    [self.view addSubview:rfControlBtn];
    
    timerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    timerBtn.frame = CGRectMake(kScreen_Width / 2, timerLab.frame.origin.y, kScreen_Width / 2, 30);
    [timerBtn addTarget:self action:@selector(hideTableView:) forControlEvents:UIControlEventTouchUpInside];
    timerBtn.tag = 100 + 2;
    [self.view addSubview:timerBtn];
    
    rect = CGRectMake(0, self.barView.frame.size.height, kScreen_Width, kScreen_Height - self.barView.frame.size.height);
    
    kindScrollView = [[UIScrollView alloc] initWithFrame:rect];
    kindScrollView.delegate = self;
    kindScrollView.bounces = NO;
    kindScrollView.pagingEnabled = YES;
    kindScrollView.contentSize = CGSizeMake(kScreen_Width * 2, rect.size.height);
    kindScrollView.backgroundColor = [UIColor whiteColor];
    kindScrollView.showsHorizontalScrollIndicator = NO;
    kindScrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:kindScrollView];
    
    self.modelArr = [[NSMutableArray alloc] initWithCapacity:1];
    UIView *circlrView = [[UIView alloc] initWithFrame:CGRectMake(kScreen_Width / 2 - 140, rect.size.height / 2 - 140, 280, 280)];
    circlrView.backgroundColor = [UIColor clearColor];
    circlrView.layer.masksToBounds = YES;
    circlrView.layer.cornerRadius = 140;
//    circlrView.center = CGPointMake(self.view.center.x, self.view.center.y + 22);
    [kindScrollView addSubview:circlrView];
    
    UIView *bottomRightView = [[UIView alloc]initWithFrame:CGRectMake(140 - 65, 140 + 30, 130, 130)];
    bottomRightView.backgroundColor = [UIColor clearColor];
    bottomRightView.clipsToBounds = YES;
    
    UIButton *btn = [self createButtonWithImageNameForNormal:@"circle_quarter_normal"
                     
                                    imageNameForHightlighted:@"circle_quarter_click"
                                           transformRotation:0
                                                   buttonTag:BottomViewTag];
    btn.frame = CGRectMake(0, 0, 130, 130);
    [circlrView addSubview:bottomRightView];
    [bottomRightView addSubview:btn];
    
    CGFloat r = DEGREES_TO_RADIANS(45);
    bottomRightView.transform = CGAffineTransformMakeRotation(r);

    
    bottomRightView = [[UIView alloc]initWithFrame:CGRectMake(140 - 65, -20, 130, 130)];
    bottomRightView.backgroundColor = [UIColor clearColor];
    bottomRightView.clipsToBounds = YES;
    
    
    btn = [self createButtonWithImageNameForNormal:@"circle_quarter_normal"
                     
                                imageNameForHightlighted:@"circle_quarter_click"
                                           transformRotation:0
                                                   buttonTag:TopViewTag];
    btn.frame = CGRectMake(0, 0, 130, 130);
    [circlrView addSubview:bottomRightView];
    [bottomRightView addSubview:btn];
    
    r = DEGREES_TO_RADIANS(225);
    bottomRightView.transform = CGAffineTransformMakeRotation(r);

    
    bottomRightView = [[UIView alloc]initWithFrame:CGRectMake(-20, 75, 130, 130)];
    bottomRightView.backgroundColor = [UIColor clearColor];
    bottomRightView.clipsToBounds = YES;
    
    
    btn = [self createButtonWithImageNameForNormal:@"circle_quarter_normal"
           
                          imageNameForHightlighted:@"circle_quarter_click"
                                 transformRotation:0
                                         buttonTag:LeftViewTag];
    btn.frame = CGRectMake(0, 0, 130, 130);
    [circlrView addSubview:bottomRightView];
    [bottomRightView addSubview:btn];
    
    r = DEGREES_TO_RADIANS(135);
    bottomRightView.transform = CGAffineTransformMakeRotation(r);
    
    
    
    bottomRightView = [[UIView alloc]initWithFrame:CGRectMake(140 + 30,  75, 130, 130)];
    bottomRightView.backgroundColor = [UIColor clearColor];
    bottomRightView.clipsToBounds = YES;
    
    
    btn = [self createButtonWithImageNameForNormal:@"circle_quarter_normal"
           
                          imageNameForHightlighted:@"circle_quarter_click"
                                 transformRotation:0
                                         buttonTag:RightViewTag];
    btn.frame = CGRectMake(0, 0, 130, 130);
    [circlrView addSubview:bottomRightView];
    [bottomRightView addSubview:btn];
    
    r = DEGREES_TO_RADIANS(315);
    bottomRightView.transform = CGAffineTransformMakeRotation(r);

    CGSize size = [Util sizeForText:NSLocalizedString(@"Edit", nil) Font:18 forWidth:320];
    UILabel *topLab = [[UILabel alloc] initWithFrame:CGRectMake(140 - size.width / 2, 45, size.width, 20)];
    topLab.backgroundColor = [UIColor clearColor];
    topLab.font = [UIFont systemFontOfSize:18];
    topLab.textColor = RGBA(71.0, 183.0, 233.0, 1);
    topLab.text = NSLocalizedString(@"Edit", nil);
    [circlrView addSubview:topLab];

    size = [Util sizeForText:NSLocalizedString(@"Learn", nil) Font:18 forWidth:320];
    UILabel *downLab = [[UILabel alloc] initWithFrame:CGRectMake(143 - size.width / 2, 215, size.width, 20)];
    downLab.backgroundColor = [UIColor clearColor];
    downLab.font = [UIFont systemFontOfSize:18];
    downLab.textColor = RGBA(71.0, 183.0, 233.0, 1);
    downLab.text = NSLocalizedString(@"Learn", nil);
    [circlrView addSubview:downLab];

    size = [Util sizeForText:leftStr Font:18 forWidth:320];
    leftLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 130, 80, 20)];
    leftLab.backgroundColor = [UIColor clearColor];
    leftLab.font = [UIFont systemFontOfSize:18];
    leftLab.textAlignment = NSTextAlignmentCenter;
    leftLab.textColor = RGBA(71.0, 183.0, 233.0, 1);
    [circlrView addSubview:leftLab];

    size = [Util sizeForText:rightStr Font:18 forWidth:320];
    rightLab = [[UILabel alloc] initWithFrame:CGRectMake(190, 130, 80, 20)];
    rightLab.backgroundColor = [UIColor clearColor];
    rightLab.font = [UIFont systemFontOfSize:18];
    rightLab.textAlignment = NSTextAlignmentCenter;
    rightLab.textColor = RGBA(71.0, 183.0, 233.0, 1);
    [circlrView addSubview:rightLab];

    
    UIView *centerView = [[UIView alloc] initWithFrame:CGRectMake(kScreen_Width / 2 - 50, rect.size.height / 2 - 50, 100, 100)];
    centerView.backgroundColor = RGB(235, 235, 235);
    centerView.layer.masksToBounds = YES;
    centerView.layer.cornerRadius = 50;
//    centerView.center = circlrView.center;
    [kindScrollView addSubview:centerView];

    centerView = [[UIView alloc] initWithFrame:CGRectMake(kScreen_Width / 2 - 48, rect.size.height / 2 - 48, 96, 96)];
    centerView.backgroundColor = RGB(247, 247, 247);
    centerView.layer.masksToBounds = YES;
    centerView.layer.cornerRadius = 48;
//    centerView.center = circlrView.center;
    [kindScrollView addSubview:centerView];
    
    UIImageView *centerImgView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreen_Width / 2 - 40, rect.size.height / 2 - 40, 80, 80)];
    centerImgView.layer.masksToBounds = YES;
    centerImgView.layer.cornerRadius = 40;
    _centerImgView = centerImgView;
//    centerImgView.center = circlrView.center;
    [kindScrollView addSubview:centerImgView];
    
    // timer tableView
    timerTableView = [[UITableView alloc] initWithFrame:CGRectMake(kScreen_Width, 0, rect.size.width, rect.size.height - iOS_6_height - 60) style:UITableViewStylePlain];
    timerTableView.backgroundColor = [UIColor whiteColor];
    timerTableView.delegate = self;
    timerTableView.dataSource = self;
    timerTableView.separatorStyle = 0;
    timerTableView.userInteractionEnabled = YES;
    [timerTableView addHeaderWithTarget:self action:@selector(timerHeaderReresh)];
    [kindScrollView addSubview:timerTableView];

    addBGView = [[UIView alloc] initWithFrame:CGRectMake(kScreen_Width, rect.size.height - iOS_6_height - 60, kScreen_Width, 60)];
    addBGView.backgroundColor = RGBA(210, 210, 210, 1);
    [kindScrollView addSubview:addBGView];
    
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addBtn.frame = CGRectMake(0, 0, 40, 40);
    addBtn.center = CGPointMake(addBGView.frame.size.width / 2, addBGView.frame.size.height / 2);
    [addBtn setBackgroundImage:[UIImage imageNamed:@"add_timer_normal"] forState:UIControlStateNormal];
    [addBtn setBackgroundImage:[UIImage imageNamed:@"add_timer_click"] forState:UIControlStateHighlighted];
    [addBtn addTarget:self action:@selector(addMore:) forControlEvents:UIControlEventTouchUpInside];
    [addBGView addSubview:addBtn];

}

-(UIButton *)createButtonWithImageNameForNormal:(NSString *)normal imageNameForHightlighted:(NSString *)hightlighted transformRotation:(CGFloat) degree buttonTag:(NSInteger)tag
{
    UIImage *img_n = [UIImage imageNamed:normal];
    UIImage *img_p = [UIImage imageNamed:hightlighted];
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, img_n.size.width, img_n.size.height)];
    [btn setBackgroundImage:img_n forState:UIControlStateNormal];
    [btn setBackgroundImage:img_p forState:UIControlStateHighlighted];
    [btn setBackgroundImage:[UIImage imageNamed:@"circle_quarter_selected"] forState:UIControlStateSelected];
    btn.transform =  CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(degree));
    btn.tag = tag;
    [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    if (tag ==LeftViewTag) {
        btn.selected = self.HJFstatu.deviceOpen;
        _openBtn = btn;
    }
    else if (tag ==RightViewTag){
        btn.selected = self.HJFstatu.deviceClose;
        _closeBtn = btn;
    }
    return btn;
}

-(void)buttonClick:(id)sender
{
    NSLog(@"%@",self.model);
    
    NSInteger tag = ((UIButton *)sender).tag;
    
    if (TopViewTag == tag) {
        
        AddNewRFDeviceVC *addRFVC = [[AddNewRFDeviceVC alloc] init];
        addRFVC.typeNumber = 1;
        addRFVC.macStr = self.macStr;
        addRFVC.RFMacStrArr = self.RFMacStrArr;
        addRFVC.nameStr = self.nameStr;
        addRFVC.typeStr = self.typeStr;
        addRFVC.iconStr = self.iconStr;
        addRFVC.model = self.model;
        [self.navigationController pushViewController:addRFVC animated:YES];
        
    } else  {
        if (RightViewTag == tag) {
            _openBtn.selected = NO;
            _closeBtn.selected = YES;
            self.HJFstatu.deviceClose = YES;
            self.HJFstatu.deviceOpen = NO;
            _centerImgView.image = _offImage;
            rightLab.textColor= RGB(252, 156, 91);
            leftLab.textColor = RGBA(71.0, 183.0, 233.0, 1);
            
        }
        if (LeftViewTag == tag) {
            _closeBtn.selected = NO;
            _openBtn.selected = YES;
            self.HJFstatu.deviceClose = NO;
            self.HJFstatu.deviceOpen = YES;
            _centerImgView.image = _onImage;
            leftLab.textColor= RGB(252, 156, 91);
            rightLab.textColor = RGBA(71.0, 183.0, 233.0, 1);

        }
        
        onOrOff = !(tag == RightViewTag);
        //        _openBtn.selected = onOrOff;
        //        _closeBtn.selected = !_openBtn.isSelected;
        Device *device = [[DeviceManagerInstance getlocalDeviceDictary] objectForKey:self.model.rfDataMac];
        [DeviceManagerInstance set433TodeviceWithMacString:device.mac WithHost:device.host Open:onOrOff withArc4Address:self.model.address deviceType:self.model.typeRF With:device.localContent timerDic:nil];
        
        [NSThread sleepForTimeInterval:0.05];
    }
}

#pragma mark - timerHeaderReresh
- (void)timerHeaderReresh
{
    // 刷新表格
    [self reloadTimerList];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [timerTableView reloadData];
        [timerTableView headerEndRefreshing];
    });
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == kindScrollView) {
        CGFloat current_x = scrollView.contentOffset.x;
        NSInteger current = current_x / [UIScreen mainScreen].bounds.size.width;
        [slider setFrame:CGRectMake(kScreen_Width / 2 * current, barViewHeight + 55, kScreen_Width / 2, 3)];
    }
}

- (void)hideTableView:(UIButton *)btn
{
    [slider setFrame:CGRectMake(kScreen_Width / 2 * (btn.tag - 101), barViewHeight + 55, kScreen_Width / 2, 3)];
    [kindScrollView setContentOffset:CGPointMake(kScreen_Width * (btn.tag - 101), 0) animated:YES];
}

// 添加更多的定时 倒计时 防盗
- (void)addMore:(UIButton *)btn
{
    if ([_rfTimerArray count] > 9) {
        
        [Util showAlertWithTitle:NSLocalizedString(@"Tips", nil) msg:NSLocalizedString(@"Ten groups timer are limited", nil)];
        return;
    }
    RFTimerVC *addTimerVC = [[RFTimerVC alloc] init];
    addTimerVC.typeStr = @"add";
    addTimerVC.indexArray = _rfTimerArray;
    addTimerVC.macString = self.model.rfDataMac;
    addTimerVC.rfAddress = self.model.address;
    addTimerVC.rfType = self.model.typeRF;
    [self.navigationController pushViewController:addTimerVC animated:YES];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.f;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _rfTimerArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
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
    
    NSDictionary *dict = [_rfTimerArray objectAtIndex:indexPath.row];
    
    NSString *string = [self systemTimeZoneWithFlag:[[dict objectForKey:@"flag"] intValue] WithHour:[dict objectForKey:@"hour"] Minent:[dict objectForKey:@"min"]];
    
    cell.titleName.textColor = RGBA(30.0, 180.0, 240.0, 1.0);
    NSString *time = [self dateStingWithHoutAndMinWith:[dict objectForKey:@"hour"] WIthMin:[dict objectForKey:@"min"]];
    
    if ([[dict objectForKey:@"switch"] intValue] == 0x01) {
        cell.switchLab.text = onStr;
    }else{
        cell.switchLab.text = offStr;
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
}

#pragma mark - switchClickedMethod
- (void)switchClickedMethod:(UIButton *)but
{
    NSDictionary *dic = [_rfTimerArray objectAtIndex:but.tag - 2000];
    int flag = [[dic objectForKey:@"flag"] intValue];
    int hour = [[dic objectForKey:@"hour"] intValue];
    int min = [[dic objectForKey:@"min"] intValue];
    
    BitSwitch bitFlag = kBit8On;
    
    if ([chooseArr[but.tag - 2000] isEqualToString:@"1"]) {
        
        flag = flag & kBitTurnOff(bitFlag);
        [chooseArr replaceObjectAtIndex:but.tag - 2000 withObject:@"0"];
        [but setImage:[UIImage imageNamed:@"button_close.png"] forState:UIControlStateNormal];
    } else {
        
        flag = flag | bitFlag;
        [chooseArr replaceObjectAtIndex:but.tag - 2000 withObject:@"1"];
        [but setImage:[UIImage imageNamed:@"button_open.png"] forState:UIControlStateNormal];
    }
    
    BOOL isON = NO;
    if ([[dic objectForKey:@"switch"] intValue] == 0x01) {
        isON = YES;
    }else{
        isON = NO;
    }
    
    Device *device = [[DeviceManagerInstance getlocalDeviceDictary] objectForKey:self.macStr];
    
    NSMutableDictionary *timerDic = [NSMutableDictionary dictionary];
    [timerDic setObject:dic[@"indx"] forKey:@"Num"];
    [timerDic setObject:[NSString stringWithFormat:@"%d", flag] forKey:@"Flag"];
    [timerDic setObject:[NSString stringWithFormat:@"%d", hour] forKey:@"Hour"];
    [timerDic setObject:[NSString stringWithFormat:@"%d", min] forKey:@"Min"];
    
//    for (int i = 0; i < 2; i++) {
        [DeviceManagerInstance set433TodeviceWithMacString:device.mac WithHost:device.host Open:isON withArc4Address:self.model.address deviceType:self.model.typeRF With:device.localContent timerDic:timerDic];
//    }
}

#pragma mark - timerLongPressed
- (void)timerLongPressed:(UILongPressGestureRecognizer *)longPress
{
    if (longPress.state == 1) {
        
        [timerTableView setFrame:CGRectMake(kScreen_Width, 0, rect.size.width, rect.size.height)];
        kindScrollView.scrollEnabled = NO;
        addBGView.hidden = YES;
        timerTableView.headerHidden = YES;
        self.back = 2;
        self.delete = 2;
        [timerTableView reloadData];
    }
}

#pragma mark - deleteTimerCell
- (void)deleteTimerCell:(UITapGestureRecognizer *)tap
{
    self.delete = 2;
    [chooseArr removeObjectAtIndex:[tap.tag intValue] - 100000];
    NSDictionary *tempDic = [_rfTimerArray objectAtIndex:[tap.tag intValue] - 100000];
    NSString *indexStr =  [tempDic objectForKey:@"indx"];
    Device *device = [[DeviceManagerInstance getlocalDeviceDictary] objectForKey:self.macStr];
    NSMutableDictionary *checkDic = [NSMutableDictionary dictionary];
    [checkDic setObject:@"10" forKey:@"Order"];
    [checkDic setObject:indexStr forKey:@"Num"];
    
    for (int i = 0; i < 2; i++) {
        [DeviceManagerInstance set433TodeviceWithMacString:device.mac WithHost:device.host Open:YES withArc4Address:self.model.address deviceType:self.model.typeRF With:device.localContent timerDic:checkDic];
    }
    
    [_rfTimerArray removeObjectAtIndex:[tap.tag intValue] - 100000];
    
    [timerTableView reloadData];
    
    if (_rfTimerArray.count == 0) {
        self.back = 1;
        self.delete = 1;
        [timerTableView reloadData];
        [timerTableView setFrame:CGRectMake(kScreen_Width, 0, rect.size.width, rect.size.height - 60)];
        timerTableView.headerHidden = NO;
        kindScrollView.scrollEnabled = YES;
        addBGView.hidden = NO;
    }
}

#pragma mark - editTimer
- (void)editTimer:(UITapGestureRecognizer *)tap
{
    int index = [tap.tag intValue] - 100100;
    if (self.back == 1) {
        
        NSDictionary *dict = [_rfTimerArray objectAtIndex:index];
        
        NSString *repeatStr = [self systemTimeZoneWithFlag:[[dict objectForKey:@"flag"] intValue] WithHour:[dict objectForKey:@"hour"] Minent:[dict objectForKey:@"min"]];
        
        NSString *timeStr = [self dateStingWithHoutAndMinWith:[dict objectForKey:@"hour"] WIthMin:[dict objectForKey:@"min"]];
        
        NSString *switchStr = [dict objectForKey:@"switch"];
        
        RFTimerVC *setTimerVC = [[RFTimerVC alloc] init];
        setTimerVC.typeStr = @"edit";
        setTimerVC.indexArray = [NSMutableArray arrayWithArray:@[timeStr, repeatStr, switchStr]];
        setTimerVC.macString = self.model.rfDataMac;
        setTimerVC.rfAddress = self.model.address;
        setTimerVC.rfType = self.model.typeRF;
        setTimerVC.taskNumber = [dict[@"indx"] intValue];
        [self.navigationController pushViewController:setTimerVC animated:YES];
    }
}

#pragma mark - 时间转换
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

#pragma mark - navBtn method
-(void)leftButtonMethod:(UIButton *)but
{
    if (self.back == 1) {
        
        [Util getAppDelegate].rootVC.pan.enabled = YES;
        [self.navigationController popViewControllerAnimated:YES];
    } else if (self.back == 2) {
        self.back = 1;
        self.delete = 1;
        [timerTableView reloadData];
        [timerTableView setFrame:CGRectMake(kScreen_Width, 0, rect.size.width, rect.size.height - iOS_6_height - 60)];
        timerBtn.userInteractionEnabled = YES;
        timerTableView.headerHidden = NO;
        
        kindScrollView.scrollEnabled = YES;
        addBGView.hidden = NO;
        
        for (int i = 0; i < _rfTimerArray.count; i++) {
            LockCell *cell = (LockCell *)[self.view viewWithTag:100000 + i];
            cell.delView.hidden = YES;
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
