//
//  LBPhotoCollectionViewCell.h
//  LBPhotoBrowser
//
//  Created by FSLB on 2017/3/16.
//  Copyright © 2017年 FSLB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBPhotoItem.h"
#import "LBPhotoView.h"
#import "LBPhotoBrowser.h"

@interface LBPhotoCollectionViewCell : UICollectionViewCell

/** 显示模式（大图模式/预览模式） */
@property (nonatomic, assign)LBPhotoBrowserImageDisplayMode displayMode;

@property (nonatomic, strong)LBPhotoView *photoView;
@property (nonatomic, strong)LBPhotoItem *photoItem;

- (void) setDisplayModel:(LBPhotoBrowserImageDisplayMode)displayMode photoItem:(LBPhotoItem *)photoItem;

@end
