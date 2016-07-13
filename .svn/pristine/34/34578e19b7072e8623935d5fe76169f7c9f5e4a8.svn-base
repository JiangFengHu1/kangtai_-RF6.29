//
//
/**
 * Copyright (c) www.bugull.com
 */
//
//


#import "SortUnitView.h"
#import <QuartzCore/QuartzCore.h>

#define CheckTrackingTime       .1

static NSString * const AnimationKeyRotationZ = @"AnimationKeyRotationZ";
static NSString * const AnimationKeyTranslationX = @"AnimationKeyTranslationX";
static NSString * const AnimationKeyZoomSmall = @"AnimationKeyZoomSmall";

float distanceBetweenPoints(CGPoint a, CGPoint b)
{
    float deltaX = a.x - b.x;
    float deltaY = a.y - b.y;
    return sqrtf( (deltaX * deltaX) + (deltaY * deltaY) );
}

@interface SortUnitView()
{
    BOOL goingHome;
    BOOL initialized;
}

@property (readonly,nonatomic) CGPoint touchPoint;

@property (readonly,nonatomic) BOOL highlighted;
@property (weak,nonatomic) id delegate;

@property (readonly,nonatomic,getter = isDragging) BOOL dragging;
@property (strong,nonatomic) UIView * imageCover;
@property (strong,nonatomic) UIButton * removeBtn;

@property (strong,nonatomic) NSTimer * trackTimer;
@property (strong,nonatomic) NSTimer * maybeTrackTimer;
@property (strong,nonatomic) NSTimer * checkTrackTimer;

@property (nonatomic,getter = isTracking) BOOL tracking;


@end

@implementation SortUnitView

- (void)refreshContent
{
    [self initialize];
    self.imageView.image = [UIImage imageNamed:self.sortUnit.image];
    self.titleLabel.text = self.sortUnit.name;
}

- (void)setCornerRadius:(CGFloat)cornerRadius
{
    _cornerRadius = cornerRadius;
    self.imageView.layer.cornerRadius = cornerRadius;
    self.imageCover.layer.cornerRadius = cornerRadius;
    self.imageView.layer.shadowColor = [UIColor colorWithRed:85.0/255 green:85.0/255 blue:85.0/255 alpha:1].CGColor;
    self.imageView.layer.shadowRadius = cornerRadius;
    self.imageView.layer.shadowOffset = CGSizeMake(0, 1.5);
    self.imageView.layer.shadowOpacity = .25;
}

//- (id)initWithSortUnit:(SortUnit *)sortUnit home:(CGRect)home
//{
//    self = [super initWithFrame:home];
//    if (self)
//    {
//        _home = home;
//        _sortUnit = sortUnit;
//        [self initialize];
//        [self refreshContent];
//    }
//    return self;
//}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}
//
//- (id)initWithCoder:(NSCoder *)aDecoder
//{
//    self = [super initWithCoder:aDecoder];
//    if (self)
//    {
//        [self initialize];
//    }
//    return self;
//}

- (void)initialize
{
    if (initialized)
    {
        return;
    }
    self.exclusiveTouch = YES;
    self.backgroundColor = [UIColor clearColor];
    if (!self.contentView)
    {
        self.contentView = [[UIView alloc] initWithFrame:self.bounds];
        _contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _contentView.backgroundColor = [UIColor clearColor];
        [self addSubview:_contentView];
    }
    
    if (!self.titleLabel)
    {
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height - Label_Hight, self.frame.size.width, Label_Hight)];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:11];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.textColor = [UIColor whiteColor];
        [self.contentView addSubview:self.titleLabel];
    }

    if (!self.imageView)
    {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(Inner_Margin, Inner_Margin, self.frame.size.width - 2 * Inner_Margin, self.frame.size.height - Inner_Margin - Label_Hight)];
        self.imageView.clipsToBounds = YES;
        [self.contentView addSubview:self.imageView];
    }
    
    self.imageCover = [[UIView alloc] initWithFrame:self.imageView.frame];
    self.imageCover.backgroundColor = [UIColor clearColor];
    self.imageCover.autoresizingMask = self.imageView.autoresizingMask;
    [self.contentView addSubview:self.imageCover];
    
