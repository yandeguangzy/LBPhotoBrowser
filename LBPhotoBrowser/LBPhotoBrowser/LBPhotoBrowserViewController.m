//
//  LBPhotoBrowserViewController.m
//  LBPhotoBrowser
//
//  Created by FSLB on 2017/3/6.
//  Copyright © 2017年 FSLB. All rights reserved.
//

#import "LBPhotoBrowserViewController.h"
#import "LBPhotoCollectionViewCell.h"
#import "LBPhotoBrowserRemarkView.h"
#import "LBPhotoView.h"

@interface LBPhotoBrowserViewController ()<UIScrollViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
/** navgationView */
@property (nonatomic, strong)UIView *navgationView;


@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, strong) UICollectionView *mCollectionView;
@property (nonatomic, strong) UIImageView *backgroundView;

@property (nonatomic, strong) LBPhotoBrowserRemarkView *remarkScrollView;

/** 手势 */
@property (nonatomic, strong)UITapGestureRecognizer *doubleTap;
@property (nonatomic, strong)UITapGestureRecognizer *singleTap;
@property (nonatomic, strong)UIPanGestureRecognizer *pan;

@property (nonatomic, strong)UIButton *disPlayModelBtn;

@end

@implementation LBPhotoBrowserViewController{
    CGPoint _startLocation;
    
    CGPoint _oldContentOffset;
}

- (instancetype)initWithPhotoItems:(NSMutableArray <LBPhotoItem *> *)items selectedIndex:(NSUInteger)selectedIndex{
    self = [super init];
    if(self){
        _items = items;
        _selectedIndex = selectedIndex;
        _displayMode = KSPhotoBrowserImageFullScreen;
        
        self.modalPresentationStyle = UIModalPresentationCustom;
        self.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
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
    
    [self addGestureRecognizer];
    
    _backgroundView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    _backgroundView.contentMode = UIViewContentModeScaleAspectFill;
    _backgroundView.backgroundColor = [UIColor blackColor];
    _backgroundView.alpha = 1;
    _backgroundView.userInteractionEnabled = YES;
    [self.view addSubview:_backgroundView];
    
    [self.view addSubview:self.mCollectionView];
    [self.mCollectionView setContentOffset:CGPointMake(_mCollectionView.bounds.size.width * _selectedIndex, 0) animated:NO];
    
    [self.view addSubview:self.navgationView];
    [self.view addSubview:self.remarkScrollView];
    
    [self scrollViewDidScroll:_mCollectionView];
    [self scrollViewDidEndDecelerating:_mCollectionView];
}

#pragma mark - 懒加载
- (UIView *)navgationView{
    if(!_navgationView){
        _navgationView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 44)];
        _navgationView.backgroundColor = [UIColor clearColor];//[UIColor colorWithWhite:0 alpha:0.6];
        [_navgationView addSubview:self.backBtn];
        [_navgationView addSubview:self.pageLabel];
        [_navgationView addSubview:self.disPlayModelBtn];
    }
    return _navgationView;
}

- (UICollectionView *)mCollectionView{
    if(!_mCollectionView){
        _mCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(-10, 0, SCREEN_WIDTH+10, SCREEN_HEIGHT) collectionViewLayout:self.flowLayout];
        _mCollectionView.delegate= self;
        _mCollectionView.dataSource = self;
        _mCollectionView.pagingEnabled = YES;
        _mCollectionView.backgroundColor = [UIColor clearColor];
        [_mCollectionView registerClass:[LBPhotoCollectionViewCell class] forCellWithReuseIdentifier:@"LBPhotoCollectionViewCell"];
        
    }
    return _mCollectionView;
}

