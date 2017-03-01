//
//  ZJRetweetView.m
//  TaurusWeibo
//
//  Created by company on 15/9/11.
//  Copyright (c) 2015年 Taurus. All rights reserved.
//

#import "ZJRetweetView.h"

#import "ZJStatus.h"
#import "ZJStatusFrame.h"
#import "ZJPhotosView.h"

@interface ZJRetweetView ()

// 昵称
@property (nonatomic, weak) UILabel *nameView;

// 正文
@property (nonatomic, weak) UILabel *textView;

// 配图
@property (nonatomic, weak) ZJPhotosView *photoView;


@end

@implementation ZJRetweetView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
         // 添加所有子控件
        [self setUpAllChildView];
        
        self.userInteractionEnabled = YES;
        self.image = [UIImage imageWithStretchableName:@"timeline_retweet_background"];
    }
    return self;
}

// 添加所有子控件
- (void)setUpAllChildView
{
    
    // 昵称
    UILabel *nameView = [[UILabel alloc] init];
    nameView.font = [UIFont systemFontOfSize:13];
    nameView.textColor = [UIColor blueColor];
    
    [self addSubview:nameView];
    _nameView = nameView;
    
    
    // 正文
    UILabel *textView = [[UILabel alloc] init];
    textView.font = [UIFont systemFontOfSize:15];
    textView.numberOfLines = 0;
    
    [self addSubview:textView];
    _textView = textView;
    
    // 配图
    ZJPhotosView *photoView = [[ZJPhotosView alloc] init];
    [self addSubview:photoView];
    
    _photoView = photoView;
}

- (void)setStatusFrame:(ZJStatusFrame *)statusFrame
{
    _statusFrame = statusFrame;
    
    ZJStatus *status = statusFrame.status;
    
    // 昵称
    _nameView.frame = statusFrame.retweetNameFrame;
    _nameView.text = status.retweetName;
    
    // 正文
    _textView.frame = statusFrame.retweetTextFrame;
    _textView.text = status.retweeted_status.text;

    // 配图
    _photoView.frame = statusFrame.retweetPhotosFrame;
    _photoView.pic_urls = status.retweeted_status.pic_urls;
}

@end
