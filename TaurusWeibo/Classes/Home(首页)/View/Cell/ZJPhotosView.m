//
//  ZJPhotosView.m
//  TaurusWeibo
//
//  Created by company on 15/9/12.
//  Copyright (c) 2015年 Taurus. All rights reserved.
//  相册View包含所有的配图

#import "ZJPhotosView.h"
#import "ZJPhoto.h"
#import "UIImageView+WebCache.h"
#import "ZJPhotoView.h"
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"

@implementation ZJPhotosView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //添加所有子控件
        [self setUpAllChildView];
    }
    return self;
}

- (void)setUpAllChildView
{
    for (int i = 0; i < 9; i++) {
        ZJPhotoView *imageV = [[ZJPhotoView alloc] init];
        // 添加点按手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        [imageV addGestureRecognizer:tap];

        imageV.tag = i;
        [self addSubview:imageV];
    }

}

#pragma mark - 点击图片的时候调用
- (void)tap:(UITapGestureRecognizer *)tap
{
    UIImageView *tapView = (UIImageView *)tap.view;
    
    int i = 0;
    NSMutableArray *arrM = [NSMutableArray array];
    // ZJPhoto -> MJPhoto
    for (ZJPhoto *photo in _pic_urls) {
        MJPhoto *photos = [[MJPhoto alloc] init];
        NSString *urlStr = photo.thumbnail_pic.absoluteString;
        //替换为bmiddle 图片清楚
        urlStr = [urlStr stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"bmiddle"];
        photos.url = [NSURL URLWithString:urlStr];
        photos.index = i;
        photos.srcImageView = tapView;
        [arrM addObject:photos];
        i++;
    }
    
    // 弹出图片浏览器
    // 创建浏览器对象
    MJPhotoBrowser *brower = [[MJPhotoBrowser alloc] init];
    // MJPhoto
    brower.photos = arrM;
    brower.currentPhotoIndex = tapView.tag;
    [brower show];

}

- (void)setPic_urls:(NSArray *)pic_urls
{
    _pic_urls = pic_urls;
    NSInteger count = self.subviews.count;
    for (int i = 0; i < count; i++) {
        
        ZJPhotoView *imageV = self.subviews[i];
        
        if (i < _pic_urls.count) { // 显示
            imageV.hidden = NO;
            
            // 获取ZJPhoto模型
            ZJPhoto *photo = _pic_urls[i];
            
            imageV.photo = photo;
        }else{
            imageV.hidden = YES;
        }
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat w = 70;
    CGFloat h = 70;
    
    CGFloat margin = 10;
    int col = 0;
    int rol = 0;
    int cols = _pic_urls.count == 4 ? 2 : 3;
    
    // 计算显示出来的imageView
    for (int i = 0; i < _pic_urls.count; i++) {
        col = i % cols;
        rol = i / cols;
        UIImageView *imageV = self.subviews[i];
        x = col * (w + margin);
        y = rol * (h + margin);
        imageV.frame = CGRectMake(x, y, w, h);
    }

}

@end
