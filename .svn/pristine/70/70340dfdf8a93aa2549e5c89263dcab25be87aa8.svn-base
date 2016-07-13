//
//
/**
 * Copyright (c) www.bugull.com
 */
//
//

#import <Foundation/Foundation.h>
//#import "CustomTabBarViewController.h"//tabbar
#import "MMDrawerController.h"//侧滑
#import "MMDrawerVisualState.h"

#import "AppDelegate.h"
//主视图
#import "WIFIDeviiceVC.h"
#import "LiftMenuVC.h"
#import "LoginINVC.h"

//#import "HomeWebVC.h"
//#import "AccessVC.h"
//#import "MoreVC.h"
//#import "MapVC.h"



@interface EC_UIManager : NSObject



@property (nonatomic,strong) MMDrawerController * drawerController;
@property (nonatomic,strong) LiftMenuVC *leftVC;
//@property (nonatomic,strong) HomeWebVC *rightVC;
// 得到公共的.
+(EC_UIManager *)sharedManager;
// 显示登陆页面.
-(void)showLoginV;
// 显示主页.
-(void)showMainV;
// 显示注册界面
-(void)showRegisterVC;
// 显示测试 仿威信的 朋友圈的 cell.
-(void)showWeChatTestVC;
// 显示查找副井
-(void)showTestChaZhaoFuJin;
// 测试显示 face view.
-(void)showFaceTestVC;
// 只正对 JZ_MainLeftVC
-(void)settingBottomBarHeight:(float)height;
// 操作 GUI.
-(void)operationGUI:(BOOL)isShow;

// 关闭菜单
-(void)closeSwitchMenu:(BOOL)animation;
// 打开菜单.
-(void)openSwitchMenu:(BOOL)animatin;
// 当前菜单状态. yes ,close , no ,show
-(BOOL)currentSwitchMenuState;

// 关于启动后要做的事情
-(void)applunchOperatioin;


@end
