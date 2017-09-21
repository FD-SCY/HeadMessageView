//
//  ViewController.m
//  头条滚动
//
//  Created by 石纯勇 on 2017/4/20.
//  Copyright © 2017年 scy. All rights reserved.
//

#import "ViewController.h"
#import "HeadMessageView.h"
#import "MyCell.h"

@interface ViewController () <HeadMessageViewDataSource, HeadMessageViewDelegate>

@property (nonatomic, strong) NSArray *messages;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _messages = @[@"头条新闻 1111111111", @"头条新闻 2222222", @"头条新闻 33333333", @"头条新闻 44444444", @"头条新闻 555555", @"头条新闻 66666", @"头条新闻 7777777"];
    
    HeadMessageView *demoView = [[HeadMessageView alloc]initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 80)];
    demoView.backgroundColor = [UIColor clearColor];
    demoView.rollDirection = Vertical_Top_Roll;
    demoView.dataSource = self;
    demoView.delegate = self;
    demoView.rollInterval = 2;
    [self.view addSubview:demoView];
}

#pragma mark - HeadMessageViewDataSource & HeadMessageViewDelegate
- (NSUInteger)numberOfItemsInHeadMessageView:(HeadMessageView *)headView {
    return _messages.count;
}

- (HeadMessageCell *)headMessageView:(HeadMessageView *)headView viewForItemAtIndex:(NSUInteger)index {
    if (index < 4) {
        MyCell *cell = [headView dequeueReusableCellWithIdentifier:@"MyHeadCell"];
        if (!cell) {
            cell = [[MyCell alloc]initWithHeadView:headView reuseIdentifier:@"MyHeadCell"];
        }
        cell.messageLb.text = _messages[index];
        return cell;
    }
    else {
        HeadMessageCell *cell = [headView dequeueReusableCellWithIdentifier:@"HeadCell"];
        if (!cell) {
            cell = [[HeadMessageCell alloc]initWithHeadView:headView reuseIdentifier:@"HeadCell"];
        }
        cell.messageLb.text = _messages[index];
        return cell;
    }
}

- (void)headMessageView:(HeadMessageView *)headView didSelectItemAtIndex:(NSInteger)index {
    NSLog(@"%@", _messages[index]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
