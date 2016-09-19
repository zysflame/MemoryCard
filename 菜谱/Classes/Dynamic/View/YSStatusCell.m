//
//  QYStatusCell.m
//  青云微博
//
//  Created by qingyun on 16/7/14.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "YSStatusCell.h"
#import "YSStatusModel.h"
#import "UIButton+WebCache.h"
#import "YSUserModel.h"
#import "UIImageView+WebCache.h"

// cell中所有的判断必须全面, 否则信息会部队称

#import "YSMessageModel.h"
#import "YSCurrentMessage.h"
@interface YSStatusCell ()

/** 头像按钮 */
@property (weak, nonatomic) IBOutlet UIButton *btnHead;
/** 博主昵称 */
@property (weak, nonatomic) IBOutlet UILabel *lblName;
/** 创建时间 */
@property (weak, nonatomic) IBOutlet UILabel *lblTime;
/** 发布来源 */
@property (weak, nonatomic) IBOutlet UILabel *lblSource;
/** 微博主内容 */
@property (weak, nonatomic) IBOutlet UILabel *lblContent;
/** 微博的图片 */
@property (weak, nonatomic) IBOutlet UIView *viewContentImages;
/** 转发的内容 */
@property (weak, nonatomic) IBOutlet UILabel *lblRetweetContent;
/** 转发内容中的图片 */
@property (weak, nonatomic) IBOutlet UIView *viewRetweetImages;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lcContentHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lcRetweetHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lcBottomRetweetContent;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lcBottomRetweetImage;

@end

@implementation YSStatusCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *strId = @"YSStatusCell";
    YSStatusCell *cell = [tableView dequeueReusableCellWithIdentifier:strId];
    if (cell == nil){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"YSStatusCell" owner:nil options:nil] firstObject];
    }
    return cell;
}

/** nib加载完毕的时候调用(所有的outlet属性都已经赋值) */
- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.btnHead.layer.cornerRadius = 25.0;
    self.btnHead.layer.masksToBounds = YES;
}

- (void)setMessage:(YSCurrentMessage *)message{
    _message = message;
    
    // 设置头像
    AVUser *currentUser = [AVUser currentUser];
    NSData *imageData  = [currentUser objectForKey:@"headerImage"];
    UIImage *imageHeader = [UIImage imageWithData:imageData];
    [self.btnHead setImage:imageHeader forState:UIControlStateNormal];
    //    if ([currentUser.username isEqualToString:message.userName]) {
    //    }else{
    //        UIImage *imageHeader = [UIImage imageWithData:message.headerImv];
    //        [self.btnHead setImage:imageHeader forState:UIControlStateNormal];
    //    }
    
    // 设置昵称
    self.lblName.text = message.nickName;
    
    // 设置创建时间
    //    self.lblTime.text = status.strTimeDes;
    
    // 设置时间  ----- 实际上是显示昵称
    //    self.lblSource.text = message.nickName;
    
    // 设置来源  ---- 时间上是显示 时间
    NSDate *update = message.updatedAt;
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString *strTime = [formatter stringFromDate:update];
    self.lblTime.text = strTime;
    
    // 设置微博内容
    self.lblContent.text = message.content;
    
    // 如果有图片就设置图片
    [self loadImages:message.arrImages forView:self.viewContentImages];
    
    self.lcBottomRetweetImage.constant = 0;
    self.lcBottomRetweetContent.constant = 0;
}

