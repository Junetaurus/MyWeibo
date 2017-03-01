//
//  ZJCover.h
//  TaurusWeibo
//
//  Created by company on 15/9/9.
//  Copyright (c) 2015年 Taurus. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZJCover;

@protocol ZJCoverDelegate <NSObject>

// 点击蒙板的时候调用
- (void)coverDidClickCover:(ZJCover *)cover;

@end

@interface ZJCover : UIView
/**
 *  显示蒙板
 */
+ (instancetype)show;

//设置浅灰色蒙板

@property (nonatomic, assign) BOOL dimBackground;

@property (nonatomic ,weak)id<ZJCoverDelegate> delegate;

@end
