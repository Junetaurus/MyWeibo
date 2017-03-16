//
//  ZJHomeViewController.m
//  TaurusWeibo
//
//  Created by company on 15/9/6.
//  Copyright (c) 2015年 Taurus. All rights reserved.
//

#import "ZJHomeViewController.h"
#import "ZJOneViewController.h"
#import "UIBarButtonItem+Item.h"
#import "ZJTitleButton.h"
#import "ZJPopMenu.h"
#import "ZJCover.h"
#import "ZJStatusCell.h"
#import "ZJStatusFrame.h"

#import "ZJAccount.h"
#import "ZJAccountTool.h"
#import "ZJHttpTool.h"
#import "ZJUserParams.h"
#import "ZJStatusParams.h"

#import "ZJUser.h"
#import "ZJStatus.h"

#import "MJExtension.h"
#import "MJRefresh.h"
#import "UIImageView+WebCache.h"


@interface ZJHomeViewController () <ZJCoverDelegate>

@property (nonatomic, weak) ZJTitleButton *titleButton;

@property (nonatomic, strong) ZJOneViewController *one;

@property (nonatomic, strong) NSMutableArray *statuses;

@end

@implementation ZJHomeViewController

- (NSMutableArray *)statuses
{
    if (_statuses == nil) {
        _statuses = [NSMutableArray array];
    }
    return _statuses;
}

- (ZJOneViewController *)one
{
    if (_one == nil) {
        _one = [[ZJOneViewController alloc] init];
    }
    return _one;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundColor = BackGounderColor;
    
    // 取消分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //设置导航条内容
    [self setUpNavgationBar];
    
    // 添加下拉刷新控件
    [self.tableView addHeaderWithTarget:self action:@selector(loadNewStatus)];
    
    // 添加上拉刷新控件
    [self.tableView addFooterWithTarget:self action:@selector(loadMoreStatus)];
    
    //自动下拉刷新
    [self.tableView headerBeginRefreshing];
    
    //设置用户昵称
    [self setUserName];
}

#pragma mark - 设置用户昵称
- (void)setUserName
{
    //创建参数模型
    ZJUserParams *params = [ZJUserParams param];
    params.uid = [ZJAccountTool account].uid;
    
    [ZJHttpTool GET:@"https://api.weibo.com/2/users/show.json" parameters:params.keyValues success:^(id responseObject) {
        //字典转模型
        ZJUser *user = [ZJUser objectWithKeyValues:responseObject];
        // 设置导航条的标题
        [self.titleButton setTitle:user.name forState:UIControlStateNormal];
        
        //获取当前的账号
        ZJAccount *account = [ZJAccountTool account];
        account.name = user.name;
        
        // 保存用户的名称
        [ZJAccountTool saveAccount:account];
    } failure:^(NSError *error) {
        NSLog(@"error = %@",error);
    }];

}

#pragma mark - 展示最新的微博数
-(void)showNewStatusCount:(NSInteger)count
{
    if (count == 0) {
        return;
    }
     // 展示最新的微博
    CGFloat x = 0;
    CGFloat y = CGRectGetMaxY(self.navigationController.navigationBar.frame) - 35;
    CGFloat w = [UIScreen mainScreen].bounds.size.width;
    CGFloat h = 35;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(x, y, w, h)];
    
    label.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"timeline_new_status_background"]];
    label.textColor = [UIColor whiteColor];
    label.text = [NSString stringWithFormat:@"最新微博数%ld",count];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:16];
    
    // 插入导航控制器下导航条下面
    [self.navigationController.view insertSubview:label belowSubview:self.navigationController.navigationBar];
    
    // 动画往下平移
    [UIView animateWithDuration:0.3 animations:^{
        label.transform = CGAffineTransformMakeTranslation(0, h);
    } completion:^(BOOL finished) {
        // 动画往上平移
        [UIView animateWithDuration:0.3 delay:2.2 options:UIViewAnimationOptionCurveLinear animations:^{
            //还原
            label.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            [label removeFromSuperview];

        }];
    }];
}

#pragma mark - 请求最新的微博
- (void)loadNewStatus
{
    NSString *sinceId = nil;
    if (self.statuses.count) {
        ZJStatus *status = [self.statuses[0] status];
        sinceId = status.idstr;
    }
    
    ZJStatusParams *params = [[ZJStatusParams alloc] init];
    params.access_token = [ZJAccountTool account].access_token;
    
    if (sinceId) {
        params.since_id = sinceId;
    }
    
    [ZJHttpTool GET:@"https://api.weibo.com/2/statuses/friends_timeline.json" parameters:params.keyValues success:^(id responseObject) {
        [self.tableView headerEndRefreshing];
        // 获取微博字典数组
        NSArray *dictArr = responseObject[@"statuses"];
        // 把字典数组转换成模型数组
        NSArray *statue =[ZJStatus objectArrayWithKeyValuesArray:dictArr];
        //展示最新的微博数
        [self showNewStatusCount:statue.count];
        
        // 模型转换视图模型 ZJStatus -> ZJStatusFrame
        NSMutableArray *statusFrames = [NSMutableArray array];
        for (ZJStatus *status in statue) {
            ZJStatusFrame *statusF = [[ZJStatusFrame alloc] init];
            statusF.status = status;
            [statusFrames addObject:statusF];
        }

        
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, statue.count)];
        // 把最新的微博数插入到最前面
        [self.statuses insertObjects:statusFrames atIndexes:indexSet];
        
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        NSLog(@"error = %@",error);
    }];
}


