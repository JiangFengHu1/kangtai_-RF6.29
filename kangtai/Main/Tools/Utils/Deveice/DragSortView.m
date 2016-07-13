//
//
/**
 * Copyright (c) www.bugull.com
 */
//
//

#import "DragSortView.h"
#import "SortUnitView.h"
#import "SortUnitPage.h"
#import "SocketOperation.h"
#define PagingHoldDistance 32
#define CheckInsertDuration .2
#define CheckPagingDuration .4
#define CheckTopDuration    .4
#define TrackInterval       .1

#define TopMore             32

@class SortUnitPage;

@interface SortUnitView(DragSortView)

@property (readonly,nonatomic) CGPoint touchPoint;
@property (weak,nonatomic) id delegate;

- (void)setHome:(CGRect)home;
- (void)setSortUnit:(id<SortUnit>)sortUnit;
- (void)goHome;
- (void)startShake;
- (void)stopShake;
- (void)remove;
- (void)refreshContent;

- (void)setTracking:(BOOL)tracking;

@end

@interface DragSortView() <UIScrollViewDelegate,SortUnitViewDelegate>
{
    CGFloat horizontalMargin;
    NSInteger horizontalCount;
    NSInteger verticalCount;
    NSInteger maxCountInPage;
    
    NSInteger totalPage;
    
    CGPoint insertLocation;
    NSInteger insertIndex;
    BOOL inserting;
    BOOL checkingInsert;
    
    BOOL paging;
    BOOL checkingPaging;
    BOOL pagingToLeft;
    
    BOOL checkingDelete;
    BOOL checkingEdit;
    
    CGRect _delFrame;
    CGRect _editFrame;
    CGRect _topFrame;
    BOOL checkingTop;
    BOOL needCheckTop;
    BOOL topRunning;
    
    CGPoint trackLocation;
    SortUnitView * trackUnitView;
    SortUnitPage * trackPage;
}

@property (strong,nonatomic) UIScrollView * scroll;
@property (strong,nonatomic) UIImageView * backgroundImageView;
@property (strong,nonatomic) UIPageControl * pageControl;

@property (strong,nonatomic) NSMutableArray * sortUnitPages;

@property (strong,nonatomic) NSTimer * checkInsertTimer;
@property (strong,nonatomic) NSTimer * checkPagingTimer;
@property (strong,nonatomic) NSTimer * trackTimer;

@property (strong,nonatomic) NSTimer * checkTopTimer;

@property (nonatomic) CGSize homeSize;

- (void)frontSortUnitView:(SortUnitView *)sortUnitView;

- (NSArray *)allUnitViews;

@end


@implementation DragSortView

- (NSArray *)allUnitViews
{
    NSMutableArray * unitViews = [NSMutableArray array];
    for (SortUnitPage * page in self.sortUnitPages)
    {
        [unitViews addObjectsFromArray:page.sortUnitViews];
    }
    return unitViews;
}

- (void)setEditing:(BOOL)editing
{
    if ((!self.editingEnabled && editing) || self.editing == editing)
    {
        return;
    }
    for (SortUnitPage * page in self.sortUnitPages)
    {
        page.editing = editing;
    }
    _editing = editing;
    [self resetAddViews];
    if (_editing)
    {
        [self.delegate dragSortViewBecameEditing:self];
    }
    else
    {
        [_selectedUnitView setSelected:NO];
        _selectedUnitView = nil;
        trackUnitView = nil;
        [self.delegate dragSortViewEndEditing:self];
    }
}

- (void)setEditingEnabled:(BOOL)editingEnabled
{
    if (editingEnabled != _editingEnabled)
    {
        if (!_editingEnabled && self.editing)
        {
            self.editing = NO;
        }
        _editingEnabled = editingEnabled;
        NSArray * allUnitViews = [self allUnitViews];
        for (SortUnitView * unitView in allUnitViews)
        {
            unitView.editingEnabled = editingEnabled;
        }
    }
}

- (void)checkEmptyPage
{
    if (!self.trackTimer.isValid)
    {
        for (NSInteger i = self.sortUnitPages.count - 1; i >= 0; i--)
        {
            SortUnitPage * unitPage = [self.sortUnitPages objectAtIndex:i];
            if (unitPage.count == 0)
            {
                [self deletePage:i];
            }
        }
    }
}

