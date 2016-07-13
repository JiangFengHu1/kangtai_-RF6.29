//
//
/**
 * Copyright (c) www.bugull.com
 */
//
//

#import "EC_UIManager.h"

static const CGFloat kPublicLeftMenuWidth = 230.0f;
static EC_UIManager *ec_uiManager = nil;

@implementation EC_UIManager
{
    UINavigationController *loginVC; // 登录页.
    UINavigationController *mainPageVC; // 主页
    UINavigationController *leftPageVC;
    UINavigationController *registerPageVC;// 注册页.
}



// 得到公共的.
+(EC_UIManager *)sharedManager
{
    
    if (ec_uiManager == nil) {
        ec_uiManager = [[EC_UIManager alloc] init];
    }
    return ec_uiManager;
}


// 显示主页.
-(void)showMainV{
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:YES];
    
    if (self.leftVC==nil) {
        self.leftVC = [[LiftMenuVC alloc]
                       init];
        
        
    }
    
    
//    if (self.rightVC == nil) {
//        self.rightVC = [[HomeWebVC alloc] init];
//        //[self.rightVC initVC];
//    }
    
    if (self.drawerController == nil) {
        
//        [[Util getAppDelegate].window.rootViewController removeFromParentViewController];
        WIFIDeviiceVC *message = [[WIFIDeviiceVC alloc] init];
        mainPageVC = [[UINavigationController alloc] initWithRootViewController:message];
        
        leftPageVC = [[UINavigationController alloc] initWithRootViewController:self.leftVC];

        self.drawerController = [[MMDrawerController alloc]
                                 initWithCenterViewController:mainPageVC
                                 leftDrawerViewController:leftPageVC
                                 rightDrawerViewController:nil];
        [self.drawerController setMaximumLeftDrawerWidth:kPublicLeftMenuWidth];
        [self.drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModePanningNavigationBar];
        [self.drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
        
        [self.drawerController setDrawerVisualStateBlock:^(MMDrawerController *__drawerController, MMDrawerSide drawerSide, CGFloat percentVisible) {
            MMDrawerControllerDrawerVisualStateBlock block;
            block = [MMDrawerVisualState parallaxVisualStateBlockWithParallaxFactor:2.0];
            block(__drawerController, drawerSide, percentVisible);
        }];
    }
    
    [Util getAppDelegate].window.rootViewController =  self.drawerController;
}


// 显示登陆页面.
-(void)showLoginV
{
    LoginINVC *logInV = [[LoginINVC alloc] init];
    loginVC = [[UINavigationController alloc] initWithRootViewController:logInV];
    
    [Util getAppDelegate].window.rootViewController =  loginVC;
}
// 显示注册界面
-(void)showRegisterVC
{
    
}

// 显示测试 仿威信的 朋友圈的 cell.
-(void)showWeChatTestVC
{
    
}
// 显示查找副井
-(void)showTestChaZhaoFuJin
{
    
}
// 测试显示 face view.
-(void)showFaceTestVC
{
    
}
// 只正对 JZ_MainLeftVC
-(void)settingBottomBarHeight:(float)height
{
    
}
// 操作 GUI.
-(void)operationGUI:(BOOL)isShow
{
 
    if (isShow) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent animated:YES];
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
//        [WZGuideViewController show];
    }else{
//        [WZGuideViewController hide];
    }

}


// 关闭菜单
-(void)closeSwitchMenu:(BOOL)animation
{
   
    UIViewController *tempVC = [Util getAppDelegate].window.rootViewController;
    if ([tempVC isKindOfClass:[MMDrawerController class]]) {
        [(MMDrawerController *)tempVC closeDrawerAnimated:animation completion:^(BOOL finished) {
            
        }];
    }

    
    
}
// 打开菜单.
-(void)openSwitchMenu:(BOOL)animatin
{
    
    UIViewController *tempVC = [Util  getAppDelegate].window.rootViewController;
    if ([tempVC isKindOfClass:[MMDrawerController class]]) {
        [(MMDrawerController *)tempVC openDrawerSide:MMDrawerSideLeft animated:animatin completion:^(BOOL finished) {
            
        }];
    }

    
}
// 当前菜单状态. yes ,close , no ,show
-(BOOL)currentSwitchMenuState{
    UIViewController *tempVC = [Util getAppDelegate].window.rootViewController;
    if ([tempVC isKindOfClass:[MMDrawerController class]]) {
        MMDrawerSide state = ((MMDrawerController *)mainPageVC).openSide;
        if (state == MMDrawerSideLeft) {
            return NO;
        }
        return YES;
    }
    return YES;
}


//-(BOOL)currentSwitchMenuState
//{
//    return YES;
//}

// 关于启动后要做的事情
-(void)applunchOperatioin
{
    
}








@end
