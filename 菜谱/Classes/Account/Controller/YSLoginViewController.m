//
//  YSLoginViewController.m
//  菜谱
//
//  Created by qingyun on 16/8/17.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "YSLoginViewController.h"
#import "MainTabBarViewController.h"
#import "YSEMaileRegisterViewController.h"

@interface YSLoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *txfUserName;
@property (weak, nonatomic) IBOutlet UITextField *txfPWD;

@end

@implementation YSLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadDefaultSetting];
    [self loadNavigationSetting];
}

#pragma mark 加载默认设置
- (void)loadDefaultSetting{
    self.title = @"登录";
    //    self.hidesBottomBarWhenPushed = YES;
}

#pragma mark 加载导航栏设置
- (void)loadNavigationSetting{
    // 隐藏默认的返回按钮
    //    self.navigationItem.hidesBackButton = YES;
}

#pragma mark  > 注册按钮触发的方法 <
- (IBAction)ZhuCeBtn:(UIButton *)sender {
    UIStoryboard *registeredSB = [UIStoryboard storyboardWithName:@"registered" bundle:nil];
    UIViewController *registeredVC = [registeredSB instantiateViewControllerWithIdentifier:@"YSPhoneRegisterViewController"];
    [self.navigationController pushViewController:registeredVC animated:YES];
    
    
    //    YSEMaileRegisterViewController *registerVC = [YSEMaileRegisterViewController new];
    //    [self.navigationController pushViewController:registerVC animated:YES];
}

#pragma mark  > 忘记密码的操作 <
- (IBAction)forgetThePassWordBtn:(UIButton *)sender {
    UIViewController *resetPwdVC = [self.storyboard instantiateViewControllerWithIdentifier:@"YSResetPassWordViewController"];
    [self.navigationController pushViewController:resetPwdVC animated:YES];
}

#pragma mark  > 登录按钮 <
- (IBAction)loginBtn:(UIButton *)sender {
    
    if ([self.txfUserName.text isEqualToString:@""] || [self.txfPWD.text isEqualToString:@""]) {
        NSLog(@"账号密码为空");
        UIAlertController *alertContorller = [UIAlertController alertControllerWithTitle:@"友情提示" message:@"请填写账号密码" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *alAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
            
        }];
        
        [alertContorller addAction:alAction];
        [self presentViewController:alertContorller animated:YES completion:nil];
        
        return;
    }
    sender.enabled = NO;
    __weak typeof(self) weakSelf = self;
    [AVUser logInWithUsernameInBackground:self.txfUserName.text password:self.txfPWD.text block:^(AVUser *user, NSError *error) {
        if (user != nil) {
            NSLog(@"登录成功");
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults]; // 保存
            [defaults setObject:user.username forKey:@"username"];
            NSData *imageData = [user objectForKey: @"headerImage"];
            [defaults setObject:imageData forKey:@"headerImage"];
            [defaults setObject:[user objectForKey:@"nickName"] forKey:@"nickName"];
            [defaults setObject:[user objectForKey:@"gender"] forKey:@"gender"];
            [defaults setObject:[user objectForKey:@"age"] forKey:@"age"];
            [defaults synchronize]; // 立即写入
            
            MainTabBarViewController *mainVC = [MainTabBarViewController new];
            [weakSelf presentViewController:mainVC animated:YES completion:nil];
            
            weakSelf.txfUserName.text = nil;
            weakSelf.txfPWD.text = nil;
        } else {
            NSLog(@"登录失败>>>%@",error);
            __weak typeof(self) weakSelf = self;
            UIAlertController *alertContorller = [UIAlertController alertControllerWithTitle:@"友情提示" message:@"账号密码错误请重试。。。" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }];
            UIAlertAction *alertDengLuAction = [UIAlertAction actionWithTitle:@"重新登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSLog(@"刷新了一下");
                sender.enabled = YES;
            }];
            [alertContorller addAction:alertDengLuAction];
            [alertContorller addAction:alertAction];
            [self presentViewController:alertContorller animated:YES completion:nil];
        }
    }];
    
}

#pragma mark  > qq 账号登录 <
- (IBAction)QQLoginBtn:(UIButton *)sender {
    NSLog(@">>>>qq账号登录%s",__func__);
}

#pragma mark  > 新浪微博账号登录 <
- (IBAction)sinaLoginBtn:(UIButton *)sender {
    NSLog(@">>>>微博账号登录%s",__func__);
}

#pragma mark  > 点击屏幕后编辑结束 <
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
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
