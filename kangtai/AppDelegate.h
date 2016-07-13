//
//
/**
 * Copyright (c) www.bugull.com
 */
//
//

#import <UIKit/UIKit.h>
#import "LoginINVC.h"
#import "RootViewController.h"
#import "WIFIDeviiceVC.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) RootViewController *rootVC;
@property (strong, nonatomic) NSTimer *timer;
@property (nonatomic, copy) NSString *connect;
@property (nonatomic, assign) BOOL connected;
@property (nonatomic, assign) BOOL hasRun;

@end
