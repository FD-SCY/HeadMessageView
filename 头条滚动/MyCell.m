//
//  MyCell.m
//  头条滚动
//
//  Created by 石纯勇 on 2017/4/21.
//  Copyright © 2017年 scy. All rights reserved.
//

#import "MyCell.h"

@implementation MyCell

- (id)initWithHeadView:(HeadMessageView *)headView reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithHeadView:headView reuseIdentifier:reuseIdentifier]) {
        _signView = [[UIView alloc]initWithFrame:CGRectMake(self.bounds.size.width-40, (self.bounds.size.height-20)/2, 10, 10)];
        _signView.layer.cornerRadius = 5;
        _signView.backgroundColor = [UIColor yellowColor];
        [self addSubview:_signView];
    }
    return self;
}

@end
