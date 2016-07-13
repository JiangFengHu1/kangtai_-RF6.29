//
//
/**
 * Copyright (c) www.bugull.com
 */
//
//

#import "SortUnitPage.h"

@interface SortUnitView(UnitPage)

- (void)setHome:(CGRect)home;
- (void)goHome;
- (void)startShake;
- (void)stopShake;
- (void)refreshContent;
- (void)remove;

@end

@interface DragSortView(UnitPage)

- (void)checkIndexAndGohome:(SortUnitView *)sortUnitView;
- (CGRect)homeForIndex:(NSInteger)index page:(NSInteger)page;
- (SortUnitView *)unitViewForUnit:(id<SortUnit>)sortUnit;
- (void)checkEmptyPage;

@end

@implementation SortUnitPage

- (NSInteger)count
{
    return self.sortUnits.count;
}

- (void)clear
{
    for (SortUnitView * unitView in self.sortUnitViews)
    {
        [unitView removeFromSuperview];
    }
    [self.sortUnitViews removeAllObjects];
    [self.sortUnits removeAllObjects];
    [_addView removeFromSuperview];
    _addView = nil;
}

- (void)changePage:(NSInteger)newPage animated:(BOOL)animated
{
    if (newPage != self.page)
    {
        CGFloat pageWidth = self.dragSortView.bounds.size.width;
        for (SortUnitView * sortUnitView in self.sortUnitViews)
        {
            CGRect home = sortUnitView.home;
            home.origin.x += ((newPage - sortUnitView.sortUnit.page) * pageWidth);
            [sortUnitView setHome:home];
            sortUnitView.sortUnit.page = newPage;
            if (animated)
            {
                [sortUnitView goHome];
            }
            else
            {
                sortUnitView.frame = sortUnitView.home;
            }
        }
        self.page = newPage;
    }
}

- (void)setEditing:(BOOL)editing
{
    if (_editing != editing)
    {
        _editing = editing;
        for (SortUnitView * unitView in self.sortUnitViews)
        {
            unitView.editing = editing;
        }
    }
}

- (void)checkAndGoHomeInRange:(NSRange)range
{
    for (int i = 0; i < range.length; i++)
    {
        NSInteger index = range.location + i;
        SortUnitView * unitView = [self.sortUnitViews objectAtIndex:index];
        if (unitView.sortUnit.index != index)
        {
            unitView.sortUnit.index = index;
            [self.dragSortView checkIndexAndGohome:unitView];
        }
    }
}

- (void)moveSortUnitView:(SortUnitView *)sortUnitView toIndex:(NSInteger)toIndex
{
    if (toIndex >= [self count])
    {
        toIndex = [self count];
    }
    NSInteger fromIndex = sortUnitView.sortUnit.index;
    [self.sortUnitViews removeObject:sortUnitView];
    [self.sortUnits removeObject:sortUnitView.sortUnit];
    
    [self.sortUnitViews insertObject:sortUnitView atIndex:toIndex];
    [self.sortUnits insertObject:sortUnitView.sortUnit atIndex:toIndex];
    sortUnitView.sortUnit.index = toIndex;
    [sortUnitView setHome:[self.dragSortView homeForIndex:toIndex page:self.page]];
    
    NSInteger begin = 0;
    NSInteger end = 0;
    if (fromIndex < toIndex)
    {
        begin = fromIndex;
        end = toIndex - 1;
    }
    else if (fromIndex > toIndex)
    {
        begin = toIndex + 1;
        end = fromIndex;
    }
    NSInteger length = end - begin + 1;
    if (length > 0)
    {
        [self checkAndGoHomeInRange:NSMakeRange(begin, length)];
    }
}


- (BOOL)removeSortUnitView:(SortUnitView *)unitView
{
    if (![self.sortUnits containsObject:unitView.sortUnit])
    {
        return NO;
    }
    NSInteger deleteIndex = unitView.sortUnit.index;
    [self.sortUnits removeObjectAtIndex:deleteIndex];
    [self.sortUnitViews removeObjectAtIndex:deleteIndex];
    NSInteger length = self.sortUnits.count - deleteIndex;
    if (length > 0)
    {
        [self checkAndGoHomeInRange:NSMakeRange(deleteIndex, length)];
    }
    return YES;
}

