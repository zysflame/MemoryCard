//
//  YSCommentInfoModel.m
//  菜谱
//
//  Created by qingyun on 16/9/12.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "YSCommentInfoModel.h"

@implementation YSCommentInfoModel

+ (instancetype)modelWithDictionary:(NSDictionary *)dicData{
    YSCommentInfoModel *model = [YSCommentInfoModel new];
    model.nickname = dicData[@"nickname"];
    model.date = dicData[@"date"];
    model.comment = dicData[@"comment"];
    NSArray *arrTemp = dicData[@"images"];
    NSMutableArray *arrMImages = [NSMutableArray arrayWithCapacity:arrTemp.count];
    for (NSDictionary *dic in arrTemp) {
        NSString *strImageURL = dic[@"img"];
//        NSURL *imageURL = [NSURL URLWithString:strImageURL];
        [arrMImages addObject:strImageURL];
    }
    model.images = [arrMImages copy];
    
    return model;
}

@end
