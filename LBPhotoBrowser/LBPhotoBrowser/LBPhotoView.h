//
//  LBPhotoView.h
//  LBPhotoBrowser
//
//  Created by FSLB on 2017/3/13.
//  Copyright © 2017年 FSLB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBPhotoItem.h"

@interface LBPhotoView : UIScrollView<UIScrollViewDelegate>

@property (nonatomic, strong)LBPhotoItem *item;
@property (nonatomic, strong)UIImageView *mImageView;

- (void)setItem:(LBPhotoItem *)item determinate:(BOOL)determinate;
@end
