//
//  YSMessageModel.m
//  菜谱
//
//  Created by qingyun on 16/9/7.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "YSMessageModel.h"

@implementation YSMessageModel

+ (instancetype)messageModelWithDictionary:(NSDictionary *)dicData{
    if (dicData == nil || [dicData isKindOfClass:[NSNull class]]) return nil;
    YSMessageModel *model = [self new];
    model.content = dicData[@"content"];
    model.createdAt = dicData[@"createdAt"];
    model.updatedAt = dicData[@"updatedAt"];
    return model;
}

- (void)setCreatedAt:(NSString *)createdAt{
    _createdAt = [createdAt copy];
//    _strTimeDes = [NSString descriptionWithString:_createdAt];
}

@end
