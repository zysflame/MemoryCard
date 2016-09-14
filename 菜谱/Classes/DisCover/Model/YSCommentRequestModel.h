//
//  YSCommentModel.h
//  菜谱
//
//  Created by qingyun on 16/9/11.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YSCommentRequestModel : NSObject

/** travelId */
@property (nonatomic,copy) NSString *travelId;
/** ticketId */
@property (nonatomic,copy) NSString *ticketId;
/** sightId ID  获取图片时要用*/
@property (nonatomic,copy) NSString *sightId;
/** sightName 标题*/
@property (nonatomic,copy) NSString *sightName;
/** useComment  用户评论的标识*/
@property (nonatomic,copy) NSString *useComment;

/** 创建模型*/
+ (instancetype)commentRequestModelWithDictionary:(NSDictionary *)dicData;


@end
