//
//  YSImageclloecView.m
//  菜谱
//
//  Created by qingyun on 16/9/8.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "YSImageclloecView.h"

@interface YSImageclloecView ()

@property (weak, nonatomic) UIButton *deleteBtn;
@property (weak, nonatomic) UIImageView *videoIcon;

@end

@implementation YSImageclloecView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup{
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.clipsToBounds = YES;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.frame = CGRectMake(0, 0, width, height);
    [self.contentView addSubview:imageView];
    _imageView = imageView;
    
    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [deleteBtn setBackgroundImage:[UIImage imageNamed:@"back_single@2x.png"] forState:UIControlStateNormal];
    deleteBtn.frame = CGRectMake(width - 27, 2, 25, 25);
    deleteBtn.hidden = YES;
    [deleteBtn addTarget:self action:@selector(deleteClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:deleteBtn];
    _deleteBtn = deleteBtn;
}

- (void)deleteClick:(UIButton *)button
{
    if (self.deleteBlock) {
        self.deleteBlock(self);
    }
}


@end
