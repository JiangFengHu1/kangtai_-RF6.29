//
//
/**
 * Copyright (c) www.bugull.com
 */
//
//

#import <UIKit/UIKit.h>
#import "SortUnit.h"

#define Min_Outter_Margin 5
#define Inner_Margin 10
#define Label_Hight 20
#define ButtonWidth 20
#define Default_CornerRadius 12
#define DRAG_THRESHOLD 10
#define LongPress_Duration .8

@class DragSortView;
@class SortUnitView;

@protocol DragSortViewDelegate <NSObject>

- (CGSize)homeSizeInDragSortView:(DragSortView *)dragSortView;

- (NSArray *)sortUnitsInDragSortView:(DragSortView *)dragSortView;

- (SortUnitView *)dragSortView:(DragSortView *)dragSortView unitViewForUnit:(id<SortUnit>)sortUnit;

- (void)dragSortView:(DragSortView *)dragSortView unitViewClicked:(SortUnitView *)unitView;

- (void)dragSortViewBecameEditing:(DragSortView *)dragSortView;

- (void)dragSortViewEndEditing:(DragSortView *)dragSortView;

- (void)deleteSortUnitView:(SortUnitView *)unitView;

- (void)editUnitView:(SortUnitView *)unitView;

@optional
- (UIView *)addViewForDragSortView:(DragSortView *)dragSortView;

@end

@interface DragSortView : UIView 

@property (weak,nonatomic) id<DragSortViewDelegate> delegate;
@property (nonatomic) BOOL editing;
@property (strong,nonatomic) UIImage * backgroundImage;
@property (readonly,nonatomic) NSInteger currentPage;

@property (readonly,nonatomic) SortUnitView * selectedUnitView;

@property (nonatomic) BOOL editingEnabled;

- (BOOL)addSortUnit:(id<SortUnit>)sortUnit inPage:(NSInteger)page;
- (BOOL)deleteSortUnit:(id<SortUnit>)sortUnit;
- (BOOL)updateSortUnit:(id<SortUnit>)sortUnit;
- (void)deletePage:(NSInteger)page;

- (void)topRunover:(BOOL)del;

- (NSArray *)sortUnitsInPage:(NSInteger)page;
- (id<SortUnit>)sortUnitAtIndex:(NSInteger)index page:(NSInteger)page;
- (NSInteger)countInPage:(NSInteger)page;
- (NSInteger)numberOfPages;

- (void)setDelFrame:(CGRect)delFrame editFrame:(CGRect)editFrame;

- (void)moveToPage:(NSInteger)page animated:(BOOL)animated;

- (void)reloadData;

- (void)reloadSortUnit:(id<SortUnit>)unit;


@end
