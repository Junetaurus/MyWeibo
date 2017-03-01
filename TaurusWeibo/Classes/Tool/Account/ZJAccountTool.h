//
//  ZJAccountTool.h
//  TaurusWeibo
//
//  Created by company on 15/9/10.
//  Copyright (c) 2015年 Taurus. All rights reserved.
//  专门处理账号的业务（账号存储和读取）

#import <Foundation/Foundation.h>
@class ZJAccount;

@interface ZJAccountTool : NSObject

+ (void)saveAccount:(ZJAccount *)account;

+ (ZJAccount *)account;

@end
