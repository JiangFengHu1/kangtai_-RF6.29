//
//
/**
 * Copyright (c) www.bugull.com
 */
//
//


#import <UIKit/UIKit.h>

typedef enum
{
    DirectionLeft,
    DirectionRight,
    DirectionTop,
    DirectionBottom,
}Direction;

@interface UIView (Convenient)

@property (nonatomic) CGFloat left;

@property (nonatomic) CGFloat right;

@property (nonatomic) CGFloat top;

- (CGFloat)bottom;

- (CGFloat)valueOfDirection:(Direction)direction;

@property (nonatomic) CGFloat width;

@property (nonatomic) CGFloat height;

@property (nonatomic) CGSize size;

- (CGPoint)origin;

- (void)moveToLeft:(CGFloat)amount;

- (void)moveToRight:(CGFloat)amount;

- (void)moveToTop:(CGFloat)amount;

- (void)moveToBottom:(CGFloat)amount;

- (void)moveToDirection:(Direction)direction amount:(CGFloat)amount;

- (void)moveToLeftOfView:(UIView *)view margin:(CGFloat)margin;

- (void)moveToRightOfView:(UIView *)view margin:(CGFloat)margin;

- (void)moveToTopOfView:(UIView *)view margin:(CGFloat)margin;

- (void)moveToBottomOfView:(UIView *)view margin:(CGFloat)margin;

- (void)moveToDirection:(Direction)direction ofView:(UIView *)view margin:(CGFloat)margin;

- (void)moveToPoint:(CGPoint)point;

- (void)resize:(CGSize)size;

- (void)addToView:(UIView *)view offset:(CGPoint)offSet;

- (void)removeSubViews;

- (void)removeSubviewOfClass:(Class)type;

@end
