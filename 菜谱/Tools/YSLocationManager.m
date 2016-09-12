//
//  LocationManager.m
//  菜谱
//
//  Created by qingyun on 16/8/31.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "YSLocationManager.h"

// 遵守的是位置管理和雷达服务的代理
@interface YSLocationManager () <BMKLocationServiceDelegate,BMKRadarManagerDelegate>

/** 百度封装的 位置服务管理器*/
@property (nonatomic, strong) BMKLocationService *locationService;
/** 定位的当前位置*/
@property (nonatomic) CLLocation *currentLocation;
/** 雷达属性的定义*/
@property (nonatomic, strong) BMKRadarManager *radarManager;

@end

@implementation YSLocationManager

#pragma mark  > 初始化定位服务器 --- 懒加载 <
- (BMKLocationService *)locationService{
    if (!_locationService) {
        _locationService = [[BMKLocationService alloc] init];
        _locationService.distanceFilter = 100.f;  // 设置最小的更新距离
        // 设置定位的精确度
        _locationService.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    }
    return _locationService;
}

#pragma mark  > 初始化一个雷达管理器 --- 懒加载 <
- (BMKRadarManager *)radarManager{
    if (!_radarManager) {
        _radarManager = [[BMKRadarManager alloc] init];
        _radarManager.userId = @"此处填写雷达扫描的 用户的专有id";
        [_radarManager addRadarManagerDelegate:self];
    }
    return _radarManager;
}

#pragma mark  > 创建单例 <
+ (instancetype)shareLocationManager{
    static YSLocationManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[YSLocationManager alloc] init];
    });
    return manager;
}

#pragma mark  > 开始定位 <
- (void)startTheLocationService{
    [self.locationService startUserLocationService];
}

- (void)stopTheLocationService{
    [self.locationService stopUserLocationService];
}

#pragma mark  > BMKLocationServiceDelegate 定位后调用的方法 <
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation{
    // 把获取到的位置赋值给当前位置
    self.currentLocation = userLocation.location;
    // 回调block 块
    if (self.blkLocationUpdate) {
        self.blkLocationUpdate(userLocation.location.coordinate);
    }
    // 定位成功后上传位置信息   --- 雷达定位需要用到的自己的位置
//    BMKRadarUploadInfo *info = [[BMKRadarUploadInfo alloc] init];
//    // 指定位置的信息
//    info.pt = userLocation.location.coordinate;
//    info.extInfo = @"我";
//    // 上传信息 --- 开始上传的结果
//    BOOL result = [self.radarManager uploadInfoRequest:info];
//    NSLog(@"开始上传的结果是>>>%d",result);
}

#pragma mark  > BMKRadarManagerDelegate --- 上传用户信息后得到的结果 <
- (void)onGetRadarUploadResult:(BMKRadarErrorCode)error{
    // 查找周围用户的对象
    BMKRadarNearbySearchOption *searchOption = [[BMKRadarNearbySearchOption alloc] init];
    // 设置搜索的半径
    searchOption.radius = 8000.f;
    // 设置中心点位置
    searchOption.centerPt = self.currentLocation.coordinate;
    // 设置排序的类型   默认的是由近到远
    searchOption.sortType = BMK_RADAR_SORT_TYPE_DISTANCE_FROM_NEAR_TO_FAR;
    BOOL result = [self.radarManager getRadarNearbySearchRequest:searchOption];
    NSLog(@"检索开始的结果>>>%d",result);
}

#pragma mark  > BMKRadarManagerDelegate --- 搜索周围得到的结果 <
- (void)onGetRadarNearbySearchResult:(BMKRadarNearbyResult *)result error:(BMKRadarErrorCode)error{
    // 当error 是0 时表示得到了数据
    if (error != 0) {
        NSLog(@"未搜到数据。。。请重试");
        if (self.blkSearchResult) {
            self.blkSearchResult(error);
        }
        return;
    }
//    //处理结果
//    NSMutableArray *resultArray = [NSMutableArray arrayWithCapacity:result.totalNum];
//    // pageNum 总页数
//    for (NSUInteger index = 0; index < result.pageNum; index ++) {
//        result.pageIndex = index;
//        [resultArray addObjectsFromArray:result.infoList];
//    }
    // 将所有对象转化为model
//    NSMutableArray *modelArray = [NSMutableArray arrayWithCapacity:resultArray.count];
//    for (BMKRadarNearbyInfo *info in resultArray){
//        UserInfo *user = [[UserInfo alloc] init];
//        user.userID = info.userId;
        
        //将经纬度转化为cllocation,计算距离
//        CLLocation *userLocation = [[CLLocation alloc] initWithLatitude:info.pt.latitude longitude:info.pt.longitude];
        //用户的位置距离的计算
//         user.distanse = [self.currentLocation distanceFromLocation:userLocation];
//        [modelArray addObject:user];
//    }
    
//    if (self.blkRadarNear) {
//        self.blkRadarNear(modelArray);
//    }
}

- (void)dealloc{
    // 释放雷达的服务
    [self.radarManager removeRadarManagerDelegate:self];
    [BMKRadarManager releaseRadarManagerInstance];
}

@end
