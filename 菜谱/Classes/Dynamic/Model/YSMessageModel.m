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
   
    return model;
}

@end
