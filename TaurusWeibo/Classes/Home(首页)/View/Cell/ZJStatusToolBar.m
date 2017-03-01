//
//  ZJStatusToolBar.m
//  TaurusWeibo
//
//  Created by company on 15/9/11.
//  Copyright (c) 2015年 Taurus. All rights reserved.
//

#import "ZJStatusToolBar.h"
#import "ZJStatus.h"

@interface ZJStatusToolBar ()

@property (nonatomic, strong) NSMutableArray *btns;
@property (nonatomic, strong) NSMutableArray *divideVs;

@property (nonatomic, weak) UIButton *retweet;
@property (nonatomic, weak) UIButton *comment;
@property (nonatomic, weak) UIButton *unlike;

@end

@implementation ZJStatusToolBar

- (NSMutableArray *)btns
{
    if (_btns == nil) {
        _btns = [NSMutableArray array];
    }
    return _btns;
}

- (NSMutableArray *)divideVs
{
    if (_divideVs == nil) {
        
        _divideVs = [NSMutableArray array];
    }
    
    return _divideVs;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 添加所有子控件
        [self setUpAllChildView];
        
        self.userInteractionEnabled = YES;
        self.image = [UIImage imageWithStretchableName:@"timeline_card_bottom_background"];
    }
    return self;
}

// 添加所有子控件
- (void)setUpAllChildView
{
    // 转发
    UIButton *retweet = [self setUpOneButtonWithTitle:@"转发" image:[UIImage imageNamed:@"timeline_icon_retweet"]];
    _retweet = retweet;
    
    // 评论
    UIButton *comment = [self setUpOneButtonWithTitle:@"评论" image:[UIImage imageNamed:@"timeline_icon_comment"]];
    _comment = comment;
    
    // 赞
    UIButton *unlike = [self setUpOneButtonWithTitle:@"赞" image:[UIImage imageNamed:@"timeline_icon_unlike"]];
    _unlike = unlike;
    
    //添加图片
    for (int i = 0; i < 2; i++) {
        UIImageView *divideV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"timeline_card_bottom_line"]];
        [self addSubview:divideV];
        [self.divideVs addObject:divideV];
    }

}

- (UIButton *)setUpOneButtonWithTitle:(NSString *)title image:(UIImage *)image
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setImage:image forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:12];
    //文字距离图片距离为5
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
   
    [self addSubview:btn];
    [self.btns addObject:btn];
    return btn;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 设置按钮的frame
    NSUInteger count = self.btns.count;
    CGFloat w = [UIScreen mainScreen].bounds.size.width / count;
    CGFloat h = self.height;
    CGFloat x = 0;
    CGFloat y = 0;
    
    for (int i = 0; i < count ; i++) {
        UIButton *btn = self.btns[i];
        x = i * w;
        btn.frame = CGRectMake(x, y, w, h);
    }
    
    int i = 1;
    //分割线
    for (UIImageView *divide in self.divideVs) {
        UIButton *btn = self.btns[i];
        divide.x = btn.x;
        i++;
    }

}

- (void)setStatus:(ZJStatus *)status
{
    // 设置转发的标题
    [self setBtn:_retweet title:status.reposts_count];
    
    // 设置评论的标题
    [self setBtn:_comment title:status.comments_count];
    
    // 设置赞
    [self setBtn:_unlike title:status.attitudes_count];
    
    _status = status;

}

// 设置按钮的标题
- (void)setBtn:(UIButton *)btn title:(int)count
{
    NSString *title = nil;
    if (count) {
        // > 10000
        if (count > 10000) {
            CGFloat floatCount = count / 10000.0;
            
            title = [NSString stringWithFormat:@"%.1fW",floatCount];
            title = [title stringByReplacingOccurrencesOfString:@".0" withString:@""];
        }else{ // < 10000
            title = [NSString stringWithFormat:@"%d",count];
        }
        // 设置转发
        [btn setTitle:title forState:UIControlStateNormal];
    }
}


@end
