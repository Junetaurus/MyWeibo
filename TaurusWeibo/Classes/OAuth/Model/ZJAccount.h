//
//  ZJAccount.h
//  TaurusWeibo
//
//  Created by company on 15/9/10.
//  Copyright (c) 2015年 Taurus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZJAccount : NSObject <NSCoding>

/**
 *  获取数据的访问命令牌
 */
@property (nonatomic, copy) NSString *access_token;
/**
 *  账号的有效期
 */
@property (nonatomic, copy) NSString *expires_in;
/**
 *  用户唯一标识符
 */
@property (nonatomic, copy) NSString *uid;

/**
 *   过期时间 = 当前保存时间+有效期
 */
@property (nonatomic, strong) NSDate *expires_date;
/**
 *  账号的有效期
 */
@property (nonatomic, copy) NSString *remind_in;


/**
 *  用户的昵称
 */
@property (nonatomic, copy) NSString *name;



+ (instancetype)accountWithDict:(NSDictionary *)dict;


@end
