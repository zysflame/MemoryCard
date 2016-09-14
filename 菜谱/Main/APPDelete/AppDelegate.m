//
//  AppDelegate.m
//  菜谱
//
//  Created by qingyun on 16/8/17.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "AppDelegate.h"
#import "MainTabBarViewController.h"
#import "YSGuideViewController.h"
#import "YSNavigationViewController.h"
#import "YSLoginViewController.h"
// 信息
#import "YSCurrentMessage.h"
// 百度地图
#import <BaiduMapAPI_Base/BMKBaseComponent.h>

#define KAppKey @""

@interface AppDelegate () <BMKGeneralDelegate>

/** 创建的一个百度地图的管理*/
@property (nonatomic, strong) BMKMapManager *bManager;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSString *strVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    NSString *strCurrentVersion = [[NSUserDefaults standardUserDefaults] objectForKey:@"oldVersionKey"];
    if ([strVersion isEqualToString:strCurrentVersion]) {
        [self loadMainController];
        
    }else{
        YSGuideViewController *guidVc = [YSGuideViewController new];
        //        YSNavigationViewController *navgVC = [[YSNavigationViewController alloc] initWithRootViewController:guidVc];
        self.window.rootViewController = guidVc;
    }
    [self.window makeKeyAndVisible];
    
    // 如果使用美国站点，请加上下面这行代码：
    // [AVOSCloud setServiceRegion:AVServiceRegionUS];
    [AVOSCloud setApplicationId:@"6WuwHq3DabgyOgPq2V1H5yON-gzGzoHsz" clientKey:@"AwRSis2jueemKU9EbdFoXHVp"];
    
    // 在LeanCould 中注册子类化的对象
    [YSCurrentMessage registerSubclass];
    
    // 初始化百度地图的管理器
    self.bManager = [[BMKMapManager alloc] init];
    [self.bManager start:@"EnfK2yfbCMbCXBkjmVTVT1OQ2CKGAREe" generalDelegate:self];
    
    return YES;
}

- (void)loadMainController{
    AVUser *currentUser = [AVUser currentUser];
    NSString *strUser = currentUser.username;
    if (strUser == nil) {
        UIStoryboard *loginSB = [UIStoryboard storyboardWithName:@"login" bundle:[NSBundle mainBundle]];
        UIViewController *loginVC = [loginSB instantiateViewControllerWithIdentifier:@"YSLoginViewController"];
        YSNavigationViewController *navgVC = [[YSNavigationViewController alloc] initWithRootViewController:loginVC];
        self.window.rootViewController = navgVC;
        
    }else{
        MainTabBarViewController *mainVC = [MainTabBarViewController new];
        self.window.rootViewController = mainVC;
    }
}

//联网状态
-(void)onGetNetworkState:(int)iError{
//    NSLog(@"network:%d",iError);
}
//授权状态
-(void)onGetPermissionState:(int)iError{
//    NSLog(@"permission:%d", iError);
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
