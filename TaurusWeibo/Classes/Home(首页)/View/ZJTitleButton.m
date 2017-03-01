//
//  ZJTitleButton.m
//  TaurusWeibo
//
//  Created by company on 15/9/9.
//  Copyright (c) 2015年 Taurus. All rights reserved.
//

#import "ZJTitleButton.h"

@implementation ZJTitleButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        [self setBackgroundImage:[UIImage imageWithStretchableName:@"navigationbar_filter_background_highlighted"] forState:UIControlStateHighlighted];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.currentImage == nil) return;
    // title
    self.titleLabel.x = 0;
    // image
    self.imageView.x = CGRectGetMaxX(self.titleLabel.frame);
}

// 重写setTitle方法，扩展计算尺寸功能
- (void)setTitle:(NSString *)title forState:(UIControlState)state
{
    [super setTitle:title forState:state];
    
    [self sizeToFit];
}

- (void)setImage:(UIImage *)image forState:(UIControlState)state
{
    [super setImage:image forState:state];
    
    [self sizeToFit];
}


@end
