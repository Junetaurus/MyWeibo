//
//  ZJPopMenu.h
//  TaurusWeibo
//
//  Created by company on 15/9/9.
//  Copyright (c) 2015年 Taurus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZJPopMenu : UIImageView

/**
 *  显示弹出菜单
 */
+ (instancetype)showInRect:(CGRect)rect;

/**
 *  隐藏弹出菜单
 */
+ (void)hide;

// 内容视图
@property (nonatomic, weak) UIView *contentView;



@end
