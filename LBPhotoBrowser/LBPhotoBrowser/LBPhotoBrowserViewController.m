//
//  LBPhotoBrowserViewController.m
//  LBPhotoBrowser
//
//  Created by FSLB on 2017/3/6.
//  Copyright © 2017年 FSLB. All rights reserved.
//

#import "LBPhotoBrowserViewController.h"

@interface LBPhotoBrowserViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic, assign)NSInteger selectedIndex;
//
@property (nonatomic, strong) UICollectionView *mCollection;

@end

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@implementation LBPhotoBrowserViewController

- (instancetype)initWithPhotoItems:(NSMutableArray <LBPhotoItem *> *)items selectedIndex:(NSUInteger)selectedIndex{
    self = [super init];
    if(self){
        _items = items;
        _selectedIndex = selectedIndex;
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
    
    LBPhotoItem *item = _items.count > _selectedIndex ? [_items objectAtIndex:_selectedIndex]:[_items objectAtIndex:0];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = CGRectMake(0, 20, 40, 40);
    btn.backgroundColor = [UIColor redColor];
    [btn addTarget:self action:@selector(dismiss:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

#pragma mark - 懒加载
- (UICollectionView *)mCollection{
    if(!_mCollection){
        //确定是水平滚动，还是垂直滚动
        UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        //[flowLayout setItemSize:CGSizeMake(MB_APP_SIZE.width, MB_APP_SIZE.height)];
        
        _mCollection = [[UICollectionView alloc] initWithFrame:CGRectMake(-10, 0, SCREEN_WIDTH+10, SCREEN_HEIGHT) collectionViewLayout:flowLayout];
        _mCollection.delegate= self;
        _mCollection.dataSource = self;
        _mCollection.pagingEnabled = YES;
        _mCollection.backgroundColor = [UIColor blackColor];
        //[_mCollection registerClass:[LBShowPictureCollectionViewCell class] forCellWithReuseIdentifier:@"LBShowPictureCollectionViewCell"];
        
    }
    return _mCollection;
}



#pragma mark - CollectionViewDelegate




#pragma marl - Push And Dismiss
- (void)showFromViewController:(UIViewController *)selfVC{
    [selfVC presentViewController:self animated:YES completion:nil];
}

- (void) dismiss:(UIButton *)btn{
    [self dismissViewControllerAnimated:YES completion:nil];
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
