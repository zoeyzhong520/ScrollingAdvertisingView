//
//  ScrollingAdvertisingView.h
//  ScrollingAdvertisingView
//
//  Created by zhifu360 on 2018/11/22.
//  Copyright © 2018 ZZJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScrollingAdvertisingCell.h"

NS_ASSUME_NONNULL_BEGIN

@class ScrollingAdvertisingView;

///数据源
@protocol ScrollingAdvertisingViewDataSource <NSObject>

@required
///返回行数
- (NSInteger)numberOfRowsForScrollingAdvertisingView:(ScrollingAdvertisingView *)scrollingAdvertising;
///返回index相对应的cell类
- (ScrollingAdvertisingCell *)scrollingAdvertising:(ScrollingAdvertisingView *)scrollingAdvertising cellAtIndex:(NSInteger)index;

@end

///代理
@protocol ScrollingAdvertisingViewDelegate <NSObject>

@optional
- (void)didSelectedCell:(ScrollingAdvertisingView *)scrollingAdvertising index:(NSInteger)index;

@end

@interface ScrollingAdvertisingView : UIView

///设置数据源
@property (nonatomic, weak) id<ScrollingAdvertisingViewDataSource>dataSource;
///设置代理
@property (nonatomic, weak) id<ScrollingAdvertisingViewDelegate>delegate;
///滚动间隔，默认2s
@property (nonatomic, assign) NSTimeInterval rollingInterval;
///当前滚动到的位置
@property (nonatomic, assign, readonly) NSInteger currentIndex;

///使用ReuseIdentifier注册Cell
- (void)registerClass:(Class)cellClass forCellReuseIdentifier:(NSString *)identifier;
///使用Nib注册Cell
- (void)registNib:(UINib *)nib forCellReuseIdentifier:(NSString *)identifier;
///从复用池取出Cell
- (ScrollingAdvertisingCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier;
///数据刷新
- (void)reloadData;
///在适当的时机释放计时器
- (void)releaseTimer;

@end

NS_ASSUME_NONNULL_END
