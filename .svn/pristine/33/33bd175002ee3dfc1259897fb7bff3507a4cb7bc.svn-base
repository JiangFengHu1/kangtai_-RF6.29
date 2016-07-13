//
//  EditableTableController.h
//  Edit Demo
//
//  Created by Alfred Hanssen on 8/15/14.
//  Copyright (c) 2014 Alfie Hanssen. All rights reserved.
//

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// Note: This class currently supports single section tableViews only

@class EditableTableController;

@protocol EditableTableControllerDelegate <NSObject>

@optional

- (void)editableTableController:(EditableTableController *)controller
 willBeginMovingCellAtIndexPath:(NSIndexPath *)indexPath;

- (void)editableTableController:(EditableTableController *)controller
  movedCellWithInitialIndexPath:(NSIndexPath *)initialIndexPath
             fromAboveIndexPath:(NSIndexPath *)fromIndexPath
               toAboveIndexPath:(NSIndexPath *)toIndexPath;

- (BOOL)editableTableController:(EditableTableController *)controller
shouldMoveCellFromInitialIndexPath:(NSIndexPath *)initialIndexPath
            toProposedIndexPath:(NSIndexPath *)proposedIndexPath
          withSuperviewLocation:(CGPoint)location;

- (void)editableTableController:(EditableTableController *)controller
didMoveCellFromInitialIndexPath:(NSIndexPath *)initialIndexPath
                    toIndexPath:(NSIndexPath *)toIndexPath;

@end

@interface EditableTableController : NSObject

@property (nonatomic, weak) id<EditableTableControllerDelegate> delegate;
@property (nonatomic, assign, getter = isEnabled) BOOL enabled;

@property (nonatomic, weak) UIView *superview; // Optional, tableView will be used as snapshot superview if not set

- (instancetype)initWithTableView:(UITableView *)tableView;

@end
