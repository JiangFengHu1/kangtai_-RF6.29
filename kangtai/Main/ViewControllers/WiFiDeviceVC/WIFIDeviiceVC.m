//
//
/**
 * Copyright (c) www.bugull.com
 */
//
//


#import "WIFIDeviiceVC.h"
#import "ProtocolData.h"
#import "RootViewController.h"

static CGFloat CellHeight = 80.f;
static NSString *CellIdentifier = @"CellIdentifier";

@interface WIFIDeviiceVC ()<NSURLConnectionDelegate>
{
    UITableViewCellEditingStyle  _cellEditingStyle;
    UIButton *animationButton;
    int connected;
    
    NSString *emailStr;
    NSString *pwdStr;
    int countNumber;
    int flag;
    
    dispatch_once_t onceToken;
    NSTimer *reloadTimer;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) EditableTableController *editableTableController;

@property (strong,nonatomic) NSMutableArray * socketViewArray;

@property (strong,nonatomic) NSTimer *timer;
@property (strong,nonatomic) NSTimer *animationTimer;

@property (assign,nonatomic) UInt8 switchIndex;
@property (strong,nonatomic) SocketOperation * subscribeOperation;
@property (strong,nonatomic) NSMutableArray * operations;

@property (nonatomic, assign) NSInteger hide;
@property (nonatomic, assign) NSInteger backNumber;
@property (nonatomic, assign) BOOL isClicked;


@end

static WIFIDeviiceVC *singleton = nil;

@implementation WIFIDeviiceVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self notificationCenterMothod];
        self.hide = 1;
        self.backNumber = 1;
        self.isClicked = YES;
        countNumber = 0;
        flag = 0;
        _disconnect = 0;
    }
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"=== %d %d == %d ==", [LocalServiceInstance isConnected], [RemoteServiceInstance isConnected], [DeviceManagerInstance networkStatus]);
    
    self.socketViewArray = [DataBase ascWithRFtableINOrderNumber];
    
    [self.tableView reloadData];
    
    [super viewWillAppear:animated];
}

- (void)checkDeviceStatus
{
    for (int i = 0; i < self.socketViewArray.count; i++) {
        Device *dev = self.socketViewArray[i];
        Device *device = [[DeviceManagerInstance getlocalDeviceDictary] objectForKey:dev.macString];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [RemoteServiceInstance queryEquipmentOnlineWithMac:device.mac deviceType:device.deviceType];
        });
    }
}

- (void)deviceLinseToTCP
{
    self.socketViewArray = [DataBase ascWithRFtableINOrderNumber];

    for (int i = 0; i < self.socketViewArray.count; i ++)
    {
        Device *devices =[self.socketViewArray objectAtIndex:i];
        Device *decix = [[DeviceManagerInstance getlocalDeviceDictary] objectForKey:devices.macString];
        
        [DeviceManagerInstance queryGPIOEventToMacDevice:decix.mac withHost:decix.host withloaclContent:decix.localContent deviceType:decix.deviceType];
    }
}

- (void)dismissHUDin
{
    [MMProgressHUD dismiss];
    
    [self.tableView reloadData];
}

//tcp
- (void)tcpChangeUpLine
{
    for (int i = 0; i < self.socketViewArray.count; i ++)
    {
        Device *decix = [self.socketViewArray objectAtIndex:i];
        Device *decive =  [[DeviceManagerInstance getlocalDeviceDictary] objectForKey:decix.macString];
        [RemoteServiceInstance subscribetoeventsWith:YES WithMac:decive.mac with:0x06 deviceType:decive.deviceType];
        [RemoteServiceInstance subscribetoeventsWith:YES WithMac:decive.mac with:0x85 deviceType:decive.deviceType];
    }
}

- (void)SendGetDeviceInfo
{
    self.socketViewArray = [DataBase ascWithRFtableINOrderNumber];
    
    if (self.socketViewArray.count > 0) {
        
        for (int i = 0; i < self.socketViewArray.count; i ++)
        {
            Device *decix =  [self.socketViewArray objectAtIndex:i];
            Device *decive =  [[DeviceManagerInstance getlocalDeviceDictary] objectForKey:decix.macString];
            [DeviceManagerInstance getDeviceInfoToMac:decive.mac With:decive.localContent WIthHost:decive.host deviceType:decive.deviceType];
        }
    }
}

- (void)timerMethod
{
    NSMutableArray  *array= [[NSUserDefaults standardUserDefaults] objectForKey:OPER_CLOSE_INFO];
    NSDictionary *dic = [array objectAtIndex:0];
    
    NSData *mac = [dic objectForKey:@"mac"];
    
    for (Device * devices in self.socketViewArray)
    {
        if ([[Crypt decodeHex:devices.macString] isEqualToData:mac])
        {
            Device *device = [[DeviceManagerInstance getlocalDeviceDictary] objectForKey:devices.macString];
           
            if (device == nil) {
                return;
            }
            
            self.switchIndex = [[NSString stringWithFormat:@"%@",[dic objectForKey:@"switch"]] intValue];
            
            int tag = (int)[self.socketViewArray indexOfObject:devices];
            WIFIDeviceCell* cell = (WIFIDeviceCell *)[self.view viewWithTag:tag + 333];

            UIImage *markImg = [device.deviceType isEqualToString:@"31"] ? [UIImage imageNamed:@"RF_mark"] : [UIImage imageNamed:@"Energy_Info_mark.png"];

            cell.deviceTimer.hidden = YES;
            if (self.switchIndex == 255) {
                cell.iconImageV.image = [Util getImageFile:device.image];
                cell.switchImageV.image = [UIImage imageNamed:@"power_on.png"];
                cell.markImgView.image = markImg;
                device.alarm = @"on";
                isSelected = YES;
            }
            if (self.switchIndex == 0) {
                device.alarm = @"off";
                isSelected = NO;
                cell.iconImageV.image = [self grayImage:[Util getImageFile:device.image]];
                cell.switchImageV.image = [UIImage imageNamed:@"power_off.png"];
                cell.markImgView.image = [self grayImage:markImg];
            }
            
            device.hver = @"1";
            device.remoteContent = @"1";
            
            if (devices != nil) {
                [[DeviceManagerInstance getlocalDeviceDictary] setObject:device forKey:devices.macString];
            }
            [self performSelector:@selector(stopAnimationWithButton:) withObject:cell.switchBut afterDelay:0.05f];
        }
    }
}