- (void)frontSortUnitView:(SortUnitView *)sortUnitView
{
    CGRect frame =  sortUnitView.frame;
    frame.origin.x = frame.origin.x - sortUnitView.sortUnit.page * self.bounds.size.width;
    frame.origin.y = frame.origin.y - TopMore;
    sortUnitView.frame = frame;
    [self addSubview:sortUnitView];
}

- (void)sortUnitViewMaybeTrack:(SortUnitView *)unitView
{
    self.scroll.scrollEnabled = NO;
}

- (void)sortUnitImageClicked:(SortUnitView *)unitView
{
//    NSLog(@"sortUnitImageClicked");
    if (self.editing && _selectedUnitView != unitView)
    {
        [_selectedUnitView setSelected:NO];
        _selectedUnitView = unitView;
        [_selectedUnitView setSelected:YES];
    }
    [self.delegate dragSortView:self unitViewClicked:unitView];
}

- (void)sortUnitRemoveBtnClicked:(SortUnitView *)unitView
{
    SortUnitPage * unitPage = [self.sortUnitPages objectAtIndex:unitView.sortUnit.page];
    [unitPage deleteSortUnit:unitView.sortUnit];
}

- (void)sortUnitTitleClicked:(SortUnitView *)unitView
{
    NSLog(@"sortUnitTitleClicked");
}

- (void)returnUnitView:(SortUnitView *)sortUnitView
{
    CGRect frame = sortUnitView.frame;
    frame.origin.x = frame.origin.x + sortUnitView.sortUnit.page * self.bounds.size.width;
    frame.origin.y = frame.origin.y + TopMore;
    sortUnitView.frame = frame;
    [self.scroll addSubview:sortUnitView];
}

- (void)sortUnitViewStartedTracking:(SortUnitView *)unitView
{
    [_selectedUnitView setSelected:NO];
    _selectedUnitView = unitView;
    [_selectedUnitView setSelected:YES];
    trackUnitView = unitView;
    trackPage = [self.sortUnitPages objectAtIndex:unitView.sortUnit.page];
    self.scroll.scrollEnabled = NO;
    [self frontSortUnitView:unitView];
    [self refreshTrackLocation];
    self.editing = YES;
    [self.trackTimer invalidate];
    self.trackTimer = [NSTimer scheduledTimerWithTimeInterval:TrackInterval target:self selector:@selector(tracking) userInfo:nil repeats:YES];
}

- (NSInteger)indexForLocation:(CGPoint)location
{
    return location.y * horizontalCount + MIN(location.x, horizontalCount -1);
}

- (NSInteger)insertIndexForLocation:(CGPoint)location
{
    NSInteger index = trackUnitView.sortUnit.index;
    NSInteger newIndex = location.y * horizontalCount + MIN(location.x, horizontalCount -1);
    if (newIndex > trackPage.count - 1)
    {
        newIndex = trackPage.count - 1 ;
    }
    else
    {
        if (newIndex > index && location.x != 0 && location.x != horizontalCount)
        {
            newIndex -- ;
        }
    }
    return MAX(0, newIndex);
}

- (void)updateInsert
{
    if ([self insertIndexForLocation:trackLocation] != insertIndex)
    {
        self.checkInsertTimer = nil;
        checkingInsert = NO;
    }
    if (!checkingInsert)
    {
        [self.checkInsertTimer invalidate];
        self.checkInsertTimer = nil;
    }
}

- (void)configInsert
{
    checkingInsert = NO;
    CGRect bigFrame = [self bigFrameForIndex:trackUnitView.sortUnit.index];
    BOOL outside = !CGRectContainsPoint(bigFrame, trackUnitView.center);
    if (outside)
    {
        NSInteger newIndex = [self insertIndexForLocation:trackLocation];
        if (trackUnitView.sortUnit.index != newIndex)
        {
            checkingInsert = YES;
            insertLocation = trackLocation;
            insertIndex = newIndex;
            [self.checkInsertTimer invalidate];
            self.checkInsertTimer = [NSTimer scheduledTimerWithTimeInterval:CheckInsertDuration target:self selector:@selector(checkInsertOver) userInfo:nil repeats:NO];
            
        }
    }
}

