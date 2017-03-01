//
//  ZJBaseParams.h
//  TaurusWeibo
//
//  Created by company on 15/9/11.
//  Copyright (c) 2015年 Taurus. All rights reserved.
//  基本的参数模型

#import <Foundation/Foundation.h>

@interface ZJBaseParams : NSObject

/**
 *  采用OAuth授权方式为必填参数,访问命令牌
 */
@property (nonatomic, copy) NSString *access_token;

+ (instancetype)param;

@end
