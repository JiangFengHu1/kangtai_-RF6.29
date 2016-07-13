//
//
/**
 * Copyright (c) www.bugull.com
 */
//
//

#import "MainVC.h"

typedef enum {
    EditStateRFpush = 1, // RF push过来的
    EditStateWFpush = 2, // WF push过来的
    EditStateOtherpush = 3, // 别的状态push过来的
} EditState;

typedef enum {
    EditTypeHelght = 1, // 松开就可以进行刷新的状态
    EditTypeDeatule = 2 // 普通状态
} EditType;

@interface EditVC : MainVC<UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,UIAlertViewDelegate>

@property (nonatomic)EditType  EditType;

@property (nonatomic)EditState  editstateType;
@property (nonatomic,strong)Device *dataModel;
@property (nonatomic, copy) NSString *macStr;
@property (nonatomic,strong)NSString *dName;

@property (nonatomic,strong)NSMutableArray *dataDAY;
@property (nonatomic,strong)UILabel *deviceName;
@property (nonatomic,strong)UITextField *pwdText;
@property (nonatomic,strong)UIScrollView *scrollView;
@property (nonatomic,strong)UIImageView *imagev;
@end