- (void)initVariable
{
    _cellEditingStyle = UITableViewCellEditingStyleDelete;
    _operations = [NSMutableArray array];
    self.socketViewArray = [[NSMutableArray  alloc]initWithCapacity:0];
    
    self.socketViewArray = [DataBase ascWithRFtableINOrderNumber];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //开启网络状况的监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    Reachability *hostReach = [Reachability reachabilityWithHostname:@"www.baidu.com"];
    [hostReach startNotifier];  //开始监听，会启动一个run loop
    
    emailStr = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_USERMODEL];
    pwdStr = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_PASSWORD];
    
    [self showMMProgressHUD];
    
    
    self.titlelab.text = NSLocalizedString(@"WiFi Devices", nil);
    [self.backButton setBackgroundImage:[UIImage imageNamed:@"list_menu_normal.png"] forState:UIControlStateNormal];
    [self.backButton setBackgroundImage:[UIImage imageNamed:@"list_menu_click.png"] forState:UIControlStateHighlighted];
    [self.rightBut setBackgroundImage:[UIImage imageNamed:@"add_normal.png"] forState:UIControlStateNormal];
    [self.rightBut setBackgroundImage:[UIImage imageNamed:@"add_click.png"] forState:UIControlStateHighlighted];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, barViewHeight, kScreen_Width, kScreen_Height - barViewHeight - iOS_6_height)];
    self.tableView.rowHeight = CellHeight;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellIdentifier];
    [self.view addSubview:self.tableView];
    [self.tableView addHeaderWithTarget:self action:@selector(headerBeginRefresh)];
    self.editableTableController = [[EditableTableController alloc] initWithTableView:self.tableView];
    [self.editableTableController setEnabled:NO];
    self.editableTableController.delegate = self;
    
    _cellEditingStyle = UITableViewCellEditingStyleDelete;
    _operations = [NSMutableArray array];
    self.socketViewArray = [[NSMutableArray  alloc]initWithCapacity:0];
    
    [self initVariable];
    
    [self performSelector:@selector(tableViewReloadData) withObject:nil afterDelay:1.7];
    [self performSelector:@selector(dismissHUDin) withObject:nil afterDelay:2.5];
    [self performSelector:@selector(SendGetDeviceInfo) withObject:nil afterDelay:.8];
    [self performSelector:@selector(tcpChangeUpLine) withObject:nil afterDelay:0.5];
    
    for (int i = 0; i < self.socketViewArray.count; i ++) {
        Device *devices = [self.socketViewArray objectAtIndex:i];
        Device*device =  [[DeviceManagerInstance getlocalDeviceDictary] objectForKey:devices.macString];
        if ([device.localContent isEqualToString:@"0"] && [device.remoteContent isEqualToString:@"0"] )
        {
            
            device.hver = @"0";
        }else{
            device.hver = @"1";
        }
        
        if ([DeviceManagerInstance networkStatus] == ReachableViaWiFi) {
            for (int i = 0; i < 2; i ++) {
                switch ([device.deviceType intValue]) {
                    case 11:
                        [LocalServiceInstance addDeviceToFMDBWithisAdd:YES WithMac:device.mac];
                        break;
                    case 21:
                        [LocalServiceInstance addEnergyDeviceToFMDBWithisAdd:YES WithMac:device.mac];
                        break;
                    case 31:
                        [LocalServiceInstance addRFDeviceToFMDBWithisAdd:YES WithMac:device.mac];
                        break;
                        
                    default:
                        break;
                }
            }
        }

        if (devices != nil) {
            [[DeviceManagerInstance getlocalDeviceDictary] setObject:device forKey:devices.macString];
        }
    }
}

- (void)tableViewReloadData
{
    [self.tableView reloadData];
}

- (void)showMMProgressHUD
{
    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleFade];
    [MMProgressHUD showWithTitle:NSLocalizedString(@"Links", nil) status:NSLocalizedString(@"Loading", nil)];
}

- (void)notificationCenterMothod
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeState) name:@"changeState" object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onlineOfflineState:) name:@"OPERATION_INFO" object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onlineOfflineStateWithLocatil:) name:@"localState" object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(tcpStateWithServer:) name:@"TCPlian" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(change:) name:@"getState" object:nil];
}

