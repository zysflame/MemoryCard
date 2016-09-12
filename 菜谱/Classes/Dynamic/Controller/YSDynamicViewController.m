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

@interface YSDynamicViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *arrDataModels;

@end

@implementation YSDynamicViewController


//- (NSArray *)arrDataModels{
//    if (!_arrDataModels) {
//        NSString *strFilePath=[[NSBundle mainBundle] pathForResource:@"status" ofType:@"plist"];
//        NSDictionary *dicStatuses=[NSDictionary dictionaryWithContentsOfFile:strFilePath];
//        NSArray *arrStatuses=dicStatuses[@"statuses"];
//        NSMutableArray *arrMStatusModels=[NSMutableArray arrayWithCapacity:arrStatuses.count];
//        for (NSDictionary *dicData in arrStatuses) {
//            YSStatusModel *status = [YSStatusModel statusModelWithDictionary:dicData];
//            [arrMStatusModels addObject:status];
//        }
//        _arrDataModels = [arrMStatusModels copy];
//
//    }
//    return _arrDataModels;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadDefaultSetting];
}

- (void)viewWillAppear:(BOOL)animated{
//    [self text];
}

- (void)text{
//    [[AVUser currentUser] setObject:nil forKey:@"MessageData"];
    NSArray *arr = [[AVUser currentUser] objectForKey:@"MessageData"];
    NSLog(@">>>>>%@",arr);
    NSUInteger count = arr.count;
    if (count == 0) {
        UIAlertController *alertContorller = [UIAlertController alertControllerWithTitle:@"友情提示" message:@"信息为0...." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
            
        }];
        [alertContorller addAction:alertAction];
        [self presentViewController:alertContorller animated:YES completion:nil];
        return ;
    }
//    NSMutableArray *arrMDatas = [NSMutableArray arrayWithCapacity:count];
    self.arrDataModels = [NSMutableArray arrayWithCapacity:count];
    for (NSUInteger index = 0; index < count; index ++) {
        NSString *str = arr[index];
        AVQuery *query = [AVQuery queryWithClassName:@"Message"];
        
        [query getObjectInBackgroundWithId:str block:^(AVObject *object, NSError *error) {
            if (object) {
                YSMessageModel *model = [YSMessageModel messageModelWithDictionary:(NSDictionary *)object];
                [self.arrDataModels addObject:model];
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self.tableView reloadData];
                });
                
            }
        }];
    }
}

#pragma mark 加载默认设置
- (void)loadDefaultSetting{
    self.view.backgroundColor = [UIColor greenColor];
    
    self.automaticallyAdjustsScrollViewInsets = YES;
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    [self.view addSubview:tableView];
    tableView.dataSource = self;
    tableView.delegate = self;
    self.tableView = tableView;
    tableView.sectionFooterHeight = 30;
    tableView.estimatedRowHeight = 40;
}

#pragma mark  > UITableViewDataSource -- UITableViewDelegate<
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSLog(@"<<<<>>>%ld",self.arrDataModels.count);
    return self.arrDataModels.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YSStatusCell *statusCell = [YSStatusCell cellWithTableView:tableView];
//    YSStatusModel *status = self.arrDataModels[indexPath.section];
    YSMessageModel *model = self.arrDataModels[indexPath.section];
//    NSLog(@"model>>%@",model.content);
    statusCell.messageModel = model;
//    statusCell.status = status;
    return statusCell;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    YSFooterView *footer = [YSFooterView footerViewWithTableView:tableView];
    footer.contentView.backgroundColor = [UIColor whiteColor];
//    footer.status = self.arrDataModels[section];
    return footer;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // 取消IndexPath位置cell的选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
     YSInfoDynamicViewController *homeInfoVC = [YSInfoDynamicViewController new];
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
