//
//  ZJUser.m
//  TaurusWeibo
//
//  Created by company on 15/9/10.
//  Copyright (c) 2015年 Taurus. All rights reserved.
//

#import "ZJUser.h"

@implementation ZJUser

- (void)setMbtype:(int)mbtype
{
    _mbtype = mbtype;
    _vip = mbtype > 2;
}

@end
