//
//  LBPhotoView.m
//  LBPhotoBrowser
//
//  Created by FSLB on 2017/3/13.
//  Copyright © 2017年 FSLB. All rights reserved.
//

#import "LBPhotoView.h"
#import "UIImageView+WebCache.h"

@implementation LBPhotoView 

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.bouncesZoom = YES;
        self.delegate = self;
        self.maximumZoomScale = 3;
        self.multipleTouchEnabled = YES;
        self.showsHorizontalScrollIndicator = YES;
        self.showsVerticalScrollIndicator = YES;
        [self addSubview:self.mImageView];
        [self resizeImageView];
    }
    return self;
}

- (void)setDisplayMode:(LBPhotoBrowserImageDisplayMode)displayMode{
    _displayMode = displayMode;
    if(_displayMode == KSPhotoBrowserImageFullScreen){
        self.userInteractionEnabled = YES;
        self.mImageView.contentMode = UIViewContentModeScaleAspectFill;
    }else{
        self.userInteractionEnabled = NO;
        self.mImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
}

- (void)setItem:(LBPhotoItem *)item displayMode:(LBPhotoBrowserImageDisplayMode)displayMode{
    self.displayMode = displayMode;
    
    self.mImageView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    
    [self.mImageView sd_setImageWithURL:item.imgUrl placeholderImage:item.placeholdImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [self resizeImageView];
    }];
    [self resizeImageView];
}

- (UIImageView *)mImageView{
    if(!_mImageView){
        _mImageView = [[UIImageView alloc] init];
        _mImageView.userInteractionEnabled = NO;
        _mImageView.contentMode = UIViewContentModeScaleAspectFill;
        _mImageView.clipsToBounds = YES;
    }
    return _mImageView;
}

- (void)resizeImageView {
    if (_mImageView.image) {
        CGSize imageSize = _mImageView.image.size;
        CGFloat width = _mImageView.frame.size.width;
        CGFloat height = width * (imageSize.height / imageSize.width);
        CGRect rect = CGRectMake(0, 0, width, height);
        _mImageView.frame = rect;
        
        // If image is very high, show top content.
        if (height <= self.bounds.size.height) {
            _mImageView.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
        } else {
            _mImageView.center = CGPointMake(self.bounds.size.width/2, height/2);
        }
        
        // If image is very wide, make sure user can zoom to fullscreen.
        if (width / height > 2) {
            self.maximumZoomScale = self.bounds.size.height / height;
        }
    } else {
        CGFloat width = self.frame.size.width;
        _mImageView.frame = CGRectMake(0, 0, width, width * 2.0 / 3);
        _mImageView.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    }
    self.contentSize = _mImageView.frame.size;
}


- (UIView *) viewForZoomingInScrollView:(UIScrollView *)scrollView{
    if(_displayMode == KSPhotoBrowserImageFullScreen){
        return self.mImageView;
    }else{
        return nil;
    }
    
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    
    _mImageView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                    scrollView.contentSize.height * 0.5 + offsetY);
}


@end
