//
//  YSPhoneNumYanZhengVC.m
//  菜谱
//
//  Created by qingyun on 16/8/25.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "YSPhoneNumYanZhengVC.h"

#import "AppDelegate.h"

@interface YSPhoneNumYanZhengVC ()

/** 验证码*/
@property (weak, nonatomic) IBOutlet UITextField *txfYanZhengMa;

@property (weak, nonatomic) IBOutlet UIButton *getNewNumBtn;

@end

@implementation YSPhoneNumYanZhengVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadDefaultSetting];
}

#pragma mark 加载默认设置
- (void)loadDefaultSetting{
    self.title = @"验证账号";
}

#pragma mark  > 点击验证按钮后的操作 <
- (IBAction)yanZhengMaBtnAction:(UIButton *)sender {
    if ([self.txfYanZhengMa.text isEqualToString:@""]) {
        UIAlertController *alertContorller = [UIAlertController alertControllerWithTitle:@"友情提示" message:@"请输入验证码" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
            
        }];
        [alertContorller addAction:alertAction];
        [self presentViewController:alertContorller animated:YES completion:nil];
        
    }
    [AVUser verifyMobilePhone:self.txfYanZhengMa.text withBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"验证成功---验证码符合");
            
            __weak typeof(self) weakSelf = self;
            UIAlertController *alertContorller = [UIAlertController alertControllerWithTitle:@"请选择您要进行的操作" message:@"是否去填写个人资料" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"跳过去首页" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
                AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
                [app loadMainController];
            }];
            UIAlertAction *alertNewAction = [UIAlertAction actionWithTitle:@"去完善资料" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                UIStoryboard *infoSB = [UIStoryboard storyboardWithName:@"registered" bundle:nil];
                UIViewController *infoVC = [infoSB instantiateViewControllerWithIdentifier:@"YSProfileInfoViewController"];
                [weakSelf presentViewController:infoVC animated:YES completion:nil];
            }];
            [alertContorller addAction:alertNewAction];
            [alertContorller addAction:alertAction];
            [self presentViewController:alertContorller animated:YES completion:nil];
        }else{
            __weak typeof(self) weakSelf = self;
            UIAlertController *alertContorller = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请输入正确的验证码" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
                weakSelf.txfYanZhengMa.text = @"";
            }];
            //            UIAlertAction *alertNewAction = [UIAlertAction actionWithTitle:@"获取新的验证码" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            // 选择的操作
            //            }];
            //            [alertContorller addAction:alertNewAction];
            [alertContorller addAction:alertAction];
            [self presentViewController:alertContorller animated:YES completion:nil];
        }
    }];
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

- (IBAction)getNewNumBtn:(UIButton *)sender {
}
@end
