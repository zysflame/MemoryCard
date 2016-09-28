//
//  YSResetPassWordViewController.m
//  菜谱
//
//  Created by qingyun on 16/9/1.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "YSResetPassWordViewController.h"

@interface YSResetPassWordViewController ()
/** 手机号*/
@property (weak, nonatomic) IBOutlet UITextField *txfPhoneNum;
/** 验证码*/
@property (weak, nonatomic) IBOutlet UITextField *txfYanZhengMa;
/** 验证码按钮*/
@property (weak, nonatomic) IBOutlet UIButton *YZMNewBtn;
/** 密码*/
@property (weak, nonatomic) IBOutlet UITextField *txfPassWord;
/** 重置密码按钮*/
@property (nonatomic, weak) IBOutlet UIButton *resetBtn;
/** 计时器*/
@property (nonatomic, strong) NSTimer *timer;
/** 计时器计数*/
@property (nonatomic,assign) NSInteger count;

@end

@implementation YSResetPassWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadDefaultSetting];
}

#pragma mark 加载默认设置
- (void)loadDefaultSetting{
    self.title = @"重置密码";
    self.resetBtn.enabled = NO;
    
    // 分别给三个textfield 添加当值改变时的监听事件
    [self.txfPhoneNum addTarget:self action:@selector(editingChange:) forControlEvents:UIControlEventEditingChanged];
    [self.txfYanZhengMa addTarget:self action:@selector(editingChange:) forControlEvents:UIControlEventEditingChanged];
    [self.txfPassWord addTarget:self action:@selector(editingChange:) forControlEvents:UIControlEventEditingChanged];
}

#pragma mark  > textfield 的监听事件 <
- (void)editingChange:(UITextField *)txf{
    if ([self.txfPhoneNum.text isEqualToString:@""] || [self.txfYanZhengMa.text isEqualToString:@""] || [self.txfPassWord.text isEqualToString:@""]) {
        self.resetBtn.enabled = NO;
    }else{
        self.resetBtn.enabled = YES;
    }
}

#pragma mark  > 点击获取验证码的按钮 <
- (IBAction)getTheNewYanZhengMa:(UIButton *)button {
    if ([self.txfPhoneNum.text isEqualToString:@""]) {
        UIAlertController *alertContorller = [UIAlertController alertControllerWithTitle:@"友情提示" message:@"请先输入手机号" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
            
        }];
        [alertContorller addAction:alertAction];
        [self presentViewController:alertContorller animated:YES completion:nil];
        return;
    }
    
    self.count = 60;
    // 初始化计时器
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerFire:) userInfo:nil repeats:YES];
    
    [AVUser requestPasswordResetWithPhoneNumber:self.txfPhoneNum.text block:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"请求验证码成功");
            UIAlertController *alertContorller = [UIAlertController alertControllerWithTitle:@"友情提示" message:@"新的验证码已发送，请稍等片刻" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
                
            }];
            [alertContorller addAction:alertAction];
            [self presentViewController:alertContorller animated:YES completion:nil];
        } else {
            NSLog(@"失败");
            UIAlertController *alertContorller = [UIAlertController alertControllerWithTitle:@"友情提示" message:@"验证码发送失败，请稍后重试。。。" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"好吧" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
                
            }];
            [alertContorller addAction:alertAction];
            [self presentViewController:alertContorller animated:YES completion:nil];
        }
    }];
}

#pragma mark  > 计时器走的 <
- (void)timerFire:(NSTimer *)timer{
    self.count -= 1;
    if (self.count < 0) {
        self.YZMNewBtn.enabled = YES;
        self.count = 60;
        [self.timer invalidate];  // 计时器失效
    }else{
        self.YZMNewBtn.enabled = NO;
        self.YZMNewBtn.titleLabel.text = [NSString stringWithFormat:@"%luS可重发",(long)self.count];
        [self.YZMNewBtn setTitle:[NSString stringWithFormat:@"%luS可重发",(long)self.count] forState: UIControlStateDisabled];
    }
}

#pragma mark  > 点击重置按钮的方法 <
- (IBAction)resetThePasswordBtn:(UIButton *)button {
    if ([self.txfYanZhengMa.text isEqualToString:@""] || [self.txfPassWord.text isEqualToString:@""]) {
        UIAlertController *alertContorller = [UIAlertController alertControllerWithTitle:@"友情提示" message:@"请输入验证码和密码" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
            
        }];
        
        [alertContorller addAction:alertAction];
        [self presentViewController:alertContorller animated:YES completion:nil];
    }
    
    [AVUser resetPasswordWithSmsCode:self.txfYanZhengMa.text newPassword:self.txfPassWord.text block:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            
            [self.navigationController popViewControllerAnimated:YES];
            NSLog(@"密码重置成功");
        } else {
            __weak typeof(self) weakSelf = self;
            UIAlertController *alertContorller = [UIAlertController alertControllerWithTitle:@"友情提示" message:@"请输入正确的验证码" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"重试" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
                weakSelf.txfYanZhengMa.text = @"";
                weakSelf.txfPassWord.text = @"";
            }];
            
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

@end