//    self.removeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [self.removeBtn setImage:[UIImage imageNamed:@"x"] forState:UIControlStateNormal];
//    self.removeBtn.frame = CGRectMake(2.5 , 2.5, ButtonWidth, ButtonWidth);
//    [self.removeBtn addTarget:self action:@selector(wantRemove) forControlEvents:UIControlEventTouchUpInside];
//    [self.contentView addSubview:self.removeBtn];
//    self.removeBtn.hidden = YES;
    
    [self setCornerRadius:Default_CornerRadius];
    
    self.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin;
    initialized = YES;
}

- (void)setHighlighted:(BOOL)highlighted
{
    _highlighted = highlighted;
    if (highlighted)
    {
        _imageCover.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.5];
    }
    else
    {
        _imageCover.backgroundColor = [UIColor clearColor];
    }
}

- (void)setSelected:(BOOL)selected
{
    if (selected)
    {
        _imageCover.layer.borderWidth = 1;
        _imageCover.layer.borderColor = [UIColor colorWithRed:0/255 green:250.0/255 blue:131.0/255 alpha:1].CGColor;
    }
    else
    {
        _imageCover.layer.borderWidth = 0;
        _imageCover.layer.borderColor = [UIColor clearColor].CGColor;
    }
}

- (void)wantRemove
{
    if ([self.delegate respondsToSelector:@selector(sortUnitRemoveBtnClicked:)])
    {
        [self.delegate sortUnitRemoveBtnClicked:self];
    }
}

- (void)setHome:(CGRect)home
{
    _home = home;
}

- (void)setSortUnit:(id<SortUnit>)sortUnit
{
    _sortUnit = sortUnit;
}

- (void)goHomeOver
{
    goingHome = NO;
}

- (void)goHome
{
    float distanceFromHome = distanceBetweenPoints([self frame].origin, [self home].origin);
    float animationDuration = (0.14 + distanceFromHome * 0.0014) / 2;
    animationDuration = MAX(.20, animationDuration);
    [UIView beginAnimations:nil context:NULL];
    if (goingHome)
    {
        [UIView setAnimationBeginsFromCurrentState:YES];
    }
    goingHome = YES;
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(goHomeOver)];
    [UIView setAnimationDuration:animationDuration];
    [self setFrame:[self home]];
    [UIView commitAnimations];
}

- (void)startShake
{
    return;
    if ([self.layer animationForKey:AnimationKeyRotationZ] != nil && [self.layer animationForKey:AnimationKeyTranslationX] != nil)
    {
        return;
    }
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    [rotationAnimation setRepeatCount:MAXFLOAT];
    [rotationAnimation setDuration:0.12];
    [rotationAnimation setAutoreverses:YES];
    [rotationAnimation setFromValue:[NSNumber numberWithFloat:(float) (M_PI/100.0)]];
    [rotationAnimation setToValue:[NSNumber numberWithFloat:(float) (-M_PI/100.0)]];
    [rotationAnimation setTimeOffset:(arc4random() % 100) * 0.0012];
    
    CABasicAnimation *translationXAnimation = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
    [translationXAnimation setRepeatCount:MAXFLOAT];
    [translationXAnimation setDuration:0.2];
    [translationXAnimation setAutoreverses:YES];
    [translationXAnimation setFromValue:[NSNumber numberWithFloat:[self.layer bounds].origin.x + .5]];
    [translationXAnimation setToValue:[NSNumber numberWithFloat:[self.layer bounds].origin.x - .5]];
    [translationXAnimation setTimeOffset:(arc4random() % 100) * 0.002];
    
    [self.layer addAnimation:rotationAnimation forKey:AnimationKeyRotationZ];
    [self.layer addAnimation:translationXAnimation forKey:AnimationKeyTranslationX];
}

- (void)stopShake
{
    return;
    [self.layer removeAnimationForKey:AnimationKeyRotationZ];
    [self.layer removeAnimationForKey:AnimationKeyTranslationX];
}

