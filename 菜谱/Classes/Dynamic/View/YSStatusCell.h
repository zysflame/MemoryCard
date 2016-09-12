//
//  QYStatusCell.h
//  青云微博
//
//  Created by qingyun on 16/7/14.
//  Copyright © 2016年 qingyun. All rights reserved.
//  微博主页cell

#import <UIKit/UIKit.h>

@class YSStatusModel;
@class YSMessageModel;

@interface YSStatusCell : UITableViewCell

@property (nonatomic, strong) YSMessageModel *messageModel;
@property (nonatomic, strong) YSStatusModel *status;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
