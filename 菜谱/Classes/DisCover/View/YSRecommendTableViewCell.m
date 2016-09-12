//
//  YSRecommendTableViewCell.m
//  菜谱
//
//  Created by qingyun on 16/9/11.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "YSRecommendTableViewCell.h"

@interface YSRecommendTableViewCell ()

/** 图片*/
@property (weak, nonatomic) IBOutlet UIImageView *imvHeader;
/** 标题*/
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
/** 评论数*/
@property (weak, nonatomic) IBOutlet UILabel *lblComment;
/** 地址*/
@property (weak, nonatomic) IBOutlet UILabel *lblAddress;

@end

@implementation YSRecommendTableViewCell

#pragma mark  > 创建时使用的类方法 <
+ (instancetype)recommnedCellWithTableView:(UITableView *)tableView{
    static NSString *strId = @"YSRecommendTableViewCell";
    YSRecommendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:strId];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"YSRecommendTableViewCell" owner:self options:nil] firstObject];
    }
    return cell;
}

- (void)setProductModel:(YSProductModel *)productModel{
    _productModel = productModel;
    NSURL *imvURL = [NSURL URLWithString:_productModel.img];
    [self.imvHeader sd_setImageWithURL:imvURL];
    self.lblTitle.text = _productModel.title;
    self.lblComment.text = _productModel.comment;
    self.lblAddress.text = _productModel.address;
}


#pragma 纯代码时会加载此方法
- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]){
        [self loadDefaultSetting];
    }
    return self;
}
#pragma mark 使用xib时会加载此方法
- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self loadDefaultSetting];
    }
    return self;
}
#pragma mark 唤醒xib视图
- (void)awakeFromNib{
    [super awakeFromNib];
}

#pragma mark 加载默认设置
- (void)loadDefaultSetting{
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
