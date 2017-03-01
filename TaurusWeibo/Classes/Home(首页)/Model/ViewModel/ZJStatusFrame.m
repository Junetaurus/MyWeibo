//
//  ZJStatusFrame.m
//  TaurusWeibo
//
//  Created by company on 15/9/11.
//  Copyright (c) 2015年 Taurus. All rights reserved.
//

#import "ZJStatusFrame.h"
#import "ZJStatus.h"
#import "ZJUser.h"

@implementation ZJStatusFrame

- (void)setStatus:(ZJStatus *)status
{
    _status = status;
    
    // 计算原创微博
    [self setUpOriginalViewFrame];
    CGFloat toolBarY = CGRectGetMaxY(_originalViewFrame);
    
    if (status.retweeted_status) {
        
        // 计算转发微博
        [self setUpRetweetViewFrame];
        
        toolBarY = CGRectGetMaxY(_retweetViewFrame);
    }
    
    //计算工具条
    CGFloat toolBarX = 0;
    CGFloat toolBarW = [UIScreen mainScreen].bounds.size.width;
    CGFloat toolBarH = 35;
    _toolBarFrame = CGRectMake(toolBarX, toolBarY, toolBarW, toolBarH);
    
    //计算cell高度
    _cellHeight = CGRectGetMaxY(_toolBarFrame);
}

#pragma mark - 计算原创微博
- (void)setUpOriginalViewFrame
{
    //头像
    CGFloat imageX = 10;
    CGFloat imageY = 10;
    CGFloat imageW = 35;
    CGFloat imageH = 35;
    _originalIconFrame = CGRectMake(imageX, imageY, imageW, imageH);
    
    //昵称
    CGFloat nameX = CGRectGetMaxX(_originalIconFrame) + 10;
    CGFloat nameY = imageY;
    CGSize nameSize = [_status.user.name sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]}];
    _originalNameFrame = (CGRect){{nameX,nameY},nameSize};
    
    //vip
    if (_status.user.vip) {
        CGFloat vipX = CGRectGetMaxX(_originalNameFrame) + 10;
        CGFloat vipY = nameY;
        CGFloat vipWH = 15;
        _originalVipFrame = CGRectMake(vipX, vipY, vipWH, vipWH);
    }
    
//    // 时间
//    CGFloat timeX = nameX;
//    CGFloat timeY = CGRectGetMaxY(_originalNameFrame) + 5;
//    CGSize timeSize = [_status.created_at sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}];
//    _originalTimeFrame = (CGRect){{timeX,timeY},timeSize};
//    
//    // 来源
//    CGFloat sourceX = CGRectGetMaxX(_originalTimeFrame) + 10;
//    CGFloat sourceY = timeY;
//    CGSize sourceSize = [_status.source sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}];
//    _originalSourceFrame = (CGRect){{sourceX,sourceY},sourceSize};
    
    // 正文
    CGFloat textX = imageX;
    CGFloat textY = CGRectGetMaxY(_originalIconFrame) + 10;
    
    CGFloat textW = [UIScreen mainScreen].bounds.size.width - 20;
    
    CGSize textSize = [_status.text boundingRectWithSize:(CGSize){textW, CGFLOAT_MAX} options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
    _originalTextFrame = (CGRect){{textX,textY},textSize};
    
    CGFloat originH = CGRectGetMaxY(_originalTextFrame) + 10;
    // 配图
    if (_status.pic_urls.count) {
        CGFloat photoX = 10;
        CGFloat photoY = CGRectGetMaxY(_originalTextFrame) + 10;
        CGSize photoSize = [self photosSizeWithCount:_status.pic_urls.count];
        
        _originalPhotosFrame = (CGRect){{photoX,photoY},photoSize};
        originH = CGRectGetMaxY(_originalPhotosFrame) + 10;
    }

    // 原创微博的frame
    CGFloat originX = 0;
    CGFloat originY = 8;
    CGFloat originW = [UIScreen mainScreen].bounds.size.width;
    
    _originalViewFrame = CGRectMake(originX, originY, originW, originH);

}

#pragma mark - 计算转发微博
- (void)setUpRetweetViewFrame
{
    // 昵称
    CGFloat nameX = 10;
    CGFloat nameY = nameX;
    // 转发微博的用户昵称
    CGSize nameSize = [_status.retweetName sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]}];
    _retweetNameFrame = (CGRect){{nameX,nameY},nameSize};
    
    // 正文
    CGFloat textX = nameX;
    CGFloat textY = CGRectGetMaxY(_retweetNameFrame) + 10;
    
    CGFloat textW = [UIScreen mainScreen].bounds.size.width - 20;
    
    // 转发微博的正文
    CGSize textSize = [_status.retweeted_status.text boundingRectWithSize:(CGSize){textW, CGFLOAT_MAX} options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
    _retweetTextFrame = (CGRect){{textX,textY},textSize};
    
    CGFloat retweetH = CGRectGetMaxY(_retweetTextFrame) + 10;
    // 配图
    if (_status.retweeted_status.pic_urls.count) {
        CGFloat photoX = 10;
        CGFloat photoY = CGRectGetMaxY(_retweetTextFrame) + 10;
        CGSize photoSize = [self photosSizeWithCount:_status.retweeted_status.pic_urls.count];
        
        _retweetPhotosFrame = (CGRect){{photoX,photoY},photoSize};
        retweetH = CGRectGetMaxY(_retweetPhotosFrame) + 10;
    }

    
    // 转发微博的frame
    CGFloat retweetX = 0;
    CGFloat retweetY = CGRectGetMaxY(_originalViewFrame);
    CGFloat retweetW = [UIScreen mainScreen].bounds.size.width;
    
    _retweetViewFrame = CGRectMake(retweetX, retweetY, retweetW, retweetH);
}

#pragma mark - 计算配图的尺寸
- (CGSize)photosSizeWithCount:(NSInteger)count
{
    // 获取总列数
    int cols = count == 4 ? 2 : 3;
    // 获取总行数 = (总个数 - 1) / 总列数 + 1
    NSInteger rols = (count - 1) / cols + 1;
    CGFloat photoWH = 70;
    CGFloat w = cols * photoWH + (cols - 1) * 10;
    CGFloat h = rols * photoWH + (rols - 1) * 10;
    
    return CGSizeMake(w, h);
}

@end
