//
//  ZJNewComposeViewController.m
//  TaurusWeibo
//
//  Created by ZhangJun on 2017/7/7.
//  Copyright © 2017年 Taurus. All rights reserved.
//

#import "ZJNewComposeViewController.h"
#import "ZJComposeViewController.h"
#import "ZJMenuAnimateView.h"

@interface ZJNewComposeViewController () <ZJMenuAnimateViewDelegate>

@property (nonatomic, strong) ZJMenuAnimateView *animateView;
@property (nonatomic, strong) UIButton *backBtn;

@end

@implementation ZJNewComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initView];
    // Do any additional setup after loading the view.
}

- (void)initView {
    CGFloat tabH = 49.0f;
    //
    self.animateView = [[ZJMenuAnimateView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - tabH)];
    self.animateView.delegate = self;
    [self.view addSubview:self.animateView];
    
    //
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, self.animateView.y + self.animateView.height, self.view.width, 0.5)];
    line.backgroundColor = BackGounderColor;
    [self.view addSubview:line];
    
    //
    UIButton *backbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.backBtn = backbtn;
    [backbtn setImage:[UIImage imageNamed:@"publish_close_n"] forState:UIControlStateNormal];
    [backbtn setImage:[UIImage imageNamed:@"publish_close_n"] forState:UIControlStateHighlighted];
    [backbtn addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [backbtn sizeToFit];
    backbtn.x = 0.5 * (self.view.width - backbtn.width);
    backbtn.y = line.y + line.height + 0.5 * (tabH - line.height - backbtn.height);
    [self.view addSubview:backbtn];
}

- (void)backBtnClick:(UIButton *)btn {
    if (self.animateView) {
        btn.userInteractionEnabled = NO;
        [self.animateView closeAnimation:^{
            [self dismissViewControllerAnimated:NO completion:^{
                btn.userInteractionEnabled = YES;
            }];
        }];
    }
}

- (void)menuAnimateViewButton:(ZJMenuButton *)button {
    [self dismissViewControllerAnimated:NO completion:^{
        if (ZJKeyWindow.rootViewController && [ZJKeyWindow.rootViewController isKindOfClass:[ZJTabBarController class]]) {
            ZJTabBarController *tabVC = (ZJTabBarController *)ZJKeyWindow.rootViewController;
            ZJComposeViewController *composeVC = [[ZJComposeViewController alloc] init];
            ZJNavigationController *nav = [[ZJNavigationController alloc] initWithRootViewController:composeVC];
            [tabVC presentViewController:nav animated:YES completion:nil];
        }
    }];
}

@end
