//
//  ViewController.m
//  菜谱
//
//  Created by qingyun on 16/8/17.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "MainTabBarViewController.h"
#import "YSNavigationViewController.h"

#import "YSHomeViewController.h"
#import "YSDynamicViewController.h"
#import "YSAddViewController.h"
#import "YSDiscoverViewController.h"
#import "YSProfileViewController.h"

#import "YSRecommendViewController.h"


#import "YSTabBar.h"

#import "UIImage+Image.h"

@interface MainTabBarViewController ()

/** 创建存放控制器的数组*/
@property (nonatomic,copy)NSArray *arrControllers;

@end

@implementation MainTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadDefaultSetting];
}

#pragma mark 加载默认设置
- (void)loadDefaultSetting{
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.tabBar.translucent = NO;
    
    [self loadTabBarController];
}

#pragma mark  > 添加tabar 的子控制器 <
- (void)loadTabBarController{
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"tabbar_bg"];
    [imageView setContentMode:UIViewContentModeCenter];
    imageView.frame = CGRectMake(0, -8, self.tabBar.width, self.tabBar.height);
    [self.tabBar setShadowImage:[UIImage imageWithColor:[UIColor clearColor]]];
    [self.tabBar setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor]]];
    
    YSRecommendViewController *discoverVC = [YSRecommendViewController new];
    [self addViewController:discoverVC WithImageName:@"tabbar_hote" Title:@"热门推荐"];
    
    //    YSHomeViewController *HomeVC = [YSHomeViewController new];
    //    [self addViewController:HomeVC WithImageName:@"tabbar_hote" Title:@"其他动态"];
    
    YSDynamicViewController *dynamicVC = [YSDynamicViewController new];
    [self addViewController:dynamicVC WithImageName:@"me" Title:@"个人动态"];
    
    YSProfileViewController *profileVC = [YSProfileViewController new];
    [self addViewController:profileVC WithImageName:@"CoolDian" Title:@"我的设置"];
    
    // 创建自己的TabBar
    YSTabBar *tabBar = [YSTabBar new];
    //self.tabBar = tabBar;
    tabBar.tintColor = [UIColor orangeColor];
    tabBar.barTintColor = [UIColor lightTextColor];
    __weak typeof(self) weakSelf = self;
    [tabBar setBlkTapThePlusBtn:^(UIButton *button) {
        // 点击加号按钮触发的事件
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
        
        
    }];
    //    [self setValue:tabBar forKey:@"tabBar"];
}


#pragma mark  > 添加子控制器 <
- (void)addViewController:(UIViewController *)viewCotroller WithImageName:(NSString *)imageName Title:(NSString *)title{
    
    viewCotroller.tabBarItem.image = [UIImage imageNamed:imageName];
    viewCotroller.tabBarItem.selectedImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_selected",imageName]];
    viewCotroller.title = title;
    viewCotroller.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -5);
    self.tabBar.tintColor = [UIColor orangeColor];
    self.tabBar.barTintColor = [UIColor lightTextColor];
    YSNavigationViewController *navigationVC = [[YSNavigationViewController alloc] initWithRootViewController:viewCotroller];
    [self addChildViewController:navigationVC];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
