//
//  YSImageCollectionViewCell.m
//  菜谱
//
//  Created by qingyun on 16/9/9.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "YSImageCollectionViewCell.h"

@implementation YSImageCollectionViewCell

- (void)awakeFromNib{
    [super awakeFromNib];
}

- (IBAction)deleteBtn:(UIButton *)deleteBtn {
    if (self.blkDeleteTheImageClickTheDelteBtn) {
        self.blkDeleteTheImageClickTheDelteBtn(self);
    }
}


@end
