//
//  ZJComposeToolBar.h
//  TaurusWeibo
//
//  Created by company on 15/9/18.
//  Copyright (c) 2015年 Taurus. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZJComposeToolBar;

@protocol ZJComposeToolBarDelegate <NSObject>

- (void)composeToolBar:(ZJComposeToolBar *)toolBar didClickBtn:(NSInteger)index;

@end

@interface ZJComposeToolBar : UIView

@property (nonatomic, weak) id<ZJComposeToolBarDelegate> delegate;

@end