- (void)checkPagingOver
{
    if (checkingPaging)
    {
        paging = YES;
        self.checkInsertTimer = nil;
        if (checkingInsert)
        {
            [self.checkInsertTimer invalidate];
            self.checkInsertTimer = nil;
            checkingInsert = NO;
        }
        if (pagingToLeft)
        {
            [self.scroll setContentOffset:CGPointMake(self.bounds.size.width * (trackUnitView.sortUnit.page - 1), 0) animated:YES];
            _currentPage --;
        }
        else
        {
            if (_currentPage == totalPage - 1)
            {
                [self addNewPage];
            }
            [self.scroll setContentOffset:CGPointMake(self.bounds.size.width * (trackUnitView.sortUnit.page + 1), 0) animated:YES];
            _currentPage ++;
        }
    }
}

- (void)updatePaging
{
    if (![self checkPaging:pagingToLeft])
    {
        [self.checkPagingTimer invalidate];
        self.checkPagingTimer = nil;
    }
}

- (BOOL)checkPaging:(BOOL)leftDirection
{
    if (leftDirection)
    {
        checkingPaging = trackLocation.x == 0 && ( trackUnitView.sortUnit.page > 0 && (trackUnitView.frame.origin.x < -PagingHoldDistance || trackUnitView.frame.origin.x + trackUnitView.touchPoint.x < PagingHoldDistance));
    }
    else
    {
        checkingPaging = trackLocation.x == horizontalCount && (trackPage.page < totalPage - 1 || [trackPage count] > 1) && (trackUnitView.frame.origin.x + trackUnitView.frame.size.width - self.bounds.size.width > PagingHoldDistance ||self.bounds.size.width - (trackUnitView.frame.origin.x + trackUnitView.touchPoint.x) < PagingHoldDistance);
    }
    return checkingPaging;
}

- (void)configPaging
{
    checkingPaging = NO;
    if ([self checkPaging:YES])
    {
        pagingToLeft = YES;
    }
    else if ([self checkPaging:NO])
    {
        pagingToLeft = NO;
    }
    
    if (checkingPaging)
    {
        [self.checkPagingTimer invalidate];
        self.checkPagingTimer = [NSTimer scheduledTimerWithTimeInterval:CheckPagingDuration target:self selector:@selector(checkPagingOver) userInfo:nil repeats:NO];
    }
}

- (void)checkPageControlVisible
{
    self.pageControl.hidden = totalPage < 2;
}

- (void)addNewPage
{
    SortUnitPage * newPage = [[SortUnitPage alloc] init];
    newPage.page = self.sortUnitPages.count;

    newPage.dragSortView = self;
    [self.sortUnitPages addObject:newPage];
    totalPage = self.sortUnitPages.count;
    self.pageControl.numberOfPages = totalPage;
    self.scroll.contentSize = CGSizeMake(self.bounds.size.width * totalPage, self.bounds.size.height);
    [self checkPageControlVisible];
}

- (void)insertOver
{
    if (inserting)
    {
        inserting = NO;
    }
}

- (void)checkInsertOver
{
    if (checkingInsert && trackUnitView)
    {
        inserting = YES;
        self.checkInsertTimer = nil;
        [trackPage moveSortUnitView:trackUnitView toIndex:insertIndex];
        [self performSelector:@selector(insertOver) withObject:nil afterDelay:.2];
    }
    checkingInsert = NO;
}

- (void)tracking
{
    if (!trackUnitView)
    {
        [_trackTimer invalidate];
        _trackTimer = nil;
    }
    if (!paging)
    {
        if (!inserting)
        {
            if (needCheckTop)
            {
                if (!checkingTop)
                {
                    [self configTop];
                }
                else
                {
                    [self updateTop];
                }
            }
            if (!checkingInsert)
            {
                [self configInsert];
            }
            else
            {
                [self updateInsert];
            }

        }
        if (!checkingPaging)
        {
            [self configPaging];
        }
        else
        {
            [self updatePaging];
        }
    }
}

- (void)configTop
{
    checkingTop = NO;
    CGPoint point = [self.scroll convertPoint:trackUnitView.imageView.center fromView:trackUnitView.contentView];
    point.x -= self.currentPage * self.bounds.size.width;;
    if (CGRectContainsPoint(_delFrame, point))
    {
        _topFrame = _delFrame;
        checkingTop = YES;
    }
    else if (CGRectContainsPoint(_editFrame, point))
    {
        _topFrame = _editFrame;
        checkingTop = YES;
    }
    if (checkingTop)
    {
        _topFrame.origin.x += self.currentPage * self.bounds.size.width;
        _checkTopTimer = [NSTimer scheduledTimerWithTimeInterval:CheckTopDuration target:self selector:@selector(checkTopOver) userInfo:nil repeats:NO];
    }
}

