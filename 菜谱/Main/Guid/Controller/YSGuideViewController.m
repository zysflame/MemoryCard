
//
//  YSFirstViewController.m
//  吃什么
//
//  Created by qingyun on 16/7/6.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "YSGuideViewController.h"
#import "MainTabBarViewController.h"

#import "AppDelegate.h"
#import "YSBeiJingScrollView.h"

#define lblTitleX 40

@interface YSGuideViewController () <UIScrollViewDelegate>

/**
 *  存放图片名字的数组
 */
@property (nonatomic,copy) NSArray *arrBackImages;

/** 背景滑动图*/
@property (nonatomic,weak) UIScrollView *scrollViewback;

@end

@implementation YSGuideViewController

- (NSArray *)arrBackImages{
    if (!_arrBackImages) {
        NSUInteger count = 5;
        NSMutableArray *arrMImages = [NSMutableArray arrayWithCapacity:count];
        for (NSUInteger index = 0; index < count; index ++) {
            NSString *strName = [NSString stringWithFormat:@"足迹_%lu",(unsigned long)index];
            [arrMImages addObject:strName];
        }
        _arrBackImages = [arrMImages copy];
    }
    return _arrBackImages;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"欢迎使用";
    
    [self loadLayoutScrollViewSetting];
}


#pragma mark 点击登录后出发的事件
- (void)clickTheProfileBtn{
    
}

#pragma mark  > 点击welcome 按钮后触发的事件 <
- (void)clickTheBtnNext{
    NSString *strVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    [[NSUserDefaults standardUserDefaults] setObject:strVersion forKey:@"oldVersionKey"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [app loadMainController];
}

#pragma mark 使用latout 加载引导页
- (void)loadLayoutScrollViewSetting{
    NSUInteger count = self.arrBackImages.count;
    
    UIBarButtonItem *btnItemProfile = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_user"] style:0 target:self action:@selector(clickTheProfileBtn)];
    btnItemProfile.tintColor = [UIColor purpleColor];
    self.navigationItem.rightBarButtonItem = btnItemProfile;
    
    UIScrollView *scrollViewback = [UIScrollView new];
    scrollViewback.frame = self.view.bounds;
    [self.view addSubview:scrollViewback];
    scrollViewback.pagingEnabled = YES;
    scrollViewback.showsHorizontalScrollIndicator = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    scrollViewback.delegate = self;
    self.scrollViewback = scrollViewback;
    
    [scrollViewback mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.and.trailing.equalTo(self.view);
        make.top.and.bottom.equalTo(self.view);
    }];
    
    UIView *viewTemp = [UIView new];
    [scrollViewback addSubview:viewTemp];
    
    [viewTemp mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(scrollViewback);
        make.top.equalTo(scrollViewback);
        make.leading.equalTo(scrollViewback);
        make.trailing.equalTo(scrollViewback);
        make.width.equalTo(self.view).multipliedBy(count);
    }];
    
    NSMutableArray *arrMImageViews = [NSMutableArray arrayWithCapacity:count];
    for (NSUInteger index = 0; index < count; index ++) {
        UIImage *image = [UIImage imageNamed:self.arrBackImages[index]];
        UIImageView *imageViewBack = [[UIImageView alloc] initWithImage:image];
        [imageViewBack sizeToFit];
        [arrMImageViews addObject:imageViewBack];
        [viewTemp addSubview:imageViewBack];
        
        if (index == 0) {
            [imageViewBack mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.and.bottom.equalTo(scrollViewback);
                make.leading.equalTo(scrollViewback);
                //                make.height.equalTo(scrollView);
                make.centerY.equalTo(scrollViewback);
            }];
        }else if (index == (count - 1)){
            [imageViewBack mas_makeConstraints:^(MASConstraintMaker *make) {
                UIImageView *imageViewTemp = arrMImageViews[index - 1];
                make.top.bottom.equalTo(scrollViewback);
                make.leading.equalTo(imageViewTemp.mas_trailing);
                make.trailing.equalTo(viewTemp);
                make.width.equalTo(imageViewTemp);
                //                make.height.equalTo(scrollView);
                make.centerY.equalTo(scrollViewback);
            }];
            
            [self loadTheNextButtonWithImageView:imageViewBack];
        }else {
            [imageViewBack mas_makeConstraints:^(MASConstraintMaker *make) {
                UIImageView *imageViewBefore = arrMImageViews[index - 1];
                make.top.and.bottom.equalTo(scrollViewback);
                make.leading.equalTo(imageViewBefore.mas_trailing);
                make.width.equalTo(imageViewBefore);
                make.centerY.equalTo(scrollViewback);
            }];
        }
        
    }
}

/** 在最后一张图片上添加按钮*/
- (void)loadTheNextButtonWithImageView:(UIImageView *)imageView{
    
    UIButton *btnNext = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnNext addTarget:self action:@selector(clickTheBtnNext) forControlEvents:UIControlEventTouchUpInside];
    [btnNext setTitle:@"欢迎使用" forState:UIControlStateNormal];
    btnNext.titleLabel.font = [UIFont italicSystemFontOfSize:30];
    [btnNext setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [self.scrollViewback addSubview:btnNext];
    
    CGFloat btnWidth = 100;
    
    [btnNext mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(150));
        make.leading.equalTo(imageView).offset((YSScreenWidth - btnWidth) / 2 + 30);
        //        make.centerY.equalTo(imageView);
        make.bottom.equalTo(imageView).offset(-100);
        make.height.mas_equalTo(60);
    }];
    
    
    [btnNext.layer setCornerRadius:5.0]; // 设置边框圆角
    [btnNext.layer setBorderColor:[UIColor orangeColor].CGColor];  // 设置边框
    [btnNext.layer setBorderWidth:1.0];   // 设置边框的线宽
    [btnNext.layer setMasksToBounds:YES]; //
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
