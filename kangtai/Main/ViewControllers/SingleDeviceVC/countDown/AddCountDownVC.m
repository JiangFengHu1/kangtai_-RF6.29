//
//
/**
 * Copyright (c) www.bugull.com
 */
//
//

#import "AddCountDownVC.h"
#import "ZQCustomTimePicker.h"

@interface AddCountDownVC ()

{
    ZQCustomTimePicker *timePicker;
}

@property(nonatomic,assign)UInt8 hour;

@property(nonatomic,assign)UInt8 min;

@property(nonatomic,assign)UInt8 flag;

@property (nonatomic, assign)BOOL isOFF;

@end

@implementation AddCountDownVC

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
    
    [self loadUI];
    
    // Do any additional setup after loading the view.
}

#pragma mark-
#pragma mark-UI
- (void)loadUI
{
    
    self.flag = 0x80;
    self.isOFF = YES;
    self.titlelab.text = NSLocalizedString(@"Add Count Down", nil);
    self.titlelab.bounds = CGRectMake(0, 0, 200, 40);
    self.view.backgroundColor = RGBA(248.0, 248.0, 248.0, 1.0);
    
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, self.barView.frame.size.height, 90, kScreen_Height - self.barView.frame.size.height)];
    leftView.backgroundColor = RGBA(242.0, 242.0, 242.0, 1.0);
    [self.view addSubview:leftView];
    UIView *firstLineView = [[UIView alloc] initWithFrame:CGRectMake(leftView.frame.size.width, (int)(kScreen_Height - self.barView.frame.size.height) / 2 + 34, kScreen_Width - leftView.frame.size.width, 1)];
    firstLineView.backgroundColor = RGBA(220.0, 220.0, 220.0, 1.0);
    [self.view addSubview:firstLineView];
    UIView *secondLineView = [[UIView alloc] initWithFrame:CGRectMake(leftView.frame.size.width, (int)(kScreen_Height - self.barView.frame.size.height) / 2 + 114, kScreen_Width - leftView.frame.size.width, 1)];
    secondLineView.backgroundColor = RGBA(220.0, 220.0, 220.0, 1.0);
    [self.view addSubview:secondLineView];
    
    UILabel *afterLab = [[UILabel alloc] initWithFrame:CGRectMake(13, self.barView.frame.size.height - 44 + firstLineView.frame.origin.y / 2, 80, 40)];
    afterLab.backgroundColor = [UIColor clearColor];
    afterLab.font = [UIFont systemFontOfSize:18];
    afterLab.text = NSLocalizedString(@"After",nil);
    afterLab.adjustsFontSizeToFitWidth = YES;
    afterLab.numberOfLines = 0;
    afterLab.textColor = RGBA(0.0, 0.0, 0.0, 1.0);
    [self.view addSubview:afterLab];
    
    UILabel *powerLab = [[UILabel alloc] initWithFrame:CGRectMake(13, (firstLineView.frame.origin.y + secondLineView.frame.origin.y) / 2 - 21, 80, 40)];
    powerLab.backgroundColor = [UIColor clearColor];
    powerLab.font = [UIFont systemFontOfSize:18];
    powerLab.text = NSLocalizedString(@"Action", nil);
    powerLab.adjustsFontSizeToFitWidth = YES;
    powerLab.numberOfLines = 0;
    powerLab.textColor = RGBA(0.0, 0.0, 0.0, 1.0);
    [self.view addSubview:powerLab];
    
    NSArray *actionNameArr = @[NSLocalizedString(@"ON", nil), NSLocalizedString(@"OFF", nil)];
    NSArray *imgArr = @[@"valid__2", @"invalid_2"];
    for (int i = 0; i < 2; i++) {
        UIButton *actionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        actionBtn.frame = CGRectMake(leftView.frame.size.width, powerLab.center.y - 37 + i * 42, kScreen_Width - leftView.frame.size.width, 35);
        actionBtn.tag = 100 + i;
        [actionBtn addTarget:self action:@selector(switchButtDeviceMethod:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:actionBtn];
        
        UIImageView *actionImgView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 5, 25, 25)];
        actionImgView.image = [UIImage imageNamed:imgArr[i]];
        actionImgView.tag = 200 + i;
        [actionBtn addSubview:actionImgView];
        
        UILabel *actionNameLab = [[UILabel alloc] initWithFrame:CGRectMake(55, 0, kScreen_Width - leftView.frame.size.width - 55, 35)];
        actionNameLab.backgroundColor = [UIColor clearColor];
        actionNameLab.font = [UIFont systemFontOfSize:18];
        actionNameLab.text = actionNameArr[i];
        actionNameLab.textColor = RGBA(164.0, 164.0, 164.0, 1.0);
        [actionBtn addSubview:actionNameLab];
    }
    
    float pickerF = (kScreen_Height == 480) ? 5 : 28;
    float x = (float)kScreen_Width / 320;
    float y = (float)kScreen_Height / 568;
    float h = (kScreen_Width > 320) ? y : 1;
    
    timePicker = [[ZQCustomTimePicker alloc] initWithFrame:CGRectMake((leftView.frame.size.width + 20) * x, (barViewHeight + pickerF) * h + ((iOS_version < 7.0) ? 17 : 0), 205, 170) withIsZero:YES andSetTimeString:nil];
    [self.view addSubview:timePicker];
}

