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

@interface LBPhotoCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong)LBPhotoView *photoView;
@property (nonatomic, strong)LBPhotoItem *photoItem;

@end
