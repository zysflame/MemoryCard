//
//  YSImageclloecView.h
//  菜谱
//
//  Created by qingyun on 16/9/8.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YSImageclloecView : UICollectionViewCell

@property (weak, nonatomic) UIImageView *imageView;

@property (copy, nonatomic) void(^deleteBlock)(UICollectionViewCell *cell);


@end
