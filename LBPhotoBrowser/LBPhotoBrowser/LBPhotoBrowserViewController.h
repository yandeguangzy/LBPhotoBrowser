//
//  LBPhotoBrowserViewController.h
//  LBPhotoBrowser
//
//  Created by FSLB on 2017/3/6.
//  Copyright © 2017年 FSLB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBPhotoItem.h"
#import "LBPhotoBrowser.h"

@interface LBPhotoBrowserViewController : UIViewController

//供外部修改
/** 当前图片/所有图片 */
@property (nonatomic, strong) UILabel *pageLabel;
/** 返回按钮 */
@property (nonatomic, strong) UIButton *backBtn;

/** 所有items */
@property (nonatomic, strong)NSMutableArray <LBPhotoItem *> *items;
/** 显示模式（大图模式/预览模式） */
@property (nonatomic, assign)LBPhotoBrowserImageDisplayMode displayMode;


- (instancetype)initWithPhotoItems:(NSMutableArray <LBPhotoItem *> *)items selectedIndex:(NSUInteger)selectedIndex;
- (void)showFromViewController:(UIViewController *)selfVC;


@end
