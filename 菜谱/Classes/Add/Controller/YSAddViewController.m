//
//  YSAddViewController.m
//  菜谱
//
//  Created by qingyun on 16/8/17.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "YSAddViewController.h"
#import <AVFoundation/AVFoundation.h>

#import "YSMessageModel.h"

#import "TZImagePickerController.h"
#import "YSImageclloecView.h"


#define imageWidth 60
#define BtnWidth 50
#define BtnOffset 16

static NSString * const strId = @"Image";

@interface YSAddViewController () <UITextViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,TZImagePickerControllerDelegate>
/** 编辑文字  textView*/
@property (nonatomic, weak) UITextView *textViewBack;
/** 获取的图片的数组*/
@property (nonatomic, strong) NSMutableArray *arrMImages;
/** 背景图*/
@property (nonatomic, weak) UIView *viewBack;
/** 存放图片*/
@property (weak, nonatomic) UICollectionView *collectionView;

/** 添加图片按钮*/
@property (nonatomic, weak) UIButton * albumeButton;
/** 个人发表的心情的数组*/
@property (nonatomic, strong) NSMutableArray *arrMessage;


@property (nonatomic, copy) NSString *strID;

@end

@implementation YSAddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadDefaultSetting];
    [self loadNavigationSetting];
}

#pragma mark 加载默认设置
- (void)loadDefaultSetting{
    self.navigationItem.title = @"添加";
    self.automaticallyAdjustsScrollViewInsets = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.arrMImages = [NSMutableArray arrayWithCapacity:5];
//    [self settingCollectionView];
    [self loadTheUI];
}

- (void)settingCollectionView{
    // 创建一个初始化UICollectionView的layout对象
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    // 设置最小的行距
    flowLayout.minimumLineSpacing = 5;
    // 设置最小的列间距
    flowLayout.minimumInteritemSpacing = 5;
    NSUInteger line = 3;
    // 设置每个cell的尺寸
    CGFloat width = (YSScreenWidth - 10)/ (line + 1);
    flowLayout.itemSize = CGSizeMake(width, width);
    // 设置section的边距
    flowLayout.sectionInset = UIEdgeInsetsMake(30, 30, 30, 30);

    
    // 创建一个UICollectionView对象
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
    [self.view addSubview:collectionView];
    self.collectionView = collectionView;
    // UICollectionView默认的背景色是黑色
    collectionView.backgroundColor = [UIColor orangeColor];
    // 设置数据源
    collectionView.dataSource = self;
    // 设置代理
    collectionView.delegate = self;
    
    // 为UICollectionView注册一个cell
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:strId];
}

#pragma mark - UICollectionViewDataSource
/** collectionView中有多少个分组 */
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
/** collectionView中第section组有多少个cell */
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 9;
}
// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:strId forIndexPath:indexPath];
    cell.contentView.backgroundColor = YSColorRandom;

    // 绝对不要在CollectionViewCell创建的时候使用下面的方法, 否则翻脸挂掉
    //if (cell == nil) {
    //    cell = [[UICollectionViewCell alloc] init];
    //}
    return cell;
}



#pragma mark  > 点击添加按钮后触发的方法 <
- (void)showAlbume{
    TZImagePickerController *imagepickerVC = [[TZImagePickerController alloc] initWithMaxImagesCount:4 delegate:self];
    __weak typeof(self) weakSelf = self;
    [imagepickerVC setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isCan) {
        [weakSelf.arrMImages addObjectsFromArray:photos];
        [weakSelf loadImageViews];
    }];
    [self presentViewController:imagepickerVC animated:YES completion:nil];
}

#pragma mark 加载导航栏设置
- (void)loadNavigationSetting{
    UIBarButtonItem *itemWrong = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(clickTheCancelAction:)];
    self.navigationItem.leftBarButtonItem = itemWrong;
    
    UIBarButtonItem *itemSend = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:@selector(clickTheSendBtn:)];
    self.navigationItem.rightBarButtonItem = itemSend;
}

