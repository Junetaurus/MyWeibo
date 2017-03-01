//
//  ZJStatusResult.m
//  TaurusWeibo
//
//  Created by company on 15/9/12.
//  Copyright (c) 2015年 Taurus. All rights reserved.
//

#import "ZJStatusResult.h"
#import "ZJStatus.h"

@implementation ZJStatusResult

+ (NSDictionary *)objectClassInArray
{
    return @{@"statuses":[ZJStatus class]};
}

@end
