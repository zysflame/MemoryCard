//
//  YSHomeInfoViewController.h
//  菜谱
//
//  Created by qingyun on 16/8/19.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YSCurrentMessage;

@interface YSHomeInfoViewController : UIViewController

/** 当前的信息*/
@property (nonatomic, strong) YSCurrentMessage *currentMessage;

@end
