//
//  YSMessageModel.h
//  菜谱
//
//  Created by qingyun on 16/9/7.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YSMessageModel : AVObject <AVSubclassing>

/** 用户的用户名*/
@property (nonatomic, copy) NSString *nickName;
/** 用户名*/
@property (nonatomic,copy) NSString *userName;
/** 头像*/
@property (nonatomic, strong) NSData *headerImv;
/** 信息的内容*/
@property (nonatomic, copy) NSString *content;
/** 发表的说说内添加的图片*/
@property (nonatomic, copy) NSArray *arrImages;
/** 创建的时间*/
@property (nonatomic, copy, readonly) NSString *strTimeDes;


/** 创建模型*/
+ (instancetype)messageModelWithDictionary:(NSDictionary *)dicData;


@end
