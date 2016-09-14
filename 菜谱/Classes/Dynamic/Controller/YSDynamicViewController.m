//
//  YSDynamicViewController.m
//  菜谱
//
//  Created by qingyun on 16/8/17.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "YSDynamicViewController.h"
#import "YSInfoDynamicViewController.h"
#import "YSStatusModel.h"

#import "YSStatusCell.h"
#import "YSFooterView.h"

#import "YSMessageModel.h"
#import "YSCurrentMessage.h"
@interface YSDynamicViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *arrDataModels;

@end

@implementation YSDynamicViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadDefaultSetting];
}

- (void)viewWillAppear:(BOOL)animated{
    [self requestTheData];
}

- (void)requestTheData{
    AVQuery *query = [AVQuery queryWithClassName:@"YSCurrentMessage"];
     __weak typeof(self) weakSelf = self;
    [query orderByDescending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
//            NSLog(@"查询失败>>> %@",error);
            UIAlertController *alertContorller = [UIAlertController alertControllerWithTitle:@"友情提示" message:@"网络不好，请耐心等待" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
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
            
//            NSLog(@"请求成功的对象>>%ld",message.arrImages.count);
            [weakSelf.arrDataModels addObject:message];
        }
        // 刷新 UI
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView reloadData];
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
    tableView.estimatedRowHeight = 40;
}

#pragma mark 加载默认设置
- (void)loadDefaultSetting{
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = YES;
    [self loadTableViewSetting];
}

#pragma mark  > UITableViewDataSource -- UITableViewDelegate<
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
