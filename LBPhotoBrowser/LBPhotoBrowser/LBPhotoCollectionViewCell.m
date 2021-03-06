//
//  LBPhotoCollectionViewCell.m
//  LBPhotoBrowser
//
//  Created by FSLB on 2017/3/16.
//  Copyright © 2017年 FSLB. All rights reserved.
//

#import "LBPhotoCollectionViewCell.h"

@interface LBPhotoCollectionViewCell ()

@end

@implementation LBPhotoCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.photoView];
    }
    return self;
}

- (LBPhotoView *)photoView{
    if(!_photoView){
        _photoView = [[LBPhotoView alloc] init];
    }
    return _photoView;
}

- (void)setPhotoItem:(LBPhotoItem *)photoItem{
    _photoItem = photoItem;
    [self.photoView setItem:photoItem displayMode:_displayMode];
}


- (void) setDisplayModel:(LBPhotoBrowserImageDisplayModel)displayMode photoItem:(LBPhotoItem *)photoItem{
    self.photoView.frame = self.bounds;
    self.displayMode = displayMode;
    self.photoItem = photoItem;
}

@end
