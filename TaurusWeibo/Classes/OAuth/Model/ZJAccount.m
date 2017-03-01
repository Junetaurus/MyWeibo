//
//  ZJAccount.m
//  TaurusWeibo
//
//  Created by company on 15/9/10.
//  Copyright (c) 2015年 Taurus. All rights reserved.
//

#import "ZJAccount.h"
#import "MJExtension.h"

#define ZJAccountTokenKey @"token"
#define ZJUidKey @"uid"
#define ZJExpires_inKey @"exoires"
#define ZJExpires_dateKey @"date"

@implementation ZJAccount

MJCodingImplementation

+ (instancetype)accountWithDict:(NSDictionary *)dict
{
    ZJAccount *account = [[self alloc] init];
    [account setValuesForKeysWithDictionary:dict];
    return account;
}

- (void)setExpires_in:(NSString *)expires_in
{
    _expires_in = expires_in;
    
    // 计算过期的时间 = 当前时间 + 有效期
    _expires_date = [NSDate dateWithTimeIntervalSinceNow:[expires_in longLongValue]];
}


//// 归档的时候调用：告诉系统哪个属性需要归档，如何归档
//- (void)encodeWithCoder:(NSCoder *)aCoder
//{
//    [aCoder encodeObject:_access_token forKey:ZJAccountTokenKey];
//    [aCoder encodeObject:_expires_in forKey:ZJExpires_inKey];
//    [aCoder encodeObject:_uid forKey:ZJUidKey];
//    [aCoder encodeObject:_expires_date forKey:ZJExpires_dateKey];
//
//}
//// 解档的时候调用：告诉系统哪个属性需要解档，如何解档
//- (id)initWithCoder:(NSCoder *)aDecoder
//{
//    if (self = [super init]) {
//        // 一定要记得赋值
//        _access_token =  [aDecoder decodeObjectForKey:ZJAccountTokenKey];
//        _expires_in = [aDecoder decodeObjectForKey:ZJExpires_inKey];
//        _uid = [aDecoder decodeObjectForKey:ZJUidKey];
//        _expires_date = [aDecoder decodeObjectForKey:ZJExpires_dateKey];
//    }
//    return self;
//}

@end
