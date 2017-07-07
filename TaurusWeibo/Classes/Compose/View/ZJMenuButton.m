//
//  ZJMenuButton.m
//  TaurusWeibo
//
//  Created by ZhangJun on 2017/7/7.
//  Copyright © 2017年 Taurus. All rights reserved.
//

#import "ZJMenuButton.h"

@implementation ZJMenuButton

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat margin = 8;
    
    CGFloat imgW = self.imageView.width;
    CGFloat imgH = self.imageView.height;
    CGFloat imgX = 0.5 * (self.width - imgW);
    self.imageView.frame = CGRectMake(imgX, margin, imgW, imgH);
    
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.frame = CGRectMake(0, imgH + margin*2, self.width, self.titleLabel.font.lineHeight);
}

@end
