//
//  ZJMenuAnimateView.m
//  TaurusWeibo
//
//  Created by ZhangJun on 2017/7/7.
//  Copyright © 2017年 Taurus. All rights reserved.
//

#import "ZJMenuAnimateView.h"
#import "ZJMenuButton.h"

@interface ZJMenuAnimateView ()

@property (nonatomic, assign) NSInteger columnCount;
@property (nonatomic, assign) CGFloat margin;
@property (nonatomic, strong) NSArray<NSString *> *textArray;
@property (nonatomic, strong) NSMutableArray<NSString *> *imageNameArray;

@end

@implementation ZJMenuAnimateView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.masksToBounds = YES;
        
        self.columnCount = 3;
        self.margin = 10;
        
        self.textArray = @[NSLocalizedString(@"文字",nil),NSLocalizedString(@"图片",nil),NSLocalizedString(@"视频",nil),NSLocalizedString(@"语音",nil),NSLocalizedString(@"投票",nil),NSLocalizedString(@"签到",nil)];
        self.imageNameArray = [NSMutableArray array];
        for (NSInteger i = 0; i < self.textArray.count; i ++) {
            [self.imageNameArray addObject:[NSString stringWithFormat:@"publish_%ld",i]];
        }
        //
        [self showMenu];
        
        //
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self startAnimation];
        });
    }
    return self;
}

- (void)showMenu {
    CGFloat width = (self.width - (self.margin * (self.columnCount - 1)))/self.columnCount;
    for (NSInteger i = 0; i < self.imageNameArray.count; i++) {
        NSInteger row = i / self.columnCount;
        NSInteger loc = i % self.columnCount;
        ZJMenuButton *button = [ZJMenuButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake((self.margin + width) * loc,self.height + (self.margin + width) * row, width, width);
        [self addSubview:button];
        NSString *imageName = self.imageNameArray[i];
        UIImage *image = [UIImage imageNamed:imageName];
        [button setImage:image forState:UIControlStateNormal];
        [button setImage:image forState:UIControlStateHighlighted];
        if (self.textArray && i < self.textArray.count) {
            [button setTitle:self.textArray[i] forState:UIControlStateNormal];
        }
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.tag = i;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)startAnimation {
    for (NSInteger i = 0; i < self.imageNameArray.count; i++) {
        ZJMenuButton *button = self.subviews[i];
        [UIView animateWithDuration:0.03*(self.imageNameArray.count)*5 delay:i*0.03 usingSpringWithDamping:0.7 initialSpringVelocity:0.05 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            button.y -= button.width * 2 + self.margin;
        } completion:^(BOOL finished) {
            
        }];
    }
}

- (void)closeAnimation:(void (^)())completion {
    for (NSInteger i = 0; i < self.imageNameArray.count; i++) {
        ZJMenuButton *button = self.subviews[i];
        [UIView animateWithDuration:0.03*(self.imageNameArray.count)*5 delay:0.03*self.imageNameArray.count-i*0.03 usingSpringWithDamping:0.7 initialSpringVelocity:0.05 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            button.y += button.width * 2 + self.margin;
        } completion:^(BOOL finished) {
            [button removeFromSuperview];
            completion();
        }];
    }
}

- (void)buttonClick:(ZJMenuButton *)btn {
    if (self.delegate && [self.delegate respondsToSelector:@selector(menuAnimateViewButton:)]) {
        [self.delegate menuAnimateViewButton:btn];
    }
}

@end