- (void)updateTop
{
    if (!trackUnitView || !CGRectContainsPoint(_topFrame, [self.scroll convertPoint:trackUnitView.imageView.center fromView:trackUnitView.contentView]))
    {
        [_checkTopTimer invalidate];
        checkingTop = NO;
    }
}

- (void)checkTopOver
{
    checkingTop = NO;
    if (trackUnitView)
    {
        self.userInteractionEnabled = NO;
        topRunning = YES;
        if (CGRectEqualToRect(_topFrame, _editFrame))
        {
            [self.delegate editUnitView:trackUnitView];
        }
        else
        {
            [self.delegate deleteSortUnitView:trackUnitView];
        }
    }
}


- (void)refreshTrackLocation
{
    NSInteger horizontal = (trackUnitView.frame.origin.x - Min_Outter_Margin + self.homeSize.width + horizontalMargin) / (self.homeSize.width + horizontalMargin * 2);
    NSInteger vertical = (trackUnitView.frame.origin.y - Min_Outter_Margin - TopMore + self.homeSize.height / 2) / self.homeSize.height;
    trackLocation = CGPointMake(horizontal, vertical);
}

- (void)sortUnitViewMoved:(SortUnitView *)unitView offset:(CGPoint)offset
{
    [self refreshTrackLocation];
    [self tracking];
}

- (BOOL)sortUnitViewStoppedTracking:(SortUnitView *)unitView
{
    [unitView setHighlighted:NO];
    [self.trackTimer invalidate];
    self.trackTimer = nil;
    if (paging && unitView.sortUnit.page != _currentPage)
    {
        [self pageAction];
    }
    [self returnUnitView:unitView];
    paging = NO;
    inserting = NO;
    [self.checkPagingTimer invalidate];
    [self.checkInsertTimer invalidate];
    [self.checkTopTimer invalidate];
    checkingPaging = NO;
    checkingInsert = NO;
    checkingTop = NO;
    self.scroll.scrollEnabled = YES;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(checkEmptyPage) object:nil];
    [self performSelector:@selector(checkEmptyPage) withObject:nil afterDelay:.3];
    if (topRunning)
    {
        [self frontSortUnitView:unitView];
        return NO;
    }
    trackUnitView = nil;
    trackPage = nil;
    return YES;
}

- (BOOL)isEditing:(SortUnitView *)unitView
{
    return _editing;
}

- (void)initialize
{
    self.backgroundColor = [UIColor clearColor];
    self.exclusiveTouch = YES;
    self.backgroundImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    self.backgroundImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self addSubview:self.backgroundImageView];
    
//    self.scroll = [[UIScrollView alloc] initWithFrame:self.bounds];
    self.scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, -TopMore, self.bounds.size.width, self.bounds.size.height + TopMore)];
    self.scroll.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.scroll.backgroundColor = [UIColor clearColor];
    self.scroll.showsHorizontalScrollIndicator = NO;
    self.scroll.showsVerticalScrollIndicator = NO;
    self.scroll.bounces = NO;
    self.scroll.pagingEnabled = YES;
    self.scroll.delegate = self;
    [self addSubview:self.scroll];
    
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.bounds.size.height - 36, self.bounds.size.width, 36)];
    self.pageControl.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    [self.pageControl addTarget:self action:@selector(page) forControlEvents:UIControlEventValueChanged];
    [self addSubview:self.pageControl];
    
    self.sortUnitPages = [NSMutableArray array];
}

- (void)setBackgroundImage:(UIImage *)backgroundImage
{
    _backgroundImage = backgroundImage;
    self.backgroundImageView.image = backgroundImage;
}

- (void)setDelegate:(id<DragSortViewDelegate>)delegate
{
    _delegate = delegate;
}

- (NSInteger)horizontalCountForImgSize:(CGSize)imgSize
{
    return (self.bounds.size.width - Min_Outter_Margin * 2) / self.homeSize.width;
}

- (CGRect)homeForIndex:(NSInteger)index page:(NSInteger)page
{
    CGFloat horizontal = index % horizontalCount;
    CGFloat vertical = index / horizontalCount;
    return CGRectMake(page * self.bounds.size.width + Min_Outter_Margin + (horizontal * 2 + 1) * horizontalMargin + horizontal * self.homeSize.width , Min_Outter_Margin + vertical * self.homeSize.height + TopMore, self.homeSize.width, self.homeSize.height);
}

