//
//  YSCommentInfoModel.h
//  菜谱
//
//  Created by qingyun on 16/9/12.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YSCommentInfoModel : NSObject

/** nickname 昵称*/
@property (nonatomic,copy) NSString *nickname;
/** 日期*/
@property (nonatomic,copy) NSString *date;
/** comment*/
@property (nonatomic,copy) NSString *comment;
/** 图片*/
@property (nonatomic, strong) NSMutableArray *images;

/** 创建模型*/
+ (instancetype)modelWithDictionary:(NSDictionary *)dicData;


@end
