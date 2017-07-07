//
//  ZJMenuAnimateView.h
//  TaurusWeibo
//
//  Created by ZhangJun on 2017/7/7.
//  Copyright © 2017年 Taurus. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZJMenuButton;

@protocol ZJMenuAnimateViewDelegate <NSObject>

- (void)menuAnimateViewButton:(ZJMenuButton *)button;

@end

@interface ZJMenuAnimateView : UIView

@property (nonatomic, weak) id<ZJMenuAnimateViewDelegate>delegate;

- (void)closeAnimation:(void (^)())completion;

@end
