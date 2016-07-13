//
//
/**
 * Copyright (c) www.bugull.com
 */
//
//

#import "ZQCustomDatePicker.h"

@implementation ZQCustomDatePicker

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSDate *now = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
        NSString *dateString = [dateFormatter stringFromDate:now];
        nowYear = [[dateString substringWithRange:NSMakeRange(0, 4)] intValue];
        nowMonth = [[dateString substringWithRange:NSMakeRange(4, 2)] intValue];
        nowDay = [[dateString substringWithRange:NSMakeRange(6, 2)] intValue];
        
        yearArr = [[NSMutableArray alloc] initWithCapacity:1];
        for (int i = 0; i < 10; i++) {
            [yearArr addObject:[NSString stringWithFormat:@"%d",nowYear + i]];
        }
        
        [self setYearPicker];
        [self setMonthPicker];
        [self setDayPicker];
    }
    return self;
}

- (void)setYearPicker
{
    self.yearPicker = [[iCarousel alloc] initWithFrame:CGRectMake(0, 0, 100.0, 170.0)];
    [self.yearPicker setBackgroundColor:[UIColor clearColor]];
    [self.yearPicker setDelegate:self];
    [self.yearPicker setDataSource:self];
    [self.yearPicker setType:iCarouselTypeLinear];
    [self.yearPicker setVertical:YES];
    [self.yearPicker setClipsToBounds:YES];
    [self.yearPicker setDecelerationRate:.7f];
    [self.yearPicker scrollToItemAtIndex:0 animated:NO];
    [self carouselCurrentItemIndexDidChange:self.yearPicker];
    [self addSubview:self.yearPicker];
}

- (void)setMonthPicker
{
    self.monthPicker = [[iCarousel alloc] initWithFrame:CGRectMake(113, 0, 60.0, 170.0)];
    [self.monthPicker setBackgroundColor:[UIColor clearColor]];
    [self.monthPicker setDelegate:self];
    [self.monthPicker setDataSource:self];
    [self.monthPicker setType:iCarouselTypeLinear];
    [self.monthPicker setVertical:YES];
    [self.monthPicker setClipsToBounds:YES];
    [self.monthPicker setDecelerationRate:.91f];
    [self.monthPicker scrollToItemAtIndex:nowMonth - 1 animated:NO];
    [self carouselCurrentItemIndexDidChange:self.monthPicker];
    [self addSubview:self.monthPicker];
}

- (void)setDayPicker
{
    self.dayPicker = [[iCarousel alloc] initWithFrame:CGRectMake(180, 0, 60.0, 170.0)];
    [self.dayPicker setBackgroundColor:[UIColor clearColor]];
    [self.dayPicker setDelegate:self];
    [self.dayPicker setDataSource:self];
    [self.dayPicker setType:iCarouselTypeLinear];
    [self.dayPicker setVertical:YES];
    [self.dayPicker setClipsToBounds:YES];
    [self.dayPicker setDecelerationRate:.91f];
    [self.dayPicker scrollToItemAtIndex:nowDay - 1 animated:NO];
    [self carouselCurrentItemIndexDidChange:self.dayPicker];
    [self addSubview:self.dayPicker];

}

#pragma mark - iCarouselDataSource && iCarouseDelegate

