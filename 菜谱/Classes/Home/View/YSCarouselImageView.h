//
//  DGBCarouselImageView.h
//  Demo
//
//  Created by douguangbin on 16/9/2.
//  Copyright © 2016年 douguangbin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YSCarouselImageView;
//图片来源
typedef NS_ENUM(NSInteger , DGBBannerSource){
    
    DGBBannerStyleOnlyLocalSource = 0,
    DGBBannerStyleOnlyWebSource = 1,
    
};

@protocol YSCarouselImageViewDelegate <NSObject>

- (void)dgbCarouselImageView:(YSCarouselImageView *)carouselImageView didSelectItemAtIndex:(NSInteger)index;

@end


@interface YSCarouselImageView : UIView

@property (nonatomic,weak) id <YSCarouselImageViewDelegate> delegate;

@property (nonatomic,assign) CGFloat timeInterval;

@property (nonatomic,assign) BOOL showPageControl;

@property (nonatomic,strong) UIColor *currentPageIndicatorTintColour;
@property (nonatomic,strong) UIColor *pageIndicatorTintColour;

- (instancetype)initWithFrame:(CGRect)frame withBannerSource:(DGBBannerSource )bannerSource withBannerArray:(NSArray *)bannerArray;

@end
