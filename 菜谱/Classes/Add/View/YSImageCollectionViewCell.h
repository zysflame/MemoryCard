//
//  YSImageCollectionViewCell.h
//  菜谱
//
//  Created by qingyun on 16/9/9.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YSImageCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (copy, nonatomic) void(^blkDeleteTheImageClickTheDelteBtn)(UICollectionViewCell *cell);


@end
