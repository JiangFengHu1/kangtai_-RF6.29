//
//
/**
 * Copyright (c) www.bugull.com
 */
//
//


#import "MainVC.h"

enum{
    ohbuyRightMove = 1,
    ohbuyResetMove,
};

@protocol ohbuyMoveDelegate <NSObject>

- (void)ohbuyMoveMethod:(NSInteger)index;

@end

@interface AboutVC : MainVC

@property (nonatomic, assign) id <ohbuyMoveDelegate> delegate;
@property (nonatomic,strong)UILabel *versonLab;
@property (nonatomic,assign)NSInteger verson;

@end
