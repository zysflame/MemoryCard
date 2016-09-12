//
//  YSHTTPRequest.m
//  青云微博
//
//  Created by qingyun on 16/8/1.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "YSHTTPRequestManager.h"

#import "AFNetWorking.h"

@implementation YSHTTPRequestManager

+ (instancetype)sharedHTTPRequest{
    static YSHTTPRequestManager *HTTPRequest ;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
       HTTPRequest = [YSHTTPRequestManager new];
    });
    return HTTPRequest;
}

#pragma mark  > POST 请求时调用的方法 <
- (void)POSTWithURL:(NSString *)strURL withParam:(NSDictionary *)dictParam andRequestSuccess:(void (^)(id responseObject))blkRequestSuccess andRequestFailure:(void (^)(NSError *error))blkRequestFailure{
    // 创建一个 HTTP管理
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    // 设置响应的接收类型
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html",nil];
    [manager POST:strURL parameters:dictParam  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 网络请求成功时调用
//        NSLog(@"%@",responseObject);
        blkRequestSuccess(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 网络请求失败时调用
        blkRequestFailure(error);
        
    }];
}

#pragma mark  > GET 请求时调用的方法 <
- (void)GETWithURL:(NSString *)strURL withParam:(NSDictionary *)dictParam andRequestSuccess:(void (^)(id responseObject))blkRequestSuccess andRequestFailure:(void (^)(NSError *error))blkRequestFailure{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
     manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"charset/UTF-8", nil];
    [manager GET:strURL parameters:dictParam  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 网络请求成功时调用
//        NSLog(@"%@",responseObject);
        blkRequestSuccess(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 网络请求失败时调用
        blkRequestFailure(error);
        
    }];
}



@end