- (void)setStatus:(YSStatusModel *)status {
    _status = status;
    
    // 设置头像
    NSURL *url = [NSURL URLWithString:status.user.strProfileImageUrl];
    [self.btnHead sd_setBackgroundImageWithURL:url forState:UIControlStateNormal];
    
    // 设置昵称
    self.lblName.text = status.user.strScreenName;
    
    // 设置创建时间
    self.lblTime.text = status.strTimeDes;
    
    // 设置来源
    self.lblSource.text = status.strSourceDes;
    
    // 设置微博内容
    self.lblContent.text = status.strText;
    
    // 转发
    YSStatusModel *retweetedStatus = status.retweetedStatus;
    if (retweetedStatus == nil) { // 没有转发
        self.lblRetweetContent.text = nil;
        
        // 如果有图片就设置图片
        [self loadImageURLs:status.arrPicUrls forView:self.viewContentImages];
        [self loadImageURLs:nil forView:self.viewRetweetImages];
        
        self.lcBottomRetweetImage.constant = 0;
        self.lcBottomRetweetContent.constant = 0;
        
    } else { // 转发
        self.lblRetweetContent.text = retweetedStatus.strText;
        
        [self loadImageURLs:nil forView:self.viewContentImages];
        [self loadImageURLs:retweetedStatus.arrPicUrls forView:self.viewRetweetImages];
        
        self.lcBottomRetweetImage.constant = 8;
        self.lcBottomRetweetContent.constant = 8;
    }
}

- (void)loadImages:(NSArray *)arrImageDatas forView:(UIView *)view {
    // 清除之前添加的所有的ImageView
    [view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    NSUInteger count = arrImageDatas.count;
    NSInteger lineCount = 3;
    CGFloat space = 8;
    CGFloat width = (YSScreenWidth - 4 * space) / lineCount;
    CGFloat height = width;
    
    // 调整view的高度
    // 有多少行
    NSInteger line = (count + lineCount - 1) / lineCount;
    CGFloat heightView = 0;
    if (line) {
        heightView = space + (space + height) * line;
    }
    
    if (view == self.viewContentImages) {
        self.lcContentHeight.constant = heightView;
    } else {
        self.lcRetweetHeight.constant = heightView;
    }
    
    // 如果图片的数量是0 直接返回
    if (count == 0) return;
    
    // 添加ImageView
    for (NSUInteger index = 0; index < count; index ++) {
        UIImageView *imageView = [UIImageView new];
        imageView.image = [UIImage imageWithData:arrImageDatas[index]];
        //        [imageView sd_setImageWithURL:[NSURL URLWithString:arrImageDatas[index]] placeholderImage:[UIImage imageNamed:@"social-placeholder"]];
        [view addSubview:imageView];
        CGFloat X = space + (index % lineCount) * (width + space);
        CGFloat Y = space + (index / lineCount) * (height + space);
        imageView.frame = CGRectMake(X, Y, width, height);
        
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
    }
}


- (void)loadImageURLs:(NSArray *)arrURLs forView:(UIView *)view {
    // 清除之前添加的所有的ImageView
    [view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    NSUInteger count = arrURLs.count;
    NSInteger lineCount = 3;
    CGFloat space = 8;
    CGFloat width = (YSScreenWidth - 4 * space) / lineCount;
    CGFloat height = width;
    
    // 调整view的高度
    // 有多少行
    NSInteger line = (count + lineCount - 1) / lineCount;
    CGFloat heightView = 0;
    if (line) {
        heightView = space + (space + height) * line;
    }
    
    if (view == self.viewContentImages) {
        self.lcContentHeight.constant = heightView;
    } else {
        self.lcRetweetHeight.constant = heightView;
    }
    
    // 如果图片的数量是0 直接返回
    if (count == 0) return;
    
    // 添加ImageView
    for (NSUInteger index = 0; index < count; index ++) {
        UIImageView *imageView = [UIImageView new];
        
        [imageView sd_setImageWithURL:[NSURL URLWithString:arrURLs[index][@"thumbnail_pic"]] placeholderImage:[UIImage imageNamed:@"social-placeholder"]];
        [view addSubview:imageView];
        CGFloat X = space + (index % lineCount) * (width + space);
        CGFloat Y = space + (index / lineCount) * (height + space);
        imageView.frame = CGRectMake(X, Y, width, height);
        
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
    }
}

@end
