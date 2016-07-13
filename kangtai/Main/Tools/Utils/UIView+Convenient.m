//
//
/**
 * Copyright (c) www.bugull.com
 */
//
//


#import "UIView+Convenient.h"

@implementation UIView (Convenient)

- (CGFloat)left
{
    return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)left
{
    self.frame = CGRectMake(left, self.top, self.width, self.height);
}

- (CGFloat)right
{
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setRight:(CGFloat)right
{
    self.frame = CGRectMake(right - self.width, self.top, self.width, self.height);
}

- (CGFloat)top
{
    return self.frame.origin.y;
}

- (void)setTop:(CGFloat)top
{
    self.frame = CGRectMake(self.left, top, self.width, self.height);
}

- (CGFloat)bottom
{
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setWidth:(CGFloat)width
{
    self.frame = CGRectMake(self.left, self.top, width, self.height);
}

- (CGFloat)valueOfDirection:(Direction)direction
{
    if (direction == DirectionLeft)
    {
        return [self left];
    }
    if (direction == DirectionRight)
    {
        return [self right];
    }
    if (direction == DirectionTop)
    {
        return [self top];
    }
    if (direction == DirectionBottom)
    {
        return [self bottom];
    }
    return 0;
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (void)setSize:(CGSize)size
{
    self.frame = CGRectMake(self.left, self.top, size.width,size.height);
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height
{
    self.frame = CGRectMake(self.left, self.top, self.width, height);
}

- (CGSize)size
{
    return self.frame.size;
}

- (CGPoint)origin
{
    return self.frame.origin;
}

- (void)moveToLeft:(CGFloat)amount
{
    self.frame = CGRectMake(self.frame.origin.x - amount, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
}

- (void)moveToRight:(CGFloat)amount
{
    self.frame = CGRectMake(self.frame.origin.x + amount, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
}

- (void)moveToTop:(CGFloat)amount
{
    self.frame = CGRectMake(self.frame.origin.x , self.frame.origin.y - amount , self.frame.size.width, self.frame.size.height);
}

- (void)moveToBottom:(CGFloat)amount
{
    self.frame = CGRectMake(self.frame.origin.x , self.frame.origin.y + amount , self.frame.size.width, self.frame.size.height);
}

- (void)moveToDirection:(Direction)direction amount:(CGFloat)amount
{
    if (direction == DirectionLeft)
    {
        [self moveToLeft:amount];
    }
    if (direction == DirectionRight)
    {
        [self moveToRight:amount];
    }
    if (direction == DirectionTop)
    {
        [self moveToTop:amount];
    }
    if (direction == DirectionBottom)
    {
        [self moveToBottom:amount];
    }
}

- (void)moveToLeftOfView:(UIView *)view margin:(CGFloat)margin
{
    self.frame = CGRectMake(view.frame.origin.x - self.frame.size.width - margin, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
}

- (void)moveToRightOfView:(UIView *)view margin:(CGFloat)margin
{
    self.frame = CGRectMake([view right] + margin, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
}

- (void)moveToTopOfView:(UIView *)view margin:(CGFloat)margin
{
    self.frame = CGRectMake(self.frame.origin.x, view.frame.origin.y - margin - self.frame.size.height, self.frame.size.width, self.frame.size.height);
}

- (void)moveToBottomOfView:(UIView *)view margin:(CGFloat)margin
{
    self.frame = CGRectMake(self.frame.origin.x, [view bottom] + margin, self.frame.size.width, self.frame.size.height);
}

- (void)moveToDirection:(Direction)direction ofView:(UIView *)view margin:(CGFloat)margin
{
    if (direction == DirectionLeft)
    {
        [self moveToLeftOfView:view margin:margin];
    }
    if (direction == DirectionRight)
    {
        [self moveToRightOfView:view margin:margin];
    }
    if (direction == DirectionTop)
    {
        [self moveToTopOfView:view margin:margin];
    }
    if (direction == DirectionBottom)
    {
        [self moveToBottomOfView:view margin:margin];
    }
}

- (void)moveToPoint:(CGPoint)point
{
    self.frame = CGRectMake(point.x, point.y, self.frame.size.width, self.frame.size.height);
}

- (void)resize:(CGSize)size
{
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, size.width, size.height);
}

- (void)addToView:(UIView *)view offset:(CGPoint)offSet
{
    [view addSubview:self];
    [self moveToPoint:offSet];
}

- (void)removeSubViews
{
    for (UIView * view in self.subviews)
    {
        [view removeFromSuperview];
    }
}

- (void)removeSubviewOfClass:(Class)type
{
    for (UIView * view in self.subviews)
    {
        if ([view isMemberOfClass:type])
        {
            [view removeFromSuperview];
        }
    }
}

@end
