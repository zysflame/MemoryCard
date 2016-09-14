//
//  YSCommentModel.m
//  菜谱
//
//  Created by qingyun on 16/9/11.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "YSCommentRequestModel.h"

@implementation YSCommentRequestModel

+ (instancetype)commentRequestModelWithDictionary:(NSDictionary *)dicData{
    YSCommentRequestModel *model = [YSCommentRequestModel new];
    model.travelId = dicData[@"travelId"];
    model.ticketId = dicData[@"ticketId"];
    model.sightName = dicData[@"sightName"];
    model.sightId = dicData[@"sightId"];
    model.useComment = dicData[@"useComment"];
    return model;
}

@end
