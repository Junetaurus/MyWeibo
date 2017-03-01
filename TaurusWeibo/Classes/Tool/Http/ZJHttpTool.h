//
//  ZJHttpTool.h
//  TaurusWeibo
//
//  Created by company on 15/9/10.
//  Copyright (c) 2015年 Taurus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZJUpLoadParam.h"

@interface ZJHttpTool : NSObject

/**
 *  发送get请求
 */
+ (void)GET:(NSString *)URLString
 parameters:(id)parameters
    success:(void (^)(id responseObject))success
    failure:(void (^)(NSError *error))failure;


/**
 *  发送post请求
 */

+ (void)POST:(NSString *)URLString
  parameters:(id)parameters
     success:(void (^)(id responseObject))success
     failure:(void (^)(NSError *error))failure;

/**
 *  上传文件请求
 */

+ (void)UpLoad:(NSString *)URLString
    parameters:(id)parameters
   upLoadParam:(ZJUpLoadParam *)upLoadParam
       success:(void (^)(id responseObject))success
       failure:(void (^)(NSError *error))failure;


@end
