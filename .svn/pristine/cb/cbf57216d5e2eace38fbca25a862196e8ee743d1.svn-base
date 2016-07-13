////
////
///**
// * Copyright (c) www.bugull.com
// */
////
////
//
//#import "RFPageVC.h"
//
//#define HEIGHT_BUT 90
//#define WIDTH_BUT 90
//
//@interface RFPageVC ()
//
//@property(nonatomic,strong)UITapGestureRecognizer *tapGestureRecognizer;
//@property (strong,nonatomic) NSString  *imageSTring;
//
//@end
//
//@implementation RFPageVC
//
//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Custom initialization
//
//    }
//    return self;
//}
//
//- (void)viewDidLoad
//{
//    [super viewDidLoad];
//    self.dataDAY = [[NSMutableArray alloc] initWithCapacity:0];
//
//    
//    self.dataDAY = [RFDataBase selectAllDataFromDataBase:self.macString];
//    
//    [self loadUI];
//    // Do any additional setup after loading the view.
//}
//
//- (void)viewWillAppear:(BOOL)animated
//{
//
//    
//    self.dataDAY =  [RFDataBase selectAllDataFromDataBase:self.macString];
//    
//    [self createlogo];
//    [super viewWillAppear:animated];
//    
//}
//
//- (void)loadUI
//{
//    
//    self.titlelab.text = @"RF";
//    self.backButton.hidden = NO;
////    self.imageView_L.hidden = NO;
//    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 90, kScreen_Width, 300)];
//    
//    
//    self.scrollView.backgroundColor = [UIColor clearColor];
//    
//    [self.view addSubview:self.scrollView];
//    
//    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bottom_back.png"]];
//    imageView.frame = CGRectMake(0, kScreen_Height-65, kScreen_Width, 65);
//    if (iOS7 == NO) {
//        imageView.frame = CGRectMake(0, kScreen_Height-80, kScreen_Width, 65);
//        
//    }
//    [self.view addSubview:imageView];
//    
//    UIImageView *addImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"add_normal.png"]];
//    addImageView.frame = CGRectMake(135, 9.5, 46, 46);
//    [imageView addSubview:addImageView];
//    
//    
//    UIButton *butt = [UIButton buttonWithType:UIButtonTypeCustom];
//    butt.frame = imageView.frame;
//    [butt addTarget:self action:@selector(addDeviceMethod:) forControlEvents:UIControlEventTouchUpInside];
//    
//    [self.view addSubview:butt];
//
//    
//}
//
//- (void)createlogo
//{
//    for (id view in [self.scrollView subviews])
//    {
//        [view removeFromSuperview];
//    }
//    
//    int col = (320- WIDTH_BUT*3)/4;
//    int row = (188 - HEIGHT_BUT*2)/3;
//    
//    for (int i = 0; i < [self.dataDAY count]; i ++)
//    {
//        
//        
//        
//      
//        int x = col + i%3 *(col + WIDTH_BUT);
//        int y = row + i/3 *(row +HEIGHT_BUT);
//        
//        UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(x, y, WIDTH_BUT, HEIGHT_BUT)];
//        CALayer *imageLayer = bgView.layer;
//        
//        [imageLayer setMasksToBounds:YES];
//        
//        
//        bgView.backgroundColor = [UIColor clearColor];
//        bgView.tag = i + 100;
//        
//        [self.scrollView addSubview:bgView];
//        
//        
//        UIImageView * boundsimag = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mark_border.png"]];
//        boundsimag.frame = CGRectMake( 13, 8, 64, 64);
//        boundsimag.userInteractionEnabled = YES;
//        [bgView addSubview:boundsimag];
//        RFDataModel *model = [self.dataDAY objectAtIndex:i];
//        
//        
//
//        UIImage *endImage;
//        NSString *dataPath = [[[NSBundle mainBundle] bundlePath] stringByAppendingString:[NSString stringWithFormat:@"/%@",model.rfDataLogo]];//获取程序包中相应文件的路径
//        NSFileManager *fileMa = [NSFileManager defaultManager];
//        
//        if(![fileMa fileExistsAtPath:dataPath]){
//            
//            NSFileManager *fileManager = [NSFileManager defaultManager];
//            if (![fileManager fileExistsAtPath:[Util getFilePathWithImageName:model.rfDataLogo]]) {
//                NSLog(@"找不到图片");
//                
//            }else{
//                endImage = [[UIImage alloc] initWithContentsOfFile:[Util getFilePathWithImageName:model.rfDataLogo]];
//                
//            }
//            
//        }else{
//            endImage = [UIImage imageNamed:model.rfDataLogo];
//            
//        }
//
//        
//        UIImageView * imagev = [[UIImageView alloc] initWithImage:endImage];
//        imagev.frame = CGRectMake(13, 8, 64, 64);
//        imagev.userInteractionEnabled = YES;
//
//        imagev.layer.cornerRadius = 10;
//        imagev.clipsToBounds = YES;
//        [bgView addSubview:imagev];
//        
//        
//        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//        button.frame = CGRectMake(62, 0, 25, 25);
//        [button setBackgroundImage:[UIImage imageNamed:@"delete.png"] forState:UIControlStateNormal];
//        button.tag = 200 +i;
//        [button addTarget:self action:@selector(buttonChange:) forControlEvents:UIControlEventTouchUpInside];
//        [bgView addSubview:button];
//        button.hidden = YES;
//        
//        //在bgview上添加点击手势事件
//        self.tapGestureRecognizer = [[UITapGestureRecognizer  alloc] initWithTarget:self action:@selector(tapOnContentView:)];
//        self.tapGestureRecognizer.tag  = [NSString stringWithFormat:@"%d",i + 400];
////        silpView.tag =  i;
//        [bgView addGestureRecognizer:self.tapGestureRecognizer];
//        
//        self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, y+HEIGHT_BUT);
//        //长按手势
//        UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(LongPressGestureRecognizer:)];
//        [self.scrollView addGestureRecognizer:longGesture];
//        
//        UILabel *labName = [[UILabel alloc] init];
//        labName.frame = CGRectMake(0, 67, 85 , 30);
//        labName.text = model.rfDataName;
//        
//        labName.font = [UIFont systemFontOfSize:12];
//        labName.textAlignment = NSTextAlignmentCenter;
//        labName.backgroundColor = [UIColor clearColor];
//        [bgView addSubview:labName];
//        
//    }
//    
//
//}
//
//#pragma mark-点击方法
//- (void)addDeviceMethod:(UIButton *)but
//{
//    
//    
//    AddRFVC*login = [[AddRFVC alloc] init];
//    login.macString = self.macString;
//    login.typeString = @"1";
//    login.fmdbRFTableArray = self.dataDAY;
//    [self.navigationController pushViewController:login animated:YES];
//    
//}
//
//
////单点击
//- (void)tapOnContentView:(UITapGestureRecognizer *)tapGestureRecognizer
//{
//    
//    if (_edit == YES) {
//        
//        if (tapGestureRecognizer.state == UIGestureRecognizerStateEnded) {
//            
//            [self editView:NO];
//        }
//    }else{
//        
//        if (tapGestureRecognizer.state == UIGestureRecognizerStateEnded) {
//            
//            RFVC *rf = [[RFVC alloc] init];
//            
//            int indexc =  [tapGestureRecognizer.tag intValue]-400;
//            
//            RFDataModel *model =   [self.dataDAY objectAtIndex:indexc];
//            
//            rf.macString = self.macString;
//            rf.RFdataModel = model;
//            [self.navigationController pushViewController:rf animated:YES];
//
//        }
//    }
//    
//    
//}
//
//
//static bool _edit = NO;
//- (void)LongPressGestureRecognizer:(UILongPressGestureRecognizer *)longGesture
//{
//    
//    if (longGesture.state == UIGestureRecognizerStateEnded) {
//        
//        [self editView:YES];
//    }
//    
//}
//- (void)editView:(BOOL)isEdit
//{
//    _edit = isEdit;
//    for (UIView *view in self.scrollView.subviews)
//    {
//        for (UIView *v in view.subviews)
//        {
//            //所有的uibutton是否显示
//            if ([v isMemberOfClass:[UIButton class]])
//                [v setHidden:!isEdit];
//        }
//    }
//    
//    //缩小大小
//    float scale;
//    if (_edit) {
//        scale = 0.9;
//    }else{
//        scale = 1.0;
//    }
//    
//    for (UIView *view in self.scrollView.subviews)
//    {
//        //动画缩小，放大
//        [UIView animateWithDuration:0.1 delay:0.1 options:0  animations:^
//         {
//             view.transform=CGAffineTransformMakeScale(scale, scale);
//         } completion:^(BOOL finished)
//         {
//             
//         }];
//    }
//}
////删除view时
//-(void)buttonChange:(UIButton*)sender
//{
//    NSArray *views = self.scrollView.subviews;
//    __block CGRect newframe;
//    int index = sender.tag - 200;
//    for (int i = index; i < [self.dataDAY count]; i++)
//    {
//        UIView *obj = [views objectAtIndex:i];
//        __block CGRect nextframe = obj.frame;
//        if (i == index)
//        {
//            //删除这个view
//            [obj removeFromSuperview];
//        }
//        else
//        {
//            for (UIView *v in obj.subviews)
//            {
//                //把每个按钮的tag从重设置
//                if ([v isMemberOfClass:[UIButton class]])
//                {
//                    v.tag = i+200 - 1;
//                    break;
//                }
//            }
//            //并且位置动画改变
//            [UIView animateWithDuration:0.6 animations:^
//             {
//                 obj.frame = newframe;
//             } completion:^(BOOL finished)
//             {
//                 
//             }];
//        }
//        //记住上一个view的位置
//        newframe = nextframe;
//    }
//    //数组移除
//    RFDataModel *model = [self.dataDAY objectAtIndex:index];
////    删除服务器数据
//    [self deleteRFDeviceToServerWith:model];
////    删除本地图片
//    [Util deleteCancleImageFileWithPath:model.rfDataLogo];
////    删除数据库信息
//    [RFDataBase deleteDataFromDataBase:model];
//    
//
//    
//    [self.dataDAY removeObjectAtIndex:index];
//    for (int i = 0; i < self.dataDAY.count; i ++) {
//        UIView * silpView = [self.tapGestureRecognizer view];
//        silpView.tag =  i;
//        self.tapGestureRecognizer.tag = [NSString stringWithFormat:@"%d",i + 400];
//        
//    }
//
//    
//}
//
//
//
//#pragma mark-点击方法
//- (void)circleButtonMethod:(UIButton *)but
//{
//    
//            
//
//    
//    RFVC *rf = [[RFVC alloc] init];
//    RFDataModel *model = [self.dataDAY objectAtIndex:but.tag- 500];
//    rf.RFdataModel = model;
////    rf.deciceName =  model.rfDataName;
////    rf.imgName = model.rfDataLogo;
//    
//    [self.navigationController pushViewController:rf animated:YES];
//    
//    
//}
//
//
//
//- (void)down
//{
//    //    NSString *dataPath = [[[NSBundle mainBundle] bundlePath] stringByAppendingString:[NSString stringWithFormat:@"/%@",decives.image]];//获取程序包中相应文件的路径
//    //    NSFileManager *fileMa = [NSFileManager defaultManager];
//    //
//    //    if([fileMa fileExistsAtPath:dataPath]) //
//    //    {
//    //
//    //    }
//    
//    NSMutableArray *tempArray = [DataBase ascWithRFtableINOrderNumber];
//    for (int i= 0; i < tempArray.count; i ++) {
//        
//        Device *decives =   [tempArray objectAtIndex:i];
//        NSString *dataPath = [[[NSBundle mainBundle] bundlePath] stringByAppendingString:[NSString stringWithFormat:@"/%@",decives.image]];//获取程序包中相应文件的路径
//        NSFileManager *fileMa = [NSFileManager defaultManager];
//        
//        if(![fileMa fileExistsAtPath:dataPath]) //
//        {
//            NSLog(@"dice===%@",decives.image);
//            
//            
//            NSFileManager *fileManager = [NSFileManager defaultManager];
//            if (![fileManager fileExistsAtPath:[Util getFilePathWithImageName:decives.image]]) {
//                
//                NSLog(@"meiypi==");
//                
//                [self httdpwnload:decives.image];
//            }
//            
//            
//        }else{
//            
//            continue;
//            
//        }
//        
//    }
//    
//    
//}
//
//- (void)httdpwnload:(NSString *)url
//{
//    [HTTPService downloadWithFilePathString:[NSString stringWithFormat:@"%@/%@",UploadedFileImageUrl,url] downLoadPath:^(NSString *filePath) {
//        
//        NSLog(@"file=%@",filePath);
//    } error:^(NSError *error) {
//        
//    }];
//}
//
//
//- (void)doSomething:(NSMutableArray *)thread
//{
//    
//    
//    for (int i = 0; i <thread.count; i ++) {
//        RFDataModel *mode = [thread objectAtIndex:i];
//        
//        
//        NSString *dataPath = [[[NSBundle mainBundle] bundlePath] stringByAppendingString:[NSString stringWithFormat:@"/%@",mode.rfDataLogo]];//获取程序包中相应文件的路径
//        //    NSError *error;
//        NSFileManager *fileMa = [NSFileManager defaultManager];
//        
//        if(![fileMa fileExistsAtPath:dataPath]) //拷贝
//        {
//            
//            NSFileManager *fileManager = [NSFileManager defaultManager];
//            if (![fileManager fileExistsAtPath:[Util getFilePathWithImageName:mode.rfDataLogo]]) {
//                
//                [self httdpwnload:mode.rfDataLogo];
////                [self  downLoadWithUrl:mode.rfDataLogo];
//                NSLog(@"copy xxx.txt success");
//                
//            }
//        }
//    }
//    
////    [self performSelector:@selector(changeMainUITo) withObject:self afterDelay:1.2];
//     NSLog(@"sahd=%@",thread);
//}
//
//- (void)changeMainUITo
//{
//    
//    
//}
//- (void)deleteRFDeviceToServerWith:(RFDataModel *)model
//{
//    
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//
//    NSString *tempString = [Util getPassWordWithmd5:[defaults objectForKey:KEY_PASSWORD]];
//    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//    [dict setValue:AccessKey forKey:@"accessKey"];
//    [dict setValue:[defaults objectForKey:KEY_USERMODEL] forKey:@"username"];
//    [dict setValue:tempString forKey:@"password"];
//    [dict setValue:model.rfDataMac forKey:@"macAddress"];
//    [dict setValue:model.address forKey:@"addressCode"];
//
//    NSString *timeSp = [NSString stringWithFormat:@"%f", (double)[[NSDate date] timeIntervalSince1970]*1000];
//    
//    NSArray *temp =   [timeSp componentsSeparatedByString:@"."];
//    [dict setValue:[temp objectAtIndex:0] forKey:@"lastOperation"];
//    [HTTPService POSTHttpToServerWith:DeleteRFURL WithParameters:dict   success:^(NSDictionary *dic) {
//        
////        [[Util getUtitObject] HUDHide];
//        
//        NSString * success = [dic objectForKey:@"success"];
//        
//        if ([success boolValue] == true) {
//            NSLog(@"成功");
//            
//        }
//        if ([success boolValue] == false) {
//            
//            [Util showAlertWithTitle:NSLocalizedString(@"Tips", nil) msg:[dic objectForKey:@"msg"]];
//            
//        }
//        
//        
//    } error:^(NSError *error) {
////        [[Util getUtitObject] HUDHide];
//        
//        [Util showAlertWithTitle:NSLocalizedString(@"Tips", nil) msg:[NSString stringWithFormat:@"%@",error]];
//        
//    }];
//
//    
//}
//
//
////-(void)downLoadWithUrl:(NSString *)url
////{
////    
////    NSString *temp = [NSString stringWithFormat:@"%@/%@",UploadedFileImageUrl,url];
////    NSURL *netUrl = [[NSURL alloc]initWithString:temp];
////    
////    self.imageSTring = url;
////    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:netUrl];
////    NSURLConnection *conn = [[NSURLConnection alloc]initWithRequest:request delegate:self];
////    if (conn)
////    {
////        [conn start];//开始连接网络
////    }
////}
////
////#pragma mark -
////#pragma mark NSURLConnectionDelegate methods
//////连接失败
////- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
////{
////    //    if ([self.delegate respondsToSelector:@selector(faileWithError:)])
////    //    {
////    //        [self.delegate faileWithError:error];
////    //    }
////    NSLog(@"the connection is faile!,the reason is %@",error);
////}
////
////#pragma mark -
////#pragma mark NSURLConnectionDataDelegate methods
//////连接成功,当链接收到回复时调用该方法
////- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
////{
////    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
////    //对于http请求,成功的返回码为200
////    if (httpResponse.statusCode ==200)
////    {
////        NSLog(@"connect success!");
////    }
////}
//////接收数据
////- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
////{
////    //    [self.data appendData:data];
////    //    NSLog(@"--------%@",data);
////    [data writeToFile:[self getFilePathWithPath:self.imageSTring] atomically:YES];
////    
////    [self createlogo];
////    //    [self.tableView performSelector:@selector(reloadData) withObject:nil afterDelay:0.5];
////    
////}
////
////
////
////- (NSString *)getFilePathWithPath:(NSString *)path
////{
////    
////    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
////    NSString *docDir = [paths objectAtIndex:0];
////    //    NSString *tempStr = [NSString stringWithFormat:@"Local-image-V_%d-_%d.png",arc4random()%0xff,arc4random()%0xff];
////    //    [self.dataDAY removeObject:[self.dataDAY lastObject]];
////    return [docDir stringByAppendingString:[NSString stringWithFormat:@"/%@",path]];
////}
////
//
//- (void)didReceiveMemoryWarning
//{
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
//
//- (void)dealloc
//{
//    self.dataDAY = nil;
//}
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
