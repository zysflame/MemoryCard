//
//  YSProfileViewController.m
//  菜谱
//
//  Created by qingyun on 16/8/17.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "YSProfileViewController.h"

#import "AppDelegate.h"

#import "YSProfileInfoViewController.h"

#import "YSLoginViewController.h"
#import "TZImagePickerController.h"

#import "YSProfileHeader.h"

@interface YSProfileViewController () <UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,TZImagePickerControllerDelegate>

@property (nonatomic, weak) UITableView *tableView;
/** 存放标题的数组*/
@property (nonatomic,copy) NSArray *arrTitles;
@property (nonatomic, strong) UIImage *headerImage;
@property (nonatomic, weak) UIButton *headerBtn;
@end

@implementation YSProfileViewController

- (NSArray *)arrTitles{
    if (!_arrTitles) {
        _arrTitles = @[@"资料设置",@"密码重置",@"功能介绍",@"帮助",@"切换账号",@"退出程序"];
    }
    return _arrTitles;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadDefaultSetting];
}

#pragma mark 加载默认设置
- (void)loadDefaultSetting{
    //    self.view.backgroundColor = YSColorRandom;
    //    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(80, 100, 200, 200)];
    //    [self.view addSubview:lable];
    //    lable.numberOfLines = 0;
    //    lable.text = @"包含资料设置，好友的关注列表，自己发的自己的足迹";
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    //    tableView.contentInset = UIEdgeInsetsMake(200, 0, 0, 0);
    [self.view addSubview:tableView];
    tableView.dataSource = self;
    tableView.delegate = self;
    self.tableView = tableView;
    
    YSProfileHeader *infoView = [YSProfileHeader profileHeaderView];
    __weak typeof(self) weakSelf = self;
    AVUser *currentUser = [AVUser currentUser];
    infoView.txfUserName.text = currentUser.username;
    
    NSUserDefaults *defau = [NSUserDefaults standardUserDefaults];
    NSData *imageData = [defau objectForKey:@"headerImage"];
    UIImage *image = [UIImage imageWithData:imageData scale:1.0];  // 15188342749
    [infoView.headerBtn setImage:image forState:UIControlStateNormal];
    infoView.nickName.text = [defau objectForKey:@"nickName"];
    
    AVQuery *userQuery = [AVQuery queryWithClassName:@"_User"];
    [userQuery getObjectInBackgroundWithId:currentUser.objectId block:^(AVObject *object, NSError *error) {
        if (object) {
            infoView.nickName.text = object[@"nickName"];
            NSData *imageData = object[@"headerImage"];
            if (imageData) {
                UIImage *image = [UIImage imageWithData:imageData scale:1.0];
                [infoView.headerBtn setBackgroundImage:image forState:UIControlStateNormal];
            }else{
                [infoView.headerBtn setBackgroundImage:[UIImage imageNamed:@"social-placeholder"] forState:UIControlStateNormal];
            }
        }else{
            [infoView.headerBtn setBackgroundImage:[UIImage imageNamed:@"social-placeholder"] forState:UIControlStateNormal];
        }
    }];
    
    [infoView setBlkClickTheHeaderBtn:^(UIButton *button) {
        weakSelf.headerBtn = button;
        TZImagePickerController *imagepicker = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
        [imagepicker setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assest, BOOL isCan) {
            [button setBackgroundImage:photos[0] forState:UIControlStateNormal];
        }];
        [weakSelf presentViewController:imagepicker animated:YES completion:nil];
        
        //        UIImagePickerController *pickerVC = [[UIImagePickerController alloc] init];
        //        pickerVC.delegate = (id)self;
        //        pickerVC.allowsEditing = NO;
        //        pickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        //        [weakSelf presentViewController:pickerVC animated:YES completion:nil];
        
        
    }];
    tableView.tableHeaderView = infoView;
    
}

#pragma mark  >  --- UITableViewDataSource <
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return self.arrTitles.count - 2;
    }else{
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *strID = @"strIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:strID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strID];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (indexPath.section == 0) {
        cell.textLabel.text = self.arrTitles[indexPath.row];
    }else if (indexPath.section == 1){
        cell.textLabel.textColor = [UIColor redColor];
        cell.textLabel.font = [UIFont systemFontOfSize:20 weight:0.5];
        NSUInteger count = self.arrTitles.count;
        cell.textLabel.text = [self.arrTitles objectAtIndex:count - 2];
    }else{
        cell.textLabel.textColor = [UIColor redColor];
        cell.textLabel.font = [UIFont systemFontOfSize:20 weight:0.5];
        cell.textLabel.text = [self.arrTitles lastObject];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.01;
    } else {
        return 5;
    }
}