- (NSArray *)loadDataWithDate:(NSDate *)date WithDateOrTime:(BOOL)isDate
{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit |NSCalendarUnitMinute |NSCalendarUnitSecond | NSCalendarUnitHour fromDate:date];
    
    NSDateFormatter* dateFo = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
    
    [dateFo setDateFormat:@"yyyy-MM-dd HH:mm:ss"];//设定时间格式,这里可以设置成自己需要的格式
    
    
    NSDate *datessss =[dateFo dateFromString:[NSString stringWithFormat:@"2014-07-02 %ld:%ld:%ld",(long)[components hour],(long)[components minute],(long)[components second]]];
    
    dateFo.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];//这就是GMT+0时区了
    NSString *dateString = [dateFo stringFromDate:datessss];
    
    
    NSArray *array =  [dateString componentsSeparatedByString:@" "];
    
    NSString *daString =  [array objectAtIndex:0];
    
    NSString *timeString =  [array objectAtIndex:1];
    
    NSArray *dateArray =  [daString componentsSeparatedByString:@"-"];
    //    self.dateDD = [[dateArray objectAtIndex:2] intValue];
    NSArray *timeArray =  [timeString componentsSeparatedByString:@":"];
    
    if (isDate == YES) {
        return dateArray;
    }
    else{
        return timeArray;
    }
    
    return nil;
}

#pragma mark-
#pragma mark-Click

- (void)reloadButtonMethod:(UIButton *)sender
{
    self.hour = timePicker.hourPicker.currentItemIndex;
    self.min = timePicker.minutePicker.currentItemIndex;
    
    if (self.hour == 0 && self.min == 0) {
        [Util showAlertWithTitle:NSLocalizedString(@"Tips", nil) msg:NSLocalizedString(@"Chosen time error", nil)];
        return;
    }
    
    Device *device = [[DeviceManagerInstance getlocalDeviceDictary] objectForKey:self.macString];
    
    [DeviceManagerInstance setCountdownWithMacString:device.mac Withhost:device.host flag:self.flag Hour:self.hour min:self.min TaskCount:0x01 Switch:self.isOFF key:device.key With:device.localContent deviceType:device.deviceType];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
    });
}

- (void)switchButtDeviceMethod:(UIButton *)but
{
    for (int i = 0; i < 2; i++) {
        UIImageView *tempImgView = (UIImageView *)[self.view viewWithTag:200 + i];
        if (i == but.tag - 100) {
            tempImgView.image = [UIImage imageNamed:@"valid__2"];
        } else {
            tempImgView.image = [UIImage imageNamed:@"invalid_2"];
        }
    }
    self.isOFF = (but.tag - 100 == 0);
}

- (void)leftButtonMethod:(UIButton *)but
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
