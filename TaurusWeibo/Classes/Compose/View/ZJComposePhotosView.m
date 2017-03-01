//
//  ZJComposePhotosView.m
//  TaurusWeibo
//
//  Created by company on 15/10/4.
//  Copyright © 2015年 Taurus. All rights reserved.
//

#import "ZJComposePhotosView.h"

@implementation ZJComposePhotosView

- (void)setImage:(UIImage *)image
{
    _image = image;
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = image;
    [self addSubview:imageView];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    NSInteger cols = 3;
    CGFloat marign = 10;
    CGFloat wh = (self.width - (cols - 1) * marign) / cols;
    
    CGFloat x = 0;
    CGFloat y = 0;
    NSInteger col = 0;
    NSInteger row = 0;
    
    for (int i = 0; i < self.subviews.count; i++) {
        UIImageView *imageV = self.subviews[i];
        
        col = i % cols;
        row = i / cols;
        
        x = col * (marign + wh);
        y = row * (marign + wh);
        
        imageV.frame = CGRectMake(x, y, wh, wh);
    }

}

@end
