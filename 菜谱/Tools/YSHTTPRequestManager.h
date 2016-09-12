//
//  YSHTTPRequest.h
//  青云微博
//
//  Created by qingyun on 16/8/1.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YSHTTPRequestManager : NSObject

/** 创建的单例*/
+ (instancetype)sharedHTTPRequest;

/** post 请求时使用的方法*/
- (void)POSTWithURL:(NSString *)strURL
       withParam:(NSDictionary *)dictParam
       andRequestSuccess:(void(^)(id responseObject))blkRequestSuccess
       andRequestFailure:(void(^)(NSError *error)) blkRequestFailure;

/** get 请求时用的方法*/
- (void)GETWithURL:(NSString *)strURL
          withParam:(NSDictionary *)dictParam
  andRequestSuccess:(void(^)(id responseObject))blkRequestSuccess
  andRequestFailure:(void(^)(NSError *error)) blkRequestFailure;
@end
