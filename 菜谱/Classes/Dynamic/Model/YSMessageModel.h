//
//  YSMessageModel.h
//  菜谱
//
//  Created by qingyun on 16/9/7.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "YSUserInfoModel.h"

@interface YSMessageModel : NSObject

/** 用户的用户名*/
@property (nonatomic, strong) YSUserInfoModel *userInfo;
/** 信息的内容*/
@property (nonatomic, copy) NSString *content;
/** 创建的时间*/
@property (nonatomic, copy) NSString *createdAt;
@property (nonatomic, copy, readonly) NSString *strTimeDes;
/** 最后一次更新时间*/
@property (nonatomic,copy) NSString *updatedAt;

/** 发表的说说内添加的图片*/
@property (nonatomic, copy) NSArray *arrImages;
/** 创建模型*/
+ (instancetype)messageModelWithDictionary:(NSDictionary *)dicData;


@end
