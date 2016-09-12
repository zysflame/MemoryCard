//
//  YSCommentModel.m
//  菜谱
//
//  Created by qingyun on 16/9/11.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "YSCommentModel.h"

@implementation YSCommentModel

+ (instancetype)commentModelWithDictionary:(NSDictionary *)dicData{
    YSCommentModel *model = [YSCommentModel new];
    model.travelId = dicData[@"travelId"];
    model.ticketId = dicData[@"ticketId"];
    model.sightName = dicData[@"sightName"];
    model.sightId = dicData[@"sightId"];
    model.useComment = dicData[@"useComment"];
    return model;
}

@end
