//
//  UIImage+Image.h
//  TaurusWeibo
//
//  Created by company on 15/9/6.
//  Copyright (c) 2015年 Taurus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Image)

// 加载最原始的图片，没有渲染
+ (instancetype)imageWithOriginalName:(NSString *)imageName;

//拉伸图片
+ (instancetype)imageWithStretchableName:(NSString *)imageName;

@end
