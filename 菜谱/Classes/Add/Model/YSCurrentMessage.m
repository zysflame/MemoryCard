//
//  YSMessage.m
//  菜谱
//
//  Created by qingyun on 16/9/9.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "YSCurrentMessage.h"

@implementation YSCurrentMessage

+ (NSString *)parseClassName{
    return @"YSCurrentMessage";
}

- (void)setNickName:(NSString *)nickName{
    _nickName = nickName;
    [self setObject:nickName forKey:@"nickName"];
}

- (void)setUserName:(NSString *)userName{
    _userName = userName;
    [self setObject:userName forKey:@"userName"];
}

- (void)setContent:(NSString *)content{
    _content = content;
    [self setObject:content forKey:@"content"];
}

- (void)setArrImages:(NSArray *)arrImages{
    _arrImages = arrImages;
    [self setObject:arrImages forKey:@"arrImages"];
}

- (void)setHeaderImv:(NSData *)headerImv{
    _headerImv = headerImv;
    [self setObject:headerImv forKey:@"headerImv"];
}

@end