- (UICollectionViewFlowLayout *)flowLayout{
    if(!_flowLayout){
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        //确定是水平滚动，还是垂直滚动
        [_flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
         //[flowLayout setItemSize:CGSizeMake(MB_APP_SIZE.width, MB_APP_SIZE.height)];
    }
    return _flowLayout;
}
//返回按钮
- (UIButton *)backBtn {
    if(!_backBtn){
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _backBtn.frame = CGRectMake(30, 5, 25, 25);
        _backBtn.backgroundColor = [UIColor clearColor];
        NSBundle *bundle = [NSBundle bundleForClass:NSClassFromString(@"LBPhotoBrowserViewController")];
        NSString *bundlePath = [bundle pathForResource:@"LBPhotoBrowser" ofType:@"bundle"];
        [_backBtn setBackgroundImage:[[UIImage alloc]initWithContentsOfFile:[bundlePath stringByAppendingPathComponent:@"LBPhotoBrowser_close.png"]] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(dismiss:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

//页数
- (UILabel *) pageLabel{
    if(!_pageLabel){
        _pageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
        _pageLabel.textAlignment = NSTextAlignmentCenter;
        _pageLabel.textColor = [UIColor whiteColor];
        _pageLabel.font = [UIFont systemFontOfSize:16];
        _pageLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _pageLabel;
}

//显示模式按钮
- (UIButton *)disPlayModelBtn{
    if(!_displayMode){
        _disPlayModelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _disPlayModelBtn.frame = CGRectMake(SCREEN_WIDTH - 64, 5, 34, 34);
        _disPlayModelBtn.backgroundColor = [UIColor clearColor];
        NSBundle *bundle = [NSBundle bundleForClass:NSClassFromString(@"LBPhotoBrowserViewController")];
        NSString *bundlePath = [bundle pathForResource:@"LBPhotoBrowser" ofType:@"bundle"];
        [_disPlayModelBtn setBackgroundImage:[[UIImage alloc]initWithContentsOfFile:[bundlePath stringByAppendingPathComponent:@"LBPhotoBrowser_small.png"]] forState:UIControlStateNormal];
        [_disPlayModelBtn setBackgroundImage:[[UIImage alloc]initWithContentsOfFile:[bundlePath stringByAppendingPathComponent:@"LBPhotoBrowser_full.png"]] forState:UIControlStateSelected];
        [_disPlayModelBtn addTarget:self action:@selector(switchDisplayMode:) forControlEvents:UIControlEventTouchUpInside];
        _disPlayModelBtn.selected = NO;//NO为全屏展示  YES为预览模式
    }
    return _disPlayModelBtn;
}

//备注信息背景视图
- (LBPhotoBrowserRemarkView *)remarkScrollView{
    if(!_remarkScrollView){
        _remarkScrollView = [[LBPhotoBrowserRemarkView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT/2, SCREEN_WIDTH, SCREEN_HEIGHT/2)];
    }
    return _remarkScrollView;
}

#pragma mark - set方法
- (void) setRemarkViewEnable:(BOOL)remarkViewEnable{
    _remarkViewEnable = remarkViewEnable;
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
    [cell setDisplayModel:_displayMode photoItem:_items[indexPath.row]];
    return cell;
}

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self collectionSelectedItem:indexPath.row];
}

#pragma mark --UICollectionViewDelegateFlowLayout

//定义每个Item 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(_displayMode == KSPhotoBrowserImageFullScreen){
        return CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
    }else{
        return CGSizeMake((SCREEN_WIDTH - 22)/3, (SCREEN_WIDTH - 13)/3);
    }
}

//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if(_displayMode == KSPhotoBrowserImageFullScreen){
        return UIEdgeInsetsMake(0 ,10, 0, 0);
    }else{
        return UIEdgeInsetsMake(0 ,1, 1, 1);
    }
    
}

#pragma mark - scrollerViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(_displayMode == KSPhotoBrowserImagePreview){
        _oldContentOffset = scrollView.contentOffset;
    }
    
    NSInteger page = _mCollectionView.contentOffset.x / _mCollectionView.frame.size.width + 0.5;
    if(page < 0 || page >= _items.count){
        return;
    }
    _selectedIndex = page;
    _pageLabel.text = [NSString stringWithFormat:@"%ld / %ld", (long)(_selectedIndex + 1), (long)_items.count];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger page = _mCollectionView.contentOffset.x / _mCollectionView.frame.size.width;
    if(_displayMode == KSPhotoBrowserImageFullScreen){
        LBPhotoItem *item = _items[page];
        [self.remarkScrollView updateWithTitle:nil content:item.remark];
    }
}

#pragma mark - Gesture

- (void)addGestureRecognizer {
    _doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didDoubleTap:)];
    _doubleTap.numberOfTapsRequired = 2;
    [self.view addGestureRecognizer:_doubleTap];
    
    _singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didSingleTap:)];
    _singleTap.numberOfTapsRequired = 1;
    [_singleTap requireGestureRecognizerToFail:_doubleTap];
    [self.view addGestureRecognizer:_singleTap];
    
//    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(didLongPress:)];
//    [self.view addGestureRecognizer:longPress];
    
    _pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didPan:)];
    [self.view addGestureRecognizer:_pan];
}

