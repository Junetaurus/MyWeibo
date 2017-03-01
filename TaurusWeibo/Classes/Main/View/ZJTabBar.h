//
//  ZJTabBar.h
//  TaurusWeibo
//
//  Created by company on 15/9/6.
//  Copyright (c) 2015年 Taurus. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZJTabBar;

@protocol ZJTabBarDelegate <NSObject>

- (void)tabBar:(ZJTabBar *)tabBar didClickButton:(NSInteger)index;

/**
 *  点击加号按钮的时候调用
 *
 
 */
- (void)tabBarDidClickPlusButton:(ZJTabBar *)tabBar;


@end

@interface ZJTabBar : UIView

// items:保存每一个按钮对应tabBarItem模型
@property (nonatomic, strong) NSArray *items;

@property (nonatomic, weak) id<ZJTabBarDelegate> delegate;

@end
