//
//
/**
 * Copyright (c) www.bugull.com
 */
//
//

#import "LiftMenuVC.h"

#import "AddDeviceVC.h"
#import "AboutVC.h"
#import "ChangePWSVC.h"

@interface LiftMenuVC ()

@end

@implementation LiftMenuVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.flag = 1;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"flag"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",self.flag] forKey:@"flag"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [super viewWillAppear:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.imageVW.hidden = YES;
    self.barView.hidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSMutableArray *tempArray = [NSMutableArray arrayWithObjects:@"devices_mark",  @"left_RF_mark", @"about.png",nil];
    self.dataMy = tempArray;
    self.titleMy = [NSMutableArray arrayWithObjects:NSLocalizedString(@"WIFI-Devices", @"WIFI-Devices test_"), NSLocalizedString(@"RF Devices", nil),  NSLocalizedString(@"About", @"About test_"), nil];
    
    self.tableView.separatorStyle =UITableViewCellSeparatorStyleNone;
    self.tableView.frame = CGRectMake(0, barViewHeight, kScreen_Width, kScreen_Height - 270);
    self.tableView.scrollEnabled = NO;
    
    float height = (iOS_version < 7.0) ? 20 : 0;
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreen_Height - 270 + barViewHeight + height, kScreen_Width, 270 - barViewHeight - height)];
    bottomView.backgroundColor = RGBA(238.0, 238.0, 238.0, 1);
    [self.view addSubview:bottomView];
    
    UIImageView *headerImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 15, 40, 40)];
    headerImgView.center = CGPointMake(230 * widthScale / 2, 35);
    headerImgView.layer.masksToBounds = YES;
    headerImgView.layer.cornerRadius = 20;
    headerImgView.image = [UIImage imageNamed:@"person.png"];
    [bottomView addSubview:headerImgView];
    
    UILabel *userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, kScreen_Height - 208 + 65, 230 * widthScale, 20)];
    userNameLabel.font = [UIFont systemFontOfSize:14];
    userNameLabel.backgroundColor = [UIColor clearColor];
    userNameLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_USERMODEL];
    userNameLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:userNameLabel];
    
    UIButton *changePWDBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    changePWDBtn.frame = CGRectMake(24, kScreen_Height - 170 + 65, 230 * widthScale - 48, 35);
    [changePWDBtn setBackgroundImage:[UIImage imageNamed:@"updata_button_normal.png"] forState:UIControlStateNormal];
    [changePWDBtn setBackgroundImage:[UIImage imageNamed:@"updata_button_click.png"] forState:UIControlStateHighlighted];
    [changePWDBtn setTitle:NSLocalizedString(@"Change Password", nil) forState:UIControlStateNormal];
    changePWDBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    changePWDBtn.titleLabel.textColor = [UIColor whiteColor];
    changePWDBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [changePWDBtn addTarget:self action:@selector(changePWD) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:changePWDBtn];
    
    UIButton *logoutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    logoutBtn.frame = CGRectMake(24, kScreen_Height - 120 + 65, 230 * widthScale - 48, 35);
    [logoutBtn setBackgroundImage:[UIImage imageNamed:@"logout_button_normal.png"] forState:UIControlStateNormal];
    [logoutBtn setBackgroundImage:[UIImage imageNamed:@"logout_button_click.png"] forState:UIControlStateHighlighted];
    [logoutBtn setTitle:NSLocalizedString(@"Log Out", nil) forState:UIControlStateNormal];
    logoutBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    logoutBtn.titleLabel.textColor = [UIColor whiteColor];
    logoutBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [logoutBtn addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:logoutBtn];
}

- (void)changePWD
{
    [Util getAppDelegate].rootVC.selectedIndex = 3;
    [Util getAppDelegate].rootVC.tap.enabled = NO;
    [Util getAppDelegate].rootVC.pan.enabled = NO;
    [UIView animateWithDuration:0.5 animations:^{
        [[Util getAppDelegate].rootVC.curView setFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height)];
    } completion:nil];
}

- (void)logout
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"Are you sure to log out?", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) otherButtonTitles:NSLocalizedString(@"Confirm", nil), nil];
    [alertView show];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"stopTheUpdateTimer" object:nil];
        
        [[DeviceManagerInstance getlocalDeviceDictary] removeAllObjects];
        
        NSMutableArray *socketViewArray = [DataBase ascWithRFtableINOrderNumber];
        for (int i = 0; i <socketViewArray.count; i ++) {
            Device *dec = [socketViewArray objectAtIndex:i];
            [DataBase deleteDataFromDataBase:dec];
        }
        
        NSMutableArray *listArray = [RFDataBase ascWithRFTableINorderNumber];
        if (listArray.count != 0) {
            for (RFDataModel *model in listArray)
            {
                [RFDataBase deleteDataFromDataBase:model];
            }
        }
        
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:KEY_USERMODEL];
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:KEY_PASSWORD];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        
        [Util getAppDelegate].hasRun = NO;
        
        [[EC_UIManager sharedManager ] showLoginV];
    }
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataMy count] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *SimpleTableIdentifier = @"SimpleTableIdentifier";
    
    LeftVCCell *cell = [tableView dequeueReusableCellWithIdentifier:
                        SimpleTableIdentifier];
    if (cell == nil) {
        cell = [[LeftVCCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                 reuseIdentifier: SimpleTableIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    if (indexPath.row == 0 || indexPath.row == 1) {
        cell.devName.text = [self.titleMy objectAtIndex:0];
        cell.iconImageV.image = [UIImage imageNamed:[self.dataMy objectAtIndex:0]];
        cell.grayView.hidden = NO;
        cell.choosenView.hidden = NO;
        if (indexPath.row == 0) {
            cell.hidden = YES;
        }
    } else {
        cell.devName.text = [self.titleMy objectAtIndex:indexPath.row - 1];
        cell.iconImageV.image = [UIImage imageNamed:[self.dataMy objectAtIndex:indexPath.row - 1]];
    }
    cell.tag = indexPath.row + 1000;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 5;
    }
    return 60;    //cell.xib里的高度
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [self.view setFrame:CGRectMake(-20 * widthScale, 0, kScreen_Width, kScreen_Height)];
    [UIView commitAnimations];
    
    for (int i = 1; i < 4; i++) {
        
        LeftVCCell *cell = (LeftVCCell *)[self.view viewWithTag:1000 + i];
        if (i == (int)indexPath.row) {
            
            self.flag = i;
            [Util getAppDelegate].rootVC.selectedIndex = i - 1;
            [Util getAppDelegate].rootVC.tap.enabled = NO;
            [UIView animateWithDuration:0.5 animations:^{
                [[Util getAppDelegate].rootVC.curView setFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height)];
            } completion:nil];
            cell.choosenView.hidden = NO;
            cell.grayView.hidden = NO;
        } else {
            cell.choosenView.hidden = YES;
            cell.grayView.hidden = YES;
        }
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"flag"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",self.flag] forKey:@"flag"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