- (void)carouselCurrentItemIndexDidChange:(iCarousel *)carousel
{
    NSUInteger count = 0;
    if ([carousel isEqual:self.yearPicker]) {
        count = 10;
    }
    if ([carousel isEqual:self.monthPicker]) {
        count = 12;
    }
    if ([carousel isEqual:self.dayPicker]) {
        count = dayCount;
    }
    
    long int index2 = carousel.currentItemIndex;
    NSMutableArray *itemArray = (NSMutableArray *)carousel.visibleItemViews;
    UILabel *label1;
    UILabel *label2;
    UILabel *label3;
    
    if (index2 == 0)
    {
        label1 = (UILabel *)[itemArray objectAtIndex:5];
        label2 = (UILabel *)[itemArray objectAtIndex:0];
        label3 = (UILabel *)[itemArray objectAtIndex:1];
    }
    else if (index2 == count - 1)
    {
        label1 = (UILabel *)[itemArray objectAtIndex:4];
        label2 = (UILabel *)[itemArray objectAtIndex:5];
        label3 = (UILabel *)[itemArray objectAtIndex:0];
    }
    else if (index2 == count - 2)
    {
        label1 = (UILabel *)[itemArray objectAtIndex:3];
        label2 = (UILabel *)[itemArray objectAtIndex:4];
        label3 = (UILabel *)[itemArray objectAtIndex:5];
    }
    else if (index2 == 1)
    {
        label1 = (UILabel *)[itemArray objectAtIndex:0];
        label2 = (UILabel *)[itemArray objectAtIndex:1];
        label3 = (UILabel *)[itemArray objectAtIndex:2];
        
    }
    else if (index2 == 2)
    {
        label1 = (UILabel *)[itemArray objectAtIndex:1];
        label2 = (UILabel *)[itemArray objectAtIndex:2];
        label3 = (UILabel *)[itemArray objectAtIndex:3];
    }
    else
    {
        label1 = (UILabel *)[itemArray objectAtIndex:2];
        label2 = (UILabel *)[itemArray objectAtIndex:3];
        label3 = (UILabel *)[itemArray objectAtIndex:4];
    }
    label1.backgroundColor = [UIColor clearColor];
    label2.backgroundColor = [UIColor clearColor];
    label3.backgroundColor = [UIColor clearColor];
    
    label1.textColor = RGBA(186.0, 186.0, 186.0, 1.0);
    label1.font = [UIFont systemFontOfSize:30.0f];
    label2.textColor = RGBA(30.0, 180.0, 240.0, 1.0);
    label2.font = [UIFont systemFontOfSize:45.0f];
    label3.textColor = RGBA(186.0, 186.0, 186.0, 1.0);
    label3.font = [UIFont systemFontOfSize:30.0f];
    
    if ([carousel isEqual:self.yearPicker] || [carousel isEqual:self.monthPicker]) {
        
        [self.dayPicker reloadData];
    }
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    if (view == nil)
    {
        view = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 10.0f, 60, 50)];
        if ([carousel isEqual:self.yearPicker]) {
            view.frame = CGRectMake(0, 10, 110, 50);
        }
    }
    
    ((UILabel *)view).textAlignment = NSTextAlignmentCenter;
    ((UILabel *)view).font = [UIFont systemFontOfSize:30.0f];
    ((UILabel *)view).textColor = RGBA(186.0, 186.0, 186.0, 1.0);
    ((UILabel *)view).backgroundColor = [UIColor clearColor];
    
    if ([carousel isEqual:self.yearPicker]) {
        ((UILabel *)view).text = yearArr[index];
        
    } else {
        ((UILabel *)view).text = [NSString stringWithFormat:@"%02lu", (unsigned long)index + 1];
    }
    if ([carousel isEqual:self.dayPicker]) {
        if (index == carousel.currentItemIndex) {
            ((UILabel *)view).font = [UIFont systemFontOfSize:45.0f];
            ((UILabel *)view).textColor = RGBA(30.0, 180.0, 240.0, 1.0);
        }
    }
    return view;
}

//必须的方法
- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    NSUInteger count = 0;
    dayCount = 0;
    if ([carousel isEqual:self.yearPicker])
    {
        count = 10;
    }
    else if ([carousel isEqual:self.monthPicker])
    {
        count = 12;
    }
    else if ([carousel isEqual:self.dayPicker])
    {
        if (self.monthPicker.currentItemIndex == 1)
        {
            if ([yearArr[self.yearPicker.currentItemIndex] intValue] % 400 == 0 || ([yearArr[self.yearPicker.currentItemIndex] intValue] % 4 == 0 && [yearArr[self.yearPicker.currentItemIndex] intValue] % 100 != 0))
            {
                dayCount = 28;
                count = 28;
            }
            else
            {
                dayCount = 29;
                count = 29;
            }

        }
        else
        {
            if (self.monthPicker.currentItemIndex == 0 || self.monthPicker.currentItemIndex == 2 || self.monthPicker.currentItemIndex == 4 || self.monthPicker.currentItemIndex == 6 || self.monthPicker.currentItemIndex == 7 || self.monthPicker.currentItemIndex == 9 || self.monthPicker.currentItemIndex == 11)
            {
                dayCount = 31;
                count = 31;
            }
            else
            {
                dayCount = 30;
                count = 30;
            }
        }
    }
    return count;
}


- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    if (option == iCarouselOptionSpacing)
    {
        return value * 1.1;
    }
    // 首尾相连
    if (option == iCarouselOptionWrap)
    {
        return YES;
    }
    return value;
}

@end
