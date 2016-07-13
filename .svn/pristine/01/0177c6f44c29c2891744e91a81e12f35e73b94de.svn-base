//
//
/**
 * Copyright (c) www.bugull.com
 */
//
//


#import <UIKit/UIKit.h>
#import "DragSortView.h"

@class SortUnitView;

@protocol SortUnitViewDelegate <NSObject>

@optional
- (void)sortUnitImageClicked:(SortUnitView *)unitView;
- (void)sortUnitRemoveBtnClicked:(SortUnitView *)unitView;
- (void)sortUnitTitleClicked:(SortUnitView *)unitView;
- (void)sortUnitViewStartedTracking:(SortUnitView *)unitView;
- (void)sortUnitViewMoved:(SortUnitView *)unitView offset:(CGPoint)offset;
- (BOOL)sortUnitViewStoppedTracking:(SortUnitView *)unitView;
- (BOOL)isEditing:(SortUnitView *)unitView;
- (void)sortUnitViewMaybeTrack:(SortUnitView *)unitView;

@end

@interface SortUnitView : UIView

@property (readonly,nonatomic) id<SortUnit> sortUnit;
@property (readonly,nonatomic) CGRect home;
@property (strong,nonatomic) IBOutlet UIView * contentView;
@property (strong,nonatomic) IBOutlet UIImageView * imageView;
@property (strong,nonatomic) IBOutlet UILabel * titleLabel;


@property (nonatomic) CGFloat cornerRadius;

@property (nonatomic,getter = isEditing) BOOL editing;

@property (nonatomic,getter = isEditingEnabled) BOOL editingEnabled;

- (void)refreshContent;

- (void)setHighlighted:(BOOL)highlighted;

- (void)setSelected:(BOOL)selected;


@end


