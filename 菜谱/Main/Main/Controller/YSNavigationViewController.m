//
//  YSNavigationViewController.m
//  吃什么
//
//  Created by qingyun on 16/6/29.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "YSNavigationViewController.h"

@interface YSNavigationViewController ()

@end

@implementation YSNavigationViewController

#pragma mark 第一次使用这个类时，会调用次方法
+ (void)initialize{
    UINavigationBar *naviBar = [UINavigationBar appearance];
    
    naviBar.tintColor = [UIColor lightGrayColor];
}

-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    [super pushViewController:viewController animated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
