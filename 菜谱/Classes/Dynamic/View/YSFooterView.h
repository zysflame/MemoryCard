//
//  QYFooterView.h
//  青云微博
//
//  Created by qingyun on 16/7/14.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import <UIKit/UIKit.h>

//@class YSStatusModel;

@interface YSFooterView : UITableViewHeaderFooterView

//@property (nonatomic, strong) YSStatusModel *status;

+ (instancetype)footerViewWithTableView:(UITableView *)tableView;

@end
