//
//  LBPhotoBrowserViewController.h
//  LBPhotoBrowser
//
//  Created by FSLB on 2017/3/6.
//  Copyright © 2017年 FSLB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBPhotoItem.h"

typedef NS_ENUM(NSUInteger, LBPhotoBrowserImageDisplayModel) {
    KSPhotoBrowserImageFullScreen = 0,
    KSPhotoBrowserImagePreview
};

@interface LBPhotoBrowserViewController : UIViewController

//供外部修改
/** 当前图片/所有图片 */
@property (nonatomic, strong) UILabel *pageLabel;
/** 返回按钮 */
@property (nonatomic, strong) UIButton *backBtn;

/** 所有items */
@property (nonatomic, strong)NSMutableArray <LBPhotoItem *> *items;
/** 显示模式（大图模式/预览模式） */
@property (nonatomic, assign)LBPhotoBrowserImageDisplayModel displayMode;

/** 是否启用RemarkView 默认为NO*/
@property (nonatomic, assign)BOOL remarkViewEnable;


- (instancetype)initWithPhotoItems:(NSMutableArray <LBPhotoItem *> *)items selectedIndex:(NSUInteger)selectedIndex;
- (void)showFromViewController:(UIViewController *)selfVC;


@end
