//
//  ViewController.m
//  ScrollingAdvertisingView
//
//  Created by zhifu360 on 2018/11/22.
//  Copyright © 2018 ZZJ. All rights reserved.
//

#import "ViewController.h"
#import "ScrollingAdvertisingView.h"

@interface ViewController ()<ScrollingAdvertisingViewDelegate,ScrollingAdvertisingViewDataSource>

@property (nonatomic, strong) ScrollingAdvertisingView *scrollAdvertisingView;
@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.scrollAdvertisingView];
    [self.scrollAdvertisingView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.scrollAdvertisingView releaseTimer];
}

#pragma mark - ScrollingAdvertisingViewDelegate,ScrollingAdvertisingViewDataSource
- (NSInteger)numberOfRowsForScrollingAdvertisingView:(ScrollingAdvertisingView *)scrollingAdvertising {
    return self.dataArray.count;
}

- (ScrollingAdvertisingCell *)scrollingAdvertising:(ScrollingAdvertisingView *)scrollingAdvertising cellAtIndex:(NSInteger)index {
    
    ScrollingAdvertisingCell *cell = [scrollingAdvertising dequeueReusableCellWithIdentifier:@"cellID"];
    cell.textLabel.text = self.dataArray[index];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.backgroundColor = [UIColor colorWithRed:(arc4random()%256)/255.0 green:(arc4random()%256)/255.0 blue:(arc4random()%256)/255.0 alpha:1.0];
    return cell;
}

- (void)didSelectedCell:(ScrollingAdvertisingView *)scrollingAdvertising index:(NSInteger)index {
    NSLog(@"index===%ld",index);
}

#pragma mark - lazy
- (ScrollingAdvertisingView *)scrollAdvertisingView {
    if (!_scrollAdvertisingView) {
        _scrollAdvertisingView = [[ScrollingAdvertisingView alloc] initWithFrame:CGRectMake(15, ([UIScreen mainScreen].bounds.size.height-120)/2, [UIScreen mainScreen].bounds.size.width - 30, 60)];
        _scrollAdvertisingView.delegate = self;
        _scrollAdvertisingView.dataSource = self;
        [_scrollAdvertisingView registerClass:[ScrollingAdvertisingCell class] forCellReuseIdentifier:@"cellID"];
    }
    return _scrollAdvertisingView;
}

- (NSArray *)dataArray {
    if (!_dataArray) {
        _dataArray = @[@"为国家谋发展，也为世界作贡献，这是中国人民赋予自己的神圣职责。",@"40年改革开放，中国不仅发展了自己，也造福了世界。",@"“落其实思其树，饮其流怀其源”。",@"在亚太经合组织第二十六次领导人非正式会议上，习近平主席又重申中国将坚持对外开放基本国策，大幅度放宽市场准入，加大保护知识产权力度，创造更具吸引力的投资和营商环境。"];
    }
    return _dataArray;
}

@end
