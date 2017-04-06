//
//  LBPhotoBrowserRemarkView.h
//  LBPhotoBrowser
//
//  Created by FSLB on 2017/3/21.
//  Copyright © 2017年 FSLB. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LBPhotoBrowserRemarkView : UIScrollView

- (void) updateWithTitle:(NSString *)titleStr content:(NSString *)content;

@property (nonatomic, strong) NSString *titleStr;

@property (nonatomic, strong) NSString *contentStr;

@property (nonatomic, strong) UILabel *remarkLabel;

@property (nonatomic, assign) BOOL isEnable;

@end
