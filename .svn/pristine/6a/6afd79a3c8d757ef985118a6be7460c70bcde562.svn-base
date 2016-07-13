//
//
/**
 * Copyright (c) www.bugull.com
 */
//
//


#import <Foundation/Foundation.h>
#import "SortUnit.h"
#import "SortUnitView.h"
#import "DragSortView.h"

@interface SortUnitPage : NSObject

@property (weak,nonatomic) DragSortView * dragSortView;
@property (strong,nonatomic) UIView * addView;
@property (nonatomic) NSInteger page;
@property (strong,nonatomic) NSMutableArray * sortUnits;
@property (strong,nonatomic) NSMutableArray * sortUnitViews;

@property (nonatomic,getter = isEditing) BOOL editing;

- (NSInteger)count;
- (void)addSortUnit:(id<SortUnit>)sortUnit;
- (BOOL)containsSortUnit:(id<SortUnit>)sortUnit;
- (BOOL)deleteSortUnit:(id<SortUnit>)sortUnit;
- (BOOL)updateSortUnit:(id<SortUnit>)sortUnit;
- (BOOL)removeSortUnitView:(SortUnitView *)unitView;
- (void)moveSortUnitView:(SortUnitView *)sortUnitView toIndex:(NSInteger)toIndex;
- (void)addSortUnitView:(SortUnitView *)sortUnitView atIndex:(NSInteger)index;
- (void)addSortUnitView:(SortUnitView *)sortUnitView;
- (void)clear;
- (void)changePage:(NSInteger)newPage animated:(BOOL)animated;

@end
