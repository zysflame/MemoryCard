//
//  YSProductModel.m
//  菜谱
//
//  Created by qingyun on 16/9/11.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "YSProductModel.h"

@implementation YSProductModel

+ (instancetype)modelWithDictionary:(NSDictionary *)dicData{
    YSProductModel *model = [YSProductModel new];
    model.img = dicData[@"img"];
    model.title = dicData[@"title"];
    model.comment = dicData[@"comment"];
    model.distance = dicData[@"newDist"];
    model.address = dicData[@"address"];
    model.strID = dicData[@"id"];
    model.iosPoint = dicData[@"iosPoint"];
    return model;
}

@end
