//
//
/**
 * Copyright (c) www.bugull.com
 */
//
//

//
//#import "LockVC.h"
//
//@interface LockVC ()
//
//
//
//@end
//
//@implementation LockVC
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
//- (void)viewWillAppear:(BOOL)animated
//{
//
//    [super viewWillAppear:animated];
//    
//}
//- (void)viewDidLoad
//{
//    [super viewDidLoad];
//    
//    
//
//    [self loadUI];
//}
//
//- (void)loadUI
//{
//    self.titlelab.text = NSLocalizedString(@"Lock", nil);
//    self.backButton.hidden = NO;
//    self.imageView_L.hidden = NO;
//    
//    
//}
//
//#pragma mark - UITableViewDataSource
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 65;
//}
//
//-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return 1;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *SimpleTableIdentifier = @"SimpleTableIdentifier";
//    
//    LockCell*cell = [tableView dequeueReusableCellWithIdentifier:
//                            SimpleTableIdentifier];
//    if (cell == nil) {
//        cell = [[LockCell alloc] initWithStyle:UITableViewCellStyleSubtitle
//                                     reuseIdentifier: SimpleTableIdentifier];
//    }
//    
//    if ([self.device.LockType isEqualToString:@"open"])
//    {
//        buttonIsNo = YES;
//        [cell.switchBut setImage:[UIImage imageNamed:@"button_open.png"] forState:UIControlStateNormal];
//    }else{
//        
//        buttonIsNo = NO;
//
//        [cell.switchBut setImage:[UIImage imageNamed:@"button_close.png"] forState:UIControlStateNormal];
//
//    }
//    
//    cell.switchBut.tag = indexPath.row + 100;
//    [cell.switchBut addTarget:self action:@selector(switchClickMethod:) forControlEvents:UIControlEventTouchUpInside];
//    
//    return cell;
//    
//    
//    
//}
//static bool buttonIsNo = NO;
//
//static bool lock = NO;
//
//- (void)switchClickMethod:(UIButton *)but
//{
//  
//    BOOL isSelected = !but.isSelected;
//    [but setSelected:isSelected];
//    
//    
//    
//
//    if (buttonIsNo == YES)
//    {
//        lock = NO;
//        self.device.LockType = @"close";
//        buttonIsNo = NO;
//        [but setImage:[UIImage imageNamed:@"button_close.png"] forState:UIControlStateNormal];
//
//        
//        
//    }else if (buttonIsNo == NO){
//        buttonIsNo = YES;
//        lock = YES;
//
//        self.device.LockType = @"open";
//        
//        [but setImage:[UIImage imageNamed:@"button_open.png"] forState:UIControlStateNormal];
//
//    }
//    
//    [[DeviceManagerInstance getlocalDeviceDictary] setObject:self.device forKey:self.device.macString];
//    [LocalServiceInstance  sendToUdpLockWithData:self.device.mac lock:lock isHost:self.device.host key:self.device.key];
//  
////    self.view.clipsToBounds = YES;
//}
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
