//
//  YSRecommendViewController.m
//  菜谱
//
//  Created by qingyun on 16/8/17.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "YSDiscoverViewController.h"
#import "YSListDisCoverViewController.h"

#import <CoreLocation/CoreLocation.h> // 导入系统框架
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import "YSLocationManager.h"

@interface YSDiscoverViewController () <CLLocationManagerDelegate,BMKMapViewDelegate,BMKLocationServiceDelegate>

/** 展示地图的图层*/
@property (nonatomic, weak) BMKMapView *mapViewBack;

@property (nonatomic, strong) BMKLocationService *locService;

@end

@implementation YSDiscoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadDefaultSetting];
    [self loadNavigationSetting];
    
    [self getTheCityNameWith];

    
}

#pragma mark 加载导航栏设置
- (void)loadNavigationSetting{
    UIBarButtonItem *itemListBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"tabbar_menu"] style:UIBarButtonItemStylePlain target:self action:@selector(clickTheListBtnAction)];
    self.navigationItem.rightBarButtonItem = itemListBtn;
}

#pragma mark  > 发送网络请求 <
- (void)requestInformation{
    NSString *strURL = @"http://restapi.amap.com/v3/place/around?key=c56887a1512d6e2d932fd294a8a0ed59&location=113.56503%2C34.819452&radius=5000&output=json&offset=50";
    
    YSHTTPRequestManager *manager = [YSHTTPRequestManager sharedHTTPRequest];
    NSDictionary *dic = @{@"uid":@"token"};
    [manager GETWithURL:strURL withParam:dic andRequestSuccess:^(id responseObject) {
        
        NSLog(@">>>%@",responseObject);
        // 附近的一些地址
        
        
    } andRequestFailure:^(NSError *error) {
        NSLog(@">>>>>请求失败");
        __weak typeof(self) weakSelf = self;
        UIAlertController *alertContorller = [UIAlertController alertControllerWithTitle:@"友情提示" message:@"网络不好，请耐心等待" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }];
        UIAlertAction *alertDengLuAction = [UIAlertAction actionWithTitle:@"刷新试试" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertContorller addAction:alertDengLuAction];
        [alertContorller addAction:alertAction];
        [self presentViewController:alertContorller animated:YES completion:nil];
        
    }];
    
    
}


#pragma mark  > 点击了列表按钮 <
- (void)clickTheListBtnAction{
    YSListDisCoverViewController *listVc = [YSListDisCoverViewController new];
    [self.navigationController pushViewController:listVc animated:YES];
}

#pragma mark 加载默认设置
- (void)loadDefaultSetting{
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *btnStart = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:btnStart];
    btnStart.frame = CGRectMake(50, 80, 80, 50);
    btnStart.backgroundColor = [UIColor orangeColor];
    [btnStart setTitle:@"开始" forState:UIControlStateNormal];
    [btnStart addTarget:self action:@selector(startTheDingWei) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *gensui = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:gensui];
    gensui.frame = CGRectMake(230, 80, 80, 50);
    gensui.backgroundColor = [UIColor orangeColor];
    [gensui setTitle:@"跟随" forState:UIControlStateNormal];
    [gensui addTarget:self action:@selector(gensui) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btnStop = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:btnStop];
    btnStop.frame = CGRectMake(140, 80, 80, 50);
    btnStop.backgroundColor = [UIColor orangeColor];
    [btnStop setTitle:@"停止" forState:UIControlStateNormal];
    [btnStop addTarget:self action:@selector(stopDingwei) forControlEvents:UIControlEventTouchUpInside];
    
    BMKMapView *mapViewBack = [[BMKMapView alloc] init];
    CGFloat mapViewY = (YSScreenHeight - YSScreenWidth) / 2;
    mapViewBack.frame = CGRectMake(0, mapViewY, YSScreenWidth, YSScreenWidth);
    [self.view addSubview:mapViewBack];
    self.mapViewBack = mapViewBack;
    
    // 设置显示的区域 --- 比例尺级别
    self.mapViewBack.zoomLevel = 15;
    self.mapViewBack.showMapScaleBar = YES;
    self.mapViewBack.logoPosition = BMKLogoPositionLeftTop;
    _locService = [[BMKLocationService alloc]init];
    _locService.distanceFilter = 100.f;  // 设置最小的更新距离
    // 设置定位的精确度
    _locService.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    

}

