//
//
/**
 * Copyright (c) www.bugull.com
 */
//
//

#import "RegisterationVC.h"

@interface RegisterationVC ()<UITextFieldDelegate,UIAlertViewDelegate>
{
    UIButton *butt;
}

@property(nonatomic,copy)NSString *emailString;
@property(nonatomic,copy)NSString *passString;

@property (nonatomic,strong) UITextField *passText;
@end

@implementation RegisterationVC

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
    
    
    [self layUI];
    // Do any additional setup after loading the view.
}

- (void)layUI
{
    self.titlelab.text = NSLocalizedString(@"Sign Up", nil);
    UILabel *tipsLab = [[UILabel alloc] initWithFrame:CGRectMake(20, barViewHeight + 10, kScreen_Width - 40, 60)];
    
    tipsLab.text = NSLocalizedString(@"Email will be used to retrieve your password,please fill in", nil);
    tipsLab.textColor = [UIColor colorWithRed:146.0/255 green:146.0/255 blue:146.0/255 alpha:1];
    tipsLab.font = [UIFont systemFontOfSize:16];
    tipsLab.numberOfLines = 0;
    tipsLab.backgroundColor = [UIColor clearColor];
    [self.view addSubview:tipsLab];
    
    
    UIImageView *textImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_input_squre.png"]];
    textImage.frame = CGRectMake(18,barViewHeight + 80, kScreen_Width - 36, 110);
    [self.view addSubview:textImage];
    
    UITextField *userText = [[UITextField alloc] initWithFrame:CGRectMake(25, barViewHeight + 86, kScreen_Width - 45, 52)];
    userText.placeholder = NSLocalizedString(@"Email", nil);
    userText.font = [UIFont systemFontOfSize:16];
    userText.textAlignment = NSTextAlignmentLeft;
    userText.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    userText.borderStyle = UITextBorderStyleNone;
    userText.tag = 111;
    userText.delegate = self;
    [self.view addSubview:userText];
    
    self.passText = [[UITextField alloc] initWithFrame:CGRectMake(25, barViewHeight + 136, kScreen_Width - 45, 52)];
    self.passText.placeholder = NSLocalizedString(@"Password", nil);
    self.passText.font = [UIFont systemFontOfSize:16];
    self.passText.textAlignment = NSTextAlignmentLeft;
    self.passText.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.passText.borderStyle = UITextBorderStyleNone;
    self.passText.tag = 112;
    self.passText.secureTextEntry = YES;
    self.passText.delegate = self;
    [self.view addSubview:self.passText];
    
    UILabel *showPwdLab = [[UILabel alloc] initWithFrame:CGRectMake(57, barViewHeight + 205, kScreen_Width - 60, 25)];
    showPwdLab.backgroundColor = [UIColor clearColor];
    showPwdLab.font = [UIFont systemFontOfSize:16];
    showPwdLab.text = NSLocalizedString(@"Show Password", nil);
    showPwdLab.textColor = [UIColor colorWithRed:151.0/255 green:151.0/255 blue:151.0/255 alpha:1];
    showPwdLab.userInteractionEnabled = YES;
    [self.view addSubview:showPwdLab];
    
    UITapGestureRecognizer *showPWDTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showPasswordMethod)];
    [showPwdLab addGestureRecognizer:showPWDTap];
    
    butt = [UIButton buttonWithType:UIButtonTypeCustom];
    butt.frame = CGRectMake(20, barViewHeight + 205, 25, 25);
    [butt addTarget:self action:@selector(showPasswordMethod) forControlEvents:UIControlEventTouchUpInside];
    [butt setImage:[UIImage imageNamed:@"invalid.png"] forState:UIControlStateNormal];
    
    [self.view addSubview:butt];
}

- (void)leftButtonMethod:(UIButton *)but
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)reloadButtonMethod:(UIButton *)sender
{
    [self performSelector:@selector(signUpMethod:) withObject:nil];
}

- (void)signUpMethod:(UIButton *)but
{
    [self.view endEditing:YES];
    
    if (self.emailString == nil || [self.emailString isEqualToString:@"" ] || self.passString == nil || [self.passString isEqualToString:@"" ])
    {
        [Util showAlertWithTitle:NSLocalizedString(@"Tips", nil) msg:NSLocalizedString(@"Options can not be empty", nil)];
        
        return;
    }
    
    if (!IS_AVAILABLE_EMAIL(self.emailString)) {
        [Util showAlertWithTitle:NSLocalizedString(@"Tips", nil) msg:NSLocalizedString(@"Please enter a correct Email", nil)];
        return;
    }
    
    if (self.passString.length < 6) {
        [Util showAlertWithTitle:NSLocalizedString(@"Tips", nil) msg:NSLocalizedString(@"Password length must be longer than 6", nil)];
        return;
    }
    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleFade];
    [MMProgressHUD showWithTitle:NSLocalizedString(@"Register", nil) status:NSLocalizedString(@"Loading", nil)];
    
    [self signUpRequestHttpToServerWithpsWord:self.passString];
}
#pragma mark-HTTP
- (void)signUpRequestHttpToServerWithpsWord:(NSString *)psWord
{
    NSString *tempString =   [Util  getPassWordWithmd5:psWord];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:AccessKey forKey:@"accessKey"];
    [dict setValue:self.emailString forKey:@"username"];
    [dict setValue:tempString forKey:@"password"];
    
    [HTTPService POSTHttpToServerWith:SignUpURL WithParameters:dict success:^(NSDictionary *dic) {
        
        NSString * success = [dic objectForKey:@"success"];
        
        [MMProgressHUD dismiss];
        
        if ([success boolValue] == true) {
            UIAlertView *alert =[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Tips", nil) message:NSLocalizedString(@"Register successfully", nil) delegate:self cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Confirm", nil), nil];
            alert.tag = 237;
            [alert show];
            self.passText.text = @"";
        }
        if ([success boolValue] == false) {
            
            [Util showAlertWithTitle:NSLocalizedString(@"Tips", nil) msg:NSLocalizedString(@"Username already exist", nil)];
            
        }
    } error:^(NSError *error) {
        
        [MMProgressHUD dismiss];
        
        [Util showAlertWithTitle:NSLocalizedString(@"Tips", nil) msg:NSLocalizedString(@"Link Timeout", nil)];
        
    }];
    
}


#pragma mark-click
static bool showPWD = YES;
- (void)showPasswordMethod
{
    if (showPWD)
    {
        [butt setImage:[UIImage imageNamed:@"valid.png"] forState:UIControlStateNormal];
        self.passText.secureTextEntry = NO;
        
    }else{
        
        [butt setImage:[UIImage imageNamed:@"invalid.png"] forState:UIControlStateNormal];
        self.passText.secureTextEntry = YES;
    }
    showPWD = !showPWD;
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
#pragma mark-
#pragma mark-<UITextFieldDelegate>
//return键
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    
    return YES;
}




//开始编辑
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    return YES;
}

//结束编辑
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag == 111) {
        
        self.emailString = textField.text;
    }else{
        
        self.passString = textField.text;
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 237) {
        if (buttonIndex == 1) {
            
            [self.navigationController popViewControllerAnimated:YES];
            
        }
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
