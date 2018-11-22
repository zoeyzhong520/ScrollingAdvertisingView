//
//  ScrollingAdvertisingCell.m
//  ScrollingAdvertisingView
//
//  Created by zhifu360 on 2018/11/22.
//  Copyright © 2018 ZZJ. All rights reserved.
//

#import "ScrollingAdvertisingCell.h"

@implementation ScrollingAdvertisingCell

- (instancetype)initWithFrame:(CGRect)frame
{
    return [self initWithReuseIdentifier:@""];
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _reuseIdentifier = reuseIdentifier;
        [self baseInit];
        [self debugMessage];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self debugMessage];
    }
    return self;
}

///基础配置
- (void)baseInit {
    
    _contentView = [UIView new];
    [self addSubview:_contentView];
    
    _textLabel = [UILabel new];
    [_contentView addSubview:_textLabel];
}

///调试信息
- (void)debugMessage {
    if (AllowScrollingAdvertisingDebug) {
        NSLog(@"className===%p,line===%d,void===%s",self,__LINE__,__func__);
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _contentView.frame = self.bounds;
    
    _textLabel.frame = CGRectMake(15, 0, _contentView.bounds.size.width - 30, _contentView.bounds.size.height);
}

- (void)dealloc
{
    [self debugMessage];
}

@end