- (void)zoomBig
{
    CATransform3D transform = CATransform3DMakeAffineTransform(CGAffineTransformMakeScale(1.16, 1.16));
    self.layer.transform = transform;
    CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    animation.toValue = [NSValue valueWithCATransform3D:transform];
    animation.duration = .2;
    [self.layer addAnimation:animation forKey:nil];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.2];
    self.alpha = .6;
    [UIView commitAnimations];
}

- (void)zoomSmall
{
    if (CGSizeEqualToSize(self.frame.size, self.home.size))
    {
        return;
    }
    CATransform3D transform = CATransform3DMakeAffineTransform(CGAffineTransformMakeScale(1.16, 1.16));
    self.layer.transform = CATransform3DIdentity;
    CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    if (self.editing)
    {
        animation.removedOnCompletion = NO;
        [animation setDelegate:self];
    }
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.fromValue = [NSValue valueWithCATransform3D:transform];
    animation.toValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    animation.duration = .2;
    [self.layer addAnimation:animation forKey:AnimationKeyZoomSmall];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.2];
    self.alpha = 1;
    [UIView commitAnimations];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if ([self.layer animationForKey:AnimationKeyZoomSmall] == anim)
    {
        [self.layer removeAnimationForKey:AnimationKeyZoomSmall];
        if (self.isEditing)
        {
            [self startShake];
        }
    }
}

- (void)longPressCanceled
{
    [self.trackTimer invalidate];
    [self.maybeTrackTimer invalidate];
    self.maybeTrackTimer = nil;
    self.trackTimer = nil;
    _touchPoint = CGPointZero;
}

- (void)longPressFinished
{
    _editing = YES;
    _tracking = YES;
    self.removeBtn.hidden = NO;
    [self.trackTimer invalidate];
    self.trackTimer = nil;
    
    if ([self.delegate respondsToSelector:@selector(sortUnitViewStartedTracking:)])
    {
        [self.delegate sortUnitViewStartedTracking:self];
    }
    [self zoomBig];
}

- (void)maybeTrack
{
    [self.maybeTrackTimer invalidate];
    self.maybeTrackTimer = nil;
    if ([self.delegate respondsToSelector:@selector(sortUnitViewMaybeTrack:)])
    {
        [self.delegate sortUnitViewMaybeTrack:self];
    }
}

- (BOOL)isLongPress
{
    return [self.trackTimer isValid];
}

- (BOOL)configTouchesForLongPress:(NSSet *)touches
{
    CGPoint point = [[touches anyObject] locationInView:self];
    if (CGRectContainsPoint(self.imageCover.frame, point))
    {
        _touchPoint = point;
        return YES;
    }
    return NO;
}

- (BOOL)touchesOKForDrag:(NSSet *)touches
{
    CGPoint point = [[touches anyObject] locationInView:self];
    return CGRectContainsPoint(self.imageCover.frame, point);
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.isEditingEnabled)
    {
        if (!self.isEditing)
        {
            if ([self configTouchesForLongPress:touches])
            {
                [self setHighlighted:YES];
                [self.trackTimer invalidate];
                self.trackTimer = [NSTimer scheduledTimerWithTimeInterval:LongPress_Duration target:self selector:@selector(longPressFinished) userInfo:nil repeats:NO];
                self.maybeTrackTimer = [NSTimer scheduledTimerWithTimeInterval:LongPress_Duration / 2 target:self selector:@selector(maybeTrack) userInfo:nil repeats:NO];
            }
        }
        else if ([self touchesOKForDrag:touches])
        {
//            self.tracking = YES;
            [self checkTracking];
        }
    }
    else
    {
        [self setHighlighted:YES];
    }
}

- (void)checkTracking
{
    self.checkTrackTimer = [NSTimer scheduledTimerWithTimeInterval:CheckTrackingTime target:self selector:@selector(checkTrackingOver) userInfo:nil repeats:NO];
}

- (void)checkTrackingOver
{
    self.tracking = YES;
}

