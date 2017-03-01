//
//  ZJUser.h
//  TaurusWeibo
//
//  Created by company on 15/9/10.
//  Copyright (c) 2015年 Taurus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZJUser : NSObject

/**
 *  微博昵称
 */
@property (nonatomic, copy) NSString *name;
/**
 *  微博头像
 */
@property (nonatomic, strong) NSURL *profile_image_url;

/** 会员类型 > 2代表是会员 */
@property (nonatomic, assign) int mbtype;

/** 会员等级 */
@property (nonatomic, assign) int mbrank;


@property (nonatomic, assign,getter=isVip) BOOL vip;


@end
