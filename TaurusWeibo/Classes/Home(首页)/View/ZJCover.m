//
//  ZJCover.m
//  TaurusWeibo
//
//  Created by company on 15/9/9.
//  Copyright (c) 2015年 Taurus. All rights reserved.
//

#import "ZJCover.h"

@implementation ZJCover

// 设置浅灰色蒙板
- (void)setDimBackground:(BOOL)dimBackground
{
    _dimBackground = dimBackground;
    if (dimBackground) {
        self.backgroundColor = [UIColor blackColor];
        self.alpha = 0.5;
    } else {
        self.alpha = 1.0;
        self.backgroundColor = [UIColor clearColor];
    }
}

// 显示蒙板
+ (instancetype)show
{
    ZJCover *cover =[[ZJCover alloc] initWithFrame:[UIScreen mainScreen].bounds];
    cover.backgroundColor = [UIColor clearColor];
    
    [ZJKeyWindow addSubview:cover];
    
    return cover;
}

// 点击蒙板的时候做事情
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //移除蒙板
    [self removeFromSuperview];
    
    // 通知代理移除菜单
    if ([_delegate respondsToSelector:@selector(coverDidClickCover:)]) {
        [_delegate coverDidClickCover:self];
    }
}

@end
