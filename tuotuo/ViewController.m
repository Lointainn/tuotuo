//
//  ViewController.m
//  tuotuo
//
//  Created by Wu on 2/1.
//  Copyright © 2018年 Wu. All rights reserved.
//

#import "ViewController.h"
#import "DraggingView.h"

@interface DraggingCell : DraggingViewCell
@property (nonatomic, copy) NSString *text;
@end

@interface ViewController ()
{
    DraggingView *dView;
}
@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSArray *array = @[@1,@2,@3,@4,@5,@6,@7,@8,@9,@10,@11,@12,@13,@14,@15,@16,@17,@18,@19,@20,@21];
    NSArray *array2 = @[@1,@2,@3,@4,@5,@6,@7,@8,@9,@10,@11,@12,@13,@14,@15,@16,@17,@18,@19,@20,@21,@22];

    dView = [[DraggingView alloc] initWithFrame:self.view.bounds];
    dView.chosenViewHeight = CGRectGetHeight(self.view.frame)/2;
    dView.abandonViewHeight = CGRectGetHeight(self.view.frame)/2;
    dView.cellWidth = 80;
    dView.cellHeight = 70;
    dView.chosenCount = array.count;
    dView.abandonCount = array2.count;
    dView.averageLocation = 1;
    [dView registerCell:[DraggingCell class]];
    [dView setChosenCellBlock:^DraggingViewCell *(DraggingView *draggingView, NSUInteger num) {
        DraggingCell *cell = [draggingView dequeueReusableCellForChosenWithNum:num];
        cell.text = [NSString stringWithFormat:@"第%@个",array[num]];
        return cell;
    }];
    [dView setAbandonCellBlock:^DraggingViewCell *(DraggingView *draggingView, NSUInteger num) {
        DraggingCell *cell = [draggingView dequeueReusableCellForAbandonWithNum:num];
        cell.text = [NSString stringWithFormat:@"第%@个",array2[num]];
        return cell;
    }];
    [dView setWidthOfCellBlock:^CGFloat(DraggingView *draggingView, NSUInteger num) {
        return 100;
    }];
    [self.view addSubview:dView];
//    UITableView
}

@end

@implementation DraggingCell
{
    UILabel *label;
}

- (void)setText:(NSString *)text {
    _text = text;
    if (!label) {
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 70)];
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [UIColor orangeColor];
    }
    label.text = text;
    [self addSubview:label];
}
@end
