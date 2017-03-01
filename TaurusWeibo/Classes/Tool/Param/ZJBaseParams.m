//
//  ZJBaseParams.m
//  TaurusWeibo
//
//  Created by company on 15/9/11.
//  Copyright (c) 2015年 Taurus. All rights reserved.
//

#import "ZJBaseParams.h"
#import "ZJAccountTool.h"
#import "ZJAccount.h"

@implementation ZJBaseParams

+ (instancetype)param
{
    ZJBaseParams *param = [[self alloc] init];
    
    param.access_token = [ZJAccountTool account].access_token;
    
    return param;
}


@end
