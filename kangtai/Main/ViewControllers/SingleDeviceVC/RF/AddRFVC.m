////
////
///**
// * Copyright (c) www.bugull.com
// */
////
////
//
//#import "AddRFVC.h"
//#define HEIGHT_BUT 48
//#define WIDTH_BUT 48
//
//@interface AddRFVC ()
//
//
//@property (nonatomic,copy)NSString *rfUUIDString;
//
//@end
//
//
//@implementation AddRFVC
//
//@synthesize macString = _macString;
//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Custom initialization
//        self.fmdbRFTableArray = [[NSMutableArray alloc] initWithCapacity:0];
//        
//        
//    }
//    return self;
//}
//
//
//- (void)viewWillAppear:(BOOL)animated
//{
//    typeButIndex = 666;
//    butIndex = 500;
//    [super viewWillAppear:animated];
//}
//
//- (void)viewDidLoad
//{
//    [super viewDidLoad];
//    self.dataDAY = [[NSMutableArray alloc] initWithObjects:@"0.png",@"1.png",@"2.png",@"3.png",@"4.png",@"5.png",@"6.png",@"add_mark_normal.png",nil];
//    [self loadUI];
//    
//    
//    
//}
//
//- (void)loadUI
//{
////    self.titlelab.text = NSLocalizedString(@"Add", nil);
////    self.backButton.hidden = NO;
////    self.imageView_L.hidden = NO;
//    UILabel *ssidLab = [[UILabel alloc] initWithFrame:CGRectMake(20, 80, 60, 40)];
//    ssidLab.backgroundColor = [UIColor clearColor];
//    
//    ssidLab.font = [UIFont systemFontOfSize:16];
//    ssidLab.text = NSLocalizedString(@"Name", nil);
//    ssidLab.numberOfLines = 0;
//    ssidLab.textColor = [UIColor colorWithRed:39.0/255 green:39.0/255 blue:39.0/255 alpha:1];
//    [self.view addSubview:ssidLab];
//    
//    UILabel *pwdLab = [[UILabel alloc] initWithFrame:CGRectMake(20, 130, 60, 40)];
//    pwdLab.backgroundColor = [UIColor clearColor];
//    
//    pwdLab.font = [UIFont systemFontOfSize:16];
//    pwdLab.text = NSLocalizedString(@"Type", nil);
//    pwdLab.numberOfLines = 0;
//    pwdLab.textColor = [UIColor colorWithRed:39.0/255 green:39.0/255 blue:39.0/255 alpha:1];
//    [self.view addSubview:pwdLab];
//    
//    
//    UILabel *showPwdLab = [[UILabel alloc] initWithFrame:CGRectMake(20,180, 120, 40)];
//    showPwdLab.backgroundColor = [UIColor clearColor];
//    
//    showPwdLab.font = [UIFont systemFontOfSize:16];
//    showPwdLab.text = NSLocalizedString(@"icon", nil);
//    showPwdLab.textColor = [UIColor colorWithRed:39.0/255 green:39.0/255 blue:39.0/255 alpha:1];
//    [self.view addSubview:showPwdLab];
//    
//    //    输入框
//    UIImageView *bgimage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"input_squre.png"]];
//    bgimage.frame = CGRectMake(80, 102.5, 186, 7.5);
//    bgimage.userInteractionEnabled = YES;
//    [self.view addSubview:bgimage];
//    
//    self.pwdText = [[UITextField alloc] initWithFrame:CGRectMake(80, 80, 180, 40)];
//    self.pwdText.borderStyle = UITextBorderStyleNone;
//    self.pwdText.delegate = self;
//    self.pwdText.textColor = [UIColor blueColor];
//    self.pwdText.textAlignment = NSTextAlignmentLeft;
//    self.pwdText.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
//    [self.view addSubview:self.pwdText];
//    
//    
//    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bottom_back.png"]];
//    imageView.userInteractionEnabled = NO;
//    imageView.frame = CGRectMake(0, kScreen_Height-65, kScreen_Width, 65);
//    if (iOS7 == NO) {
//        imageView.frame = CGRectMake(0, kScreen_Height-80, kScreen_Width, 65);
//    }
//    [self.view addSubview:imageView];
//    
//    
//    //    保存// 取消按钮
//    UIButton *saveButt = [UIButton buttonWithType:UIButtonTypeCustom];
//    saveButt.frame = CGRectMake(160, kScreen_Height-55, 150, 45);
//    [saveButt addTarget:self action:@selector(saveDeviceMethod:) forControlEvents:UIControlEventTouchUpInside];
//    
//    [saveButt setBackgroundImage:[UIImage imageNamed:@"button_right_normal.png"] forState:UIControlStateNormal];
//    [saveButt setBackgroundImage:[UIImage imageNamed:@"button_right_click.png"] forState:UIControlStateHighlighted];
//    saveButt.tag = 443;
//    [saveButt setTitle:NSLocalizedString(@"save", nil) forState:UIControlStateNormal];
//    [self.view addSubview:saveButt];
//    [saveButt setTitleColor:[UIColor colorWithRed:31.0/255 green:141.0/255 blue:234.0/255 alpha:1] forState:UIControlStateNormal];
//
//    UIButton *cancleButt = [UIButton buttonWithType:UIButtonTypeCustom];
//    cancleButt.frame = CGRectMake(10, kScreen_Height-55, 150, 45);
//    [cancleButt setBackgroundImage:[UIImage imageNamed:@"button_left_normal.png"] forState:UIControlStateNormal];
//    [cancleButt setBackgroundImage:[UIImage imageNamed:@"button_left_click.png"] forState:UIControlStateHighlighted];
//    
//    cancleButt.tag = 447;
//    [cancleButt setTitleColor:[UIColor colorWithRed:151.0/255 green:151.0/255 blue:151.0/255 alpha:1] forState:UIControlStateNormal];
//
//    [cancleButt setTitle:NSLocalizedString(@"cancle", nil) forState:UIControlStateNormal];
//    
//    [cancleButt addTarget:self action:@selector(saveDeviceMethod:) forControlEvents:UIControlEventTouchUpInside];
//    
//    [self.view addSubview:cancleButt];
//    
//    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 220, kScreen_Width, 195)];
//    
//    
//    self.scrollView.backgroundColor = [UIColor clearColor];
//    
//    [self.view addSubview:self.scrollView];
//    
//    self.imagev = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mark_border_selected_1.png"]];
//    self.imagev.frame = CGRectMake(0, 0, 55, 55);
//    self.imagev.userInteractionEnabled = YES;
//    [self.scrollView addSubview:self.imagev];
//
//    
////    加载选择图片
//    [self loadButtonLogoMethod];
//    
//    NSArray *arr = [NSArray arrayWithObjects:NSLocalizedString(@"Switch", nil),NSLocalizedString(@"Dimmer", nil) ,nil];
//    
//    for (int i=0; i < 2; i ++) {
//        
//        UILabel *showPwdLab = [[UILabel alloc] initWithFrame:CGRectMake(i *80+120, 135, 60, 30)];
//        showPwdLab.backgroundColor = [UIColor clearColor];
//        
//        showPwdLab.font = [UIFont systemFontOfSize:14];
//        showPwdLab.text = [arr objectAtIndex:i];
//        showPwdLab.textColor = [UIColor colorWithRed:151.0/255 green:151.0/255 blue:151.0/255 alpha:1];
//        [self.view addSubview:showPwdLab];
//
//        UIButton *dataButt = [UIButton buttonWithType:UIButtonTypeCustom];
//        dataButt.frame = CGRectMake(i *80+95, 140, 21, 21);
//        [dataButt addTarget:self action:@selector(switchButtDeviceMethod:) forControlEvents:UIControlEventTouchUpInside];
//        dataButt.tag = i +666;
//        
//        [dataButt setImage:[UIImage imageNamed:@"invalid.png"] forState:UIControlStateNormal];
//
//        if (0==i) {
//            
//            self.typeImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"selected.png"]];
//            [dataButt setBackgroundImage:nil forState:UIControlStateNormal];
//            
//            self.typeImage.bounds = CGRectMake(0, 0, 21, 21);
//            
//            [dataButt setImage:nil forState:UIControlStateNormal];
//
//            self.typeImage.center = dataButt.center;
//            self.typeImage.userInteractionEnabled = YES;
//            [self.view addSubview:self.typeImage];
//            
//        }
//
//        [self.view addSubview:dataButt];
//    }
//
//    
//    
//    
//}
//
//
//- (void)loadButtonLogoMethod
//{
//    
//    for (id view in [self.scrollView subviews])
//    {
//        if ([view isKindOfClass:[UIButton class]]) {
//            [view removeFromSuperview];
//            
//        }
//    }
//
//    int col = (320- HEIGHT_BUT*4)/5;
//    int row = (140 - WIDTH_BUT*2)/3;
//    
//    for (int i = 0; i < [self.dataDAY count]; i ++)
//    {
//        
//        
//        int x = col + i%4 *(col + HEIGHT_BUT);
//        int y = row + i/4 *(row +WIDTH_BUT);
//        
////        NSString *imageName = [self.dataDAY objectAtIndex:i];
////        
////        UIImage *endImage;
//        NSString *imageName = [self.dataDAY objectAtIndex:i];
//        
//        UIImage *endImage;
//        NSString *dataPath = [[[NSBundle mainBundle] bundlePath] stringByAppendingString:[NSString stringWithFormat:@"/%@",imageName]];//获取程序包中相应文件的路径
//        NSFileManager *fileMa = [NSFileManager defaultManager];
//        
//        if(![fileMa fileExistsAtPath:dataPath]){
//            
//            NSFileManager *fileManager = [NSFileManager defaultManager];
//            if (![fileManager fileExistsAtPath:[Util getFilePathWithImageName:imageName]]) {
//                NSLog(@"找不到图片");
//                
//            }else{
//                endImage = [[UIImage alloc] initWithContentsOfFile:[Util getFilePathWithImageName:imageName]];
//                butIndex = 507;
//                
//            }
//            
//        }else{
//            endImage = [UIImage imageNamed:imageName];
//            
//        }
//        
//
////        if ([imageName hasPrefix:@"/"])
////        {
////            
////            endImage = [[UIImage alloc] initWithContentsOfFile:imageName];
////            butIndex = 507;
////        }
////        else{
////            endImage = [UIImage imageNamed:imageName];
////        }
//        UIImageView *imageView = [[UIImageView alloc] initWithImage:endImage];
//        imageView.frame = CGRectMake(x, y, WIDTH_BUT, HEIGHT_BUT);
//        imageView.layer.cornerRadius = 5;
//        imageView.clipsToBounds = YES;
//        imageView.userInteractionEnabled = YES;
//        imageView.tag = i + 600;
//        [self.scrollView addSubview:imageView];
//        
//        
//        
//        
//        UIButton *but =[UIButton buttonWithType:UIButtonTypeCustom];
//        but.frame = CGRectMake(x, y, WIDTH_BUT, HEIGHT_BUT);
//        
//        but.tag = i + 500;
//   
//
//        if (0==i) {
//            
//            self.imagev.center = but.center;
//              }
//        [but addTarget:self action:@selector(circleButtonMethod:) forControlEvents:UIControlEventTouchUpInside];
//        [self.scrollView addSubview:but];
//        
//        
//        
//    }
//
//}
//
//
//- (void)switchButtDeviceMethod:(UIButton *)but
//{
//
//    UIButton *previous = (UIButton *)[self.view viewWithTag:typeButIndex];
//    
//    [previous setImage:[UIImage imageNamed:@"invalid.png"] forState:UIControlStateNormal];
//    [but setImage:nil  forState:UIControlStateNormal];
//    
//    self.typeImage.center = but.center;
//    typeButIndex = but.tag;
//    
//}
//
//static int  typeButIndex = 666;
//
//static int  butIndex = 500;
//
//#pragma mark-点击方法
//
////选择图标
//- (void)circleButtonMethod:(UIButton *)but
//{
//    
//
//    int last = self.dataDAY.count - 1+500;
//    if (but.tag == last) {
//        [self actionSheet];
//        
//    }
//
////    switch (but.tag) {
////        case 507:
////            
////            [self actionSheet];
////
////            break;
////            
////        default:
////            
////            break;
////    }
////    
//            self.imagev.center = but.center;
//            butIndex = but.tag;
//}
////添加设备保存到数据库中
//- (void)saveDeviceMethod:(UIButton *)but
//{
//    NSString *imageNe = [self.dataDAY objectAtIndex:butIndex-500];
//    
//    
//    NSString *string;
//    if (butIndex == 507) {
//        
//        string = self.rfUUIDString;
//        if ([string hasPrefix:@".png"]) {
//            
//            string = [string stringByAppendingString:@".png"];
//            
//        }
//
//        
//        
//    }else{
//        string = imageNe;
//        
//    }
//
//    switch (but.tag) {
//        case 447:
//            
//            break;
//            
//        case 443:
//        {
//            
//            RFDataModel *model = nil;
//            if ([self.typeString isEqualToString:@"1"]) {
//              
//                if (self.deviceNa == nil || [self.deviceNa isEqualToString:@""]) {
//                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Tips" message:@"The device name can not be empty" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
//                    [alertView show];
//                    return;
//                }
//
//            }
//            model = [[RFDataModel alloc]init];
//            
//            UInt8 byte[3];
//            for (int i = 0; i < 3; i ++){
//                byte[i] = arc4random() % 0xff;
//            }
//            NSData *data = [NSData dataWithBytes:byte length:3];
//            
//            
//            for (RFDataModel *rfData in self.fmdbRFTableArray)
//            {
//                if ([[Util getRFAddressWith:rfData.address] isEqualToData:data]) {
//                    
//                    for (int i = 0; i < 3; i ++){
//                        byte[i] = arc4random() % 0xff;
//                    }
//                    
//                }
//            }
//            
//            model.rfDataLogo =  [self.dataDAY objectAtIndex:butIndex - 500];
//            model.rfDataMac =  self.macString;
//            model.rfDataName = self.deviceNa;
//            model.rfDataState = @"open";
//            model.typeRF = @"1";
//
//            model.address = [NSString stringWithFormat:@"%02X%02X%02X",byte[0],byte[1],byte[2]];
//            
//
//            
//            UIButton *button = (UIButton *)[self.view viewWithTag:typeButIndex];
//            switch (button.tag) {
//                case 666:
//                    model.typeRF = @"1";
//                    
//                    break;
//                case 667:
//                    model.typeRF = @"2";
//                    
//                    break;
//                    
//                default:
//                    break;
//            }
//            
////            NSLog(@"*==*=%@",model.address);
//            [RFDataBase insertIntoDataBase:model];
//
//            [self editRFDeviceSendToServer:model WithNewImageName:string];
//
//        }
//            
//            break;
//        default:
//            break;
//    }
//    
//    UIImage *endImage;
//    if (butIndex == 507)
//    {
//        
//        endImage = [[UIImage alloc] initWithContentsOfFile:[Util getFilePathWithImageName:imageNe]];
//    }
//    else{
//        endImage = [UIImage imageNamed:imageNe];
//    }
//    
//    
//    [self sendImageToServerWithimageName:string WithImage:endImage];
//
//    [self.navigationController popViewControllerAnimated:YES];
//    
//    self.deviceNa = @"";
//}
//
//
//#pragma mark-textFieldDelegate
//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    [self.view endEditing:YES];
//    
//}
//- (void)textFieldDidEndEditing:(UITextField *)textField
//{
//    [self.view endEditing:YES];
//    
//    self.deviceNa = textField.text;
//}
//
//- (BOOL)textFieldShouldReturn:(UITextField *)textField
//{
//    
//    [self.view endEditing:YES];
//    return YES;
//}
//
//#pragma mark-图片
//- (void)actionSheet
//{
//    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Photos",@"Camera",nil ];
//    [actionSheet showInView:self.view];//参数指显示UIActionSheet的parent。
//}
//
//
//
//-(void) actionSheet : (UIActionSheet *) actionSheet didDismissWithButtonIndex:(NSInteger) buttonIndex
//{
//    switch (buttonIndex) {
//        case 0:
//            [self pickImageFromAlbum];
//            break;
//        case 1:
//            [self pickImageFromCamera];
//            break;
//        default:
//            break;
//    }
//}
//#pragma mark-
//#pragma mark-imagePicker
//- (void)pickImageFromAlbum
//{
//    imagePicker = [[UIImagePickerController alloc] init];
//    imagePicker.delegate = self;
//    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//    imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
//    imagePicker.allowsEditing = YES;
//    
//    [self presentViewController:imagePicker animated:YES completion:nil];
//}
//
//- (void)pickImageFromCamera
//{
//    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Tips" message:@"Current camera unavailable" delegate:self cancelButtonTitle:@"Cancle" otherButtonTitles:@"OK", nil];
//        [alert show];
//        return;
//    }
//    imagePicker = [[UIImagePickerController alloc] init];
//    imagePicker.delegate = self;
//    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
//    imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
//    imagePicker.allowsEditing = YES;
//    
//    [self presentViewController:imagePicker animated:YES completion:nil ];
//}
//- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
//{
//    
//    UIImage *image= [info objectForKey:@"UIImagePickerControllerOriginalImage"];
//    
//    UIImageView *imgView = (UIImageView *)[self.view viewWithTag:607];
//    imgView.image = image;
//    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera)
//    {
//        UIImageWriteToSavedPhotosAlbum (image, nil, nil , nil);    //保存到library
//    }
////    NSData *imageData = UIImageJPEGRepresentation(image, 0.00001);
////    
////    [imageData writeToFile:[self getFilePath] atomically:YES];
//    CGSize imagesize = image.size;
//    imagesize.height =200;
//    imagesize.width =200;
//    //对图片大小进行压缩--
//    image = [self imageWithImage:image scaledToSize:imagesize];
//    NSData *imageData = UIImageJPEGRepresentation(image, 0.00001);
//    
//    [imageData writeToFile:[self getFilePath] atomically:YES];
//    [self dismissViewControllerAnimated:YES completion:nil];
//    [self loadButtonLogoMethod];
//    [self dismissViewControllerAnimated:YES completion:nil];
//
//
//}
//
//-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
//{
//    // Create a graphics image context
//    UIGraphicsBeginImageContext(newSize);
//    
//    // Tell the old image to draw in this new context, with the desired
//    // new size
//    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
//    
//    // Get the new image from the context
//    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
//    
//    // End the context
//    UIGraphicsEndImageContext();
//    
//    // Return the new image.
//    return newImage;
//}
//
//
//- (NSString *)getFilePath
//{
//    
//    
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *docDir = [paths objectAtIndex:0];
//    
//    
//    NSString *tempStr = [Util getUUID];
//    
//    tempStr = [tempStr stringByAppendingString:@".png"];
//    self.rfUUIDString = tempStr;
////    NSString *tempStr = [NSString stringWithFormat:@"Local-image_RF-V_%d-_%d.png",arc4random()%0xff,arc4random()%0xff];
//    [self.dataDAY insertObject:tempStr atIndex:7];
//    return [docDir stringByAppendingString:[NSString stringWithFormat:@"/%@",tempStr]];
//    
//}
//
//#pragma mark-
//#pragma mark-http
////编辑 RF 设备
//
//
//- (void)editRFDeviceSendToServer:(RFDataModel *)rfModel_ WithNewImageName:(NSString *)imageName
//{
//    
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    
//
//    NSString *tempString = [Util getPassWordWithmd5:[defaults objectForKey:KEY_PASSWORD]];
//    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//    [dict setValue:AccessKey forKey:@"accessKey"];
//    [dict setValue:[defaults objectForKey:KEY_USERMODEL] forKey:@"username"];
//    [dict setValue:tempString forKey:@"password"];
//    
//    [dict setValue:rfModel_.rfDataMac forKey:@"macAddress"];
//    
//
//
//    [dict setValue:rfModel_.rfDataName forKey:@"deviceName"];
//    [dict setValue:rfModel_.address forKey:@"addressCode"];
//    [dict setValue:rfModel_.rfDataLogo forKey:@"imageName"];
//    [dict setValue:rfModel_.typeRF forKey:@"type"];
//    
//    NSString *timeSp = [NSString stringWithFormat:@"%f", (double)[[NSDate date] timeIntervalSince1970]*1000];
//    
//    NSArray *temp =   [timeSp componentsSeparatedByString:@"."];
//    [dict setValue:[temp objectAtIndex:0] forKey:@"lastOperation"];
//    
//    [HTTPService POSTHttpToServerWith:EditRFURL WithParameters:dict success:^(NSDictionary *dic) {
//        
//        
//        NSString * success = [dic objectForKey:@"success"];
//        
//        if ([success boolValue] == true) {
//            NSLog(@"成功");
//        }
//        if ([success boolValue] == false) {
//            
//            [Util showAlertWithTitle:NSLocalizedString(@"Tips", nil) msg:[dic objectForKey:@"msg"]];
//            
//        }
//        
//        
//    } error:^(NSError *error) {
//        
//        [Util showAlertWithTitle:NSLocalizedString(@"Tips", nil) msg:@"Link Timeout"];
//        
//    }];
//    
//    
//    
//}
//
//
//- (void)sendImageToServerWithimageName:(NSString *)name WithImage:(UIImage *)image
//{
//    
//    
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    NSString *tempString = [Util getPassWordWithmd5:[defaults objectForKey:KEY_PASSWORD]];
//    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//    [dict setValue:AccessKey forKey:@"accessKey"];
//    [dict setValue:[defaults objectForKey:KEY_USERMODEL] forKey:@"username"];
//    [dict setValue:tempString forKey:@"password"];
//    [dict setValue:name forKey:@"imageName"];
//    
//    
//    [HTTPService PostHttpToServerImageAndDataWith:UploadURL WithParmeters:dict WithFilePath:nil imageName:name andImageFile:image success:^(NSDictionary *dic) {
//        
////        [[Util getUtitObject] HUDHide];
//        
//        NSString * success = [dic objectForKey:@"success"];
//        
//        if ([success boolValue] == true) {
//         NSLog(@"成功");
////         [Util showAlertWithTitle:NSLocalizedString(@"Tips", nil) msg:@"cok"];
//            
//            
//        }
//        if ([success boolValue] == false) {
//            
//            [Util showAlertWithTitle:NSLocalizedString(@"Tips", nil) msg:[dic objectForKey:@"msg"]];
//            
//        }
//        
//    } error:^(NSError *error) {
////        [[Util getUtitObject] HUDHide];
//        
//        [Util showAlertWithTitle:NSLocalizedString(@"Tips", nil) msg:@"Link Timeout"];
//        
//        
//    }];
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
