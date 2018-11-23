//
//  ScrollingAdvertisingCell.h
//  ScrollingAdvertisingView
//
//  Created by zhifu360 on 2018/11/22.
//  Copyright © 2018 ZZJ. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

///是否打开调试信息
static BOOL AllowScrollingAdvertisingDebug = NO;

@interface ScrollingAdvertisingCell : UIView

///重用标识
@property (nonatomic, copy, readonly) NSString *reuseIdentifier;
///用作背景的UIView
@property (nonatomic, strong, readonly) UIView *contentView;
///文本展示的UILabel
@property (nonatomic, strong, readonly) UILabel *textLabel;

///使用ReuseIdentifier初始化
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier;
///使用Coder初始化
- (instancetype)initWithCoder:(NSCoder *)aDecoder;

@end

NS_ASSUME_NONNULL_END