- (void)change:(NSNotification *)notification
{

    
//    for (int i = 0; i < self.socketViewArray.count; i ++)
//    {
    
    NSString *macStr = [notification object];
//        Device *devices = [self.socketViewArray objectAtIndex:i];
    
        Device *decix = [[DeviceManagerInstance getlocalDeviceDictary] objectForKey:macStr];
        
        if (decix == nil) {
            return;
        }

        if ([decix.remoteContent isEqualToString:@"0"])
        {
            decix.hver = @"0";
        }
        else{
            
            decix.hver = @"1";
            
            decix.remoteContent = @"1";
            
            dispatch_async(dispatch_queue_create("reonline", NULL), ^{
                if ([LocalServiceInstance isConnected]) {
                    for (int i = 0; i < 2; i++) {
                        switch ([decix.deviceType intValue]) {
                            case 11:
                                [LocalServiceInstance addDeviceToFMDBWithisAdd:YES WithMac:decix.mac];
                                break;
                            case 21:
                                [LocalServiceInstance addEnergyDeviceToFMDBWithisAdd:YES WithMac:decix.mac];
                                break;
                            case 31:
                                [LocalServiceInstance addRFDeviceToFMDBWithisAdd:YES WithMac:decix.mac];
                                break;
                                
                            default:
                                break;
                        }
                    }
                }
                for (int i = 0; i < 2; i++) {
                    [DeviceManagerInstance queryGPIOEventToMacDevice:decix.mac withHost:decix.host withloaclContent:decix.localContent deviceType:decix.deviceType];
                }
            });

//            [DeviceManagerInstance queryGPIOEventToMacDevice:decix.mac withHost:decix.host withloaclContent:decix.localContent deviceType:decix.deviceType];

        }
    
    [[DeviceManagerInstance getlocalDeviceDictary] setObject:decix forKey:decix.macString];
    
//    }
    
    [self.tableView reloadData];
}

- (void)tcpStateWithServer:(NSNotification *)notification
{
    
    [self deviceLinseToTCP];
    
    
    [self tcpChangeUpLine];
    
}

- (void)onlineOfflineStateWithLocatil:(NSNotification *)notification
{
    
    [self.tableView reloadData];
}

- (void)onlineOfflineState:(NSNotification *)notification{
    
    NSDictionary  *dict =[notification object];
    
    NSLog(@"dict--%@",dict);
    
    self.socketViewArray = [DataBase ascWithRFtableINOrderNumber];
    
    for (int i= 0 ;i <self.socketViewArray.count ;i ++)
    {
        
        Device *devcices = [self.socketViewArray objectAtIndex:i];
        if (devcices == nil) {
            return;
        }
        
        if ([[Crypt decodeHex:devcices.macString] isEqualToData:[dict objectForKey:@"mac"]])
        {
            
            Device *device = [[DeviceManagerInstance getlocalDeviceDictary] objectForKey:devcices.macString];
            
            if ([device.localContent isEqualToString:@"0"] && [device.remoteContent isEqualToString:@"0"])
            {
                device.hver = @"0";
            }
            else
            {
                device.hver = @"1";
//                device.localContent = @"0";
//                device.remoteContent = @"1";
                if (DeviceManagerInstance.networkStatus ==  ReachableViaWiFi)
                {
//                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        for (int j = 0; j < 2; j ++) {
                            
                            switch ([device.deviceType intValue]) {
                                case 11:
                                    [LocalServiceInstance addDeviceToFMDBWithisAdd:YES WithMac:device.mac];
                                    break;
                                case 21:
                                    [LocalServiceInstance addEnergyDeviceToFMDBWithisAdd:YES WithMac:device.mac];
                                    break;
                                case 31:
                                    [LocalServiceInstance addRFDeviceToFMDBWithisAdd:YES WithMac:device.mac];
                                    break;
                                    
                                default:
                                    break;
                            }
                        }
//                    });
                }
            }
            
            if (device != nil) {
                [[DeviceManagerInstance getlocalDeviceDictary] setObject:device forKey:devcices.macString];
            }
        }
    }
    
    self.socketViewArray = [DataBase ascWithRFtableINOrderNumber];
    [self.tableView reloadData];
}

- (void)changeState
{
    if ([_timer isValid]) {
        [_timer invalidate];
        _timer = nil;
    }
    self.timer =  [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(timerMethod) userInfo:nil repeats:NO];
}

#pragma mark-HTTP
//删除 WiFi 设备

- (void)deleteWifiDeviceSynchronizationToServerWith:(NSString *)useName WithPass:(NSString *)passWord MacAddress:(NSString *)mac
{
    NSString *tempString = [Util getPassWordWithmd5:passWord];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:AccessKey forKey:@"accessKey"];
    [dict setValue:useName forKey:@"username"];
    [dict setValue:tempString forKey:@"password"];
    [dict setValue:[mac uppercaseStringWithLocale:[NSLocale currentLocale]]   forKey:@"macAddress"];
    NSString *timeSp = [NSString stringWithFormat:@"%f", (double)[[NSDate date] timeIntervalSince1970]*1000];
    
    NSArray *temp =   [timeSp componentsSeparatedByString:@"."];
    [dict setValue:[temp objectAtIndex:0] forKey:@"lastOperation"];
    [HTTPService POSTHttpToServerWith:DeleteWifiURL WithParameters:dict   success:^(NSDictionary *dic) {
        
        NSString * success = [dic objectForKey:@"success"];
        
        if ([success boolValue] == true) {
        }
        if ([success boolValue] == false) {
            
//            [Util showAlertWithTitle:NSLocalizedString(@"Tips", nil) msg:[dic objectForKey:@"msg"]];
        }
        
    } error:^(NSError *error) {
//        [Util showAlertWithTitle:NSLocalizedString(@"Tips", nil) msg:NSLocalizedString(@"Link Timeout", nil)];
    }];
}

