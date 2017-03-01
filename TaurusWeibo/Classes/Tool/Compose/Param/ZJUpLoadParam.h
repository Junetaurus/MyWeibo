//
//  ZJUpLoadParam.h
//  TaurusWeibo
//
//  Created by company on 15/10/4.
//  Copyright © 2015年 Taurus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZJUpLoadParam : NSObject

/**
 *  上传文件的二进制数据
 */
@property (nonatomic, strong) NSData *data;

/**
 *  上传的参数名称
 */
@property (nonatomic, copy) NSString *name;

/**
 *  上传到服务器的文件名称
 */
@property (nonatomic, copy) NSString *fileName;

/**
 *  上传文件的类型
 */
@property (nonatomic, copy) NSString *mimeType;


@end
