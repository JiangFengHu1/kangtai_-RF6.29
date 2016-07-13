//
//
/**
 * Copyright (c) www.bugull.com
 */
//
//

#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    //    初始化数据库
    [DataBase shareInstance];
    [RFDataBase shareInstance];

    _connect = @"1";
    _hasRun = NO;
    _connected = NO;

    self.window.backgroundColor = [UIColor whiteColor];
    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleFade];

    if ([DeviceManagerInstance networkStatus] == ReachableViaWiFi) {
        
        [LocalServiceInstance connect];
    }
    [RemoteServiceInstance connect];
    
    NSString *broadcastAddress = [Util getBroadcastAddress];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:broadcastAddress forKey:@"broadcastAddress"];

    LoginINVC *logInV = [[LoginINVC alloc] init];
    UINavigationController *loginVC = [[UINavigationController alloc] initWithRootViewController:logInV];
    self.window.rootViewController = loginVC;
    
    [userDefaults setObject:@"timer" forKey:HEnuS_Timer] ;
    [userDefaults setObject:nil forKey:SERVER_KEY] ;
    [userDefaults synchronize];
    
    [NSTimer scheduledTimerWithTimeInterval:10.f target:self selector:@selector(connectMethod) userInfo:nil repeats:YES];

    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
    
    [self.window makeKeyAndVisible];
    return YES;
}

#pragma mark -connectMethod
- (void)connectMethod
{
    if (![RemoteServiceInstance isConnected] && [DeviceManagerInstance networkStatus] != NotReachable) {
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:SERVER_KEY];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [RemoteServiceInstance connect];
    }
    if (![LocalServiceInstance isConnected] && [DeviceManagerInstance networkStatus] == ReachableViaWiFi) {
        
        [LocalServiceInstance connect];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    
    [[NSUserDefaults standardUserDefaults ]setObject:@"secondTimer" forKey:HEnuS_Timer] ;
    [[NSUserDefaults standardUserDefaults ]synchronize];
    
//    [LocalServiceInstance disconnect];
//    [RemoteServiceInstance disconnect];
//    
//    NSArray *array =[[DeviceManagerInstance getlocalDeviceDictary] allKeys];
//    if (array.count == 0) {
//        return;
//    }
//    for (int i =0 ;i < array.count ; i ++) {
//        
//        NSString *string = [array objectAtIndex:i];
//        
//        Device *dev = [[DeviceManagerInstance getlocalDeviceDictary] objectForKey:string];
//        
//        [dev.heartTimer invalidate];
//        [dev.heartbeatTimer invalidate];
//        
//        [[DeviceManagerInstance getlocalDeviceDictary] setObject:dev forKey:string];
//    }
}


- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    NSArray *array =[DataBase selectAllDataFromDataBase];
    if (array.count == 0) {
        return;
    }
    for (int i =0 ;i < array.count ; i ++) {
        
        Device *device = array[i];
        
        Device *dev = [[DeviceManagerInstance getlocalDeviceDictary] objectForKey:device.macString];
        
        dev.deviceRespons = NO;
        
        //        dev.interval = 0;
        
        //        [DataBase updateDeviceResponseDataBaseMAC:dev];
        if (dev != nil) {
            [[DeviceManagerInstance getlocalDeviceDictary] setObject:dev forKey:device.macString];
        }
    }
    
    //    [[NSUserDefaults standardUserDefaults ]setObject:@"timer" forKey:HEnuS_Timer] ;
    //    [[NSUserDefaults standardUserDefaults ]synchronize];
    
    NSString *timei  = [[NSUserDefaults standardUserDefaults ]objectForKey:HEnuS_Timer] ;
    
    if ([timei isEqualToString:@"secondTimer"])
    {
        if ([DeviceManagerInstance networkStatus] == NotReachable) {
            
//            [Util showAlertWithTitle:NSLocalizedString(@"Tips", nil) msg:NSLocalizedString(@"Network is unavailable", nil)];
            
        } else {
            
            [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleFade];
            [MMProgressHUD showWithTitle:NSLocalizedString(@"Loading",nil) status:@""];

            [[NSUserDefaults standardUserDefaults] setObject:nil forKey:SERVER_KEY];
            NSArray *array =[[DeviceManagerInstance getlocalDeviceDictary] allKeys];
            if (array.count == 0) {
                [self performSelector:@selector(dismissHUD) withObject:nil afterDelay:2.f];
                return;
            }

            
            if ([DeviceManagerInstance networkStatus] == ReachableViaWiFi) {
                
                NSString *broadcastAddress = [Util getBroadcastAddress];
                
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                [userDefaults setObject:broadcastAddress forKey:@"broadcastAddress"];

                if (![LocalServiceInstance isConnected]) {
                    [LocalServiceInstance connect];
                }
                if (![RemoteServiceInstance isConnected]) {
                    [RemoteServiceInstance connect];
                }

                for (int i =0 ;i < array.count ; i ++) {
                    
                    NSString * keymac =  [array objectAtIndex:i];
                    
                    Device *dev = [[DeviceManagerInstance getlocalDeviceDictary] objectForKey:keymac];
                    
                    dev.localContent = @"0";
                    if (dev != nil) {
                        [[DeviceManagerInstance getlocalDeviceDictary] setObject:dev forKey:keymac];
                    }

                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

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
                    });
                }
                
                NSLog(@"进入程序的第二次");

            } else {
                if ([LocalServiceInstance isConnected]) {
                    [LocalServiceInstance disconnect];
                }

                if (![RemoteServiceInstance isConnected]) {
                    [RemoteServiceInstance connect];
                }
                
                for (int i =0 ;i < array.count ; i ++) {
                    
                    NSString * keymac =  [array objectAtIndex:i];
                    
                    Device *dev = [[DeviceManagerInstance getlocalDeviceDictary] objectForKey:keymac];
                    
                    dev.localContent = @"0";
                    dev.remoteContent = @"1";

                    if (dev != nil) {
                        [[DeviceManagerInstance getlocalDeviceDictary] setObject:dev forKey:keymac];
                    }
                }
            }
            
            self.timer = [NSTimer scheduledTimerWithTimeInterval:1.f target:self selector:@selector(dismissMMpressagess) userInfo:nil repeats:YES];
        }
    }
}

- (void)refreshDeviceList
{

}

- (void)dismissHUD
{
    [MMProgressHUD dismiss];
}

- (void)dismissMMpressagess
{
    static int i = 0;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSArray *array =[[DeviceManagerInstance getlocalDeviceDictary] allKeys];
        for (int i =0 ;i < array.count ; i ++) {
            
            NSString * keymac =  [array objectAtIndex:i];
            Device *dev = [[DeviceManagerInstance getlocalDeviceDictary] objectForKey:keymac];
            [RemoteServiceInstance queryEquipmentOnlineWithMac:dev.mac deviceType:dev.deviceType];
        }
    });
//    [self performSelectorOnMainThread:@selector(refreshDeviceList) withObject:nil waitUntilDone:NO];

    if (i == 2) {
        [MMProgressHUD dismiss];
        [self.timer invalidate];
        self.timer = nil;
        i = 0;
        return;
    }
    
    i++;
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


void uncaughtExceptionHandler(NSException *exception)
{
    NSLog(@"CRASH: %@", exception);
    NSLog(@"Stack Trace: %@", [exception callStackSymbols]);
    // Internal error reporting
}

//禁止屏幕旋转
-(NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    return UIInterfaceOrientationMaskPortrait;
}

@end
