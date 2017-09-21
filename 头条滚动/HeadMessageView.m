//
//  HeadMessageView.m
//  头条滚动
//
//  Created by 石纯勇 on 2017/4/20.
//  Copyright © 2017年 scy. All rights reserved.
//

#import "HeadMessageView.h"

@interface HeadMessageView() <CAAnimationDelegate>
@property (nonatomic, assign) NSUInteger numOfItems;
@property (nonatomic, assign) NSUInteger currentIndex;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) NSTimer *rollTimer;

@end

@implementation HeadMessageView

- (HeadMessageCell *)dequeueReusableCellWithIdentifier:(NSString *)cellIdentifier {
    return _reuseCellDictionary[cellIdentifier];
}

- (void)setDelegate:(id<HeadMessageViewDelegate>)delegate  {
    if (_delegate != delegate) {
        _delegate = delegate;
    }
}

- (void)setDataSource:(id<HeadMessageViewDataSource>)dataSource {
    if (_dataSource != dataSource) {
        _dataSource = dataSource;
        if (_dataSource) {
            [self reloadData];
        }
    }
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUP];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setUP];
    }
    return self;
}

- (void)setUP {
    _contentView = [[UIView alloc]initWithFrame:self.bounds];
    _contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTap:)];
    [_contentView addGestureRecognizer:tapGes];
    _reuseCellDictionary = [NSMutableDictionary dictionary];
    [self addSubview:_contentView];
    _rollDirection = Vertical_Top_Roll;
    _currentIndex = 0;
    [self setRollInterval:5];
    if (_dataSource) {
        [self reloadData];
    }
    self.layer.masksToBounds = YES;
}

- (void)setRollInterval:(NSTimeInterval)rollInterval {
    if (_rollInterval != rollInterval) {
        _rollInterval = rollInterval;
        [self stopRollTimer];
//        _rollTimer = [NSTimer scheduledTimerWithTimeInterval:_rollInterval target:self selector:@selector(rollMessages) userInfo:nil repeats:YES];
        _rollTimer = [NSTimer timerWithTimeInterval:_rollInterval target:self selector:@selector(rollMessages) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_rollTimer forMode:NSRunLoopCommonModes];
    }
}

- (void)stopRollTimer {
    if (self.rollTimer) {
        [self.rollTimer invalidate];
        self.rollTimer = nil;
    }
}

- (void)rollMessages {
//    NSValue *from = @0;
//    NSValue *to = @(-_visibleCell.frame.size.width);
    CGRect frame = _visibleCell.frame;
//    NSString *keyPath = @"transform.translation.x";
    if (_rollDirection == Vertical_Top_Roll) {
//        keyPath = @"transform.translation.y";
//        to = @(-_visibleCell.frame.size.height);
        frame.origin.y = -_visibleCell.frame.size.height;
    }
    else {
        frame.origin.x = -_visibleCell.frame.size.width;
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        _visibleCell.frame = frame;
    } completion:^(BOOL finish) {
        _currentIndex++;
        if (_currentIndex >= _numOfItems) {
            _currentIndex = 0;
        }
        [self loadCellWithIndex:_currentIndex];
    }];
    /*
    CABasicAnimation *outAnimation = [CABasicAnimation animationWithKeyPath:keyPath];
    outAnimation.fromValue = from;
    outAnimation.toValue = to;
    outAnimation.duration = 0.3;
    outAnimation.delegate = self;
    outAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    outAnimation.autoreverses = NO;
    outAnimation.fillMode = kCAFillModeForwards;
    outAnimation.removedOnCompletion = YES;
    outAnimation.beginTime = CACurrentMediaTime() + 0.1;
    [outAnimation setValue:@"MESSAGE_OUT" forKey:@"Animation_KEY"];
    [_visibleCell.layer addAnimation:outAnimation forKey:@"Message_OUT"];
     */
}

- (void)loadCellWithIndex:(NSUInteger)index {
    HeadMessageCell *tempCell = [_dataSource headMessageView:self viewForItemAtIndex:index];
    [tempCell.layer removeAllAnimations];
    if (_rollDirection == Vertical_Top_Roll) {
        tempCell.frame =
        CGRectMake(0, self.contentView.frame.size.height, self.contentView.frame.size.width, self.contentView.frame.size.height);
    } else {
        tempCell.frame =
        CGRectMake(self.contentView.frame.size.width, 0, self.contentView.frame.size.width, self.contentView.frame.size.height);
    }
    if (_visibleCell) {
        if (![[_reuseCellDictionary allKeys] containsObject:_visibleCell.reuseIdentifier] || !_reuseCellDictionary[_visibleCell.reuseIdentifier]) {
            [_reuseCellDictionary setObject:_visibleCell forKey:_visibleCell.reuseIdentifier];
        }
        [_visibleCell removeFromSuperview];
    }
    [self.contentView addSubview:tempCell];
    [UIView animateWithDuration:0.3 animations:^{
        tempCell.frame =
        CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height);
    } completion:^(BOOL finish) {
        _visibleCell = tempCell;
    }];
}

- (void)reloadData {
    for (UIView *view in self.contentView.subviews) {
        [view removeFromSuperview];
    }
    NSAssert([_dataSource respondsToSelector:@selector(numberOfItemsInHeadMessageView:)]==YES, @"expect numberOfItemsInHeadMessageView");
    [_reuseCellDictionary removeAllObjects];
    _visibleCell = nil;
    _currentIndex = 0;
    _numOfItems = [_dataSource numberOfItemsInHeadMessageView:self];
    if (_numOfItems > 0) {
        [self setNeedsLayout];
    }
    [self loadCellWithIndex:_currentIndex];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _contentView.frame = self.bounds;
}


#pragma mark - event
- (void)didTap:(UITapGestureRecognizer *)tapGes {
    if (_delegate && [_delegate respondsToSelector:@selector(headMessageView:didSelectItemAtIndex:)]) {
        [_delegate headMessageView:self didSelectItemAtIndex:_currentIndex];
    }
}
/*
#pragma mark - CAAnimationDelegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    NSString *value = [anim valueForKey:@"Animation_KEY"];
    if ([value isEqualToString:@"MESSAGE_OUT"]) {
        _currentIndex++;
        if (_currentIndex >= _numOfItems) {
            _currentIndex = 0;
        }
        [self loadCellWithIndex:_currentIndex];
    }
}*/
@end


@implementation HeadMessageCell

- (id)initWithHeadView:(HeadMessageView *)headView reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithFrame:headView.bounds]) {
        _reuseIdentifier = reuseIdentifier;
        _messageLb = [[UILabel alloc]initWithFrame:self.bounds];
        _messageLb.font = [UIFont  systemFontOfSize:15];
        [self addSubview:_messageLb];
    }
    return self;
}

@end