- (void)checkIndexAndGohome:(SortUnitView *)sortUnitView
{
    if (sortUnitView.sortUnit.index >= maxCountInPage)
    {
        NSInteger pageIndex = sortUnitView.sortUnit.page;
        SortUnitPage * oldPage = [self.sortUnitPages objectAtIndex:pageIndex];
        SortUnitPage * toPage = nil;
        while (!toPage)
        {
            if (pageIndex == totalPage - 1)
            {
                [self addNewPage];
                toPage = [self.sortUnitPages lastObject];
            }
            else
            {
                toPage = [self.sortUnitPages objectAtIndex:pageIndex + 1];
            }
            pageIndex = toPage.page;
            if (toPage.sortUnits.count == maxCountInPage)
            {
                toPage = nil;
            }
        }
        [oldPage removeSortUnitView:sortUnitView];
        [toPage addSortUnitView:sortUnitView];
    }
    else
    {
        [sortUnitView setHome:[self homeForIndex:sortUnitView.sortUnit.index page:sortUnitView.sortUnit.page]];
        [sortUnitView goHome];
    }
}

- (CGRect)bigFrameForIndex:(NSInteger)index
{
    CGFloat horizontal = index % horizontalCount;
    CGFloat vertical = index / horizontalCount;
    return CGRectMake(Min_Outter_Margin + horizontal * (2 * horizontalMargin + self.homeSize.width) , Min_Outter_Margin + vertical * self.homeSize.height + TopMore, self.homeSize.width + 2 * horizontalMargin, self.homeSize.height);
}


- (NSArray *)sortUnitsInPage:(NSInteger)page
{
    if (page >= totalPage)
    {
        return nil;
    }
    SortUnitPage * unitPage = [self.sortUnitPages objectAtIndex:page];
    return [NSArray arrayWithArray:unitPage.sortUnits];
}

- (id<SortUnit>)sortUnitAtIndex:(NSInteger)index page:(NSInteger)page
{
    if (page >= totalPage)
    {
        return nil;
    }
    SortUnitPage * unitPage = [self.sortUnitPages objectAtIndex:page];
    if (index >= [unitPage count])
    {
        return nil;
    }
    return [unitPage.sortUnits objectAtIndex:index];
}

- (void)initPages
{
    for (SortUnitPage * unitPage in self.sortUnitPages)
    {
        unitPage.dragSortView = self;
        if (unitPage.sortUnits.count > 0)
        {
            for (NSInteger index = 0; index < unitPage.sortUnits.count; index++)
            {
                id<SortUnit> sortUnit = [unitPage.sortUnits objectAtIndex:index];
                sortUnit.page = unitPage.page;
                sortUnit.index = index;
                SortUnitView * unitView = [self unitViewForUnit:sortUnit];
                unitView.editingEnabled = _editingEnabled;
                [unitPage.sortUnitViews addObject:unitView];
                [self.scroll addSubview:unitView];
            }
        }
    }
}

- (void)resetAddViews
{
    if (!self.editing && [self.delegate respondsToSelector:@selector(addViewForDragSortView:)])
    {
        for (SortUnitPage * unitPage in self.sortUnitPages)
        {
            if (unitPage.sortUnits.count < maxCountInPage)
            {
                if (!unitPage.addView)
                {
                    unitPage.addView = [self.delegate addViewForDragSortView:self];
                }
                unitPage.addView.hidden = NO;
                unitPage.addView.frame = [self homeForIndex:unitPage.sortUnits.count page:unitPage.page];
                [self.scroll addSubview:unitPage.addView];
            }
            else
            {
                unitPage.addView.hidden = YES;
            }
        }
    }
    else
    {
        for (SortUnitPage * unitPage in self.sortUnitPages)
        {
            unitPage.addView.hidden = YES;
        }
    }
}

- (SortUnitView *)unitViewForUnit:(id<SortUnit>)sortUnit
{
    SortUnitView * unitView = [self.delegate dragSortView:self unitViewForUnit:sortUnit];
    [unitView setSortUnit:sortUnit];
    [unitView setHome:[self homeForIndex:sortUnit.index page:sortUnit.page]];
    unitView.frame = unitView.home;
    [unitView refreshContent];
    unitView.delegate = self;
    return unitView;
}