#pragma mark - headerRefresh
- (void)headerBeginRefresh
{
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:ON_LINE__OFFLINE];
    self.socketViewArray = [DataBase ascWithRFtableINOrderNumber];
    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (int i = 0; i < self.socketViewArray.count; i ++)
        {
            Device *devices =  [self.socketViewArray objectAtIndex:i];
            if (devices == nil) {
                return;
            }
            
            Device *decix = [[DeviceManagerInstance getlocalDeviceDictary] objectForKey:devices.macString];
            
            if (DeviceManagerInstance.networkStatus ==  ReachableViaWiFi)
            {
                switch ([decix.deviceType intValue]) {
                    case 11:
                        [LocalServiceInstance addDeviceToFMDBWithisAdd:YES WithMac:decix.mac];
                        break;
                    case 21:
                        [LocalServiceInstance addEnergyDeviceToFMDBWithisAdd:YES WithMac:decix.mac];
                        break;
                    case 31:
                        [LocalServiceInstance addRFDeviceToFMDBWithisAdd:YES WithMac:decix.mac];
                        break;
                        
                    default:
                        break;
                }
                if (decix != nil) {
                    [[DeviceManagerInstance getlocalDeviceDictary] setObject:decix forKey:devices.macString];
                }
                
                [self performSelector:@selector(getDeviceInfo:) withObject:decix afterDelay:0.3];
            }
            
            [RemoteServiceInstance queryEquipmentOnlineWithMac:decix.mac deviceType:decix.deviceType];
        }
//    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
        [self.tableView headerEndRefreshing];
    });
}

#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.socketViewArray  count];
}


