//
//  YSProductModel.h
//  菜谱
//
//  Created by qingyun on 16/9/11.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YSProductModel : NSObject

/** 图片*/
@property (nonatomic,copy) NSString *img;
/** title 标题*/
@property (nonatomic,copy) NSString *title;
/** comment 评论数量*/
@property (nonatomic,copy) NSString *comment;
/** address  地址*/
@property (nonatomic,copy) NSString *address;
/** id  详情请求用的id*/
@property (nonatomic,copy) NSString *strID;
/** iosPoint 地址*/
@property (nonatomic,copy) NSString *iosPoint;




/** 创建模型*/
+ (instancetype)modelWithDictionary:(NSDictionary *)dicData;

@end
