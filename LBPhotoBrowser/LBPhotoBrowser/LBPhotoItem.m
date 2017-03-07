//
//  LBPhotoItem.m
//  LBPhotoBrowser
//
//  Created by FSLB on 2017/3/6.
//  Copyright © 2017年 FSLB. All rights reserved.
//

#import "LBPhotoItem.h"

@implementation LBPhotoItem

- (instancetype)initWithImageView:(UIImageView *)imageView imgUrl:(NSURL *)imgUrl placeholdImage:(UIImage *)placeholdImage{
    self = [super init];
    if(self){
        _mImageView = imageView;
        _imgUrl = imgUrl;
        _placeholdImage = placeholdImage;
    }
    return self;
}

@end