- (void)startTheDingWei{
    NSLog(@"%s",__func__);
    [_locService startUserLocationService];

//    YSLocationManager *locationManager = [YSLocationManager shareLocationManager];
//    // 开始定位
//    [locationManager startTheLocationService];

    self.mapViewBack.showsUserLocation = NO;//先关闭显示的定位图层

    self.mapViewBack.userTrackingMode = BMKUserTrackingModeNone;//设置定位的状态
    self.mapViewBack.showsUserLocation = YES;//显示定位图层
//    __weak typeof(self) weakSelf = self;
//    [locationManager setBlkLocationUpdate:^(CLLocationCoordinate2D coordinat) {
//        // 更新地图的中心点
//        BMKCoordinateRegion region = weakSelf.mapViewBack.region;
//        region.center = coordinat;
//        weakSelf.mapViewBack.region = region;
//        // 设置显示的区域 --- 比例尺级别
//        weakSelf.mapViewBack.zoomLevel = 16;
//    }];
    
}

#pragma mark  > 停止定位 <
- (void)stopDingwei{
    NSLog(@"%s",__func__);
    [[YSLocationManager shareLocationManager] stopTheLocationService];
    self.mapViewBack.showsUserLocation = NO;
}

- (void)gensui{
    NSLog(@"%s",__func__);
    [_locService startUserLocationService];

    self.mapViewBack.showsUserLocation = NO;
    self.mapViewBack.userTrackingMode = BMKUserTrackingModeFollow;
    self.mapViewBack.showsUserLocation = YES;
}

- (void)viewWillAppear:(BOOL)animated{
    [self.mapViewBack viewWillAppear];
    self.mapViewBack.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _locService.delegate = self;
    
//    [self requestInformation];
    
}

- (void)getTheCityNameWith{
//    http://api.map.baidu.com/telematics/v3/trafficEvent?location=北京&output=json&ak=E4805d16520de693a3fe707cdc962045
    NSString *strURL = @"http://api.map.baidu.com/telematics/v3/weather";
    
//    NSString *strURL = @"http://restapi.amap.com/v3/place/around?key=c56887a1512d6e2d932fd294a8a0ed59&location=113.56503%2C34.819452&radius=5000&output=json&offset=50";
//    NSDictionary *dic = @{@"uid":@"token"};
    
    YSHTTPRequestManager *manager = [YSHTTPRequestManager sharedHTTPRequest];
//    =北京&&ak=E4805d16520de693a3fe707cdc962045
//    location=北京&output=json&ak=E4805d16520de693a3fe707cdc962045
    NSDictionary *dic = @{@"location":@"郑州",@"ak":@"E4805d16520de693a3fe707cdc962045"};

    [manager GETWithURL:strURL withParam:dic andRequestSuccess:^(id responseObject) {
        
        NSLog(@">>>%@",responseObject);
        // 附近的一些地址
        
        
    } andRequestFailure:^(NSError *error) {
        NSLog(@">>>>>请求失败");
        __weak typeof(self) weakSelf = self;
        UIAlertController *alertContorller = [UIAlertController alertControllerWithTitle:@"友情提示" message:@"网络不好，请耐心等待" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }];
        UIAlertAction *alertDengLuAction = [UIAlertAction actionWithTitle:@"刷新试试" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertContorller addAction:alertDengLuAction];
        [alertContorller addAction:alertAction];
        [self presentViewController:alertContorller animated:YES completion:nil];
        
    }];

    
}

- (void)viewWillDisappear:(BOOL)animated{
    [self.mapViewBack viewWillAppear];
    self.mapViewBack.delegate = nil; // 不用时，置nil
    _locService.delegate = nil;
}

/**
 *用户方向更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    BMKCoordinateRegion region = self.mapViewBack.region;
    region.center = userLocation.location.coordinate;
    self.mapViewBack.region = region;
//    [self getTheCityNameWith:userLocation];
    [self.mapViewBack updateLocationData:userLocation];
}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{   
//    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    CLGeocoder *reverseGeocoder = [[CLGeocoder alloc] init];
    [reverseGeocoder reverseGeocodeLocation:userLocation.location completionHandler:^(NSArray *placemarks, NSError *error)
     {
         CLPlacemark *myPlacemark = [placemarks objectAtIndex:0];
         NSString *cityName = myPlacemark.locality;
         NSLog(@"My country code: %@", cityName);
         
         [_locService stopUserLocationService];
     }];
    
    BMKCoordinateRegion region = self.mapViewBack.region;
    region.center = userLocation.location.coordinate;
    self.mapViewBack.region = region;
    [self.mapViewBack updateLocationData:userLocation];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
