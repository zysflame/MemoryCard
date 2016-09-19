//
//  YSInfoDynamicViewController.m
//  菜谱
//
//  Created by qingyun on 16/8/25.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "YSInfoDynamicViewController.h"

#import "YSCommentCell.h"
#import "YSStatusCell.h"


@interface YSInfoDynamicViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *arrDataModels;

@end

@implementation YSInfoDynamicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadDefaultSetting];
    [self loadNavigationSetting];
}

#pragma mark 加载默认设置
- (void)loadDefaultSetting{
    self.view.backgroundColor = YSColorRandom;
    
    self.automaticallyAdjustsScrollViewInsets = YES;
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    [self.view addSubview:tableView];
    tableView.dataSource = self;
    tableView.delegate = self;
    self.tableView = tableView;
    //    tableView.sectionFooterHeight = 30;
    tableView.estimatedRowHeight = 40;
}

#pragma mark 加载导航栏设置
- (void)loadNavigationSetting{
    self.title = @"介绍";
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YSStatusCell *messageCell = [YSStatusCell cellWithTableView:tableView];
    messageCell.selectionStyle = UITableViewCellSelectionStyleNone;
    YSCurrentMessage *msg = self.currentMessage;
    messageCell.message = msg;
    return messageCell;
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
