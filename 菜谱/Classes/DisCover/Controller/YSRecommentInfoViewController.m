//
//  YSRecommentInfoViewController.m
//  菜谱
//
//  Created by qingyun on 16/9/11.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "YSRecommentInfoViewController.h"

#import "YSCommentModel.h"
#import "YSRecommentImageViewController.h"

@interface YSRecommentInfoViewController () <UITableViewDelegate,UITableViewDataSource>

/** tableView */
@property (nonatomic, weak) UITableView *tableView;
/** 数据源*/
@property (nonatomic, strong) NSMutableArray *arrMData;
/** 表头的图片*/
@property (nonatomic, weak) UIImageView *headerIMV;
/** 图片的数量*/
@property (nonatomic, weak) UILabel *lblImvCount;
/** 标题*/
@property (nonatomic,copy) NSString *strSightName;


@end

@implementation YSRecommentInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadDefaultSetting];
}

- (void)viewWillAppear:(BOOL)animated{
    [self requestTheInformation];
}


#pragma mark 加载默认设置
- (void)loadDefaultSetting{
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.rowHeight = 116;
    
    // 初始化数组
    self.arrMData = [NSMutableArray array];
    
    UIImageView *headerImv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0, 200)];
    self.headerIMV = headerImv;
    
    UITapGestureRecognizer *clickTap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickTheImageViewBack:)];
    clickTap.numberOfTapsRequired = 1;
    [headerImv addGestureRecognizer:clickTap];
    headerImv.userInteractionEnabled = YES;
    
    tableView.tableHeaderView = headerImv;
    
    UILabel *lblCount = [UILabel new];
    [headerImv addSubview:lblCount];
    self.lblImvCount = lblCount;
    lblCount.textColor = [UIColor orangeColor];
    [lblCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.trailing.equalTo(headerImv);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(100);
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrMData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *strID = @"strIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:strID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strID];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%lu----%lu",indexPath.section,indexPath.row];
    return cell;
}

#pragma mark  > 请求数据 <
- (void)requestTheInformation{
    NSString *strURL = @"http://searchtouch.qunar.com/queryData/searchSightDetail.do";
    NSDictionary *dic = @{@"sightId":self.sightId};
    YSHTTPRequestManager *manager = [YSHTTPRequestManager sharedHTTPRequest];
    __weak typeof(self) weakSelf = self;
    [manager GETWithURL:strURL withParam:dic andRequestSuccess:^(id responseObject) {
//        NSLog(@">>>>数据是%@",responseObject);
        NSDictionary *basic = responseObject[@"basic"];
        NSString *strImageUrl = basic[@"image"];
        NSURL *imageURL = [NSURL URLWithString:strImageUrl];
        
        NSArray *arrImage = basic[@"images"];
        NSString *strImvCount = [NSString stringWithFormat:@"%ld 张美图",arrImage.count];
    
        YSCommentModel *model = [YSCommentModel commentModelWithDictionary:basic[@"comment"]];
        weakSelf.title = model.sightName;
        weakSelf.strSightName = model.sightName;
        
        [weakSelf requestTheCommentWithModel:model];
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.headerIMV sd_setImageWithURL:imageURL];
            weakSelf.lblImvCount.text = strImvCount;
            [weakSelf.tableView reloadData];
        });
    } andRequestFailure:^(NSError *error) {
        __weak typeof(self) weakSelf = self;
        UIAlertController *alertContorller = [UIAlertController alertControllerWithTitle:@"友情提示" message:@"网络不好，请耐心等待" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
        }];
        UIAlertAction *alertDengLuAction = [UIAlertAction actionWithTitle:@"刷新试试" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [weakSelf requestTheInformation];
        }];
        [alertContorller addAction:alertDengLuAction];
        [alertContorller addAction:alertAction];
        [self presentViewController:alertContorller animated:YES completion:nil];
        
    }];
}

- (void)requestTheCommentWithModel:(YSCommentModel *)Model{
    NSString *strURL = @"http://searchtouch.qunar.com/queryData/searchCommentList.do";
    NSDictionary *dic = @{@"ticketId":Model.ticketId,@"useComment":Model.useComment,@"travelId":Model.travelId};
    YSHTTPRequestManager *manager = [YSHTTPRequestManager sharedHTTPRequest];
    __weak typeof(self) weakSelf = self;
    [manager GETWithURL:strURL withParam:dic andRequestSuccess:^(id responseObject) {
        NSLog(@">>>>数据是%@",responseObject);
       
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView reloadData];
        });
    } andRequestFailure:^(NSError *error) {
        __weak typeof(self) weakSelf = self;
        UIAlertController *alertContorller = [UIAlertController alertControllerWithTitle:@"友情提示" message:@"网络不好，请耐心等待" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
        }];
        UIAlertAction *alertDengLuAction = [UIAlertAction actionWithTitle:@"刷新试试" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [weakSelf requestTheInformation];
        }];
        [alertContorller addAction:alertDengLuAction];
        [alertContorller addAction:alertAction];
        [self presentViewController:alertContorller animated:YES completion:nil];
    }];
}

#pragma mark  > 点击图片的手势触发的方法 <
- (void)clickTheImageViewBack:(UIGestureRecognizer *)tap{
    YSRecommentImageViewController *imageVC = [[YSRecommentImageViewController alloc] init];
    imageVC.strId = self.sightId;
    imageVC.strTitle = self.strSightName;
    [self.navigationController pushViewController:imageVC animated:YES];
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
