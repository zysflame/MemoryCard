//
//  QYStatusCell.m
//  青云微博
//
//  Created by qingyun on 16/7/14.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "YSCommentInfoCell.h"
#import "UIButton+WebCache.h"
#import "YSCommentInfoModel.h"
#import "UIImageView+WebCache.h"

// cell中所有的判断必须全面, 否则信息会部队称

@interface YSCommentInfoCell ()

/** 昵称 */
@property (weak, nonatomic) IBOutlet UILabel *lblName;
/** 创建时间 */
@property (weak, nonatomic) IBOutlet UILabel *lblTime;
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

@implementation YSCommentInfoCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *strId = @"YSCommentInfoCell";
    YSCommentInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:strId];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"YSCommentInfoCell" owner:nil options:nil] firstObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

/** nib加载完毕的时候调用(所有的outlet属性都已经赋值) */
- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setCommentModel:(YSCommentInfoModel *)commentModel{
    _commentModel = commentModel;
    
    // 设置头像
//    NSURL *url = [NSURL URLWithString:status.user.strProfileImageUrl];
//    [self.btnHead sd_setBackgroundImageWithURL:url forState:UIControlStateNormal];
    
    // 设置昵称
    self.lblName.text = commentModel.nickname;
    
    // 设置创建时间
    self.lblTime.text = commentModel.date;
    
    // 设置来源
//    self.lblSource.text = status.strSourceDes;
    
    // 设置微博内容
    self.lblContent.text = commentModel
    .comment;
    
    [self loadImageURLs:commentModel.images forView:self.viewContentImages];
    
    self.lcBottomRetweetImage.constant = 0;
    self.lcBottomRetweetContent.constant = 0;
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
        [imageView sd_setImageWithURL:[NSURL URLWithString:arrURLs[index]]placeholderImage:[UIImage imageNamed:@"social-placeholder"]];
        [view addSubview:imageView];
        CGFloat X = space + (index % lineCount) * (width + space);
        CGFloat Y = space + (index / lineCount) * (height + space);
        imageView.frame = CGRectMake(X, Y, width, height);
        
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
    }
}

@end
