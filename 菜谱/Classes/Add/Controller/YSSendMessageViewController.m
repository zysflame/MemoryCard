//
//  YSSendMessageViewController.m
//  菜谱
//
//  Created by qingyun on 16/9/8.
//  Copyright © 2016年 qingyun. All rights reserved.
//   发表自己的心情

#import "YSSendMessageViewController.h"

#import "TZImagePickerController.h"
#import "YSImageCollectionViewCell.h"

#import "YSMessageModel.h"
#import "YSCurrentMessage.h"

static NSString * const strId = @"Image";
//static NSUInteger const maxNumImage = 9;
// 设置选择图片的最大数
#define maxNumImage 9

@interface YSSendMessageViewController () <UITextViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,TZImagePickerControllerDelegate>

/** 编辑文字  textView*/
@property (nonatomic, weak) IBOutlet UITextView *textViewBack;
/** 获取的图片的数组*/
@property (nonatomic, strong) NSMutableArray *arrMImages;
/** 背景图*/
@property (nonatomic, weak) IBOutlet UIView *viewBack;
/** 存放图片*/
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

/** 添加图片按钮*/
@property (nonatomic, weak) UIButton * albumeButton;


@end

@implementation YSSendMessageViewController

- (void)viewWillAppear:(BOOL)animated{
//    [self text];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadNavigationSetting];
    [self loadDefaultSetting];
    [self loadTheCollectionSetting];
}

#pragma mark 加载默认设置
- (void)loadDefaultSetting{
    // 初始化存放图片的数组
    self.arrMImages = [NSMutableArray arrayWithCapacity:9];
    self.textViewBack.text = nil;
    self.textViewBack.delegate = self;
}

#pragma mark  > collectionView 的设置 <
- (void)loadTheCollectionSetting{
    // 创建一个初始化UICollectionView的layout对象
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
//     设置最小的行距
    flowLayout.minimumLineSpacing = 10;
//     设置最小的列间距
    flowLayout.minimumInteritemSpacing = 20;
    NSUInteger line = 3;
    CGFloat jiange = 20;
//     设置每个cell的尺寸
    CGFloat width = (self.viewBack.frame.size.width - 2 * jiange) / line;
//        CGFloat width = (self.viewBack.frame.size.width - jiange)/ line - jiange;
    flowLayout.itemSize = CGSizeMake(width, width);
//     设置section的边距
    flowLayout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
    
//     设置header 的高度, 和我们的TableView的header一样(CollectionView有一个滚动方向, 当垂直滚动的时候, 高度起作用, 当水平滚动的时候, 宽度起作用)
    flowLayout.headerReferenceSize = CGSizeMake(0, 0);
    flowLayout.footerReferenceSize = CGSizeMake(0, 0);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;

    // 创建一个UICollectionView对象
    self.collectionView.collectionViewLayout = flowLayout;
    // UICollectionView默认的背景色是黑色
    self.collectionView.backgroundColor = [UIColor lightTextColor];
    // 设置数据源
    self.collectionView.dataSource = self;
    // 设置代理
    self. collectionView.delegate = self;
    
    // 为UICollectionView注册一个cell
//    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"image"];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"YSImageCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"image"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"YSButtonCollectionCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"button"];

}

#pragma mark - UICollectionViewDataSource
/** collectionView中有多少个分组 */
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}
/** collectionView中第section组有多少个cell */
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return self.arrMImages.count;
    }else{
        if (self.arrMImages.count >= maxNumImage) {
            return 0;
        }else{
            return 1;
        }
    }
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        YSImageCollectionViewCell *imageCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"image" forIndexPath:indexPath];
        [imageCell.imageView setImage:self.arrMImages[indexPath.item]];
         __weak typeof(self) weakSelf = self;
        [imageCell setBlkDeleteTheImageClickTheDelteBtn:^(UICollectionViewCell *cell) {
            [collectionView deselectItemAtIndexPath:indexPath animated:YES];
            [weakSelf.arrMImages removeObjectAtIndex:indexPath.item];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.collectionView reloadData];
            });
        }];
        return imageCell;

    }else{
        UICollectionViewCell *buttonCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"button" forIndexPath:indexPath];
        return buttonCell;
    }
}

#pragma mark  > UICollectionView 的代理事件 <
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        NSLog(@"点击了第一组>>%ld",indexPath.item);
    }else{
        TZImagePickerController *imagepickerVC = [[TZImagePickerController alloc] initWithMaxImagesCount:maxNumImage delegate:self];
        __weak typeof(self) weakSelf = self;
        [imagepickerVC setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isCan) {
//            NSLog(@">>>>%@",photos);
            [weakSelf.arrMImages addObjectsFromArray:photos];
            if (weakSelf.arrMImages.count >= maxNumImage) {
                NSRange range = NSMakeRange(maxNumImage, weakSelf.arrMImages.count - maxNumImage);
                [weakSelf.arrMImages removeObjectsInRange:range];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.collectionView reloadData];
            });
        }];
        [self presentViewController:imagepickerVC animated:YES completion:nil];

    }
}

#pragma mark 加载导航栏设置
- (void)loadNavigationSetting{
    UIBarButtonItem *itemWrong = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(clickTheCancelAction:)];
    self.navigationItem.leftBarButtonItem = itemWrong;
    
    UIBarButtonItem *itemSend = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:@selector(clickTheSendBtn:)];
    self.navigationItem.rightBarButtonItem = itemSend;
}

#pragma mark  > 点击了取消按钮 <
- (void)clickTheCancelAction:(UIBarButtonItem *)button{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark  > 点击发送按钮 <
- (void)clickTheSendBtn:(UIBarButtonItem *)button{
    // 图片的处理
    NSUInteger count = self.arrMImages.count;
    NSMutableArray *arrMImageDatas = [NSMutableArray arrayWithCapacity:count];
    for (NSUInteger index = 0; index < count; index ++) {
        NSData *imageData = UIImageJPEGRepresentation(self.arrMImages[index], 1);
        [arrMImageDatas addObject:imageData];
    }
    
    AVUser *currentUser = [AVUser currentUser];
    
    YSCurrentMessage *message = [YSCurrentMessage object];
    message.userName = currentUser.username;
    message.nickName = [currentUser objectForKey:@"nickName"];
    message.headerImv = [currentUser objectForKey:@"headerImage"];
    
    message.content = self.textViewBack.text;
    message.arrImages = [arrMImageDatas copy];
    
    [message saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }];
    
    
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
