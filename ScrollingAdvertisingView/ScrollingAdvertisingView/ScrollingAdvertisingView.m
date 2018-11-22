//
//  ScrollingAdvertisingView.m
//  ScrollingAdvertisingView
//
//  Created by zhifu360 on 2018/11/22.
//  Copyright © 2018 ZZJ. All rights reserved.
//

#import "ScrollingAdvertisingView.h"

@interface ScrollingAdvertisingView ()

///存储Identifier的字典
@property (nonatomic, strong) NSMutableDictionary *reuseIdentifiersDict;
///存储Cell的数组
@property (nonatomic, strong) NSMutableArray *reuseCells;
///当前显示的Cell
@property (nonatomic, strong) ScrollingAdvertisingCell *currentCell;
///将要显示的Cell
@property (nonatomic, strong) ScrollingAdvertisingCell *willShowCell;
///是否动画
@property (nonatomic, assign) BOOL isAnimating;
///计时器
@property (nonatomic, strong) dispatch_source_t timer;

@end

@implementation ScrollingAdvertisingView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initParameters];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self initParameters];
    }
    return self;
}

///初始化配置
- (void)initParameters {
    _rollingInterval = 2;
    self.clipsToBounds = YES;
    [self addGestureRecognizer:[self addTapGesture]];
}

///selectedCell事件
- (void)selectedCell:(UITapGestureRecognizer *)tapGesture {
    
    NSInteger count = [self.dataSource numberOfRowsForScrollingAdvertisingView:self];
    if (count && _currentIndex > count - 1) {
        _currentIndex = 0;
    }
 
    //代理方法
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedCell:index:)]) {
        [self.delegate didSelectedCell:self index:_currentIndex];
    }
}

#pragma mark - Implementation
- (void)registerClass:(Class)cellClass forCellReuseIdentifier:(NSString *)identifier {
    [self.reuseIdentifiersDict setObject:NSStringFromClass(cellClass) forKey:identifier];
}

- (void)registNib:(UINib *)nib forCellReuseIdentifier:(NSString *)identifier {
    [self.reuseIdentifiersDict setObject:nib forKey:identifier];
}

- (ScrollingAdvertisingCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier {
    
    ///从复用池中查找Cell
    for (ScrollingAdvertisingCell *cell in self.reuseCells) {
        if ([cell.reuseIdentifier isEqualToString:identifier]) {
            return cell;
        }
    }
    
    id cellClass = self.reuseIdentifiersDict[identifier];
    if ([cellClass isKindOfClass:[UINib class]]) {
        UINib *nib = [UINib nibWithNibName:identifier bundle:nil];
        NSArray *array = [nib instantiateWithOwner:nil options:nil];
        ScrollingAdvertisingCell *cell = [array firstObject];
        //KVC
        [cell setValue:identifier forKeyPath:@"reuseIdentifier"];
        return cell;
    } else {
        Class cellClass = NSClassFromString(self.reuseIdentifiersDict[identifier]);
        ScrollingAdvertisingCell *cell = [[cellClass alloc] initWithReuseIdentifier:identifier];
        return cell;
    }
}

- (void)reloadData {
    
    //释放计时器
    [self releaseTimer];
    
    //布局Cell
    [self layoutCurrentCellAndWillShowCell];
    
    //判断个数小于2不执行滚动
    NSInteger count = [self.dataSource numberOfRowsForScrollingAdvertisingView:self];
    if (count && count < 2) {
        return;
    }
    
    //开启计时器
    [self startTimer];
}

///开启计时器
- (void)startTimer {
    
    dispatch_queue_t queue = dispatch_queue_create(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), self.rollingInterval * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(_timer, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            
            //计时器操作
            [self handleTimerMove];
            
        });
    });
    dispatch_resume(_timer);
}

///释放计时器
- (void)releaseTimer {
    _isAnimating = NO;
    _currentIndex = 0;
    [_currentCell removeFromSuperview];
    [_willShowCell removeFromSuperview];
    [self.reuseCells removeAllObjects];
}

///计时器操作
- (void)handleTimerMove {
    
    if (_isAnimating) {
        return;
    }
    
    //配置当前Cell、将要显示Cell
    [self layoutCurrentCellAndWillShowCell];
    
    //currentIndex自增
    _currentIndex += 1;
    
    _isAnimating = YES;
    
    //添加动画
    [UIView animateWithDuration:0.5 delay:0.1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.currentCell.frame = CGRectMake(0, -self.bounds.size.height, self.bounds.size.width, self.bounds.size.height);
        self.willShowCell.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    } completion:^(BOOL finished) {
        if (self.currentCell && self.willShowCell) {
            [self.reuseCells addObject:self.currentCell];
            [self.currentCell removeFromSuperview];
            self.currentCell = self.willShowCell;
        }
        self.isAnimating = NO;
    }];
}

///配置当前Cell、将要显示Cell
- (void)layoutCurrentCellAndWillShowCell {
    
    //获取条数
    NSInteger count = [self.dataSource numberOfRowsForScrollingAdvertisingView:self];
    
    //判断界限
    if (_currentIndex > count - 1) {
        _currentIndex = 0;
    }
    
    NSInteger willShowIndex = _currentIndex + 1;
    if (willShowIndex > count - 1) {
        willShowIndex = 0;
    }
    
    //创建Cell
    if (!_currentCell) {
        //第一次加载时无currentCell
        _currentCell = [self.dataSource scrollingAdvertising:self cellAtIndex:_currentIndex];
        _currentCell.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
        [self addSubview:_currentCell];
        return;
    }
    
    _willShowCell = [self.dataSource scrollingAdvertising:self cellAtIndex:willShowIndex];
    _willShowCell.frame = CGRectMake(0, self.bounds.size.height, self.bounds.size.width, self.bounds.size.height);
    [self addSubview:_willShowCell];
 
    if (AllowScrollingAdvertisingDebug) {
        NSLog(@"_currentCell  %p", _currentCell);
        NSLog(@"_willShowCell %p", _willShowCell);
    }
    
    //移除Cell
    [self.reuseCells removeObject:_currentCell];
    [self.reuseCells removeObject:_willShowCell];
}

#pragma mark - Lazy
- (NSMutableDictionary *)reuseIdentifiersDict {
    if (!_reuseIdentifiersDict) {
        _reuseIdentifiersDict = [NSMutableDictionary dictionaryWithCapacity:0];
    }
    return _reuseIdentifiersDict;
}

- (NSMutableArray *)reuseCells {
    if (!_reuseCells) {
        _reuseCells = [NSMutableArray arrayWithCapacity:0];
    }
    return _reuseCells;
}

- (UITapGestureRecognizer *)addTapGesture {
    return [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectedCell:)];
}

- (void)dealloc
{
    if (AllowScrollingAdvertisingDebug) {
        NSLog(@"%p %d %s",self,__LINE__,__func__);
    }
    
    //还原
    [self releaseTimer];
}

@end
