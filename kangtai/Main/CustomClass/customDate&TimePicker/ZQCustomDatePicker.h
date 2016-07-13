//
//
/**
 * Copyright (c) www.bugull.com
 */
//
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"

@interface ZQCustomDatePicker : UIView <iCarouselDataSource, iCarouselDelegate>
{
    int nowYear;
    int nowMonth;
    int nowDay;
    NSUInteger dayCount;
    NSMutableArray *yearArr;
}
@property (nonatomic, strong) iCarousel *yearPicker;
@property (nonatomic, strong) iCarousel *monthPicker;
@property (nonatomic, strong) iCarousel *dayPicker;

@end
