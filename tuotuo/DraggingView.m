//
//  DraggingView.m
//  tuotuo
//
//  Created by Wu on 2/1.
//  Copyright © 2018年 Wu. All rights reserved.
//

#import "DraggingView.h"

@implementation DraggingView
{
    Class currentCellClass;
    UIScrollView *chosenScrollView;
    UIScrollView *abandonScrollView;
    NSMutableArray<__kindof DraggingViewCell *> *chosenCellArray;
    NSMutableArray<__kindof DraggingViewCell *> *abandonCellArray;
}

#pragma mark - UI
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpView];
        chosenCellArray = [NSMutableArray array];
        abandonCellArray = [NSMutableArray array];
    }
    return self;
}

- (void)setUpView {

    chosenScrollView = [UIScrollView new];
    chosenScrollView.backgroundColor = [UIColor yellowColor];
    [self addSubview:chosenScrollView];

    abandonScrollView = [UIScrollView new];
    abandonScrollView.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:abandonScrollView];
    
    NSKeyValueObservingOptions options = NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld;
    [chosenScrollView addObserver:self forKeyPath:@"contentOffset" options:options context:nil];
    [abandonScrollView addObserver:self forKeyPath:@"contentOffset" options:options context:nil];
}

- (void)setChosenViewHeight:(CGFloat)chosenViewHeight {
    _chosenViewHeight = chosenViewHeight;
    chosenScrollView.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), _chosenViewHeight);
    if (!CGRectEqualToRect(abandonScrollView.frame, CGRectZero)) {
        abandonScrollView.frame = CGRectMake(0, _chosenViewHeight, CGRectGetWidth(self.bounds), _abandonViewHeight);
    }
}

#pragma mark - Set
- (void)setAbandonViewHeight:(CGFloat)abandonViewHeight {
    _abandonViewHeight = abandonViewHeight;
    abandonScrollView.frame = CGRectMake(0, _chosenViewHeight, CGRectGetWidth(self.bounds), _abandonViewHeight);
}

#pragma mark - analyse

- (void)layoutSubviews {
    for (NSUInteger i = 0; i < _chosenCount; i++) {
        if (self.chosenCellBlock) {
            CGFloat width = self.widthOfCellBlock ? self.widthOfCellBlock(self, i) : _cellWidth;
            if (width == 0 || _cellHeight == 0) {
                break;
            }
            DraggingViewCell *cell = self.chosenCellBlock(self, i);
            if (i == 0) {
                cell.frame = CGRectMake(0, 0, width, _cellHeight);
            } else {
                CGRect lastFrame = [self lastCellFromScrollView:chosenScrollView];
                if (CGRectGetMaxX(lastFrame) + width > CGRectGetWidth(self.frame)) {
                    cell.frame = CGRectMake(0, CGRectGetMaxY(lastFrame), width, _cellHeight);
                } else {
                    cell.frame = CGRectMake(CGRectGetMaxX(lastFrame), CGRectGetMinY(lastFrame), width, _cellHeight);
                }
            }
            [chosenScrollView addSubview:cell];
        }
    }
    for (NSUInteger i = 0; i < _abandonCount; i++) {
        if (self.abandonCellBlock) {
            CGFloat width = self.widthOfCellBlock ? self.widthOfCellBlock(self, i) : _cellWidth;
            if (width == 0 || _cellHeight == 0) {
                break;
            }
            DraggingViewCell *cell = self.abandonCellBlock(self, i);
            if (i == 0) {
                cell.frame = CGRectMake(0, 0, width, _cellHeight);
            } else {
                CGRect lastFrame = [self lastCellFromScrollView:abandonScrollView];
                if (CGRectGetMaxX(lastFrame) + width > CGRectGetWidth(self.frame)) {
                    cell.frame = CGRectMake(0, CGRectGetMaxY(lastFrame), width, _cellHeight);
                } else {
                    cell.frame = CGRectMake(CGRectGetMaxX(lastFrame), CGRectGetMinY(lastFrame), width, _cellHeight);
                }
            }
            [abandonScrollView addSubview:cell];
        }
    }
}

- (CGRect)lastCellFromScrollView:(UIScrollView *)scrollView {
    __block CGRect lastFrame;
    [scrollView.subviews enumerateObjectsUsingBlock:^(__kindof DraggingViewCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[DraggingViewCell class]]) {
            [scrollView.subviews enumerateObjectsUsingBlock:^(__kindof DraggingViewCell * _Nonnull obj1, NSUInteger idx1, BOOL * _Nonnull stop1) {
                if ([obj1 isKindOfClass:[DraggingViewCell class]]) {
                    CGFloat objY = CGRectGetMaxY(obj.frame);
                    CGFloat objX = CGRectGetMaxX(obj.frame);
                    CGFloat obj1Y = CGRectGetMaxY(obj1.frame);
                    CGFloat obj1X = CGRectGetMaxX(obj1.frame);
                    CGFloat lastY = CGRectGetMaxY(lastFrame);
                    CGFloat lastX = CGRectGetMaxX(lastFrame);
                    CGFloat maxY = 0, maxX = 0;
                    if (objY > obj1Y) {
                        maxY = objY;
                        maxX = objX;
                    } else if (objY < obj1Y){
                        maxY = obj1Y;
                        maxX = obj1X;
                    } else {
                        if (objX > obj1X) {
                            maxX = objX;
                            maxY = objY;
                        } else {
                            maxX = obj1X;
                            maxY = obj1Y;
                        }
                    }
                    if (lastY > maxY) {
                        maxY = lastY;
                        maxX = lastX;
                    } else if (lastY == maxY) {
                        if (lastX > maxX) {
                            maxX = lastX;
                        }
                    }
                    lastFrame = CGRectMake(maxX, maxY, 0, 0);
                }
            }];
        }
    }];
    return lastFrame;
}

- (DraggingViewCell *)dequeueReusableCellForChosenWithNum:(NSUInteger)num {
    if (chosenCellArray.count > 0) {
        return chosenCellArray.firstObject;
    }
    DraggingViewCell *cell = [currentCellClass new];
    return cell;
    return nil;
}

- (DraggingViewCell *)dequeueReusableCellForAbandonWithNum:(NSUInteger)num {
    if (abandonCellArray.count > 0) {
        return abandonCellArray.firstObject;
    }
    DraggingViewCell *cell = [currentCellClass new];
    return cell;
    return nil;
}

- (void)registerCell:(Class)class {
    currentCellClass = class;
}

#pragma mark - observe
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"contentOffset"]) {
        if (object == chosenScrollView) {
            
        } else if (object == abandonScrollView) {
            
        }
    }
}
@end

@implementation DraggingViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.borderWidth = 1;
        self.layer.borderColor = [UIColor grayColor].CGColor;
    }
    return self;
}
@end
