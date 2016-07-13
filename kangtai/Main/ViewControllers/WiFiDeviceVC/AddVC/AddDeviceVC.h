//
//
/**
 * Copyright (c) www.bugull.com
 */
//
//

#import "MainVC.h"
#import "Crypt.h"
#import "HFSmartLink.h"
#import "HFSmartLinkDeviceInfo.h"
#import <SystemConfiguration/CaptiveNetwork.h>
#import "HiJoine.h"

@interface AddDeviceVC : MainVC<UITextFieldDelegate, HiJoineDelegate>

@property (nonatomic,assign)BOOL isShowPW;
@property (nonatomic,strong)UILabel *deviceName;
@property (nonatomic,strong)UITextField *pwdText;

@property (nonatomic,strong)NSString *pwdStr;

@end