#pragma mark  > UITableViewDelegate --- 选中后的方法 <
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                [self settingInformation];
                break;
            case 1:
                [self resetThepassWord];
                break;
            case 2:
                [self functionViewController];
                break;
            case 3:
                [self helpViewController];
                break;
            default:
                break;
        }
        
    }else if (indexPath.section == 1){
        [self changeTheUser];
    }else if (indexPath.section == 2){
        // 退出程序的操作
        exit(0);
        //        [UIView animateWithDuration:1 animations:^{
        //            self.view.frame = CGRectMake(-(self.view.frame.size.width),-(self.view.frame.size.height), self.view.frame.size.height,self.view.frame.size.width);
        //        } completion:^(BOOL finished) {
        //            exit(0);
        //        }];
        
    }
}


#pragma mark  > 点击资料设置后触发的方法 <
- (void)settingInformation{
    UIStoryboard *infoSB = [UIStoryboard storyboardWithName:@"registered" bundle:nil];
    UIViewController *infoVC = [infoSB instantiateViewControllerWithIdentifier:@"YSProfileInfoViewController"];
    [self.navigationController pushViewController:infoVC animated:YES];
}

#pragma mark  > 重置密码的操作 <
- (void)resetThepassWord{
    NSLog(@"重置密码");
    UIStoryboard *resetSB = [UIStoryboard storyboardWithName:@"login" bundle:[NSBundle mainBundle]];
    UIViewController *resetPwdVC = [resetSB instantiateViewControllerWithIdentifier:@"YSResetPassWordViewController"];
    [self.navigationController pushViewController:resetPwdVC animated:YES];
}

#pragma mark  > 帮助控制器 <
- (void)helpViewController{
    
    UIAlertController *alertContorller = [UIAlertController alertControllerWithTitle:@"帮助" message:@"1、首页是显示所有的心情\n2、个人发表的状态的展示\n3、加号是发表自己的心情\n4、对附近经典的推荐\n5、我的是一些基本设置" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleDefault handler:nil];
    
    [alertContorller addAction:alertAction];
    [self presentViewController:alertContorller animated:YES completion:nil];
}

#pragma mark  > 功能介绍 <
- (void)functionViewController{
    UIAlertController *alertContorller = [UIAlertController alertControllerWithTitle:@"功能介绍" message:@"1、首页是显示所有的心情\n2、个人发表的状态的展示\n3、加号是发表自己的心情\n4、对附近经典的推荐\n5、我的是一些基本设置" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleDefault handler:nil];
    
    [alertContorller addAction:alertAction];
    [self presentViewController:alertContorller animated:YES completion:nil];
}

#pragma mark  > 切换账号的操作 <
- (void)changeTheUser{
    NSLog(@"退出登录");
    UIAlertController *alertContorller = [UIAlertController alertControllerWithTitle:@"友情提示" message:@"是否要切换账号" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *alAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults removeObjectForKey:@"headerImage"];
        [defaults removeObjectForKey:@"nickName"];
        [defaults removeObjectForKey:@"gender"];
        [defaults removeObjectForKey:@"age"];
        
        [AVUser logOut];  //清除缓存用户对象
        AVUser *currentUser = [AVUser currentUser]; // 现在的currentUser是nil了
        NSLog(@"退出登录后>>>>%@",currentUser.username);
        // 退出账号登录的操作；
        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [app loadMainController];
        
    }];
    UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
        
    }];
    [alertContorller addAction:alAction];
    [alertContorller addAction:alertAction];
    [self presentViewController:alertContorller animated:YES completion:nil];
    
}


#pragma mark  > UIImagePickerControllerDelegate <
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *getimage = info[UIImagePickerControllerOriginalImage];
    [self.headerBtn setBackgroundImage:getimage forState:UIControlStateNormal];
    [picker dismissViewControllerAnimated:YES completion:nil];
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
