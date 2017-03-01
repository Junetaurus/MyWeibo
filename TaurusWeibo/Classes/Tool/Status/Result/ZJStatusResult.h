//
//  ZJStatusResult.h
//  TaurusWeibo
//
//  Created by company on 15/9/12.
//  Copyright (c) 2015年 Taurus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

@interface ZJStatusResult : NSObject

/**
 *  用户的微博数组（CZStatus）
 */
@property (nonatomic, strong) NSArray *statuses;
/**
 *  用户最近微博总数
 */
@property (nonatomic, assign) int total_number;


@end
