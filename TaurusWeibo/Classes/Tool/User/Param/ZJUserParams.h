//
//  ZJUserParams.h
//  TaurusWeibo
//
//  Created by company on 15/9/11.
//  Copyright (c) 2015年 Taurus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZJBaseParams.h"

@interface ZJUserParams : ZJBaseParams
/**
 *  当前登录用户唯一标识符
 */
@property (nonatomic, copy) NSString *uid;

@end