#pragma mark  > 点击了取消按钮触发的方法 <
- (void)clickTheCancelAction:(UIBarButtonItem *)button{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark  > 点击发送时触发的方法 <
- (void)clickTheSendBtn:(UIBarButtonItem *)sendBtn{
    
    AVUser *currentUser = [AVUser currentUser];

    NSDictionary *dic = [[AVUser currentUser] objectForKey:@"relationData"];
    NSArray *arr = dic[@"MessageData"];
    
//    NSLog(@">>>>messageData >>>>%@",arr[0]);
    
    NSMutableArray *arrMData = [NSMutableArray arrayWithArray:arr];
//    AVObject *todoFolder = [[AVObject alloc] initWithClassName:@"TodoFolder"];// 构建对象
//    [todoFolder setObject:@"工作" forKey:@"name"];// 设置名称
//    [todoFolder setObject:@1 forKey:@"priority"];// 设置优先级
    
    AVObject *message = [[AVObject alloc] initWithClassName:@"message"];
    
    [message setObject:self.textViewBack.text forKey:@"title"];
    [message setObject:self.textViewBack.text forKey:@"content"];
    NSMutableArray *arrMImageData = [NSMutableArray arrayWithCapacity:self.arrMImages.count];
    for (UIImage *image in self.arrMImages) {
        NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
        [arrMImageData addObject:imageData];
    }
    [message setObject:arrMImageData forKey:@"ImageDatas"];
    [arrMData addObject:message];
    
    [AVObject saveAllInBackground:arrMData block:^(BOOL succeeded, NSError *error) {
        if (error) {
            // 出现错误
            NSLog(@"错误啊");
        } else {
            // 保存成功
            AVRelation *MessageData = [[AVUser currentUser] relationForKey:@"MessageData"];// 新建一个 AVRelation
            for (AVObject *obj in arrMData) {
                [MessageData addObject:obj];
            }
            NSLog(@"message>>>>%@",MessageData);
            
            // 上述 3 行代码表示 relation 关联了 3 个 Todo 对象
            [currentUser saveInBackground];// 保存到云端
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }];
    
    
    
    
//    // objectWithClassName 参数对应控制台中的 Class Name
//    AVObject *message = [[AVObject alloc] initWithClassName:@"Message"];// 构建对象
////    AVObject *messData = [[AVObject alloc] initWithClassName:@"MessageData"];// 构建对象
//    [message setObject:currentUser.username forKey:@"userID"];
////    [message setObject:currentUser[@"nickName"] forKey:@"nickName"];
////    NSData *imageData = currentUser[@"headerImage"];
////    [message setObject:imageData forKey:@"headerImage"];
//    [message setObject:self.textViewBack.text forKey:@"content"];// 设置名称
//     __weak typeof(self) weakSelf = self;
//    [message saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//        if (succeeded) {
//            weakSelf.strID = message.objectId;
//            NSArray *arr = [[AVUser currentUser] objectForKey:@"MessageData"];
//            NSMutableArray *arrMData = [NSMutableArray arrayWithArray:arr];
//            [arrMData addObject: message.objectId];
////            [arrMData removeAllObjects];
//            [[AVUser currentUser] setObject:arrMData forKey:@"MessageData"];
//            [[AVUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//                NSLog(@">>>%@",message);
//                // 此处是修改数据
//                [[AVUser currentUser] setObject:arrMData forKey:@"MessageData"];
//                [[AVUser currentUser] saveInBackground];
//                
//                [weakSelf dismissViewControllerAnimated:YES completion:nil];
//            }];
//        }
//    }];// 保存到云端


}

#pragma mark  > 加载UI 的添加 <
- (void)loadTheUI{
    // 上边标题
    UILabel *lblTitle = [UILabel new];
    [self.view addSubview:lblTitle];
    lblTitle.text = @"抒发一下自己此刻的心情吧!!!!";
    lblTitle.textColor = [UIColor blackColor];
    lblTitle.font = [UIFont systemFontOfSize:20];
    [lblTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(72);
        make.leading.mas_equalTo(16);
        make.trailing.mas_greaterThanOrEqualTo(-8);
        make.height.mas_equalTo(30);
    }];
    
    // 文本编辑
    UITextView *textBack = [UITextView new];
    [self.view addSubview:textBack];
    self.textViewBack = textBack;
    textBack.delegate = self;
    textBack.backgroundColor = [UIColor lightGrayColor];
    textBack.text = @"心情内容";
    [textBack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lblTitle.mas_bottom).offset(8);
        make.leading.mas_equalTo(8);
        make.trailing.mas_equalTo(-8);
        make.height.mas_equalTo(150);
    }];
    
    // 存放照片的View
    UIView *viewBack = [UIView new];
    [self.view addSubview:viewBack];
    self.viewBack = viewBack;
    [viewBack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.and.trailing.equalTo(textBack);
        make.top.equalTo(textBack.mas_bottom).offset(16);
        make.height.mas_equalTo(80);
    }];
    viewBack.backgroundColor = [UIColor lightGrayColor];
    
   

    
    // 添加按钮
    UIButton * albumeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:albumeButton];
    self.albumeButton = albumeButton;
    albumeButton.titleLabel.font =[UIFont fontWithName:kfontBold size:18];
    [albumeButton setImage:[UIImage imageNamed:@"btn_normal"] forState:UIControlStateNormal];
    [albumeButton setImage:[UIImage imageNamed:@"btn_normal_selected"] forState:UIControlStateSelected];
    [albumeButton addTarget:self action:@selector(showAlbume) forControlEvents:UIControlEventTouchUpInside];
    [albumeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(viewBack).offset(BtnOffset);
        make.bottom.equalTo(viewBack).offset(-BtnOffset);
        make.leading.equalTo(viewBack).offset(8);
        make.width.mas_equalTo(BtnWidth);
    }];
}

