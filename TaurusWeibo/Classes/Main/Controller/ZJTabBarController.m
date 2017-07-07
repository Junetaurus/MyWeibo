//
//  ZJTabBarController.m
//  TaurusWeibo
//
//  Created by company on 15/9/6.
//  Copyright (c) 2015年 Taurus. All rights reserved.
//

#import "ZJTabBarController.h"
#import "ZJTabBar.h"

#import "ZJUserResult.h"
#import "ZJAccount.h"
#import "ZJAccountTool.h"
#import "ZJHttpTool.h"
#import "ZJUserParams.h"

#import "ZJHomeViewController.h"
#import "ZJMessageViewController.h"
#import "ZJDiscoverViewController.h"
#import "ZJProfileViewController.h"

#import "MJExtension.h"

#import "ZJNewComposeViewController.h"


@interface ZJTabBarController () <ZJTabBarDelegate>

@property (nonatomic, strong) NSMutableArray *items;

@property (nonatomic, weak) ZJHomeViewController *home;
@property (nonatomic, weak) ZJMessageViewController *message;
@property (nonatomic, weak) ZJDiscoverViewController *discover;
@property (nonatomic, weak) ZJProfileViewController *profile;


@end

@implementation ZJTabBarController

- (NSMutableArray *)items
{
    if (_items == nil) {
        
        _items = [NSMutableArray array];
        
    }
    return _items;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    //添加所有控制器
    [self setUpAllChildViewController];
    
    // 自定义tabBar
    [self setUpTabBar];
    
    //请求未读数目
    [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(requestUnread) userInfo:nil repeats:YES];
}

#pragma mark - 请求未读数目
- (void)requestUnread
{
    ZJUserParams *params = [ZJUserParams param];
    params.uid = [ZJAccountTool account].uid;
    
    [ZJHttpTool GET:@"https://rm.api.weibo.com/2/remind/unread_count.json" parameters:params.keyValues success:^(id responseObject) {
        
        ZJUserResult *result = [ZJUserResult objectWithKeyValues:responseObject];
        
        // 设置首页未读数
        _home.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d",result.status];
        
        // 设置消息未读数
        _message.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d",result.messageCount];
        
        // 设置我的未读数
        _profile.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d",result.follower];
        
        // 设置应用程序所有的未读数
        [UIApplication sharedApplication].applicationIconBadgeNumber = result.totoalCount;

    } failure:^(NSError *error) {
        NSLog(@"error = %@",error);
    }];
}
#pragma mark - 设置tabBar
- (void)setUpTabBar
{
    ZJTabBar *tabBar = [[ZJTabBar alloc] initWithFrame:self.tabBar.frame];
    tabBar.backgroundColor = [UIColor whiteColor];
    // 设置代理
    tabBar.delegate = self;
    
    // 给tabBar传递tabBarItem模型
    tabBar.items = self.items;
    
    // 添加自定义tabBar
    [self.view addSubview:tabBar];
    
    // 移除系统的tabBar
    [self.tabBar removeFromSuperview];

    
}

#pragma mark - 当点击tabBar上的按钮调用
- (void)tabBar:(ZJTabBar *)tabBar didClickButton:(NSInteger)index
{
    self.selectedIndex = index;
}

// 点击加号按钮的时候调用
- (void)tabBarDidClickPlusButton:(ZJTabBar *)tabBar
{
    ZJNewComposeViewController *composeVC = [[ZJNewComposeViewController alloc] init];
    [self presentViewController:composeVC animated:YES completion:nil];
}


#pragma mark - 添加所有的子控制器
- (void)setUpAllChildViewController
{
    // 首页
    ZJHomeViewController *home = [[ZJHomeViewController alloc] init];
    [self setUpOneChildViewController:home image:[UIImage imageNamed:@"tabbar_home"] selectedImage:[UIImage imageWithOriginalName:@"tabbar_home_selected"] title:@"首页"];
    _home = home;
    
    // 消息
    ZJMessageViewController *message = [[ZJMessageViewController alloc] init];
    [self setUpOneChildViewController:message image:[UIImage imageNamed:@"tabbar_message_center"] selectedImage:[UIImage imageWithOriginalName:@"tabbar_message_center_selected"] title:@"消息"];
    _message = message;
    
    // 发现
    ZJDiscoverViewController *discover = [[ZJDiscoverViewController alloc] init];
    [self setUpOneChildViewController:discover image:[UIImage imageNamed:@"tabbar_discover"] selectedImage:[UIImage imageWithOriginalName:@"tabbar_discover_selected"] title:@"发现"];
    _discover = discover;
    
    // 我
    ZJProfileViewController *profile = [[ZJProfileViewController alloc] init];
    [self setUpOneChildViewController:profile image:[UIImage imageNamed:@"tabbar_profile"] selectedImage:[UIImage imageWithOriginalName:@"tabbar_profile_selected"] title:@"我"];
    _profile = profile;
}

#pragma mark - 添加一个子控制器
- (void)setUpOneChildViewController:(UIViewController *)vc image:(UIImage *)image selectedImage:(UIImage *)selectedImage title:(NSString *)title
{
//    vc.tabBarItem.title = title;
//    vc.navigationItem.title = title;
    
    vc.title = title;
    vc.tabBarItem.image = image;
    vc.tabBarItem.selectedImage = selectedImage;
    
    // 保存tabBarItem模型到数组
    [self.items addObject:vc.tabBarItem];
    
    ZJNavigationController *nav = [[ZJNavigationController alloc] initWithRootViewController:vc];
    
    [self addChildViewController:nav];

}


@end
