//
//  LBPhotoBrowserViewController.m
//  LBPhotoBrowser
//
//  Created by FSLB on 2017/3/6.
//  Copyright © 2017年 FSLB. All rights reserved.
//

#import "LBPhotoBrowserViewController.h"
#import "LBPhotoCollectionViewCell.h"
#import "LBPhotoView.h"

@interface LBPhotoBrowserViewController ()<UIScrollViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic, assign)NSInteger selectedIndex;
@property (nonatomic, strong) UICollectionView *mCollectionView;
@property (nonatomic, strong) UIImageView *backgroundView;
@property (nonatomic, strong) UILabel *pageLabel;

@end

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@implementation LBPhotoBrowserViewController{
    CGPoint _startLocation;
}

- (instancetype)initWithPhotoItems:(NSMutableArray <LBPhotoItem *> *)items selectedIndex:(NSUInteger)selectedIndex{
    self = [super init];
    if(self){
        _items = items;
        _selectedIndex = selectedIndex;
        
        self.modalPresentationStyle = UIModalPresentationCustom;
        self.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    }
    return self;
}

- (instancetype)initWithPhotoItems:(NSMutableArray <LBPhotoItem *> *)items{
    self = [super init];
    if(self){
        _items = items;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    LBPhotoItem *item = [_items objectAtIndex:_selectedIndex];
//    LBPhotoView *photoView = [self getCurrentItemView];
//    
//    CGRect endRect = photoView.mImageView.frame;
//    CGRect sourceRect;
//    float systemVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
//    if (systemVersion >= 8.0 && systemVersion < 9.0) {
//        sourceRect = [item.mImageView.superview convertRect:item.mImageView.frame toCoordinateSpace:photoView];
//    } else {
//        sourceRect = [item.mImageView.superview convertRect:item.mImageView.frame toView:photoView];
//    }
//    photoView.mImageView.frame = sourceRect;
//    
//    [UIView animateWithDuration:0.3 animations:^{
//        photoView.mImageView.frame = endRect;
//        self.view.backgroundColor = [UIColor blackColor];
//        _backgroundView.alpha = 1;
//    } completion:^(BOOL finished) {
//        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
//    }];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    
    _backgroundView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    _backgroundView.contentMode = UIViewContentModeScaleAspectFill;
    _backgroundView.backgroundColor = [UIColor blackColor];
    _backgroundView.alpha = 1;
    [self.view addSubview:_backgroundView];
    
    [self.view addSubview:self.mCollectionView];
    [self.mCollectionView setContentOffset:CGPointMake(_mCollectionView.bounds.size.width * _selectedIndex, 0) animated:NO];
    
    _pageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height-40, self.view.bounds.size.width, 20)];
    _pageLabel.textColor = [UIColor whiteColor];
    _pageLabel.font = [UIFont systemFontOfSize:16];
    _pageLabel.textAlignment = NSTextAlignmentCenter;
    [self scrollViewDidScroll:_mCollectionView];
    [self.view addSubview:_pageLabel];
    
    
    //[self addBackBtn];
    [self addGestureRecognizer];
}

#pragma mark - 懒加载

- (UICollectionView *)mCollectionView{
    if(!_mCollectionView){
        //确定是水平滚动，还是垂直滚动
        UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        //[flowLayout setItemSize:CGSizeMake(MB_APP_SIZE.width, MB_APP_SIZE.height)];
        
        _mCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(-10, 0, SCREEN_WIDTH+10, SCREEN_HEIGHT) collectionViewLayout:flowLayout];
        _mCollectionView.delegate= self;
        _mCollectionView.dataSource = self;
        _mCollectionView.pagingEnabled = YES;
        _mCollectionView.backgroundColor = [UIColor clearColor];
        [_mCollectionView registerClass:[LBPhotoCollectionViewCell class] forCellWithReuseIdentifier:@"LBPhotoCollectionViewCell"];
        
    }
    return _mCollectionView;
}


#pragma mark - CollectionViewDelegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _items.count;
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"LBPhotoCollectionViewCell";
    LBPhotoCollectionViewCell * cell = (LBPhotoCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.photoItem = _items[indexPath.row];
    return cell;
}
#pragma mark --UICollectionViewDelegateFlowLayout

//定义每个Item 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
}

//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0 ,10, 0, 0);
}

#pragma mark - scrollerViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSInteger page = _mCollectionView.contentOffset.x / _mCollectionView.frame.size.width + 0.5;
    if(page < 0 || page >= _items.count){
        return;
    }
    _selectedIndex = page;
    _pageLabel.text = [NSString stringWithFormat:@"%ld / %ld", _selectedIndex + 1, _items.count];
    
}

#pragma mark - GesTure

- (void)addGestureRecognizer {
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didDoubleTap:)];
    doubleTap.numberOfTapsRequired = 2;
    [self.view addGestureRecognizer:doubleTap];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didSingleTap:)];
    singleTap.numberOfTapsRequired = 1;
    [singleTap requireGestureRecognizerToFail:doubleTap];
    [self.view addGestureRecognizer:singleTap];
    
//    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(didLongPress:)];
//    [self.view addGestureRecognizer:longPress];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didPan:)];
    [self.view addGestureRecognizer:pan];
}

