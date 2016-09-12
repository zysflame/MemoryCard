//
//  YSUserInfoModel.m
//  菜谱
//
//  Created by qingyun on 16/9/7.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "YSUserInfoModel.h"

@implementation YSUserInfoModel

+ (instancetype)modelWithDictionary:(NSDictionary *)dicData{
    YSUserInfoModel *model = [YSUserInfoModel new];
    model.userID = dicData[@"username"];
    model.nickName = dicData[@"nickName"];
    model.headerImageData = dicData[@"headerImage"];
    model.gender = dicData[@"gender"];
    
    NSArray *arr = dicData[@"MessageData"];
    NSUInteger count = arr.count;
    for (NSUInteger index = 0; index < count; index ++) {
        NSString  *strID = arr[index];
        [model.messageData addObject:strID];
    }
    
    return model;
}

@end
