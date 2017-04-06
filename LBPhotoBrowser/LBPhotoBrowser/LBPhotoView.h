//
//  LBPhotoView.h
//  LBPhotoBrowser
//
//  Created by FSLB on 2017/3/13.
//  Copyright © 2017年 FSLB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBPhotoItem.h"
#import "LBPhotoBrowser.h"

@interface LBPhotoView : UIScrollView<UIScrollViewDelegate>

/** 显示模式（大图模式/预览模式） */
@property (nonatomic, assign)LBPhotoBrowserImageDisplayModel displayMode;

@property (nonatomic, strong)LBPhotoItem *item;
@property (nonatomic, strong)UIImageView *mImageView;

- (void)setItem:(LBPhotoItem *)item displayMode:(LBPhotoBrowserImageDisplayModel)displayMode;

@end
