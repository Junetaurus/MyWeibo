//
//  ZJNewFeatureCell.m
//  TaurusWeibo
//
//  Created by company on 15/9/9.
//  Copyright (c) 2015年 Taurus. All rights reserved.
//

#import "ZJNewFeatureCell.h"
#import "ZJTabBarController.h"

@interface ZJNewFeatureCell ()

@property (nonatomic ,weak) UIImageView *imageView;

@property (nonatomic, weak) UIButton *shareButton;

@property (nonatomic, weak) UIButton *startButton;


@end

@implementation ZJNewFeatureCell

- (UIButton *)shareButton
{
    if (_shareButton == nil) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:@"分享给大家" forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"new_feature_share_false"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"new_feature_share_true"] forState:UIControlStateSelected];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn sizeToFit];
        
        [self.contentView addSubview:btn];
        
        _shareButton = btn;

    }
    return _shareButton;
}

- (UIButton *)startButton
{
    if (_startButton == nil) {
        UIButton *startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [startBtn setTitle:@"开始微博" forState:UIControlStateNormal];
        [startBtn setBackgroundImage:[UIImage imageNamed:@"new_feature_finish_button"] forState:UIControlStateNormal];
        [startBtn setBackgroundImage:[UIImage imageNamed:@"new_feature_finish_button_highlighted"] forState:UIControlStateHighlighted];
        [startBtn sizeToFit];
        [startBtn addTarget:self action:@selector(start) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:startBtn];
        _startButton = startBtn;
        
    }
    return _startButton;
}


- (UIImageView *)imageView
{
    if (_imageView == nil) {
        
        UIImageView *imageView = [[UIImageView alloc] init];
        
        _imageView = imageView;
        //加载
        [self.contentView addSubview:imageView];
    }
    return _imageView;
}

//布局
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.imageView.frame = self.bounds;
   
    // 分享按钮
    self.shareButton.center = CGPointMake(self.width * 0.5, self.height * 0.8);
    
    // 开始按钮
    self.startButton.center = CGPointMake(self.width * 0.5, self.height * 0.9);
}

- (void)setImage:(UIImage *)image
{
    _image = image;
    
    self.imageView.image = image;
}

// 判断当前cell是否是最后一页
- (void)setIndexPath:(NSIndexPath *)indexPath count:(int)count
{
    if (indexPath.row == count - 1) { // 最后一页,显示分享和开始按钮
        self.shareButton.hidden = NO;
        self.startButton.hidden = NO;
        
    }else{ // 非最后一页，隐藏分享和开始按钮
        self.shareButton.hidden = YES;
        self.startButton.hidden = YES;
    }

}

- (void)start
{
    // 进入tabBarVc
    ZJTabBarController *tabBarVC = [[ZJTabBarController alloc] init];
    
    // 切换根控制器:可以直接把之前的根控制器清空
    ZJKeyWindow.rootViewController = tabBarVC;
}

@end
