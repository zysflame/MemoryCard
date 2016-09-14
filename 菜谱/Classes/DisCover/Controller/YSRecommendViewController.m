//
//  YSRecommendViewController.m
//  菜谱
//
//  Created by qingyun on 16/9/10.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "YSRecommendViewController.h"

// 地图
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import "YSLocationManager.h"
// 网络请求
#import "YSHTTPRequestManager.h"
#import "YSProductModel.h"
#import "YSRecommendTableViewCell.h"
#import "YSRecommentInfoViewController.h"

// 轮播图
#import "YSCarouselImageView.h"
#import "UIView+Frame.h"

@interface YSRecommendViewController () <BMKMapViewDelegate,BMKLocationServiceDelegate,UITableViewDelegate,UITableViewDataSource,YSCarouselImageViewDelegate>
/** 定位服务*/
@property (nonatomic, strong) BMKLocationService *locService;
/** tableView */
@property (nonatomic, weak) UITableView *tableView;
/** tableView展示用的数据源*/
@property (nonatomic, copy) NSArray *arrData;

/** 轮播图*/
@property (nonatomic,weak) YSCarouselImageView *carouselImageView;
@property (nonatomic, copy) NSArray *imgNames;

@end

@implementation YSRecommendViewController

- (NSArray *)imgNames{
    if (!_imgNames) {
        _imgNames = @[@"http://dn.fotoplace.cc/fp6511004.jpg-ms?t=530538",
                      
                    @"http://www.dns001.com/uploads/allimg/160403/19292I293-3.jpg",

                    @"http://img.wallpapersking.com/800/2012-8/20120812103710.jpg",
                              
                    @"http://www.517europe.com.cn/upload/2014/08/201408061251224341.jpg",
                              
                    @"http://test.beiguoyou.com/upfiles/2014-11-26/e81864232f494af3986d0bcd10325afc0.jpg",
                              
                    @"http://www.xcghj.gov.cn/upimage/20131127142139.JPG"
                              ];
    }
    return _imgNames;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadDefaultSetting];
}

#pragma mark 加载默认设置
- (void)loadDefaultSetting{
    self.view.backgroundColor = [UIColor whiteColor];
    
    _locService = [[BMKLocationService alloc]init];
    _locService.distanceFilter = 100.f;  // 设置最小的更新距离
    // 设置定位的精确度
    _locService.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.rowHeight = 116;
    
    self.arrData = [NSArray array];
    
    YSCarouselImageView *carouselImageView = [[YSCarouselImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 200) withBannerSource:DGBBannerStyleOnlyWebSource withBannerArray:self.imgNames];
    carouselImageView.showPageControl = YES;
    carouselImageView.delegate = self;
    carouselImageView.timeInterval = 3;
    tableView.tableHeaderView = carouselImageView;
    self.carouselImageView = carouselImageView;

}
#pragma mark  > 定位服务获取定位的位置 <
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    CLGeocoder *reverseGeocoder = [[CLGeocoder alloc] init];
     __weak typeof(self) weakSelf = self;
    [reverseGeocoder reverseGeocodeLocation:userLocation.location completionHandler:^(NSArray *placemarks, NSError *error)
     {
         CLPlacemark *myPlacemark = [placemarks objectAtIndex:0];
         NSString *cityName = myPlacemark.locality;
//         NSLog(@"My country code: %@", cityName);
         [weakSelf requestTheInformationWithCityName:cityName WithTheLocation:userLocation.location];
         [_locService stopUserLocationService];
     }];
}

- (void)viewWillAppear:(BOOL)animated{
    [_locService startUserLocationService];
    _locService.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated{
    [_locService stopUserLocationService];
    _locService.delegate = nil;
}

#pragma mark  > 轮播图的代理方法 <
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat offsety = scrollView.contentOffset.y - (-210);
    CGFloat y = 10 - offsety;
    
    self.carouselImageView.y = y;
}
#pragma mark  > 轮播图的代理方法 <
- (void)dgbCarouselImageView:(YSCarouselImageView *)carouselImageView didSelectItemAtIndex:(NSInteger)index {
    // 点击图片触发的事件
    NSLog(@"%ld点击了图片的下标",index);
    
}

