//
//  YSHomeViewController.m
//  菜谱
//
//  Created by qingyun on 16/8/17.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "YSHomeViewController.h"

#import "YSLoginViewController.h"
#import "YSHomeInfoViewController.h"

#import "YSHomeListModel.h"

#import "YSStatusCell.h"
#import "YSFooterView.h"
#import "YSStatusModel.h"

#import "YSHTTPRequestManager.h"

#import "YSCarouselImageView.h"
#import "UIView+Frame.h"

#import "YSCurrentMessage.h"

static NSInteger page = 1;
@interface YSHomeViewController () <UITableViewDelegate,UITableViewDataSource,YSCarouselImageViewDelegate>
/** tableView 视图*/
@property (nonatomic, weak) UITableView *tableView;
/** 动画的图片的网址*/
@property (nonatomic, copy) NSArray *imgNames;
/** 存放模型的数组*/
@property (nonatomic, strong) NSMutableArray *arrDataModels;
@property (nonatomic,weak) YSCarouselImageView *carouselImageView;


@end

@implementation YSHomeViewController

- (NSArray *)imgNames{
    if (!_imgNames) {
        _imgNames = @[@"http://www.dns001.com/uploads/allimg/160403/19292I293-3.jpg",
                      
                      @"http://img.wallpapersking.com/800/2012-8/20120812103710.jpg",
                      
                      @"http://www.517europe.com.cn/upload/2014/08/201408061251224341.jpg",
                      
                      @"http://test.beiguoyou.com/upfiles/2014-11-26/e81864232f494af3986d0bcd10325afc0.jpg",
                      
                      @"http://www.xcghj.gov.cn/upimage/20131127142139.JPG"
                      ];
    }
    return _imgNames;
}

- (void)viewDidAppear:(BOOL)animated{
    //    [self requestInformation];
    [self requestTheData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //    [self loadNavigationSetting];
    [self loadDefaultSetting];
}

- (void)requestTheData{
    AVQuery *query = [AVQuery queryWithClassName:@"YSCurrentMessage"];
    __weak typeof(self) weakSelf = self;
    [query orderByDescending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            //NSLog(@"查询失败>>> %@",error);
            UIAlertController *alertContorller = [UIAlertController alertControllerWithTitle:@"友情提示" message:@"网络不好或者您没有发过心情。。。" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"返回去发表心情" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
            }];
            UIAlertAction *alertDengLuAction = [UIAlertAction actionWithTitle:@"刷新试试" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [weakSelf requestTheData];
            }];
            [alertContorller addAction:alertDengLuAction];
            [alertContorller addAction:alertAction];
            [self presentViewController:alertContorller animated:YES completion:nil];
        }
        NSArray<YSCurrentMessage *> *messageData = objects;
        weakSelf.arrDataModels = [NSMutableArray arrayWithCapacity:messageData.count];
        for (YSCurrentMessage *message in messageData) {
            if (![message.userName isEqualToString:[AVUser currentUser].username]) {
                [weakSelf.arrDataModels addObject:message];
            }
        }
        //        NSLog(@">>>%ld",weakSelf.arrDataModels.count);
        // 刷新 UI
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView reloadData];
        });
    }];
    
}


#pragma mark 加载默认设置
- (void)loadDefaultSetting{
    self.view.backgroundColor = [UIColor whiteColor];
    //    self.automaticallyAdjustsScrollViewInsets = NO;
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    [self.view addSubview:tableView];
    
    tableView.dataSource = self;
    tableView.delegate = self;
    self.tableView = tableView;
    
    tableView.sectionFooterHeight = 30;
    tableView.estimatedRowHeight = 40;
    
    self.arrDataModels = [NSMutableArray array];
    
    
    YSCarouselImageView *carouselImageView = [[YSCarouselImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 200) withBannerSource:DGBBannerStyleOnlyWebSource withBannerArray:self.imgNames];
    carouselImageView.showPageControl = YES;
    carouselImageView.delegate = self;
    carouselImageView.timeInterval = 3;
    //    tableView.tableHeaderView = carouselImageView;
    self.carouselImageView = carouselImageView;
    
}