//双击
- (void)didDoubleTap:(UITapGestureRecognizer *)tap {
    LBPhotoView *photoView = [self getCurrentItemView];
    
    if (photoView.zoomScale > 1) {
        [photoView setZoomScale:1 animated:YES];
    } else {
        CGPoint location = [tap locationInView:self.view];
        CGFloat maxZoomScale = photoView.maximumZoomScale;
        CGFloat width = self.view.bounds.size.width / maxZoomScale;
        CGFloat height = self.view.bounds.size.height / maxZoomScale;
        [photoView zoomToRect:CGRectMake(location.x - width/2, location.y - height/2, width, height) animated:YES];
    }
}

//单击
- (void)didSingleTap:(UITapGestureRecognizer *)tap {
    [self dismiss:nil];
}

//长按
//- (void)didLongPress:(UILongPressGestureRecognizer *)longPress {
//    if (longPress.state != UIGestureRecognizerStateBegan) {
//        return;
//    }
//    LBPhotoView *photoView = [self getCurrentItemView];
//    UIImage *image = photoView.mImageView.image;
//    if (!image) {
//        return;
//    }
//    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[image] applicationActivities:nil];
//    [self presentViewController:activityViewController animated:YES completion:nil];
//}

//拖动
- (void)didPan:(UIPanGestureRecognizer *)pan {
    LBPhotoView *photoView = [self getCurrentItemView];
    if (photoView.zoomScale > 1.1) {
        return;
    }
        CGPoint point = [pan translationInView:self.view];
        CGPoint location = [pan locationInView:self.view];
        CGPoint velocity = [pan velocityInView:self.view];
        switch (pan.state) {
            case UIGestureRecognizerStateBegan:
                _startLocation = location;
                [self handlePanBegin];
                break;
            case UIGestureRecognizerStateChanged: {
                double percent = 1 - fabs(point.y)/(self.view.frame.size.height/2);
                NSLog(@"%lf",percent);
                percent = MAX(percent, 0);
                double s = MAX(percent, 0.5);
                CGAffineTransform translation = CGAffineTransformMakeTranslation(point.x/s, point.y/s);
                CGAffineTransform scale = CGAffineTransformMakeScale(s, s);
                photoView.mImageView.transform = CGAffineTransformConcat(translation, scale);
                _backgroundView.alpha = percent;
            }
                break;
            case UIGestureRecognizerStateEnded:
            case UIGestureRecognizerStateCancelled: {
                if (fabs(point.y) > 100 || fabs(velocity.y) > 500) {
                    [self showDismissalAnimation];
                } else {
                    [self showCancellationAnimation];
                }
            }
                break;
                
            default:
                break;
        }
}

//拖动之前处理
- (void)handlePanBegin {
    LBPhotoItem *item = [_items objectAtIndex:_selectedIndex];
    [UIApplication sharedApplication].statusBarHidden = NO;
    item.mImageView.alpha = 0;
}

//拖动之后返回处理
- (void)showDismissalAnimation {
    LBPhotoItem *item = [_items objectAtIndex:_selectedIndex];
    LBPhotoView *photoView = [self getCurrentItemView];
    [UIApplication sharedApplication].statusBarHidden = NO;
    item.mImageView.alpha = 0;
    CGRect sourceRect;
    float systemVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (systemVersion >= 8.0 && systemVersion < 9.0) {
        sourceRect = [item.mImageView.superview convertRect:item.mImageView.frame toCoordinateSpace:photoView];
    } else {
        sourceRect = [item.mImageView.superview convertRect:item.mImageView.frame toView:photoView];
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        photoView.mImageView.frame = sourceRect;
        _backgroundView.alpha = 0;
    } completion:^(BOOL finished) {
        [self dismissWithAnimated:NO];
    }];
    
}

//拖动之后取消
- (void)showCancellationAnimation {
    LBPhotoView *photoView = [self getCurrentItemView];
    LBPhotoItem *item = [_items objectAtIndex:_selectedIndex];
    
    [UIView animateWithDuration:0.3f animations:^{
        photoView.mImageView.transform = CGAffineTransformIdentity;
        _backgroundView.alpha = 1;
    } completion:^(BOOL finished) {
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
        item.mImageView.alpha = 1;
    }];
    
}

#pragma marl - Push And Dismiss
- (void)showFromViewController:(UIViewController *)selfVC{
    [selfVC presentViewController:self animated:YES completion:nil];
}

- (void) addBackBtn{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = CGRectMake(0, 20, 40, 40);
    btn.backgroundColor = [UIColor redColor];
    [btn addTarget:self action:@selector(dismiss:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void) dismissWithAnimated:(BOOL)animated{
    [self dismissViewControllerAnimated:animated completion:nil];
    
    LBPhotoItem *item = [_items objectAtIndex:_selectedIndex];
    if (animated) {
        [UIView animateWithDuration:0.3 animations:^{
            item.mImageView.alpha = 1;
        }];
    } else {
        item.mImageView.alpha = 1;
    }
}

- (void) dismiss:(UIButton *)btn{
    [self dismissWithAnimated:YES];
}


- (LBPhotoView *) getCurrentItemView{
    LBPhotoCollectionViewCell *cell = [[self.mCollectionView visibleCells] lastObject];
    return cell.photoView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