- (NSIndexPath *)tableView:(UITableView *)tv willSelectRowAtIndexPath:(NSIndexPath *)path
{
    Device *device = [self.socketViewArray objectAtIndex:path.row];
    
    Device *dict =  [[DeviceManagerInstance getlocalDeviceDictary] objectForKey:device.macString];
    
    if ([dict.hver intValue] ==1)
    {
        return path;
        
    }
    
    return nil;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *SimpleTableIdentifier = @"SimpleTableIdentifier";
    
    WIFIDeviceCell *cell = [tableView dequeueReusableCellWithIdentifier:
                            SimpleTableIdentifier];
    if (cell == nil) {
        
        cell = [[WIFIDeviceCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                     reuseIdentifier: SimpleTableIdentifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    Device *device = [self.socketViewArray objectAtIndex:indexPath.row];
    Device *model = [[DeviceManagerInstance getlocalDeviceDictary] objectForKey:device.macString];
    cell.markImgView.hidden = [model.deviceType isEqualToString:@"11"];
    if ([model.deviceType isEqualToString:@"31"]) {
        cell.markImgView.image = [UIImage imageNamed:@"RF_mark"];
    }
    UIImage *iconLogo;
    
    NSString *dataPath = [[[NSBundle mainBundle] bundlePath] stringByAppendingString:[NSString stringWithFormat:@"/%@",model.image]];//获取程序包中相应文件的路径
    //    NSError *error;
    NSFileManager *fileMa = [NSFileManager defaultManager];
    
    if(![fileMa fileExistsAtPath:dataPath]) //
    {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if (![fileManager fileExistsAtPath:[Util getFilePathWithImageName:model.image]]) {
            iconLogo =  [[UIImage alloc] initWithContentsOfFile:[Util getFilePathWithImageName:model.image]];
        } else {
            iconLogo = [Util getImageFile:model.image];
        }
    }
    else
    {
        iconLogo = [UIImage imageNamed:model.image];
        
    }
    
    /*7.23.周三修改*/
    if ([model.image isEqualToString:@""] || model.image == nil) {
        iconLogo = [UIImage imageNamed:@"0.png"];
        
        model.image  =@"0.png";
        
        [DataBase updateFromLogo:model];
    }
    cell.iconImageV.image = iconLogo;
    cell.deviceName.text = model.name;
    UIImage *markImg = [model.deviceType isEqualToString:@"31"] ? [UIImage imageNamed:@"RF_mark"] : [UIImage imageNamed:@"Energy_Info_mark.png"];
    
    if ([model.alarm isEqualToString:@"on"])
    {
        cell.iconImageV.image = cell.iconImageV.image;
        cell.markImgView.image = markImg;
        cell.switchImageV.image = [UIImage imageNamed:@"power_on.png"];
    }
    if ([model.alarm isEqualToString:@"off"] || [model.hver isEqualToString:@"0"])
    {
        [cell.iconImageV setImage:[self grayImage:cell.iconImageV.image]];
        cell.switchImageV.image = [UIImage imageNamed:@"power_off.png"];
        cell.markImgView.image = [self grayImage:markImg];
    }
    cell.switchBut.tag = indexPath.row + 100;
    [cell.switchBut addTarget:self action:@selector(switchClickMethod:) forControlEvents:UIControlEventTouchUpInside];
    cell.tag = indexPath.row + 333;
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]
                                               initWithTarget:self action:@selector(longPressGestureRecognized:)];
    longPress.minimumPressDuration = 0.5;
    [cell addGestureRecognizer:longPress];
    
    cell.switchImageV.userInteractionEnabled = NO;
    if ([model.hver intValue] == 0)
    {
        cell.grayView.hidden = YES;
        cell.switchBut.hidden = YES;
        cell.switchImageV.hidden = YES;
        cell.deviceTimer.hidden = NO;
        [cell.iconImageV setImage:[self grayImage:cell.iconImageV.image]];
        
    }else {
        cell.grayView.hidden = NO;
        cell.deviceTimer.hidden = YES;
        cell.switchBut.hidden = NO;
        cell.switchImageV.hidden = NO;
    }
    
    if (self.hide == 1) {
        cell.delView.hidden = YES;
    }
    if (self.hide == 2) {
        cell.delView.hidden = NO;
    }
    UITapGestureRecognizer *delTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(deleteSelectedCell:)];
    delTap.tag = [NSString stringWithFormat:@"%d", 10000 + (int)indexPath.row];
    cell.delView.userInteractionEnabled = YES;
    [cell.delView addGestureRecognizer:delTap];
    
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CellHeight;    //cell.xib里的高度
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [Util getAppDelegate].rootVC.pan.enabled = NO;
    [Util getAppDelegate].rootVC.tap.enabled = NO;
    if (self.isClicked == YES) {
        SingleVC*sing = [[SingleVC alloc] init];
        Device *devices =[self.socketViewArray objectAtIndex:indexPath.row];
        
        Device *model = [[DeviceManagerInstance getlocalDeviceDictary] objectForKey:devices.macString];
        
        if ([DeviceManagerInstance networkStatus] == ReachableViaWiFi) {
            for (int i = 0; i < 2; i ++) {
                switch ([model.deviceType intValue]) {
                    case 11:
                        [LocalServiceInstance addDeviceToFMDBWithisAdd:YES WithMac:model.mac];
                        break;
                    case 21:
                        [LocalServiceInstance addEnergyDeviceToFMDBWithisAdd:YES WithMac:model.mac];
                        break;
                    case 31:
                        [LocalServiceInstance addRFDeviceToFMDBWithisAdd:YES WithMac:model.mac];
                        break;
                        
                    default:
                        break;
                }
            }
        }
        
        WIFIDeviceCell *cell = (WIFIDeviceCell *)[self.view viewWithTag:333 + indexPath.row];
        if ([cell.switchImageV.image isEqual:[UIImage imageNamed:@"power_on.png"]]) {
            sing.stateString = @"on";
        } else {
            sing.stateString = @"off";
        }
        sing.devices = model;
        sing.macString = model.macString;
        [self.timer invalidate];
        self.timer = nil;
        [self.navigationController pushViewController:sing animated:YES];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return _cellEditingStyle;
    
}

#pragma mark - EditableTableViewDelegate
// 拖动 排序
- (void)editableTableController:(EditableTableController *)controller movedCellWithInitialIndexPath:(NSIndexPath *)initialIndexPath fromAboveIndexPath:(NSIndexPath *)fromIndexPath toAboveIndexPath:(NSIndexPath *)toIndexPath
{
    [self.tableView moveRowAtIndexPath:toIndexPath toIndexPath:fromIndexPath];
    
    Device *item = [self.socketViewArray objectAtIndex:toIndexPath.row];
    
    [self.socketViewArray removeObjectAtIndex:toIndexPath.row];
    
    if (fromIndexPath.row == [self.socketViewArray count])
    {
        [self.socketViewArray addObject:item];
    }
    else
    {
        [self.socketViewArray insertObject:item atIndex:fromIndexPath.row];
    }
    // 重置所有数据库中 device数据的orderNumber
    for (int i = 0; i < self.socketViewArray.count; i++) {
        Device *devices = [self.socketViewArray objectAtIndex:i];
        if (devices == nil) {
            return;
        }
        
        devices.orderNumber = 1 + i;
        [DataBase updateOrderNumberDataBase:devices];
        Device *device = [[DeviceManagerInstance getlocalDeviceDictary] objectForKey:devices.macString];
        device.orderNumber = 1+i;
        if (device != nil) {
            [[DeviceManagerInstance getlocalDeviceDictary] setObject:device forKey:devices.macString];
        }
        [self editWifiDeviceSendToServer:device WithNewImageName:device.image];
        
    }
    
    [self.socketViewArray removeAllObjects];
    self.socketViewArray = [DataBase ascWithRFtableINOrderNumber];
    [self.tableView reloadData];
}

#pragma mark-点击方法
- (void)deleteSelectedCell:(UITapGestureRecognizer *)tap
{
    Device *dev =  [self.socketViewArray objectAtIndex:[tap.tag intValue] - 10000];
    [dev.heartTimer invalidate];
    [dev.heartbeatTimer invalidate];
    
    
    NSMutableArray *RFArr = [RFDataBase selectAllDataFromDataBase:dev.macString];
    for (int i = 0; i < RFArr.count; i++) {
        RFDataModel *rfModel = RFArr[i];
        [RFDataBase deleteDataFromDataBase:rfModel];
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (int i = 0; i < RFArr.count; i++) {
            RFDataModel *rfModel = RFArr[i];
            [self deleteRFDeviceToServerWith:rfModel];
        }
    });
    
    [[DeviceManagerInstance getlocalDeviceDictary] removeObjectForKey:dev.macString];
    [Util deleteCancleImageFileWithPath:dev.image];
    [DataBase deleteDataFromDataBase:dev];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [self deleteWifiDeviceSynchronizationToServerWith:[defaults objectForKey:KEY_USERMODEL] WithPass:[defaults objectForKey:KEY_PASSWORD] MacAddress:dev.macString];
    
    self.socketViewArray = [DataBase ascWithRFtableINOrderNumber];
    
    
    if (self.socketViewArray.count == 0) {
        self.backNumber = 1;
        self.hide = 1;
        self.isClicked = YES;
        [self.tableView setHeaderHidden:NO];
        [self.backButton setBackgroundImage:[UIImage imageNamed:@"list_menu_normal.png"] forState:UIControlStateNormal];
        [self.backButton setBackgroundImage:[UIImage imageNamed:@"list_menu_click.png"] forState:UIControlStateHighlighted];
        self.rightBut.hidden = NO;
        [self.editableTableController setEnabled:NO];
    }
    [self.tableView reloadData];
}

