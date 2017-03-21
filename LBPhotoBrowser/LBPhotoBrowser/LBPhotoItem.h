//
//  LBPhotoItem.h
//  LBPhotoBrowser
//
//  Created by FSLB on 2017/3/6.
//  Copyright © 2017年 FSLB. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LBPhotoItem : NSObject

@property (nonatomic, strong) UIImageView *mImageView;

@property (nonatomic, strong) NSURL *imgUrl;

@property (nonatomic, strong) UIImage *placeholdImage;

@property (nonatomic, strong) NSString *title;

@property (nonatomic, strong) NSString *remark;

@property (nonatomic, assign) BOOL loadSuccess;

- (instancetype)initWithImageView:(UIImageView *)imageView imgUrl:(NSURL *)imgUrl placeholdImage:(UIImage *)placeholdImage;

@end
