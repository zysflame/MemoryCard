//
//  YSMessage.h
//  菜谱
//
//  Created by qingyun on 16/9/9.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "AVObject.h"

@interface YSMessage : AVObject <AVSubclassing>

@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSMutableArray *arrImageData;

@end
