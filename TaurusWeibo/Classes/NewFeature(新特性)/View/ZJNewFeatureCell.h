//
//  ZJNewFeatureCell.h
//  TaurusWeibo
//
//  Created by company on 15/9/9.
//  Copyright (c) 2015年 Taurus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZJNewFeatureCell : UICollectionViewCell

@property (nonatomic, strong) UIImage *image;

// 判断是否是最后一页
- (void)setIndexPath:(NSIndexPath *)indexPath count:(int)count;

@end