#pragma mark  > UITableViewDataSource  UITableViewDelegate<
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YSRecommendTableViewCell *cell = [YSRecommendTableViewCell recommnedCellWithTableView:tableView];
    YSProductModel *model = self.arrData[indexPath.row];
    cell.productModel = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    YSRecommentInfoViewController *infoVC = [YSRecommentInfoViewController new];
    YSProductModel *model = self.arrData[indexPath.row];
    infoVC.sightId = model.strID;
    [self.navigationController pushViewController:infoVC animated:YES];
}

#pragma mark  > 请求城市名 <
- (void)requestTheInformationWithCityName:(NSString *)cityName  WithTheLocation:(CLLocation *)location{
//    http://searchtouch.qunar.com/ticket/list.json?startTime=1473573855400&q=%E9%83%91%E5%B7%9E&type=ticket&cat=isNearby_index_city&city=%E9%83%91%E5%B7%9E&
    
//http://searchtouch.qunar.com/ticket/list.json?startTime=1473765691257&q=%E9%83%91%E5%B7%9E&type=ticket&cat=isNearby_index_city&city=%E9%83%91%E5%B7%9E&commonParams={%22currLatitude%22:%2234.81931602868165%22,%22currLongitude%22:%22113.56429248923713%22,%22gid%22:%2218E6E8DD-4480-B23E-55BC-D7DEA4438811%22,%22uid%22:%22867831023828684%22,%22un%22:%22%22,%22vid%22:%2260001144%22,%22cid%22:%22C2075%22,%22pid%22:%2210010%22,%22userId%22:%22%22}&isLandmark=&currLatitude=34.81931602868165&currLongitude=113.56429248923713&theme=&area=%E5%85%A8%E9%83%A8%E5%9C%B0%E5%8C%BA&isNearby=1&location=1&start=30&len=15&areaType=subcity    
    NSDate *nowDate = [NSDate date];
    NSUInteger time = [nowDate timeIntervalSince1970] *1000 + 3600 * 8;
//    NSLog(@">>>时间%ld",time );
    NSString *strURL = @"http://searchtouch.qunar.com/ticket/list.json";
    NSDictionary *dic = @{@"startTime":@(time),@"q":cityName,@"type":@"ticket",@"cat":@"isNearby_index_city",@"city":cityName,@"commonParams":@{@"currLatitude":@"34.81931602868165",@"currLongitude":@"113.56429248923713",@"gid":@"18E6E8DD-4480-B23E-55BC-D7DEA4438811",@"uid":@"867831023828684",@"un":@"",@"vid":@"60001144",@"cid":@"C2075",@"pid":@"10010",@"userId":@""},@"isLandmark":@"",@"currLatitude":@(location.coordinate.latitude),@"currLongitude":@(location.coordinate.longitude),@"theme":@"",@"area":@"全部地区",@"isNearby":@"1",@"location":@"1",@"start":@"0",@"len":@"15",@"areaType":@"subcity"};

//    NSDictionary *dic = @{@"startTime":@(time),@"q":cityName};
    YSHTTPRequestManager *manager = [YSHTTPRequestManager sharedHTTPRequest];
     __weak typeof(self) weakSelf = self;
    [manager GETWithURL:strURL withParam:dic andRequestSuccess:^(id responseObject) {
        NSLog(@">>>%@",responseObject);
        NSArray *arr = responseObject[@"productList"];
        NSUInteger count = arr.count;
        NSMutableArray *arrMModels = [NSMutableArray arrayWithCapacity:count];
        for (NSUInteger index = 0; index < count; index ++) {
            NSDictionary *dic = arr[index];
            YSProductModel *model = [YSProductModel modelWithDictionary:dic];
            [arrMModels addObject:model];
        }
        weakSelf.arrData = [arrMModels copy];
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView reloadData];
        });
    } andRequestFailure:^(NSError *error) {
        __weak typeof(self) weakSelf = self;
        UIAlertController *alertContorller = [UIAlertController alertControllerWithTitle:@"友情提示" message:@"网络不好，请耐心等待" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
        }];
        UIAlertAction *alertDengLuAction = [UIAlertAction actionWithTitle:@"刷新试试" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [weakSelf requestTheInformationWithCityName:cityName WithTheLocation:location];
        }];
        [alertContorller addAction:alertDengLuAction];
        [alertContorller addAction:alertAction];
        [self presentViewController:alertContorller animated:YES completion:nil];

    }];
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
