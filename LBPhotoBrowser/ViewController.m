//
//  ViewController.m
//  LBPhotoBrowser
//
//  Created by FSLB on 2017/3/3.
//  Copyright © 2017年 FSLB. All rights reserved.
//

#import "ViewController.h"
#import "UIImageView+WebCache.h"
#import "LBPhotoBrowserViewController.h"

@interface ViewController ()

@property (nonatomic, strong) NSArray *urls;
@property (nonatomic, strong) NSArray *remarks;
@property (nonatomic, strong) NSMutableArray *imageViews;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _urls = @[@"http://ww4.sinaimg.cn/bmiddle/a15bd3a5jw1f12r9ku6wjj20u00mhn22.jpg",
              @"http://ww2.sinaimg.cn/bmiddle/a15bd3a5jw1f01hkxyjhej20u00jzacj.jpg",
              @"http://ww4.sinaimg.cn/bmiddle/a15bd3a5jw1f01hhs2omoj20u00jzwh9.jpg",
              @"http://ww2.sinaimg.cn/bmiddle/a15bd3a5jw1ey1oyiyut7j20u00mi0vb.jpg",
              @"http://ww2.sinaimg.cn/bmiddle/a15bd3a5jw1exkkw984e3j20u00miacm.jpg",
              @"http://ww4.sinaimg.cn/bmiddle/a15bd3a5jw1ezvdc5dt1pj20ku0kujt7.jpg",
              @"http://ww3.sinaimg.cn/bmiddle/a15bd3a5jw1ew68tajal7j20u011iacr.jpg",
              @"http://ww2.sinaimg.cn/bmiddle/a15bd3a5jw1eupveeuzajj20hs0hs75d.jpg",
              @"http://ww2.sinaimg.cn/bmiddle/d8937438gw1fb69b0hf5fj20hu13fjxj.jpg",
              ];
    _remarks = @[@"试试",
                 @"试试试试试试试试试试试试试试试试试试试试试试试试",
                 @"试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试",
                 @"试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试",
                 @"试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试",
                 @"试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试试",@"",@"",@""
                 ];
    
    
    CGFloat top = 64;
    CGFloat gap = 5;
    NSInteger count = 3;
    CGFloat width = (self.view.frame.size.width - gap * (count + 1)) / count;
    CGFloat height = width;
    _imageViews = @[].mutableCopy;
    for (int i = 0; i < _urls.count; i++) {
        CGFloat x = gap + (width + gap) * (i % count);
        CGFloat y = top + gap + (height + gap) * (i / count);
        CGRect rect = CGRectMake( x, y, width, height);
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:rect];
        imageView.userInteractionEnabled = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [imageView sd_setImageWithURL:[NSURL URLWithString:_urls[i]]];
        imageView.clipsToBounds = YES;
        imageView.tag = i;
        imageView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
        [self.view addSubview:imageView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTapped:)];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
        [imageView addGestureRecognizer:tap];
        [_imageViews addObject:imageView];
    }
    
}

- (void)imageViewTapped:(UITapGestureRecognizer *)tap {
    NSMutableArray *items = [[NSMutableArray alloc] init];
    for (int i = 0; i < _imageViews.count; i++){
        NSString *url = [_urls[i] stringByReplacingOccurrencesOfString:@"bmiddle" withString:@"large"];
        LBPhotoItem *item = [[LBPhotoItem alloc] initWithImageView:_imageViews[i] imgUrl:[NSURL URLWithString:url] placeholdImage:nil];
        item.remark = _remarks[i];
        [items addObject:item];
    }
    
    
    LBPhotoBrowserViewController *lbPBVC = [[LBPhotoBrowserViewController alloc] initWithPhotoItems:items selectedIndex:tap.view.tag];
    [lbPBVC showFromViewController:self];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
