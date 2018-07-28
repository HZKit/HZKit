//
//  HZCustomControlViewController.m
//  HZKit
//
//  Created by Hertz Wang on 2018/7/28.
//  Copyright © 2018 Hertz Wang. All rights reserved.
//

#import "HZCustomControlViewController.h"
#import "HZCustomControlModel.h"
#import "HZCustomControlCell.h"

NSString *cellIdentifier = @"HZCustomControlCell";

@interface HZCustomControlViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation HZCustomControlViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"自定义控件";
    [self.view addSubview:self.collectionView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action

/**
 滑尺
 */
- (void)showScrollRulerAction {
    // TODO: 尺子显示，使用 Window
    
}

#pragma mark - Collection
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    HZCustomControlCell *cell = (HZCustomControlCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    HZCustomControlModel *model = self.dataArray[indexPath.row];
    [cell setModel:model];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    HZCustomControlModel *model = self.dataArray[indexPath.row];
    if (model.action) {
        SEL selector = NSSelectorFromString(model.action);
        if ([self respondsToSelector:selector]) {
            objc_msgSend(self, selector);
        }
    }
}

#pragma mark - Lazy load
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
        CGFloat screenWidth = CGRectGetWidth(self.view.bounds);
        CGFloat padding = 15;
        layout.itemSize = CGSizeMake((screenWidth - padding * 3) * 0.5, 80);
        layout.sectionInset = UIEdgeInsetsMake(padding, padding, 0, padding);
        
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds
                                                              collectionViewLayout:layout];
        collectionView.dataSource = self;
        collectionView.delegate = self;
        collectionView.backgroundColor = [UIColor clearColor];
        
        [collectionView registerClass:[HZCustomControlCell class] forCellWithReuseIdentifier:cellIdentifier];
        
        _collectionView = collectionView;
    }
    
    return _collectionView;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray arrayWithObjects:
                      [HZCustomControlModel modelWithIcon:@"Scroll Ruler" action:@"showScrollRulerAction"],
                      [HZCustomControlModel modelWithIcon:@"Placeholder" action:nil],
                      [HZCustomControlModel modelWithIcon:@"Placeholder" action:nil],
                      [HZCustomControlModel modelWithIcon:@"Placeholder" action:nil],
                      nil];
        
        
    }
    
    return _dataArray;
}

@end