- (void)deleteRFDeviceToServerWith:(RFDataModel *)model
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *tempString = [Util getPassWordWithmd5:[defaults objectForKey:KEY_PASSWORD]];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:AccessKey forKey:@"accessKey"];
    [dict setValue:[defaults objectForKey:KEY_USERMODEL] forKey:@"username"];
    [dict setValue:tempString forKey:@"password"];
    [dict setValue:model.rfDataMac forKey:@"macAddress"];
    [dict setValue:model.address forKey:@"addressCode"];
    
    NSString *timeSp = [NSString stringWithFormat:@"%f", (double)[[NSDate date] timeIntervalSince1970]*1000];
    
    NSArray *temp =   [timeSp componentsSeparatedByString:@"."];
    [dict setValue:[temp objectAtIndex:0] forKey:@"lastOperation"];
    [HTTPService POSTHttpToServerWith:DeleteRFURL WithParameters:dict   success:^(NSDictionary *dic) {
        
        NSString * success = [dic objectForKey:@"success"];
        
        if ([success boolValue] == true) {
            NSLog(@"====RF 设备删除成功 ====");
            
        }
        if ([success boolValue] == false) {
            
            
        }
        
        
    } error:^(NSError *error) {
        
    }];
}

#pragma mark - navBtn method
- (void)leftButtonMethod:(UIButton *)but
{
    if (self.backNumber == 1) {
        RootViewController *root = [Util getAppDelegate].rootVC;
        NSLog(@"=== %f ==",root.curView.frame.origin.x );
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(ohBuyMoveMethod:)]) {
            if (root.curView.frame.origin.x == 0) {
                
                [self.delegate ohBuyMoveMethod:ohBuyRightMove];
            } else {
                
                [self.delegate ohBuyMoveMethod:ohBuyResetMove];
            }
        }
    } else if (self.backNumber == 2) {
        
        self.backNumber = 1;
        self.hide = 1;
        self.isClicked = YES;
        [self.tableView setHeaderHidden:NO];
        [self.backButton setBackgroundImage:[UIImage imageNamed:@"list_menu_normal.png"] forState:UIControlStateNormal];
        [self.backButton setBackgroundImage:[UIImage imageNamed:@"list_menu_click.png"] forState:UIControlStateHighlighted];
        self.rightBut.hidden = NO;
        [self.editableTableController setEnabled:NO];
        
        [self.tableView reloadData];
    }
}



- (void)reloadButtonMethod:(UIButton *)sender
{
    [Util getAppDelegate].rootVC.pan.enabled = NO;
    AddDeviceVC *login = [[AddDeviceVC alloc] init];
    [self.navigationController pushViewController:login animated:YES];
    [self.timer invalidate];
}

static  BOOL isSelected = NO;
- (void)switchClickMethod:(UIButton *)but
{
    Device *devicess = [self.socketViewArray objectAtIndex:but.tag - 100];
    Device *device = [[DeviceManagerInstance getlocalDeviceDictary] objectForKey:devicess.macString];
    BOOL lock = YES;
    isSelected = !but.isSelected;
    [but setSelected:isSelected];
    
    NSData *macData = [[Util getUtitObject]macStrTData:device.macString];
    WIFIDeviceCell *cell = nil;
    
    cell = (WIFIDeviceCell *)[but superview];
    if (iOS_version >=7.0&&iOS_version<=7.1)
    {
        cell = (WIFIDeviceCell *)[[but superview] superview];
    }
    
    if ([device.alarm isEqualToString:@"on"])
    {
        lock = NO;
    }
    if ([device.alarm isEqualToString:@"off"])
    {
        lock = YES;
    }
    [self.animationTimer invalidate];
//    self.animationTimer = nil;
    [self startAnimationWithButton:but];
    
    if ([DeviceManagerInstance networkStatus] == ReachableViaWiFi && [device.localContent isEqualToString:@"1"])
    {
        
        [LocalServiceInstance  setGPIOCloseOrOpenWithDeciceMac:macData index:lock host:device.host key:nil deviceType:device.deviceType];
        
        [self performSelector:@selector(getDeviceInfo:) withObject:device afterDelay:0.5];
    }
    else {
        
        
        [RemoteServiceInstance setGPIOCloseOrOpenWithDeciceMac:macData index:lock deviceType:device.deviceType];
        
    }
    
    
    [self  performSelector:@selector(stopAnimationWithButton:) withObject:but afterDelay:8.f];
}


- (void)getDeviceInfo:(Device *)device
{
    NSData *mac = [Crypt decodeHex:device.macString];
    [LocalServiceInstance queryGPIOEventToMac:mac withhost:device.host deviceType:device.deviceType];
}

- (void)startAnimationWithButton:(UIButton *)button
{
    if (!button)
        return;
    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    
        WIFIDeviceCell *cell = (WIFIDeviceCell *)[button superview] ;
        if (iOS7 == YES && iOS_version <= 7.1)
        {
            cell = (WIFIDeviceCell *)[[button superview] superview];
        }
        cell.switchImageV.alpha = .0f;
        
        UIImage *image = [UIImage imageNamed:@"power_waiting.png"];
        
        CGRect viewFrame = button.frame;
        viewFrame.origin = CGPointMake(0.0f, 0.0f);
        animationButton = [[UIButton alloc] initWithFrame:viewFrame];
        [animationButton setBackgroundColor:[UIColor clearColor]];
        [animationButton setBackgroundImage:image forState:UIControlStateNormal];
        [animationButton setUserInteractionEnabled:NO];
        [button addSubview:animationButton];
        
        animationButton.transform = CGAffineTransformIdentity;
        [self.animationTimer invalidate];
        self.animationTimer = [NSTimer timerWithTimeInterval:.2 target:self selector:@selector(animate) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.animationTimer forMode:NSRunLoopCommonModes];
//    });
}

