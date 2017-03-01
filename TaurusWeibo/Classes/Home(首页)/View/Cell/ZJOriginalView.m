//
//  ZJOriginalView.m
//  TaurusWeibo
//
//  Created by company on 15/9/11.
//  Copyright (c) 2015年 Taurus. All rights reserved.
//

#import "ZJOriginalView.h"
#import "ZJStatus.h"
#import "ZJStatusFrame.h"
#import "ZJPhotosView.h"

#import "UIImageView+WebCache.h"

@interface ZJOriginalView ()

// 头像
@property (nonatomic, weak) UIImageView *iconView;

// 昵称
@property (nonatomic, weak) UILabel *nameView;

// vip
@property (nonatomic, weak) UIImageView *vipView;

// 时间
@property (nonatomic, weak) UILabel *timeView;

// 来源
@property (nonatomic, weak) UILabel *sourceView;

// 正文
@property (nonatomic, weak) UILabel *textView;

// 配图
@property (nonatomic, weak) ZJPhotosView *photoView;

@end

@implementation ZJOriginalView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //添加所有子控件
        [self setUpAllChildView];
        
        self.userInteractionEnabled = YES;
        self.image = [UIImage imageWithStretchableName:@"timeline_card_top_background"];
    }
    return self;
}

//添加所有子控件
- (void)setUpAllChildView
{
    // 头像
    UIImageView *iconView = [[UIImageView alloc] init];
    [self addSubview:iconView];
    _iconView = iconView;
    
    // 昵称
    UILabel *nameView = [[UILabel alloc] init];
    nameView.font = [UIFont systemFontOfSize:13];
    
    [self addSubview:nameView];
    _nameView = nameView;
    
    // vip
    UIImageView *vipView = [[UIImageView alloc] init];
    [self addSubview:vipView];
    _vipView = vipView;
    
    // 时间
    UILabel *timeView = [[UILabel alloc] init];
    timeView.font = [UIFont systemFontOfSize:12];
    timeView.textColor = [UIColor orangeColor];
     
    [self addSubview:timeView];
    _timeView = timeView;
    
    // 来源
    UILabel *sourceView = [[UILabel alloc] init];
    sourceView.font = [UIFont systemFontOfSize:12];
    
    [self addSubview:sourceView];
    _sourceView = sourceView;
    
    // 正文
    UILabel *textView = [[UILabel alloc] init];
    textView.font = [UIFont systemFontOfSize:15];
    textView.numberOfLines = 0;
    
    [self addSubview:textView];
    _textView = textView;
    
    //配图
    ZJPhotosView *photoView = [[ZJPhotosView alloc] init];
    [self addSubview:photoView];
    
    _photoView = photoView;

}

- (void)setStatusFrame:(ZJStatusFrame *)statusFrame
{
    _statusFrame = statusFrame;
    // 设置frame
    [self setUpFrame];
    // 设置data
    [self setUpData];

}

- (void)setUpData
{
    ZJStatus *status = _statusFrame.status;
    // 头像
    [_iconView sd_setImageWithURL:status.user.profile_image_url placeholderImage:[UIImage imageNamed:@"timeline_image_placeholder"]];
    
    // 昵称
    if (status.user.vip) {
        _nameView.textColor = [UIColor redColor];
    }else{
        _nameView.textColor = [UIColor blackColor];
    }
    _nameView.text = status.user.name;
    
    // vip
    NSString *imageName = [NSString stringWithFormat:@"common_icon_membership_level%d",status.user.mbrank];
    UIImage *image = [UIImage imageNamed:imageName];
    
    _vipView.image = image;
    
    // 时间
    _timeView.text = status.created_at;
    
    // 来源
    
    _sourceView.text = status.source;
    
    // 正文
    _textView.text = status.text;
    
    // 配图
    _photoView.pic_urls = status.pic_urls;
}

- (void)setUpFrame
{
    // 头像
    _iconView.frame = _statusFrame.originalIconFrame;
    
    // 昵称
    _nameView.frame = _statusFrame.originalNameFrame;
    
    // vip
    if (_statusFrame.status.user.vip) { // 是vip
        _vipView.hidden = NO;
        _vipView.frame = _statusFrame.originalVipFrame;
    }else{
        _vipView.hidden = YES;
    }
    
    // 时间 动态的需要每次都计算
    //获取模型
    ZJStatus *status = _statusFrame.status;
    
    CGFloat timeX = _nameView.frame.origin.x;
    CGFloat timeY = CGRectGetMaxY(_nameView.frame) + 5;
    CGSize timeSize = [status.created_at sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}];
    _timeView.frame = (CGRect){{timeX,timeY},timeSize};
    
    // 来源
    CGFloat sourceX = CGRectGetMaxX(_timeView.frame) + 10;
    CGFloat sourceY = timeY;
    CGSize sourceSize = [status.source sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}];
    _sourceView.frame = (CGRect){{sourceX,sourceY},sourceSize};
    
    // 正文
    _textView.frame = _statusFrame.originalTextFrame;
    
    // 配图
    _photoView.frame = _statusFrame.originalPhotosFrame;
}


@end
