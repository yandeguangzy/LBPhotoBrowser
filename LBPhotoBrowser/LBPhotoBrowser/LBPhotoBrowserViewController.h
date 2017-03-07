//
//  LBPhotoBrowserViewController.h
//  LBPhotoBrowser
//
//  Created by FSLB on 2017/3/6.
//  Copyright © 2017年 FSLB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBPhotoItem.h"

@interface LBPhotoBrowserViewController : UIViewController

@property (nonatomic, strong)NSMutableArray <LBPhotoItem *> *items;

- (instancetype)initWithPhotoItems:(NSMutableArray <LBPhotoItem *> *)items selectedIndex:(NSUInteger)selectedIndex;


- (void)showFromViewController:(UIViewController *)selfVC;

@end