- (void) removeGestureRecognizer{
    [self.view removeGestureRecognizer:_doubleTap];
    [self.view removeGestureRecognizer:_singleTap];
    [self.view removeGestureRecognizer:_pan];
}

//双击
- (void)didDoubleTap:(UITapGestureRecognizer *)tap {
    if(_displayMode == KSPhotoBrowserImagePreview){
        return;
    }
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
    if(_displayMode == KSPhotoBrowserImageFullScreen){
        if(self.navgationView.hidden){
            self.navgationView.hidden = NO;
            self.remarkScrollView.hidden = (_remarkViewEnable&&self.remarkScrollView.isEnable)?NO:YES;
            [UIView animateWithDuration:0.2 animations:^{
                self.navgationView.alpha = 1;
                self.remarkScrollView.alpha = 1;
            } completion:^(BOOL finished) {
                [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
            }];
        }else{
            [UIView animateWithDuration:0.2 animations:^{
                self.navgationView.alpha = 0;
                self.remarkScrollView.alpha = 0;
            } completion:^(BOOL finished) {
                self.navgationView.hidden = YES;
                self.remarkScrollView.hidden = YES;
                [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
            }];
        }
    }
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
    if(_displayMode == KSPhotoBrowserImagePreview){
        return;
    }
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
                percent = MAX(percent, 0);
                double s = MAX(percent, 0.5);
                CGAffineTransform translation = CGAffineTransformMakeTranslation(point.x/s, point.y/s);
                CGAffineTransform scale = CGAffineTransformMakeScale(s, s);
                photoView.mImageView.transform = CGAffineTransformConcat(translation, scale);
                _backgroundView.alpha = percent - 0.6;
                _remarkScrollView.alpha = percent - 0.6;
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
        _remarkScrollView.alpha = 0;
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
        _remarkScrollView.alpha = 1;
    } completion:^(BOOL finished) {
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
        item.mImageView.alpha = 1;
    }];
    
}

#pragma mark - Push And Dismiss  switchDisplayMode
- (void)showFromViewController:(UIViewController *)selfVC{
    [selfVC presentViewController:self animated:YES completion:nil];
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

- (void)switchDisplayMode:(UIButton *)btn{
    if(_displayMode == KSPhotoBrowserImageFullScreen){
        [UIApplication sharedApplication].statusBarHidden = YES;
        _displayMode = KSPhotoBrowserImagePreview;
        _pageLabel.hidden = YES;
        _remarkScrollView.hidden = YES;
        btn.selected = YES;
        _mCollectionView.pagingEnabled = NO;
        [self removeGestureRecognizer];
    }else{
        [UIApplication sharedApplication].statusBarHidden = NO;
        _displayMode = KSPhotoBrowserImageFullScreen;
        _pageLabel.hidden = NO;
        _remarkScrollView.hidden = NO;
        btn.selected = NO;
        _mCollectionView.pagingEnabled = YES;
        [self addGestureRecognizer];
    }
    [self changgeCollectionViewFrame];
    [self collectionReloadData];
}

- (void)collectionSelectedItem:(NSInteger)index{
    [self switchDisplayMode:_disPlayModelBtn];
    [self.mCollectionView setContentOffset:CGPointMake(_mCollectionView.bounds.size.width * index, 0) animated:NO];
    [self scrollViewDidEndDecelerating:_mCollectionView];
}

- (void) collectionReloadData{
    if(_displayMode == KSPhotoBrowserImageFullScreen){
        [self.flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    }else{
        [self.flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    }
    [self.mCollectionView reloadData];
}

- (void)changgeCollectionViewFrame{
    if(_displayMode == KSPhotoBrowserImageFullScreen){
        [UIView animateWithDuration:0 animations:^{
            self.mCollectionView.frame = CGRectMake(-10, 0, SCREEN_WIDTH+10, SCREEN_HEIGHT);
        }];
    }else{
        [UIView animateWithDuration:0 animations:^{
            self.mCollectionView.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
        }];
    }
    
    if(_displayMode == KSPhotoBrowserImagePreview){
        [self.mCollectionView setContentOffset:_oldContentOffset animated:NO];
    }
    [self scrollViewDidEndDecelerating:_mCollectionView];
}


- (void) dismiss:(UIButton *)btn{
    [self dismissWithAnimated:YES];
}


- (LBPhotoView *) getCurrentItemView{
    LBPhotoCollectionViewCell *cell = [[self.mCollectionView visibleCells] lastObject];
    return cell.photoView;
}

#pragma mark - 外部方法



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
