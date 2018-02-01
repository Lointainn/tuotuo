//
//  DraggingView.h
//  tuotuo
//
//  Created by Wu on 2/1.
//  Copyright © 2018年 Wu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DraggingViewCell;
@class DraggingView;

typedef __kindof DraggingViewCell* (^CellForNumAtNum)(DraggingView* draggingView, NSUInteger num);
typedef CGFloat(^WidthOfCell)(DraggingView* draggingView, NSUInteger num);

@interface DraggingView : UIView
@property (nonatomic, assign) CGFloat chosenViewHeight;
@property (nonatomic, assign) CGFloat abandonViewHeight;
@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, assign) CGFloat cellWidth;
@property (nonatomic, assign) NSUInteger chosenCount;
@property (nonatomic, assign) NSUInteger abandonCount;
@property (nonatomic, assign) BOOL averageLocation;
@property (nonatomic, copy) CellForNumAtNum chosenCellBlock;
@property (nonatomic, copy) CellForNumAtNum abandonCellBlock;
@property (nonatomic, copy) WidthOfCell widthOfCellBlock;

- (void)registerCell:(Class)class;
- (__kindof DraggingViewCell*)dequeueReusableCellForChosenWithNum:(NSUInteger)num;
- (__kindof DraggingViewCell*)dequeueReusableCellForAbandonWithNum:(NSUInteger)num;

@end

@interface DraggingViewCell : UIView

@end