#pragma mark  > 拖动图片的操作 <
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsety = scrollView.contentOffset.y - (-210);
    CGFloat y = 10 - offsety;
    self.carouselImageView.y = y;
}

- (void)dgbCarouselImageView:(YSCarouselImageView *)carouselImageView didSelectItemAtIndex:(NSInteger)index {
    // 点击图片触发的事件
    //    NSLog(@"%ld点击了图片的下标",index);
    
}

#pragma mark  > 刷新加载新的数据 <
- (void)loadNewData{
    page += 1;
    [self requestInformation];
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf.tableView endRefreshing];
        [weakSelf.tableView reloadData];
    });
}

#pragma mark  > 发送网络请求 <
- (void)requestInformation{
    NSString *strURL = @"http://restapi.amap.com/v3/place/around?key=c56887a1512d6e2d932fd294a8a0ed59&location=113.56503%2C34.819452&radius=5000&output=json&offset=50";
    
    YSHTTPRequestManager *manager = [YSHTTPRequestManager sharedHTTPRequest];
    NSDictionary *dic = @{@"uid":@"token"};
    [manager GETWithURL:strURL withParam:dic andRequestSuccess:^(id responseObject) {
        
        NSLog(@">>>%@",responseObject);
        AVObject *response = [[AVObject alloc] initWithClassName:@"ResponseObject"];
        
        AVUser *currentUser = [AVUser currentUser];
        [response setObject:currentUser.username forKey:@"userID"];
        [response setObject:responseObject forKey:@"Response"];
        
        [response saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                [[AVUser currentUser] setObject:response forKey:@"ResponseObject"];
                [[AVUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    NSLog(@">>>%@",response);
                    // 此处是修改数据
                    [[AVUser currentUser] setObject:response.objectId forKey:@"ResponseObject"];
                    [[AVUser currentUser] saveInBackground];
                    
                }];
            }
        }];
        
        
    } andRequestFailure:^(NSError *error) {
        NSLog(@">>>>>请求失败");
        __weak typeof(self) weakSelf = self;
        UIAlertController *alertContorller = [UIAlertController alertControllerWithTitle:@"友情提示" message:@"网络不好，请耐心等待" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }];
        UIAlertAction *alertDengLuAction = [UIAlertAction actionWithTitle:@"刷新试试" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [weakSelf loadNewData];
        }];
        [alertContorller addAction:alertDengLuAction];
        [alertContorller addAction:alertAction];
        [self presentViewController:alertContorller animated:YES completion:nil];
        
    }];
    
    
}

#pragma mark 加载导航栏设置
- (void)loadNavigationSetting{
    UIBarButtonItem *itemProfile = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_user"] style:UIBarButtonItemStylePlain target:self action:@selector(clickTheUserAction)];
    self.navigationItem.rightBarButtonItem = itemProfile;
    
}

#pragma mark  > 点击用户后跳转到登录界面 <
- (void)clickTheUserAction{
    UIStoryboard *loginSB = [UIStoryboard storyboardWithName:@"login" bundle:[NSBundle mainBundle]];
    UIViewController *loginVC = [loginSB instantiateViewControllerWithIdentifier:@"YSLoginViewController"];
    [self.navigationController pushViewController:loginVC animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.arrDataModels.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YSStatusCell *messageCell = [YSStatusCell cellWithTableView:tableView];
    YSCurrentMessage *msg = self.arrDataModels[indexPath.section];
    messageCell.message = msg;
    return messageCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
//    YSFooterView *footer = [YSFooterView footerViewWithTableView:tableView];
//    footer.contentView.backgroundColor = [UIColor whiteColor];
//    footer.status = self.arrDataModels[section];
//    return nil;
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // 取消IndexPath位置cell的选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YSHomeInfoViewController *homeInfoVC = [YSHomeInfoViewController new];
    YSCurrentMessage *msg = self.arrDataModels[indexPath.section];
    homeInfoVC.currentMessage = msg;
    [self.navigationController pushViewController:homeInfoVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.01;
    } else {
        return 20;
    }
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
