//
//  YSUserInfoModel.h
//  菜谱
//
//  Created by qingyun on 16/9/7.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YSUserInfoModel : NSObject

/** userID 用户的账号*/
@property (nonatomic,copy) NSString *userID;
/** nickName 昵称*/
@property (nonatomic,copy) NSString *nickName;
/** 头像*/
@property (nonatomic) NSData *headerImageData;
/** gender 性别*/
@property (nonatomic,copy) NSString *gender;
/** 存放消息的数组*/
@property (nonatomic, strong) NSMutableArray *messageData;

/** 创建模型*/
+ (instancetype)modelWithDictionary:(NSDictionary *)dicData;


@end
