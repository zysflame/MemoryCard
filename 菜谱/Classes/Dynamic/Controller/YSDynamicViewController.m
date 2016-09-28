//
//  YSDynamicViewController.m
//  菜谱
//
//  Created by qingyun on 16/8/17.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "YSDynamicViewController.h"

#import "YSNavigationViewController.h"
#import "YSInfoDynamicViewController.h"
#import "YSStatusModel.h"

#import "YSStatusCell.h"
#import "YSFooterView.h"

#import "YSMessageModel.h"
#import "YSCurrentMessage.h"
@interface YSDynamicViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, weak) UIImageView *imageViewBack;
@property (nonatomic, strong) NSMutableArray *arrDataModels;



@end

@implementation YSDynamicViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadDefaultSetting];
    [self loadNavigationSetting];
}

- (void)viewWillAppear:(BOOL)animated{
    [self requestTheData];
}

#pragma mark  > 请求数据 <
- (void)requestTheData{
    AVQuery *query = [AVQuery queryWithClassName:@"YSCurrentMessage"];
    __weak typeof(self) weakSelf = self;
    [query orderByDescending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            NSLog(@"查询失败>>> %@",error);
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
        //        NSLog(@">>>%ld",messageData.count);
        for (YSCurrentMessage *message in messageData) {
            if ([message.userName isEqualToString:[AVUser currentUser].username]) {
                NSLog(@"message>>>>>>%ld",(unsigned long)message.arrImages.count);
                [weakSelf.arrDataModels addObject:message];
            }
        }
        // 刷新 UI
        [weakSelf.tableView.mj_header endRefreshing];
        weakSelf.tableView.backgroundView = nil;
        [weakSelf.tableView reloadData];
        dispatch_async(dispatch_get_main_queue(), ^{
            //            [weakSelf.tableView.mj_footer endRefreshing];
        });
    }];
    
}

#pragma mark  > 加载 tableView 的设置 <
- (void)loadTableViewSetting{
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    [self.view addSubview:tableView];
    tableView.dataSource = self;
    tableView.delegate = self;
    self.tableView = tableView;
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 40, 0);
    tableView.estimatedRowHeight = 40;
    
    UIImageView *imageViewBack = [[UIImageView alloc] initWithFrame:self.view.bounds];
    self.imageViewBack = imageViewBack;
    tableView.backgroundView = imageViewBack;
    imageViewBack.image = [UIImage imageNamed:@"NO 2"];
    
    __weak typeof(self) weakSelf = self;
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    tableView.mj_header.automaticallyChangeAlpha = YES;
    //默认block方法：设置下拉刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //        NSLog(@"下拉刷新");
        [weakSelf requestTheData];
    }];
    
    //默认block方法：设置上拉加载更多
    //    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
    //Call this Block When enter the refresh status automatically
    //        [weakSelf requestTheData]; // 更新请求的数据    页数什么的
    //    }];
}

#pragma mark 加载默认设置
- (void)loadDefaultSetting{
    [self loadTableViewSetting];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = YES;
    
}

#pragma mark 加载导航栏设置
- (void)loadNavigationSetting{
    UIBarButtonItem *itemProfile = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"添加"] style:UIBarButtonItemStylePlain target:self action:@selector(addTheMessage)];
    self.navigationItem.rightBarButtonItem = itemProfile;
}

- (void)addTheMessage{
    // 点击加号按钮触发的事件
    __weak typeof(self) weakSelf = self;
    UIAlertController *alertContorller = [UIAlertController alertControllerWithTitle:nil message:@"添加心情" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *sendAction = [UIAlertAction actionWithTitle:@"添加" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
        
        UIStoryboard *addSB = [UIStoryboard storyboardWithName:@"Add" bundle:[NSBundle mainBundle]];
        UIViewController *addVC = [addSB instantiateViewControllerWithIdentifier:@"YSSendMessageViewController"];
        YSNavigationViewController *naviVC = [[YSNavigationViewController alloc] initWithRootViewController:addVC];
        [weakSelf presentViewController:naviVC animated:YES completion:nil];
        
    }];
    UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
        
    }];
    [alertContorller addAction:sendAction];
    [alertContorller addAction:alertAction];
    [self presentViewController:alertContorller animated:YES completion:nil];
}

#pragma mark  > UITableViewDataSource -- UITableViewDelegate<
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.arrDataModels.count == 0) {
        return 1;
    }else{
        return self.arrDataModels.count;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.arrDataModels.count == 0) {
        static NSString *strID = @"strIdentifier";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:strID];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strID];
        }
        
        cell.textLabel.text = [NSString stringWithFormat:@"正在网络加载中，请稍候。。。"];
        return cell;
    }else{
        YSStatusCell *messageCell = [YSStatusCell cellWithTableView:tableView];
        YSCurrentMessage *msg = self.arrDataModels[indexPath.section];
        messageCell.message = msg;
        return messageCell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // 取消IndexPath位置cell的选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YSCurrentMessage *msg = self.arrDataModels[indexPath.section];
    YSInfoDynamicViewController *InfoDynamicVC = [YSInfoDynamicViewController new];
    InfoDynamicVC.currentMessage = msg;
    [self.navigationController pushViewController:InfoDynamicVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.01;
    } else {
        return 0.01;
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
