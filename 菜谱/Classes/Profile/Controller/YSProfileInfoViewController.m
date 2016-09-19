//
//  YSProfileInfoViewController.m
//  菜谱
//
//  Created by qingyun on 16/8/21.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "YSProfileInfoViewController.h"
#import "TZImagePickerController.h"
#import "AppDelegate.h"

@interface YSProfileInfoViewController () <TZImagePickerControllerDelegate>

/** 头像的按钮*/
@property (weak, nonatomic) IBOutlet UIButton *headerBtn;
/** 头像的图片*/
@property (nonatomic, strong) UIImage *headerImage;
/** 用户名*/
@property (weak, nonatomic) IBOutlet UILabel *lblUserName;
/** 昵称*/
@property (weak, nonatomic) IBOutlet UITextField *txfNickName;
/** 性别*/
@property (weak, nonatomic) IBOutlet UISegmentedControl *gender;
/** 年纪*/
@property (weak, nonatomic) IBOutlet UITextField *txfAge;
/** 保存的性别的数组*/
@property (nonatomic, copy) NSArray *arrGender;

@end

@implementation YSProfileInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadDefaultSetting];
}

#pragma mark 加载默认设置
- (void)loadDefaultSetting{
    self.title = @"资料设置";
    self.headerBtn.layer.masksToBounds = YES;
    [self loadInformationSetting];
}

- (void)loadInformationSetting{
    AVUser *currentUser = [AVUser currentUser];
    self.lblUserName.text = currentUser.username;
    
    NSUserDefaults *defau = [NSUserDefaults standardUserDefaults];
    NSData *imageData = [defau objectForKey:@"headerImage"];
    UIImage *image = [UIImage imageWithData:imageData scale:1.0];
    [self.headerBtn setImage:image forState:UIControlStateNormal];
    self.txfNickName.text = [defau objectForKey:@"nickName"];
    self.txfAge.text = [defau objectForKey:@"age"];
    NSInteger genderIndex = [[defau objectForKey:@"gender"] integerValue];
    self.gender.selectedSegmentIndex = genderIndex;
    
    AVQuery *userQuery = [AVQuery queryWithClassName:@"_User"];
    __weak typeof(self) weakSelf = self;
    [userQuery getObjectInBackgroundWithId:currentUser.objectId block:^(AVObject *object, NSError *error) {
        //        NSLog(@"当前用户的昵称是>>>%@",object[@"headerImage"]);
        NSData *imageData = object[@"headerImage"];
        UIImage *image = [UIImage imageWithData:imageData scale:1.0];
        [weakSelf.headerBtn setImage:image forState:UIControlStateNormal];
        weakSelf.txfAge.text = object[@"age"];
        weakSelf.txfNickName.text = object[@"nickName"];
        NSInteger genderIndex = [object[@"gender"] integerValue];
        weakSelf.gender.selectedSegmentIndex = genderIndex;
    }];
    
}

#pragma mark  > 数组的懒加载 <
- (NSArray *)arrGender{
    if (!_arrGender) {
        _arrGender = @[@"保密",@"男",@"女"];
    }
    return _arrGender;
}

#pragma mark  > 保存数据的按钮 <
- (IBAction)saveBtn:(id)sender {
    //    NSLog(@"保存数据信息。。。上传服务器，更新数据");
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    // 保存头像
    NSData * imgData = UIImageJPEGRepresentation( self.headerImage , 1.0);
    [[AVUser currentUser] setObject:imgData forKey:@"headerImage"];
    [[AVUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [defaults setObject:imgData forKey:@"headerImage"];
        [defaults synchronize]; // 立即写入
        
        [[AVUser currentUser] setObject:imgData forKey:@"headerImage"];
        [[AVUser currentUser] saveInBackground];
    }];
    
    // 保存 昵称
    [[AVUser currentUser] setObject:self.txfNickName.text forKey:@"nickName"];
    [[AVUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [defaults setObject:self.txfNickName.text forKey:@"nickName"];
        [defaults synchronize]; // 立即写入
        
        [[AVUser currentUser] setObject:self.txfNickName.text forKey:@"nickName"];
        [[AVUser currentUser] saveInBackground];
    }];
    
    //  保存性别
    [[AVUser currentUser] setObject:[NSNumber numberWithInt:(int)self.gender.selectedSegmentIndex] forKey:@"gender"];
    [[AVUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [defaults setObject:[NSNumber numberWithInt:(int)self.gender.selectedSegmentIndex] forKey:@"gender"];
        [defaults synchronize]; // 立即写入
        
        [[AVUser currentUser] setObject:[NSNumber numberWithInt:(int)self.gender.selectedSegmentIndex] forKey:@"gender"];
        [[AVUser currentUser] saveInBackground];
    }];
    
    // 保存年纪
    [[AVUser currentUser] setObject:self.txfAge.text forKey:@"age"];
    [[AVUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [defaults setObject:self.txfAge.text forKey:@"age"];
        [defaults synchronize]; // 立即写入
        
        [[AVUser currentUser] setObject:self.txfAge.text forKey:@"age"];
        [[AVUser currentUser] saveInBackground];
    }];
    
    // 数据结束后跳转到主页
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [app loadMainController];
}


#pragma mark  > 选择性别信息 <
- (IBAction)chooseTheGender:(UISegmentedControl *)sender {
    NSLog(@"性别是：%ld",(long)sender.selectedSegmentIndex);
}


#pragma mark  > 添加头像 <
- (IBAction)addHeaderBtn:(UIButton *)button {
    
    TZImagePickerController *imagepicker = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
    __weak typeof(self) weakSelf = self;
    [imagepicker setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assest, BOOL isCan) {
        weakSelf.headerImage = photos[0];
        [button setImage:photos[0] forState:UIControlStateNormal];
        
    }];
    [self presentViewController:imagepicker animated:YES completion:nil];
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
