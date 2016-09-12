//
//  LocationManager.h
//  菜谱
//
//  Created by qingyun on 16/8/31.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Radar/BMKRadarComponent.h>

@interface YSLocationManager : NSObject

/** 搜索周围用户返回的结果 */
@property (nonatomic, copy) void(^blkSearchResult)(NSUInteger result);
/** 定位成功后返回的位置*/
@property (nonatomic, copy) void(^blkLocationUpdate)(CLLocationCoordinate2D coordinat);
/** 雷达搜索后返回的用户的数组*/
@property (nonatomic, copy) void(^blkRadarNear)(NSArray *radarNears);

/** 创建时用的单例*/
+ (instancetype)shareLocationManager;
/** 开启定位服务*/
- (void)startTheLocationService;


- (void)stopTheLocationService;
@end
