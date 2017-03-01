//
//  ZJStatus.m
//  TaurusWeibo
//
//  Created by company on 15/9/10.
//  Copyright (c) 2015年 Taurus. All rights reserved.
//

#import "ZJStatus.h"
#import "NSDate+Date.h"

@implementation ZJStatus

// 实现这个方法，就会自动把数组中的字典转换成对应的模型
+ (NSDictionary *)objectClassInArray
{
    return @{@"pic_urls":[ZJPhoto class]};
}

//时间处理
- (NSString *)created_at
{
    //日期格式字符串
    NSDateFormatter *dateFmt = [[NSDateFormatter alloc] init];
    //时间日期本地化处理
    dateFmt.locale = [NSLocale localeWithLocaleIdentifier:@"en_US"];
    dateFmt.dateFormat = @"EEE MMM dd HH:mm:ss Z yyyy";
    NSDate *created_at = [dateFmt dateFromString:_created_at];
    
    if ([created_at isThisYear]) { //今年
        if ([created_at isToday]) { //今天
            //计算和当前时间的差距
            NSDateComponents *compare = [created_at deltaWithNow];
            
            if (compare.hour >= 1) {
                return [NSString stringWithFormat:@"%ld小时之前",compare.hour];
            } else if (compare.minute > 1) {
                return [NSString stringWithFormat:@"%ld分钟之前",compare.minute];
            } else {
                return @"刚刚";
            }
        } else if ([created_at isYesterday]) { //昨天
            dateFmt.dateFormat = @"昨天 HH:mm";
            return [dateFmt stringFromDate:created_at];
        } else { //前天
            dateFmt.dateFormat = @"MM-dd HH:mm";
        }
    } else { //不是今年
        dateFmt.dateFormat = @"yyyy-MM-dd HH:mm";
        return [dateFmt stringFromDate:created_at];
    }
    
    return _created_at;
}

//来源处理
- (void)setSource:(NSString *)source
{
    //  <a href="http://app.weibo.com/t/feed/4Pzy3W" rel="nofollow">魅蓝 2</a>
    if (![source isEqualToString:@""]) {
        NSRange range = [source rangeOfString:@">"];
        source = [source substringFromIndex:range.location + range.length];
        range = [source rangeOfString:@"<"];
        source = [source substringToIndex:range.location];
        source = [NSString stringWithFormat:@"来自%@",source];
    } else {
        source = [NSString stringWithFormat:@"%@",source];
    }
    _source = source;
    
}

- (void)setRetweeted_status:(ZJStatus *)retweeted_status
{
    _retweetName = [NSString stringWithFormat:@"@%@",retweeted_status.user.name];
    _retweeted_status = retweeted_status;
}

@end