- (void)reloadData
{
    for (SortUnitPage * page in self.sortUnitPages)
    {
        for (SortUnitView * sortUnitView in page.sortUnitViews)
        {
            [sortUnitView removeFromSuperview];
        }
    }
    [self.sortUnitPages removeAllObjects];
    self.scroll.contentOffset = CGPointZero;
    
    self.homeSize = [self.delegate homeSizeInDragSortView:self];
    horizontalCount = (self.bounds.size.width - Min_Outter_Margin * 2) / self.homeSize.width;
    verticalCount = (self.bounds.size.height - self.pageControl.frame.size.height - Min_Outter_Margin * 2) / (self.homeSize.height + Min_Outter_Margin);
    horizontalMargin = roundf((self.bounds.size.width - horizontalCount * self.homeSize.width - Min_Outter_Margin * 2) / horizontalCount / (horizontalCount * 2));
    maxCountInPage = horizontalCount * verticalCount;
    
    NSArray * allSortUnits = [self.delegate sortUnitsInDragSortView:self];
    if (allSortUnits.count > 0)
    {
        NSInteger page = 0;
        NSInteger addCount = 0;
        NSMutableArray * moreSortUnits = [NSMutableArray array];
        do
        {
            NSMutableArray * sortUnits = [NSMutableArray array];
            for (NSInteger index = 0; index < allSortUnits.count; index ++)
            {
                id<SortUnit> sortUnit = [allSortUnits objectAtIndex:index];
                if ([sortUnit page] == page)
                {
                    [sortUnits addObject:sortUnit];
                }
            }
            if (sortUnits.count > 0)
            {
                [sortUnits sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
//                    if ([obj1 index] < [obj2 index])
//                    {
//                        return NSOrderedAscending;
//                    }
//                    else if ([obj1 index] > [obj2 index])
//                    {
//                        return NSOrderedDescending;
//                    }
                    return NSOrderedSame;
                }];
                [moreSortUnits addObjectsFromArray:sortUnits];
            }
            SortUnitPage * unitPage = [[SortUnitPage alloc] init];
            unitPage.page = page;
            if (moreSortUnits.count > 0)
            {
                if (moreSortUnits.count <= maxCountInPage)
                {
                    [unitPage.sortUnits addObjectsFromArray:moreSortUnits];
                    addCount += moreSortUnits.count;
                    [moreSortUnits removeAllObjects];
                }
                else
                {
                    [unitPage.sortUnits addObjectsFromArray:[moreSortUnits subarrayWithRange:NSMakeRange(0, maxCountInPage)]];
                    addCount += maxCountInPage;
                    [moreSortUnits removeObjectsInRange:NSMakeRange(0, maxCountInPage)];
                }
            }
            [self.sortUnitPages addObject:unitPage];
            page++;
        }
        while (addCount < allSortUnits.count);
        totalPage = page;
        [self refreshContentSize];
        [self initPages];
        [self resetAddViews];
    }
    self.pageControl.numberOfPages = totalPage;
    self.pageControl.currentPage = 0;
    _currentPage = 0;
    [self checkPageControlVisible];
}

- (void)reloadSortUnit:(id<SortUnit>)unit
{
    [[[[_sortUnitPages objectAtIndex:[unit page]] sortUnitViews] objectAtIndex:[unit index]] refreshContent];
}

- (BOOL)addSortUnit:(id<SortUnit>)sortUnit inPage:(NSInteger)page
{
    if (page <= totalPage)
    {
        BOOL added = NO;
        for (NSInteger p = page; p < totalPage; p++)
        {
            SortUnitPage * unitPage = [self.sortUnitPages objectAtIndex:p];
            if ([unitPage count] < maxCountInPage)
            {
                [unitPage addSortUnit:sortUnit];
                added = YES;
                break;
            }
        }
        if (!added)
        {
            SortUnitPage * unitPage = [[SortUnitPage alloc] init];
            unitPage.page = totalPage;
            [self.sortUnitPages addObject:unitPage];
            totalPage ++;
            self.scroll.contentSize = CGSizeMake(totalPage * self.bounds.size.width, self.bounds.size.height);
            [unitPage addSortUnit:sortUnit];
        }
        return YES;
    }
    return NO;
}

- (BOOL)deleteSortUnit:(id<SortUnit>)sortUnit
{
    if (sortUnit.page >= totalPage)
    {
        return NO;
    }
    SortUnitPage * unitPage = [self.sortUnitPages objectAtIndex:sortUnit.page];
    return [unitPage deleteSortUnit:sortUnit];
}