- (void)setTracking:(BOOL)tracking
{
    if (_tracking != tracking)
    {
        if (tracking)
        {
            _tracking = tracking;
            [self setHighlighted:YES];
            [self stopShake];
            [self zoomBig];
            if ([self.delegate respondsToSelector:@selector(sortUnitViewStartedTracking:)])
            {
                [self.delegate sortUnitViewStartedTracking:self];
            }
        }
        else if([self.delegate sortUnitViewStoppedTracking:self])
        {
            _tracking = tracking;
            [self zoomSmall];
            [self goHome];
            _dragging = NO;
        }
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.isEditingEnabled)
    {
        if (!self.isEditing)
        {
            if ([self isLongPress])
            {
                if (![self configTouchesForLongPress:touches])
                {
                    [self longPressCanceled];
                    [self touchesCancelled:touches withEvent:event];
                }
            }
        }
        else if (self.isTracking)
        {
            CGPoint newTouchPoint = [[touches anyObject] locationInView:self];
            if (_dragging)
            {
                float deltaX = newTouchPoint.x - _touchPoint.x;
                float deltaY = newTouchPoint.y - _touchPoint.y;
                [self moveByOffset:CGPointMake(deltaX, deltaY)];
            }
            else if (distanceBetweenPoints(_touchPoint, newTouchPoint) > DRAG_THRESHOLD)
            {
                _touchPoint = newTouchPoint;
                _dragging = YES;
            }
        }
        else
        {
            [self.checkTrackTimer invalidate];
            if([self touchesOKForDrag:touches])
            {
                self.tracking = YES;
            }
        }
    }

}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.checkTrackTimer invalidate];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.3];
    [self setHighlighted:NO];
    [UIView commitAnimations];
    UITouch * touch = [touches anyObject];
    if ([touch tapCount] == 1)
    {
        CGPoint point = [touch locationInView:self];
        if (CGRectContainsPoint(self.imageCover.frame, point))
        {
            if ([self.delegate respondsToSelector:@selector(sortUnitImageClicked:)])
            {
                [self.delegate sortUnitImageClicked:self];
            }
        }
        else if (CGRectContainsPoint(self.titleLabel.frame, point))
        {
            if ([self.delegate respondsToSelector:@selector(sortUnitTitleClicked:)])
            {
                [self.delegate sortUnitTitleClicked:self];
            }
        }
    }
    if (self.isEditingEnabled)
    {
        if (!self.isEditing)
        {
            if ([self isLongPress])
            {
                [self longPressCanceled];
            }
        }
        else
        {
            self.tracking = NO;
        }
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self setHighlighted:NO];
    if (self.editing)
    {
        self.tracking = NO;
    }
}

- (void)moveByOffset:(CGPoint)offset
{
    CGRect frame = [self frame];
    frame.origin.x += offset.x;
    frame.origin.y += offset.y;
    [self setFrame:frame];
    if ([self.delegate respondsToSelector:@selector(sortUnitViewMoved:offset:)])
    {
        [self.delegate sortUnitViewMoved:self offset:offset];
    }
}

- (void)setEditing:(BOOL)editing
{
    if (self.isEditing != editing)
    {
        _editing = editing;
        if (_editing)
        {
            if (![self isLongPress] && !self.isDragging)
            {
                [self startShake];
            }
        }
        else
        {
            [self setSelected:NO];
            [self stopShake];
            [self zoomSmall];
        }
        self.removeBtn.hidden = !editing;
    }
}

- (void)removeAnimFinished
{
    [self removeFromSuperview];
}

- (void)remove
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:.2];
    [UIView setAnimationDidStopSelector:@selector(removeAnimFinished)];
    self.transform = CGAffineTransformMakeScale(.2, .2);
    [UIView commitAnimations];
}


- (void)setEditingEnabled:(BOOL)editingEnabled
{
    if (self.isEditingEnabled != editingEnabled)
    {
        if (!editingEnabled)
        {
            if (self.isEditing)
            {
                self.editing = NO;
            }
        }
        _editingEnabled = editingEnabled;
    }
}

@end
