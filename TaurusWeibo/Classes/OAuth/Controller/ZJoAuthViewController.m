//
//  ZJoAuthViewController.m
//  TaurusWeibo
//
//  Created by company on 15/9/10.
//  Copyright (c) 2015年 Taurus. All rights reserved.
//

#import "ZJoAuthViewController.h"
#import "MBProgressHUD+MJ.h"
#import "ZJAccount.h"
#import "ZJAccountTool.h"
#import "ZJRootTool.h"
#import "ZJHttpTool.h"

#define ZJAuthorizeBaseUrl @"https://api.weibo.com/oauth2/authorize"
#define ZJClient_id     @"2247054958"
#define ZJRedirect_uri  @"http://www.baidu.com"
#define ZJClient_secret @"53dc4544387f967dd770d1774c4a6d3e"

@interface ZJoAuthViewController () <UIWebViewDelegate>

@end

@implementation ZJoAuthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:webView];
    
    //加载网页
    
    // 拼接URL字符串
    NSString *urlStr = [NSString stringWithFormat:@"%@?client_id=%@&redirect_uri=%@",ZJAuthorizeBaseUrl,ZJClient_id,ZJRedirect_uri];
    
    //创建URl
    NSURL *url = [NSURL URLWithString:urlStr];
    
    //创建请求
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    //加载请求
    [webView loadRequest:request];
    
    //设置代理
    webView.delegate = self;
    
}

#pragma mark -UIWebView代理
//  webview开始加载的时候调用
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    //提示用户
    [MBProgressHUD showMessage:@"正在加载中..."];
}

// webview加载完成的时候调用
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [MBProgressHUD hideHUD];
}

//  webview加载失败的时候调用
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [MBProgressHUD hideHUD];
}

// 拦截webView请求
// 当Webview需要加载一个请求的时候，就会调用这个方法，询问下是否请求
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *urlStr = request.URL.absoluteString;
    
    // 获取code(RequestToken)
    NSRange range = [urlStr rangeOfString:@"code="];
    if (range.length) { // 有code=
        
        // code=7743d1bb2280084a22f99ee270da5faf
        // 0 + length
        
        NSString *code = [urlStr substringFromIndex:range.location + range.length];
        // 换取accessToken
        [self accessTokenWithCode:code];
        
        return NO;
        
    }
    
    return YES;
}

/*
 
 必选	类型及范围	说明
 client_id	true	string	申请应用时分配的AppKey。
 client_secret	true	string	申请应用时分配的AppSecret。
 grant_type	true	string	请求的类型，填写authorization_code
 
 grant_type为authorization_code时
 必选	类型及范围	说明
 code	true	string	调用authorize获得的code值。
 redirect_uri	true	string	回调地址，需需与注册应用里的回调地址一致。
 
 */

#pragma mark - 换取accessToken
- (void)accessTokenWithCode:(NSString *)code
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"client_id"] = ZJClient_id;
    params[@"client_secret"] = ZJClient_secret;
    params[@"grant_type"] = @"authorization_code";
    params[@"code"] = code;
    params[@"redirect_uri"] = ZJRedirect_uri;
    
    [ZJHttpTool POST:@"https://api.weibo.com/oauth2/access_token" parameters:params success:^(id responseObject) {
        
        NSLog(@"%@",responseObject);
        // 字典转模型
        ZJAccount *account = [ZJAccount accountWithDict:responseObject];
        
        // 保存账号信息:方便以后修改
        [ZJAccountTool saveAccount:account];
        
        //选择窗口的根控制器
        [ZJRootTool chooseRootViewController:ZJKeyWindow];

        
    } failure:^(NSError *error) {
        NSLog(@"error = %@",error);
    }];
}


@end
