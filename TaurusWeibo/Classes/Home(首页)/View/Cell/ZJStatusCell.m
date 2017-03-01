//
//  ZJStatusCell.m
//  TaurusWeibo
//
//  Created by company on 15/9/11.
//  Copyright (c) 2015年 Taurus. All rights reserved.
//

#import "ZJStatusCell.h"

#import "ZJOriginalView.h"
#import "ZJRetweetView.h"
#import "ZJStatusToolBar.h"
#import "ZJStatusFrame.h"

@interface ZJStatusCell ()

@property (nonatomic, weak) ZJOriginalView *originalView;
@property (nonatomic, weak) ZJRetweetView *retweetView ;
@property (nonatomic, weak)  ZJStatusToolBar *toolBar;

@end

@implementation ZJStatusCell

//cell用initWithStyle初始化
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setUpAllChildView];
        self.backgroundColor = [UIColor clearColor];
    }
    return  self;
}

// 添加所有子控件
- (void)setUpAllChildView
{
    // 原创微博
    ZJOriginalView *originalView = [[ZJOriginalView alloc] init];
    [self addSubview:originalView];
    _originalView = originalView;
    
    // 转发微博
    ZJRetweetView *retweetView = [[ZJRetweetView alloc] init];
    [self addSubview:retweetView];
    _retweetView = retweetView;
    
    // 工具条
    ZJStatusToolBar *toolBar = [[ZJStatusToolBar alloc] init];
    [self addSubview:toolBar];
    _toolBar = toolBar;

}

- (void)setStatusFrame:(ZJStatusFrame *)statusFrame
{
    _statusFrame = statusFrame;
    
    //设置原创微博的frame
    _originalView.frame = statusFrame.originalViewFrame;
    _originalView.statusFrame = statusFrame;
    
    //设置转发微博的frame
    _retweetView.frame = statusFrame.retweetViewFrame;
    _retweetView.statusFrame = statusFrame;
    
    //设置工具条的frame
    _toolBar.frame = statusFrame.toolBarFrame;
    _toolBar.status = statusFrame.status;

}

+ (instancetype)cellWithTableView:(UITableView *)tableView;
{
    static NSString *cellID = @"cell";
    id cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell == nil) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    return cell;
}

@end