#pragma mark - 请求更多旧的微博
- (void)loadMoreStatus
{
    NSString *maxIdStr = nil;
    if (self.statuses.count) {
        ZJStatus *status = [self.statuses[0] status];
        long long maxId = [status.idstr longLongValue] - 1;
        maxIdStr = [NSString stringWithFormat:@"%lld",maxId];    }
    
    ZJStatusParams *params = [[ZJStatusParams alloc] init];
    params.access_token = [ZJAccountTool account].access_token;
    
    if (maxIdStr) {
        params.since_id = maxIdStr;
    }
    
    [ZJHttpTool GET:@"https://api.weibo.com/2/statuses/friends_timeline.json" parameters:params.keyValues success:^(id responseObject) {
        
        [self.tableView footerEndRefreshing];
        // 获取微博字典数组
        NSArray *dictArr = responseObject[@"statuses"];
        
        // 把字典数组转换成模型数组
        NSArray *statue = [ZJStatus objectArrayWithKeyValuesArray:dictArr];
        
        // 模型转换视图模型 ZStatus -> ZJStatusFrame
        NSMutableArray *statusFrames = [NSMutableArray array];
        for (ZJStatus *status in statue) {
            ZJStatusFrame *statusF = [[ZJStatusFrame alloc] init];
            statusF.status = status;
            [statusFrames addObject:statusF];
        }

        //添加
        [self.statuses addObjectsFromArray:statusFrames];
        
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        NSLog(@"error = %@",error);
    }];
}

#pragma mark - 设置导航条
- (void)setUpNavgationBar
{
    // 左边
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem barButtonItemWithImage:[UIImage imageNamed:@"navigationbar_friendsearch"] highImage:[UIImage imageNamed:@"navigationbar_friendsearch_highlighted"] target:self action:@selector(friendsearch) forControlEvents:UIControlEventTouchUpInside];
    
    // 右边
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem barButtonItemWithImage:[UIImage imageNamed:@"navigationbar_pop"] highImage:[UIImage imageNamed:@"navigationbar_pop_highlighted"] target:self action:@selector(pop) forControlEvents:UIControlEventTouchUpInside];
    
    // TitleView
    ZJTitleButton *titleButton = [ZJTitleButton buttonWithType:UIButtonTypeCustom];
    _titleButton = titleButton;
      
    NSString *title = [ZJAccountTool account].name ? [ZJAccountTool account].name : @"首页";
    [titleButton setTitle:title forState:UIControlStateNormal];
    
    [titleButton setImage:[UIImage imageNamed:@"navigationbar_arrow_up"] forState:UIControlStateNormal];
    [titleButton setImage:[UIImage imageNamed:@"navigationbar_arrow_down"] forState:UIControlStateSelected];
    
    [titleButton addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
    
     // 高亮的时候不需要调整图片
    titleButton.adjustsImageWhenHighlighted = NO;
    self.navigationItem.titleView = titleButton;
}

- (void)friendsearch
{
    
}

- (void)pop
{
    
}

//点击标题按钮
- (void)titleClick:(UIButton *)button
{
    button.selected = !button.selected;
    
    //弹出蒙板
    ZJCover *cover = [ZJCover show];
    cover.delegate = self;
    
    //弹出pop菜单
    CGFloat popW = 200;
    CGFloat popX = (self.view.width - 200) * 0.5;
    CGFloat popH = popW;
    CGFloat popY = 55;
    ZJPopMenu *menu = [ZJPopMenu showInRect:CGRectMake(popX, popY, popW, popH)];
    menu.contentView = self.one.view;
}

// 点击蒙板的时候调用
- (void)coverDidClickCover:(ZJCover *)cover
{
    //隐藏pop菜单
    [ZJPopMenu hide];
    _titleButton.selected = NO;
}

#pragma mark - tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.statuses.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZJStatusCell *cell = [ZJStatusCell cellWithTableView:tableView];
    // 获取status模型
    ZJStatusFrame *statusFrame = self.statuses[indexPath.row];
    
    // 给cell传递模型
    cell.statusFrame = statusFrame;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 获取status模型
    ZJStatusFrame *statusFrame = self.statuses[indexPath.row];
    
    return statusFrame.cellHeight;
}

@end