- (void)animate
{
    animationButton.transform = CGAffineTransformRotate(animationButton.transform, DEGREES_TO_RADIANS(50));
}

- (void)stopAnimationWithButton:(UIButton *)button
{
    [self.animationTimer invalidate];
    self.animationTimer = nil;
    WIFIDeviceCell *cell = nil;
    if (iOS_version >= 7.0 && iOS_version <= 7.1) {
        
        cell = (WIFIDeviceCell *)[[button superview] superview];
    }else{
        
        cell = (WIFIDeviceCell *)[button superview];
    }
    cell.switchImageV.alpha = 1.f;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        for (UIView *v in [button subviews])
        {
            if ([v isKindOfClass:[UIButton class]])
            {
                [v removeFromSuperview];
            }
        }
    });
    
//    [self.tableView reloadData];
}


- (void)addOperation:(SocketOperation *)operation
{
    if (operation)
    {
        [_operations addObject:operation];
    }
}

#pragma mark-图片去色
//图片去色
- (UIImage *)grayImage:(UIImage *)sourceImage
{
    int bitmapInfo = kCGImageAlphaNone;
    int width = sourceImage.size.width;
    int height = sourceImage.size.height;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    CGContextRef context = CGBitmapContextCreate (nil,
                                                  width,
                                                  height,
                                                  8,      // bits per component
                                                  0,
                                                  colorSpace,
                                                  bitmapInfo);
    CGColorSpaceRelease(colorSpace);
    if (context == NULL) {
        return nil;
    }
    CGContextDrawImage(context,
                       CGRectMake(0, 0, width, height), sourceImage.CGImage);
    UIImage *grayImage = [UIImage imageWithCGImage:CGBitmapContextCreateImage(context)];
    CGContextRelease(context);
    return grayImage;
}

//编辑wifi信息
- (void)editWifiDeviceSendToServer:(Device *)devices_ WithNewImageName:(NSString *)imageName
{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *tempString = [Util getPassWordWithmd5:[defaults objectForKey:KEY_PASSWORD]];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:AccessKey forKey:@"accessKey"];
    [dict setValue:[defaults objectForKey:KEY_USERMODEL] forKey:@"username"];
    [dict setValue:tempString forKey:@"password"];
    [dict setValue:[devices_.macString uppercaseStringWithLocale:[NSLocale currentLocale]]   forKey:@"macAddress"];
    [dict setValue:devices_.name forKey:@"deviceName"];
    [dict setValue:devices_.codeString  forKey:@"companyCode"];
    [dict setValue:devices_.deviceType forKey:@"deviceType"];
    [dict setValue:devices_.authCodeString forKey:@"authCode"];
    [dict setValue:devices_.image forKey:@"imageName"];
    [dict setValue:[NSString stringWithFormat:@"%ld", (long)devices_.orderNumber] forKey:@"orderNumber"];
    
    NSString *timeSp = [NSString stringWithFormat:@"%f", (double)[[NSDate date] timeIntervalSince1970]*1000];
    
    NSArray *temp =   [timeSp componentsSeparatedByString:@"."];
    [dict setValue:[temp objectAtIndex:0] forKey:@"lastOperation"];
    
    [HTTPService POSTHttpToServerWith:EditWifiURL WithParameters:dict   success:^(NSDictionary *dic) {
        
        NSLog(@"dicfssr=====%@",dic);
        //        [[Util getUtitObject] HUDHide];
        
        NSString * success = [dic objectForKey:@"success"];
        
        if ([success boolValue] == true) {
            NSLog(@"成功");
            
        }
        if ([success boolValue] == false) {
            
//            [Util showAlertWithTitle:NSLocalizedString(@"Tips", nil) msg:[dic objectForKey:@"msg"]];
            
        }
        
        
    } error:^(NSError *error) {
        
//        [Util showAlertWithTitle:NSLocalizedString(@"Tips", nil) msg:NSLocalizedString(@"Link Timeout", nil)];
        
    }];
}

#pragma mark-长按手势移动
- (void)longPressGestureRecognized:(UILongPressGestureRecognizer *)longPress
{
    if (longPress.state == 1) {
        self.backNumber = 2;
        self.hide = 2;
        self.isClicked = NO;
        [self.backButton setBackgroundImage:[UIImage imageNamed:@"return_normal.png"] forState:UIControlStateNormal];
        [self.backButton setBackgroundImage:[UIImage imageNamed:@"return_normal_click.png"] forState:UIControlStateHighlighted];
        self.rightBut.hidden = YES;
        [self.editableTableController setEnabled:YES];
        [self.tableView setHeaderHidden:YES];
        [self.tableView reloadData];
    }
}

