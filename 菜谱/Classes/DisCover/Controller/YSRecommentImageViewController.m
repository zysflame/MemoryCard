//
//  YSRecommentImageViewController.m
//  菜谱
//
//  Created by qingyun on 16/9/11.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "YSRecommentImageViewController.h"

@interface YSRecommentImageViewController () <UICollectionViewDelegate,UICollectionViewDataSource>
/** 表格视图*/
@property (nonatomic, weak) UICollectionView *collectionView;
/** 存放的数据*/
@property (nonatomic, strong) NSMutableArray *arrData;

@property (nonatomic, weak) UIView *selectedView;

@end

static NSString * const reuseIdentifier = @"image";
@implementation YSRecommentImageViewController

- (void)viewWillAppear:(BOOL)animated{
    [self requestTheInformation];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadDefaultSetting];
    [self loadTheCollectionSetting];
    [self loadNavigationSetting];
}

#pragma mark 加载导航栏设置
- (void)loadNavigationSetting{
    self.automaticallyAdjustsScrollViewInsets = YES;
}

#pragma mark 加载默认设置
- (void)loadDefaultSetting{
    self.arrData = [NSMutableArray array];
    self.title = self.strTitle;
}


#pragma mark  > collectionView 的设置 <
- (void)loadTheCollectionSetting{
    // 创建一个初始化UICollectionView的layout对象
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    // 设置最小的行距
    flowLayout.minimumLineSpacing = 10;
    // 设置最小的列间距
    flowLayout.minimumInteritemSpacing = 10;
    // 设置每个cell的尺寸
    CGFloat jiange = 10;
    CGFloat width = (YSScreenWidth - 3 * jiange) / 2;
    flowLayout.itemSize = CGSizeMake(width, width);
    // 设置section的边距
    flowLayout.sectionInset = UIEdgeInsetsMake(jiange, jiange, jiange, jiange);
    // 设置header 的高度, 和我们的TableView的header一样(CollectionView有一个滚动方向, 当垂直滚动的时候, 高度起作用, 当水平滚动的时候, 宽度起作用)
    flowLayout.headerReferenceSize = CGSizeMake(0, 0);
    flowLayout.footerReferenceSize = CGSizeMake(0, 0);
    
    // 滚动的方向
    //flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    // 固定header/Footer
    flowLayout.sectionHeadersPinToVisibleBounds = YES;
    flowLayout.sectionFootersPinToVisibleBounds = YES;
    
    // 创建一个UICollectionView对象
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
    [self.view addSubview:collectionView];
    self.collectionView = collectionView;
    // UICollectionView默认的背景色是黑色
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.contentInset = UIEdgeInsetsMake(0, 0, 40, 0);
    // 设置数据源
    collectionView.dataSource = self;
    // 设置代理
    collectionView.delegate = self;
    
    // 为UICollectionView注册一个cell
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.arrData.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    if (self.arrData.count != 0) {
        UIImageView *cellImageView = [UIImageView new];
        NSString *strImage = [self.arrData objectAtIndex:indexPath.item];
        NSURL *imageUrl = [NSURL URLWithString:strImage];
        [cellImageView sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"social-placeholder"]];
        cell.backgroundView = cellImageView;
    }
    // Configure the cell
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UIView *selectView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.selectedView = selectView;
    self.selectedView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
    
    UIImageView *bigImgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, (YSScreenHeight - (YSScreenWidth - 10 * 2))/2.0, YSScreenWidth - 10 * 2,  YSScreenWidth - 10 * 2)];
    NSString *strImage = [self.arrData objectAtIndex:indexPath.item];
    NSURL *imageUrl = [NSURL URLWithString:strImage];
    [bigImgView sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"social-placeholder"]];
    [self.selectedView addSubview:bigImgView];
    
    /**#warning  添加覆盖全屏的View*/
    [[UIApplication sharedApplication].keyWindow addSubview:self.selectedView];
    
    //   给codeView添加手势
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapView)];
    [self.selectedView addGestureRecognizer:singleTap];
    [UIView animateWithDuration:0.5 animations:^{
    }];
}

- (void)requestTheInformation{
    NSString *strURL = @"http://searchtouch.qunar.com/queryData/headerImage.do";
    NSDictionary *dic = @{@"sightId":self.strId};
    YSHTTPRequestManager *manager = [YSHTTPRequestManager sharedHTTPRequest];
    __weak typeof(self) weakSelf = self;
    [manager GETWithURL:strURL withParam:dic andRequestSuccess:^(id responseObject) {
        //        NSLog(@">>>>数据是%@",responseObject);
        NSArray *arr = responseObject[@"data"];
        NSUInteger count = arr.count;
        for (NSUInteger index = 0; index < count; index ++) {
            NSDictionary *dic = arr[index];
            NSString *strImage = dic[@"image"];
            [weakSelf.arrData addObject:strImage];
        }
        NSLog(@">>>%ld",(unsigned long)weakSelf.arrData.count);
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.collectionView reloadData];
        });
    } andRequestFailure:^(NSError *error) {
        UIAlertController *alertContorller = [UIAlertController alertControllerWithTitle:@"友情提示" message:@"网络不好，请耐心等待" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
        }];
        UIAlertAction *alertDengLuAction = [UIAlertAction actionWithTitle:@"刷新试试" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [weakSelf requestTheInformation];
        }];
        [alertContorller addAction:alertDengLuAction];
        [alertContorller addAction:alertAction];
        [weakSelf presentViewController:alertContorller animated:YES completion:nil];
    }];
    
}

// 点击屏幕
- (void)tapView
{
    [self.selectedView removeFromSuperview];
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