- (void)addSortUnitView:(SortUnitView *)sortUnitView atIndex:(NSInteger)index
{
    if (!sortUnitView || [self.sortUnits containsObject:sortUnitView.sortUnit])
    {
        return;
    }
    if (index >= [self count])
    {
        index = [self count];
    }
    [sortUnitView setHome:[self.dragSortView homeForIndex:index page:self.page]];
    sortUnitView.sortUnit.index = index;
    sortUnitView.sortUnit.page = self.page;
    [self.sortUnits insertObject:sortUnitView.sortUnit atIndex:index];
    [self.sortUnitViews insertObject:sortUnitView atIndex:index];
    NSInteger length = self.sortUnits.count - index - 1;
    if (length > 0)
    {
        [self checkAndGoHomeInRange:NSMakeRange(index + 1, self.sortUnits.count - index - 1)];
    }
}

- (void)addSortUnitView:(SortUnitView *)sortUnitView
{
    sortUnitView.sortUnit.index = self.sortUnits.count;
    sortUnitView.sortUnit.page = self.page;
    [sortUnitView setHome:[self.dragSortView homeForIndex:sortUnitView.sortUnit.index page:self.page]];
    [self.sortUnits addObject:sortUnitView.sortUnit];
    [self.sortUnitViews addObject:sortUnitView];
    [sortUnitView goHome];
}

- (void)addSortUnit:(id<SortUnit>)sortUnit
{
    sortUnit.index = [self count];
    sortUnit.page = [self page];
    SortUnitView * sortUnitView = [self.dragSortView unitViewForUnit:sortUnit];
    [self.sortUnits addObject:sortUnit];
    [self.sortUnitViews addObject:sortUnitView];
    [self.dragSortView addSubview:sortUnitView];
}

- (NSMutableArray *)sortUnits
{
    if (!_sortUnits)
    {
        _sortUnits = [NSMutableArray array];
    }
    return _sortUnits;
}

- (NSMutableArray *)sortUnitViews
{
    if (!_sortUnitViews)
    {
        _sortUnitViews = [NSMutableArray array];
    }
    return _sortUnitViews;
}

- (BOOL)containsSortUnit:(id<SortUnit>)sortUnit
{
    return [self.sortUnits containsObject:sortUnit];
}

- (BOOL)deleteSortUnit:(id<SortUnit>)sortUnit
{
    if (![self.sortUnits containsObject:sortUnit])
    {
        return NO;
    }
    SortUnitView * removeView = nil;
    NSInteger index = 0;
    for (SortUnitView * unitView in self.sortUnitViews)
    {
        if ([unitView.sortUnit index] == [sortUnit index])
        {
            removeView = unitView;
            [removeView remove];
        }
        else
        {
            if ([unitView.sortUnit index] != index)
            {
                [unitView.sortUnit setIndex:index];
                [unitView setHome:[_dragSortView homeForIndex:index page:_page]];
                [unitView performSelector:@selector(goHome) withObject:nil afterDelay:.2];
            }
            index ++;
        }
    }
    
    [self.sortUnitViews removeObject:removeView];
    [self.sortUnits removeObject:sortUnit];

    
//    if ([[(id<SortUnit>)[self.sortUnits lastObject] pk] isEqualToString:sortUnit.pk])
//    {
//        [self.sortUnits removeLastObject];
//        [[self.sortUnitViews lastObject] remove];
//        [self.sortUnitViews removeLastObject];
//    }
//    else
//    {
//        SortUnitView * afterView = [self.sortUnitViews lastObject];
//        SortUnitView * beforeView = nil;
//        for (NSInteger index = self.sortUnits.count - 2; index >= sortUnit.index; index--)
//        {
//            beforeView = [self.sortUnitViews objectAtIndex:index];
//            [afterView setHome:[beforeView home]];
//            afterView.sortUnit.index = beforeView.sortUnit.index;
//            [afterView performSelector:@selector(goHome) withObject:nil afterDelay:.2];
//            afterView = beforeView;
//        }
//        [beforeView remove];
//        [self.sortUnitViews removeObjectAtIndex:sortUnit.index];
//        [self.sortUnits removeObjectAtIndex:sortUnit.index];
//    }
    if (self.sortUnits.count == 0)
    {
        [self.dragSortView performSelector:@selector(checkEmptyPage) withObject:nil afterDelay:.3];
    }
    return YES;
}

- (BOOL)updateSortUnit:(id<SortUnit>)sortUnit
{
    if (![self.sortUnits containsObject:sortUnit])
    {
        return NO;
    }
    SortUnitView * sortUnitView = [self.sortUnitViews objectAtIndex:sortUnit.index];
    [sortUnitView refreshContent];
    return YES;
}

@end
