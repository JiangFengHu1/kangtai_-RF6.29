////
////
///**
// * Copyright (c) www.bugull.com
// */
////
////
//
//#import "RFVC.h"
//
//
//#define  SLIER_HEIGHT 9
//@interface RFVC ()
//
//@property(nonatomic,assign)UInt8 values;
//
//@property (strong, nonatomic) UISlider *slider;
//
//@property (strong, nonatomic) UIImageView *backImage3;
////
//@property (strong, nonatomic) UIImageView *backImage4;
//
//@property (strong,nonatomic)UIView *view_;
//@end
//
//@implementation RFVC
//
//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}
//
//- (void)viewDidLoad
//{
//    [super viewDidLoad];
//    
//    self.values = 0x02;
//    [self loadUI];
//    // Do any additional setup after loading the view.
//}
//
//- (void)viewWillAppear:(BOOL)animated
//{
//    
//    
//    self.view_.hidden = YES;
//
//    if ([self.RFdataModel.typeRF isEqualToString:@"2"])
//    {
//        self.view_.hidden = NO;
//    }
//    if ([self.RFdataModel.typeRF isEqualToString:@"1"]) {
//        
//    
//        self.view_.hidden = YES;
//        
//    }
//
//    NSMutableArray *tempArr = [RFDataBase selectDataFromDataBaseWithId:self.RFdataModel.rfDataId];
//    self.RFdataModel = [tempArr objectAtIndex:0];
//    
//    self.nameLab.text = self.RFdataModel.rfDataName;
//    self.iconImageView.image = [Util getImageFile:self.RFdataModel.rfDataLogo];
//    [super viewWillAppear:animated];
//}
//
//
//
//- (void)loadUI
//{
//    self.titlelab.text = @"RF";
//    self.backButton.hidden = NO;
////    self.reloadBut.hidden = NO;
////    self.imageView_L.hidden = NO;
////    self.imageView_R.hidden = NO;
////    
////    self.imageView_R.image = [UIImage imageNamed:@"edit_small_normal.png"];
//    
//    self.imageV = [[UIImageView alloc] init];
//
//    self.imageV.image = [UIImage imageNamed:@"mark_border_big.png"];
//
//    
//    self.imageV.frame = CGRectMake(102.5, self.barView.frame.size.height+40, 115, 115);
//    [self.view addSubview:self.imageV];
//    
//
//    
//    self.iconImageView = [[UIImageView alloc ] initWithImage:[Util getImageFile:self.RFdataModel.rfDataLogo]];
//    
//    self.iconImageView.layer.cornerRadius = 5;
//    self.iconImageView.clipsToBounds = YES;
//    self.iconImageView.frame = self.imageV.frame;
//     [self.view addSubview:self.iconImageView];
//    self.nameLab =[[UILabel alloc] init];
//    self.nameLab.center = CGPointMake(self.iconImageView.center.x-5, self.iconImageView.center.y+80);
//    self.nameLab.bounds = CGRectMake(0, 0, 120, 30);
//    self.nameLab.textAlignment = NSTextAlignmentCenter;
//    self.nameLab.backgroundColor = [UIColor clearColor];
//    self.nameLab.text = self.RFdataModel.rfDataName;
//    self.nameLab.font = [UIFont systemFontOfSize:14];
//    self.nameLab.textColor = [UIColor colorWithRed:67.0/255 green:67.0/255 blue:67.0/255 alpha:1];
//    [self.view addSubview:self.nameLab];
//    
//    self.view_ = [[UIView alloc] initWithFrame:CGRectMake(0,self.nameLab.center.y + 65 , 320, 40)];
//    
//    
//    self.view_.backgroundColor =[UIColor clearColor];
//    [self.view addSubview:self.view_];
//   
//
//    UIButton *highButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    
//    highButton.frame = CGRectMake(280, 0, 40, 40);
//    highButton.tag = 333;
//    [highButton setImage:[UIImage imageNamed:@"light_high.png"] forState:UIControlStateNormal];
//    [highButton addTarget:self action:@selector(changeValue:)  forControlEvents:UIControlEventTouchUpInside];
//    
//    [self.view_ addSubview:highButton];
//    UIButton *lgbutton = [UIButton buttonWithType:UIButtonTypeCustom];
//    
//    lgbutton.frame = CGRectMake(0, 0, 40, 40);
//    lgbutton.tag = 334;
//    [lgbutton setImage:[UIImage imageNamed:@"light_low.png"] forState:UIControlStateNormal];
//    [lgbutton addTarget:self action:@selector(changeValue:)  forControlEvents:UIControlEventTouchUpInside];
//    
//    [self.view_ addSubview:lgbutton];
//
//   
//    
//
//
//    
//    BOOL isIphone5 =  ([UIScreen instancesRespondToSelector:@selector(currentMode)]?CGSizeEqualToSize(CGSizeMake(640, 1136),[[UIScreen mainScreen] currentMode].size):NO);
//    
//    //    4S切换一套图片
//    
//    if (isIphone5 != YES) {
//        
//
//        
//        self.imageV.image = [UIImage imageNamed:@""];
//        self.iconImageView.image = [Util getImageFile:self.RFdataModel.rfDataLogo];
//        
//        self.imageV.frame = CGRectMake(115.2, self.barView.frame.size.height+15, 89.6, 89.6);
//        
//        self.nameLab.center = CGPointMake(self.iconImageView.center.x+5, self.iconImageView.center.y+20);
//        
//        self.iconImageView.frame = self.imageV.frame;
//        
//        self.view_.frame = CGRectMake(0,self.nameLab.center.y + 75 , 320, 40);
//        
//    }
//    
//    self.backImage3 = [[UIImageView alloc]initWithFrame:CGRectMake(40, SLIER_HEIGHT, 240, 22)];
//    UIImage*image3 = [UIImage imageNamed:@"no_light_one.png"];
//    self.backImage3.backgroundColor = [UIColor colorWithPatternImage:image3];
//    
//    [self.view_ addSubview:self.backImage3];
//    
//    self.backImage4 = [[UIImageView alloc]initWithFrame:CGRectMake(40, SLIER_HEIGHT, 5, 22)];
//    UIImage *image4 = [UIImage imageNamed:@"light_one.png"];
//    self.backImage4.backgroundColor = [UIColor colorWithPatternImage:image4];
//    
//    [self.view_ addSubview:self.backImage4];
//    
//    
//    self.slider = [[UISlider alloc] initWithFrame:CGRectMake(40, SLIER_HEIGHT, 240,20)];
//    self.slider.value = 0.1;
//    self.slider.maximumValue = 1.6;
//    self.slider.minimumValue = 0;
//    //    右边
//    [self.slider setMaximumTrackImage:[UIImage imageNamed:@"clearblackground.png"] forState:UIControlStateNormal];
//    //    左边
//    [self.slider setMinimumTrackImage:[UIImage imageNamed:@"clearblackground.png"] forState:UIControlStateNormal];
//    
//    [self.slider setThumbImage:[UIImage imageNamed:@"light_one.png"] forState:UIControlStateHighlighted];//设置了普通状态和高亮状态的滑轮样式
//    
//    [self.slider addTarget:self action:@selector(changeSLiderValue:) forControlEvents:UIControlEventValueChanged];
//    self.backImage4.frame = CGRectMake(40, SLIER_HEIGHT, 240 * 0.1, 22);
//    self.slider.continuous  = NO;
//    [self.slider thumbImageForState:UIControlStateNormal];
//    [self.view_ addSubview:self.slider];
//    
//
//    
//    UIButton *onbutton = [UIButton buttonWithType:UIButtonTypeCustom];
//    onbutton.frame = CGRectMake(20, self.nameLab.center.y + 150, 80, 80);
//    
//    [onbutton setTitle:NSLocalizedString(@"ON", nil) forState:UIControlStateNormal];
//    
//    [onbutton addTarget:self action:@selector(onbuttonMethod:) forControlEvents:UIControlEventTouchUpInside];
//    [onbutton setTitleColor:[UIColor colorWithRed:30.0/255 green:142.0/255 blue:227.0/255 alpha:1] forState:UIControlStateNormal];
//    [onbutton setBackgroundImage:[UIImage imageNamed:@"circle_button_click.png"] forState:UIControlStateHighlighted];
//    
//    [onbutton setBackgroundImage:[UIImage imageNamed:@"circle_button.png"] forState:UIControlStateNormal];
//    [self.view addSubview:onbutton];
//    
//    
//    UIButton *offbutton = [UIButton buttonWithType:UIButtonTypeCustom];
//    offbutton.frame = CGRectMake(120, self.nameLab.center.y + 150, 80, 80);
//    
//    [offbutton setTitle:NSLocalizedString(@"OFF", nil) forState:UIControlStateNormal];
//    
//    [offbutton addTarget:self action:@selector(offbuttonMethod:) forControlEvents:UIControlEventTouchUpInside];
//    [offbutton setTitleColor:[UIColor colorWithRed:30.0/255 green:142.0/255 blue:227.0/255 alpha:1] forState:UIControlStateNormal];
//    [offbutton setBackgroundImage:[UIImage imageNamed:@"circle_button_click.png"] forState:UIControlStateHighlighted];
//    
//    [offbutton setBackgroundImage:[UIImage imageNamed:@"circle_button.png"] forState:UIControlStateNormal];
//    [self.view addSubview:offbutton];
//
//    UIButton *learnbutton = [UIButton buttonWithType:UIButtonTypeCustom];
//    learnbutton.frame = CGRectMake(220, self.nameLab.center.y + 150, 80, 80);
//    
//    [learnbutton setTitle:NSLocalizedString(@"Learn", nil) forState:UIControlStateNormal];
//    
//    [learnbutton addTarget:self action:@selector(learnbuttonMethod:) forControlEvents:UIControlEventTouchUpInside];
//    [learnbutton setTitleColor:[UIColor colorWithRed:30.0/255 green:142.0/255 blue:227.0/255 alpha:1] forState:UIControlStateNormal];
//    [learnbutton setBackgroundImage:[UIImage imageNamed:@"circle_button_click.png"] forState:UIControlStateHighlighted];
//    
//    [learnbutton setBackgroundImage:[UIImage imageNamed:@"circle_button.png"] forState:UIControlStateNormal];
//    [self.view addSubview:learnbutton];
//    if ([self.RFdataModel.typeRF isEqualToString:@"2"])
//    {
//        self.view_.hidden = NO;
//    }else{
//        self.view_.hidden = YES;
//
//    }
//
//
//    
//}
//
//
//
//- (void)changeSLiderValue:(UISlider *)sender
//{
//    self.backImage4.frame = CGRectMake(40, SLIER_HEIGHT, 150 * sender.value, 22);
//    
////    switch (sender.value) {
////        case :
////        
////            break;
////            
////        default:
////            break;
////    }
//    
//    
//    if (sender.value == 0.f) {
//        self.values = 0x00;
//    }
// else  if (0 < sender.value <=0.1f) {
//        self.values = 0x01;
//    }
//  else  if ( 0.1f<sender.value <= 0.2f) {
//        self.values = 0x02;
//    }
//  else if (0.2f <sender.value <= 0.3f) {
//        self.values = 0x03;
//    }
//   else if (0.3f <sender.value <= 0.4f) {
//        self.values = 0x04;
//    }
//    else if (0.4f <sender.value <= 0.5f) {
//        self.values = 0x05;
//    }
//   else if (0.5f <sender.value <= 0.6f) {
//        self.values = 0x06;
//    }
//   else if (0.6f <sender.value <= 0.7f) {
//        self.values = 0x07;
//    }
//   else if (0.7f <sender.value <= 0.8f) {
//        self.values = 0x08;
//    }
//   else if (0.8f <sender.value <= 0.9f) {
//       self.values = 0x09;
//   }
//   else if (0.9f <sender.value <= 1.0f) {
//       self.values = 0x0a;
//   }
//    
//   else if (1.0f <self.slider.value <= 1.1f) {
//       self.values = 0x0b;
//   }
//   else if (1.1f <self.slider.value <= 1.2f) {
//       self.values = 0x0c;
//   }
//   else if (1.2f <self.slider.value <= 1.3f) {
//       self.values = 0x0d;
//   }
//   else if (1.3f <self.slider.value <= 1.4f) {
//       self.values = 0x0e;
//   }
//   else if (1.4f <self.slider.value <= 1.5f) {
//       self.values = 0x0f;
//   }
//
//
//    Device *device = [[DeviceManagerInstance getlocalDeviceDictary] objectForKey:self.macString];
//    
//    [DeviceManagerInstance  setsliderTodeviceid:device.mac WithHost:device.host Open:by withArc4Address:self.RFdataModel.address deviceType:YES value:self.values With:device.localContent];
//
//}
//
//static BOOL onOrOff = YES;
//
//
//
////开关
//- (void)onbuttonMethod:(UIButton *)but
//{
//    
//        onOrOff =YES;
//    
////    433开关配置
//
//    Device *device = [[DeviceManagerInstance getlocalDeviceDictary] objectForKey:self.macString];
//
//    [DeviceManagerInstance set433TodeviceWithMacString:device.mac WithHost:device.host Open:onOrOff withArc4Address:self.RFdataModel.address deviceType:NO value:self.values With:device.localContent];
//    
//    [NSThread sleepForTimeInterval:0.3];
//
//    
//}
//
//- (void)offbuttonMethod:(UIButton *)butt
//{
//    onOrOff = NO;
//
//    
//    Device *device = [[DeviceManagerInstance getlocalDeviceDictary] objectForKey:self.macString];
//
//    [DeviceManagerInstance set433TodeviceWithMacString:device.mac WithHost:device.host Open:onOrOff withArc4Address:self.RFdataModel.address deviceType:NO value:self.values With:device.localContent];
//
//
//    [NSThread sleepForTimeInterval:0.3];
//
//}
//
//- (void)learnbuttonMethod:(UIButton *)butt
//{
//    onOrOff = YES;
////    NSMutableArray *temparray = [DataBase selectDataFromDataBaseWithId:self.dataBaseId];
////    Device *device =  [temparray objectAtIndex:0];
////    
////
////    [DeviceManagerInstance set433TodeviceWithMacString:self.dataBaseId Open:onOrOff withArc4Address:self.RFdataModel.address deviceType:NO value:self.values With:device.localContent];
////
//    Device *device = [[DeviceManagerInstance getlocalDeviceDictary] objectForKey:self.macString];
//    
//    [DeviceManagerInstance set433TodeviceWithMacString:device.mac WithHost:device.host Open:onOrOff withArc4Address:self.RFdataModel.address deviceType:NO value:self.values With:device.localContent];
//
//    [NSThread sleepForTimeInterval:0.3];
//}
//
//
//- (void)reloadButtonMethod:(UIButton *)sender{
//    
////    self.imageView_R.image = [UIImage imageNamed:@"edit_small_click.png"];
////    self.imageView_R.image = [UIImage imageNamed:@"edit_small_normal.png"];
//
//    EditVC *edit = [[EditVC alloc ]init];
//    edit.RFdataModel = self.RFdataModel;
//    edit.editstateType = EditStateRFpush;
//    [self.navigationController pushViewController:edit animated:YES];
//    
//}
//
//static bool by = YES;
//
//- (void)changeValue:(UIButton *)but
//{
//    
//    
//
//    switch (but.tag ) {
//        case 333://大
////            self.pv1.progress = by;
//            if (self.slider.value == 1.6)
//            {
//                return;
//            }
//            self.slider.value += 0.1;
//          
//
//            break;
//        case 334://小
////            NSLog(@"%f",by);
////            self.pv1.progress = by;
//
//            if (self.slider.value <= 0.0)
//            {
//                return;
//                
//            }
//
//            self.slider.value -= 0.1;
//            
//            break;
//
//        default:
//            break;
//    }
//    
//    
//    if (self.slider.value == 0.f) {
//        self.values = 0x00;
//    }
//    else  if (0 < self.slider.value <=0.1f) {
//        self.values = 0x01;
//    }
//    else  if ( 0.1f<self.slider.value <= 0.2f) {
//        self.values = 0x02;
//    }
//    else if (0.2f <self.slider.value <= 0.3f) {
//        self.values = 0x03;
//    }
//    else if (0.3f <self.slider.value <= 0.4f) {
//        self.values = 0x04;
//    }
//    else if (0.4f <self.slider.value <= 0.5f) {
//        self.values = 0x05;
//    }
//    else if (0.5f <self.slider.value <= 0.6f) {
//        self.values = 0x06;
//    }
//    else if (0.6f <self.slider.value <= 0.7f) {
//        self.values = 0x07;
//    }
//    else if (0.7f <self.slider.value <= 0.8f) {
//        self.values = 0x08;
//    }
//    else if (0.8f <self.slider.value <= 0.9f) {
//        self.values = 0x09;
//    }
//    else if (0.9f <self.slider.value <= 1.0f) {
//        self.values = 0x0a;
//    }
//
//    else if (1.0f <self.slider.value <= 1.1f) {
//        self.values = 0x0b;
//    }
//    else if (1.1f <self.slider.value <= 1.2f) {
//        self.values = 0x0c;
//    }
//    else if (1.2f <self.slider.value <= 1.3f) {
//        self.values = 0x0d;
//    }
//    else if (1.3f <self.slider.value <= 1.4f) {
//        self.values = 0x0e;
//    }
//    else if (1.4f <self.slider.value <= 1.5f) {
//        self.values = 0x0f;
//    }
//   
//
//
//    Device *device = [[DeviceManagerInstance getlocalDeviceDictary] objectForKey:self.macString];
//    
//    [DeviceManagerInstance  setsliderTodeviceid:device.mac WithHost:device.host Open:by withArc4Address:self.RFdataModel.address deviceType:YES value:self.values With:device.localContent];
//
//    self.backImage4.frame = CGRectMake(40, SLIER_HEIGHT, 150 *self.slider.value, 22);
//
//}
//
//
//
//- (void)didReceiveMemoryWarning
//{
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
//
///*
//#pragma mark - Navigation
//
//// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//    // Get the new view controller using [segue destinationViewController].
//    // Pass the selected object to the new view controller.
//}
//*/
//
//@end