- (BOOL)updateSortUnit:(id<SortUnit>)sortUnit
{
    if (sortUnit.page >= totalPage)
    {
        return NO;
    }
    SortUnitPage * unitPage = [self.sortUnitPages objectAtIndex:sortUnit.page];
    return [unitPage updateSortUnit:sortUnit];
}

- (void)refreshContentSize
{
    self.scroll.contentSize = CGSizeMake(self.bounds.size.width * totalPage, self.scroll.bounds.size.height);
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self refreshContentSize];
    for (SortUnitPage * page in self.sortUnitPages)
    {
        for (SortUnitView * unitView in page.sortUnitViews)
        {
            if (unitView != trackUnitView)
            {
                unitView.frame = unitView.home;
            }
        }
        if (page.addView)
        {
            page.addView.frame = [self homeForIndex:page.sortUnits.count page:page.page];
        }
    }
}

- (void)deletePage:(NSInteger)page
{
    if (totalPage > 1)
    {
        BOOL delayRefreshContentSize = NO;
        if (_currentPage == page)
        {
            if (_currentPage < totalPage - 1)
            {
                SortUnitPage * nextPage = [self.sortUnitPages objectAtIndex:_currentPage + 1];
                [nextPage changePage:_currentPage animated:YES];
                delayRefreshContentSize = YES;
            }
            else if (_currentPage > 0)
            {
                [self moveToPage:_currentPage - 1 animated:YES];
                delayRefreshContentSize = YES;
            }
        }
        SortUnitPage * unitPage = [self.sortUnitPages objectAtIndex:page];
        [unitPage clear];
        [self.sortUnitPages removeObjectAtIndex:page];
        totalPage --;
        for (NSInteger i = page; i < totalPage; i++)
        {
            SortUnitPage * page = [self.sortUnitPages objectAtIndex:i];
            [page changePage:i animated:NO];
        }
        self.pageControl.numberOfPages = totalPage;
        if (delayRefreshContentSize)
        {
            [self performSelector:@selector(refreshContentSize) withObject:nil afterDelay:.3];
        }
        else
        {
            [self refreshContentSize];
        }
        [self performSelector:@selector(checkPageControlVisible) withObject:nil afterDelay:.3];
    }
}

- (NSInteger)countInPage:(NSInteger)page
{
    if (page >= totalPage)
    {
        return 0;
    }
    return [[self.sortUnitPages objectAtIndex:page] count];
}

- (NSInteger)numberOfPages
{
    return totalPage;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self initialize];
    }
    return self;
}

- (void)moveToPage:(NSInteger)page animated:(BOOL)animated
{
    if (page < totalPage)
    {
        [self.scroll setContentOffset:CGPointMake(self.bounds.size.width * page, 0) animated:animated];
    }
}

- (void)setDelFrame:(CGRect)delFrame editFrame:(CGRect)editFrame
{
    _delFrame = delFrame;
    _editFrame = editFrame;
    needCheckTop = !CGRectIsEmpty(delFrame);
}

- (void)pageOver
{
    paging = NO;
    checkingPaging = NO;
}

- (void)pageAction
{
    [trackPage removeSortUnitView:trackUnitView];
    trackPage = pagingToLeft ? [self.sortUnitPages objectAtIndex:trackPage.page - 1] : [self.sortUnitPages objectAtIndex:trackPage.page + 1];
    [trackPage addSortUnitView:trackUnitView atIndex:[self indexForLocation:trackLocation]];
}

- (void)topRunover:(BOOL)del
{
    self.userInteractionEnabled = YES;
    topRunning = NO;
    if (!del)
    {
        [trackUnitView setTracking:NO];
    }
    else
    {
        [self deleteSortUnit:_selectedUnitView.sortUnit];
        trackUnitView = nil;
        trackPage = nil;
    }
    
}

#pragma scroll

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self scrollViewDidEndDecelerating:scrollView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    _currentPage =roundf(scrollView.contentOffset.x / scrollView.bounds.size.width);
    self.pageControl.currentPage = _currentPage;
    if (paging)
    {
        [self pageAction];
        [self performSelector:@selector(pageOver) withObject:nil afterDelay:.12];
    }
}

#pragma pageControl
- (void)page
{
    [self moveToPage:self.pageControl.currentPage animated:YES];
}

@end