#pragma mark  > 添加按钮 <
- (void)addBtnAfterTheImageView:(UIImageView *)imvLast{
    [self.albumeButton removeFromSuperview];
    UIButton *albumeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:albumeButton];
    self.albumeButton = albumeButton;
    //    albumeButton.titleLabel.font =[UIFont fontWithName:kfontBold size:18];
    [albumeButton setImage:[UIImage imageNamed:@"btn_normal"] forState:UIControlStateNormal];
    [albumeButton setImage:[UIImage imageNamed:@"btn_normal_selected"] forState:UIControlStateDisabled];
    [albumeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.viewBack).offset(BtnOffset);
        make.bottom.equalTo(self.viewBack).offset(-BtnOffset);
        make.leading.equalTo(imvLast.mas_trailing).offset(8);
        make.width.mas_equalTo(BtnWidth);
    }];
    [albumeButton addTarget:self action:@selector(showAlbume) forControlEvents:UIControlEventTouchUpInside];
    if (self.arrMImages.count >= 5) {
        self.albumeButton.enabled = NO;
        
        //        UIAlertController *alertContorller = [UIAlertController alertControllerWithTitle:@"友情提示" message:@"添加照片请不要超过六张" preferredStyle:UIAlertControllerStyleAlert];
        //        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleDefault handler:nil];
        //        [alertContorller addAction:alertAction];
        //        [self presentViewController:alertContorller animated:YES completion:nil];
    }
}


#pragma mark  >  textview的代理方法  UITextViewDelegate <
/** 当开始编辑的时候触发的方法*/
- (void)textViewDidBeginEditing:(UITextView *)textView{
    if ([textView.text isEqualToString:@"心情内容"]) {
        textView.text = nil;
        textView.clearsOnInsertion = YES;
    }
}

#pragma mark  > 加载图片 <
- (void)loadImageViews{
    NSUInteger count = self.arrMImages.count;
    if (count == 0) {
        return;
    }
    
    NSMutableArray *arrMImageViews = [NSMutableArray arrayWithCapacity:count];
    for (NSUInteger index = 0; index < count; index ++) {
        UIImage *image = self.arrMImages[index];
        UIImageView *imvBack = [[UIImageView alloc] initWithImage:image];
        [arrMImageViews addObject:imvBack];
        [self.viewBack addSubview:imvBack];
        
        if (index == 0) {
            [imvBack mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_viewBack).offset(3);
                make.bottom.equalTo(_viewBack).offset(-3);
                make.leading.equalTo(_viewBack).offset(3);
                //                make.height.equalTo(scrollView);
                make.centerY.equalTo(_viewBack);
                make.width.mas_equalTo(imageWidth);
            }];
            [self addBtnAfterTheImageView:imvBack];
        }else if (index == (count -1)){
            [imvBack mas_makeConstraints:^(MASConstraintMaker *make) {
                UIImageView *imageViewTemp = arrMImageViews[index - 1];
                make.top.equalTo(_viewBack).offset(3);
                make.bottom.equalTo(_viewBack).offset(-3);
                make.leading.equalTo(imageViewTemp.mas_trailing).offset(3);
                make.width.mas_equalTo(imageWidth);
                make.centerY.equalTo(_viewBack);
            }];
            [self addBtnAfterTheImageView:imvBack];
        }else{
            [imvBack mas_makeConstraints:^(MASConstraintMaker *make) {
                UIImageView *imageViewBefore = arrMImageViews[index - 1];
                make.top.equalTo(_viewBack).offset(3);
                make.bottom.equalTo(_viewBack).offset(-3);
                make.leading.equalTo(imageViewBefore.mas_trailing).offset(3);
                make.width.mas_equalTo(imageWidth);
                make.centerY.equalTo(_viewBack);
            }];
        }
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark  > 点击屏幕后编辑结束 <
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
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
