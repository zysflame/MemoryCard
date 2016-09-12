//
//  YSRecommendTableViewCell.h
//  菜谱
//
//  Created by qingyun on 16/9/11.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YSProductModel.h"

@interface YSRecommendTableViewCell : UITableViewCell

@property (nonatomic, strong) YSProductModel *productModel;
/** 创建cell的类方法*/
+ (instancetype)recommnedCellWithTableView:(UITableView *)tableView;

@end
