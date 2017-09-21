//
//  HeadMessageView.h
//  头条滚动
//
//  Created by 石纯勇 on 2017/4/20.
//  Copyright © 2017年 scy. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    Vertical_Top_Roll,
    Level_Left_Roll
} DirectionEnum;

@class HeadMessageCell;
@protocol HeadMessageViewDelegate, HeadMessageViewDataSource;
@interface HeadMessageView : UIView
@property (nonatomic, weak) id<HeadMessageViewDataSource> dataSource;
@property (nonatomic, weak) id<HeadMessageViewDelegate> delegate;
@property (nonatomic, readonly, strong) NSMutableDictionary *reuseCellDictionary;
@property (nonatomic, readonly, strong) HeadMessageCell *visibleCell;
@property (nonatomic, assign) NSTimeInterval rollInterval; // 默认五秒
@property (nonatomic, assign) DirectionEnum rollDirection; // 默认Vertical_Top_Roll
- (__kindof HeadMessageCell *)dequeueReusableCellWithIdentifier:(NSString *)cellIdentifier;
- (void)reloadData;
@end


@protocol HeadMessageViewDataSource <NSObject>
@required
- (NSUInteger)numberOfItemsInHeadMessageView:(HeadMessageView *)headView;
- (HeadMessageCell *)headMessageView:(HeadMessageView *)headView viewForItemAtIndex:(NSUInteger)index;
@optional
//....
@end

@protocol HeadMessageViewDelegate <NSObject>
- (void)headMessageView:(HeadMessageView *)headView didSelectItemAtIndex:(NSInteger)index;
@end


@interface HeadMessageCell : UIView
- (id)initWithHeadView:(HeadMessageView *)headView reuseIdentifier:(NSString *)reuseIdentifier;
@property (nonatomic, readonly, strong) NSString *reuseIdentifier;
@property (nonatomic, readonly, strong) UILabel *messageLb;
@end
