//
//  ZJStatusCell.h
//  TaurusWeibo
//
//  Created by company on 15/9/11.
//  Copyright (c) 2015年 Taurus. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZJStatusFrame;

@interface ZJStatusCell : UITableViewCell

@property (nonatomic, strong)ZJStatusFrame *statusFrame;

+ (instancetype)cellWithTableView:(UITableView *)tableView;


@end
