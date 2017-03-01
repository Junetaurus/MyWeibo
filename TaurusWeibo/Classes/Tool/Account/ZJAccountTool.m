//
//  ZJAccountTool.m
//  TaurusWeibo
//
//  Created by company on 15/9/10.
//  Copyright (c) 2015年 Taurus. All rights reserved.
//

#import "ZJAccountTool.h"
#import "ZJAccount.h"
#import "ZJHttpTool.h"
#import "ZJRootTool.h"


#define ZJAuthorizeBaseUrl @"https://api.weibo.com/oauth2/authorize"
#define ZJClient_id     @"1306571910"
#define ZJRedirect_uri  @"http://www.baidu.com"
#define ZJClient_secret @"7416ec7ba6fe111247e9bdfad4c595ec"

#define ZJAccountFileName [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"account.data"]

@implementation ZJAccountTool

// 类方法一般用静态变量代替成员属性
static ZJAccount *_account;

+ (void)saveAccount:(ZJAccount *)account
{
    [NSKeyedArchiver archiveRootObject:account toFile:ZJAccountFileName];
}

+ (ZJAccount *)account
{
    if (_account == nil) {
        _account = [NSKeyedUnarchiver unarchiveObjectWithFile:ZJAccountFileName];
        
        // 判断下账号是否过期，如果过期直接返回Nil
        if ([[NSDate date] compare:_account.expires_date] == NSOrderedDescending) {
            return nil;
        }
    }
    return _account;
}

@end
