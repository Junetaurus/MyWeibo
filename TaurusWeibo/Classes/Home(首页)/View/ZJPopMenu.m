//
//  ZJPopMenu.m
//  TaurusWeibo
//
//  Created by company on 15/9/9.
//  Copyright (c) 2015年 Taurus. All rights reserved.
//

#import "ZJPopMenu.h"

@implementation ZJPopMenu

// 显示弹出菜单
+ (instancetype)showInRect:(CGRect)rect
{
    ZJPopMenu *menu = [[ZJPopMenu alloc] initWithFrame:rect];
    
    menu.userInteractionEnabled = YES;
    menu.image = [UIImage imageNamed:@"popover_background"];
    
    [ZJKeyWindow addSubview:menu];
    
    return menu;
}

// 隐藏弹出菜单
+ (void)hide
{
    for (UIView *popMenu in ZJKeyWindow.subviews) {
        
        if ([popMenu isKindOfClass:self]) {
            [popMenu removeFromSuperview];
        }
    }
}

// 设置内容视图
- (void)setContentView:(UIView *)contentView
{
    [_contentView removeFromSuperview];
    _contentView = contentView;
    contentView.backgroundColor = [UIColor clearColor];
    [self addSubview:contentView];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    // 计算内容视图尺寸
    CGFloat y = 35;
    CGFloat margin = 5;
    CGFloat x = margin;
    CGFloat w = self.width - 2 * margin;
    CGFloat h = self.height - y - margin;
    
    _contentView.frame = CGRectMake(x, y, w, h);
}

@end