//网络链接改变时会调用的方法
-(void)reachabilityChanged:(NSNotification *)note
{
    NSLog(@"networkStatus ===> %d == %d == %d", [DeviceManagerInstance networkStatus], connected, [RemoteServiceInstance isConnected]);
    
    
    if (![Util getAppDelegate].hasRun) {
        return;
    }
    
    if([DeviceManagerInstance networkStatus] == NotReachable)
    {
        if (countNumber == 0) {
            
            [Util showAlertWithTitle:NSLocalizedString(@"Tips", nil) msg:NSLocalizedString(@"Current network is unavailable", nil)];
        }
        connected = 1;
        countNumber ++;
        _disconnect = 1;
        [LocalServiceInstance disconnect];
        [RemoteServiceInstance disconnect];
        
        for (int i = 0; i < self.socketViewArray.count; i++) {
            Device *model = [self.socketViewArray objectAtIndex:i];
            Device *device = [[DeviceManagerInstance getlocalDeviceDictary] objectForKey:model.macString];
            device.hver = @"0";
            if (device != nil) {
                [[DeviceManagerInstance getlocalDeviceDictary] setObject:device forKey:model.macString];
            }
        }
        [self.tableView reloadData];
    }
    else
    {
        if (connected == 1) {
            connected = 2;
            [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleFade];
            [MMProgressHUD showWithTitle:nil status:NSLocalizedString(@"Reconnecting", nil)];
        }
        
        [LocalServiceInstance disconnect];
        [RemoteServiceInstance disconnect];
        
        if ([reloadTimer isValid]) {
            [reloadTimer invalidate];
            reloadTimer = nil;
        }
        reloadTimer = [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(reloadDeviceStatus:) userInfo:nil repeats:YES];
        [reloadTimer fire];
    }
}

- (void)reloadDeviceStatus:(NSTimer *)timer
{
    static int count = 0;
    count += 1;
    if (!_disconnect) {
        [MMProgressHUD showWithTitle:NSLocalizedString(@"Tips", nil) status:NSLocalizedString(@"Reconnecting", nil)];
        [Util getAppDelegate].connect = @"2";
    }
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:ON_LINE__OFFLINE];
    
    if ([DeviceManagerInstance networkStatus] == ReachableViaWWAN) {
        
        if (![RemoteServiceInstance isConnected]) {
            
            [[NSUserDefaults standardUserDefaults] setObject:nil forKey:SERVER_KEY];
            
            [RemoteServiceInstance connect];
        }
        
        NSArray *array =[[DeviceManagerInstance getlocalDeviceDictary] allKeys];
        for (int i =0 ;i < array.count ; i ++) {
            
            NSString * keymac =  [array objectAtIndex:i];
            Device *dev = [[DeviceManagerInstance getlocalDeviceDictary] objectForKey:keymac];
            dev.localContent = @"0";
            [[DeviceManagerInstance getlocalDeviceDictary] setObject:dev forKey:keymac];
        }
        
    }
    if ([DeviceManagerInstance networkStatus] == ReachableViaWiFi) {
        
        
        if (![LocalServiceInstance isConnected]) {
            
            [LocalServiceInstance connect];
        }
        if (![RemoteServiceInstance isConnected]) {
            
            [[NSUserDefaults standardUserDefaults] setObject:nil forKey:SERVER_KEY];
            
            [RemoteServiceInstance connect];
        }
        
        NSArray *array =[DataBase ascWithRFtableINOrderNumber];
        
        if (array.count == 0) {
            [MMProgressHUD dismiss];
            return;
        }
        
        for (int i = 0 ;i < array.count ; i ++) {
            
            Device *device = array[i];
            
            Device *dev = [[DeviceManagerInstance getlocalDeviceDictary] objectForKey:device.macString];
            dev.localContent = @"0";
            [[DeviceManagerInstance getlocalDeviceDictary] setObject:dev forKey:device.macString];
            
//            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                for (int i = 0; i < 2; i ++) {
                    
                    switch ([dev.deviceType intValue]) {
                        case 11:
                            [LocalServiceInstance addDeviceToFMDBWithisAdd:YES WithMac:dev.mac];
                            break;
                        case 21:
                            [LocalServiceInstance addEnergyDeviceToFMDBWithisAdd:YES WithMac:dev.mac];
                            break;
                        case 31:
                            [LocalServiceInstance addRFDeviceToFMDBWithisAdd:YES WithMac:dev.mac];
                            break;
                            
                        default:
                            break;
                    }
                }
//            });
        }
    }
    
    self.socketViewArray = [DataBase ascWithRFtableINOrderNumber];
    
    for (int i = 0; i < self.socketViewArray.count; i ++) {
        
        Device *devices =  [self.socketViewArray objectAtIndex:i];
        Device *decix = [[DeviceManagerInstance getlocalDeviceDictary] objectForKey:devices.macString];
        
//        dispatch_async(dispatch_queue_create("reloadQueue", 0), ^{
            for (int i = 0; i < 2; i++) {
                [RemoteServiceInstance queryEquipmentOnlineWithMac:decix.mac deviceType:decix.deviceType];
                [RemoteServiceInstance queryEquipmentOnlineWithMac:decix.mac deviceType:nil];
            }
//        });
        
        if ([decix.hver isEqualToString:@"1"]) {
            [timer invalidate];
            timer = nil;
            count = 0;
            countNumber = 0;
            
            if ( _disconnect) {
                [self dismissHUDin];
                _disconnect = 0;
            }
            [self.tableView reloadData];
            
            return;
        }
    }
    
    if (count > 13 && _disconnect == 1) {
        count = 0;
        [timer invalidate];
        timer = nil;
        countNumber = 0;
        
        if ( _disconnect) {
            [self dismissHUDin];
            _disconnect = 0;
            [Util showAlertWithTitle:NSLocalizedString(@"Tips", nil) msg:NSLocalizedString(@"Connect again failed, please check the network or device status", nil)];
        }
    }
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
