//
//  HZShowIconfontViewController.m
//  HZKit
//
//  Created by HertzWang on 2018/8/1.
//  Copyright © 2018年 Hertz Wang. All rights reserved.
//

#import "HZShowIconfontViewController.h"
#import "HZShowIconfontCell.h"

NSString *kHZShowIconfontCellId = @"HZShowIconfontCell";

@interface HZShowIconfontViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *iconfontView;
@property (nonatomic, strong) NSMutableArray<HZFontelloGlyphModel *> *glyphs;
@property (nonatomic, strong) NSArray<UIColor *> *radomColors;

@end

@implementation HZShowIconfontViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"Iconfont";
    [self.view addSubview:self.iconfontView];
}

#pragma mark - UICollectionViewDataSource,UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.glyphs.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    HZShowIconfontCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kHZShowIconfontCellId forIndexPath:indexPath];
    
    HZFontelloGlyphModel *model = self.glyphs[indexPath.row];
    [cell setModel:model];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    HZShowIconfontCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kHZShowIconfontCellId forIndexPath:indexPath];
    [cell updateIconColor:self.radomColors[arc4random_uniform((uint32_t)(self.radomColors.count - 1))]];
}

#pragma mark - Lazy load
- (UICollectionView *)iconfontView {
    if (!_iconfontView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        CGFloat padding = 15;
        flowLayout.sectionInset = UIEdgeInsetsMake(padding, padding, 0, padding);
        
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
        collectionView.dataSource = self;
        collectionView.delegate = self;
        collectionView.backgroundColor = nil;
        
        [collectionView registerClass:[HZShowIconfontCell class] forCellWithReuseIdentifier:kHZShowIconfontCellId];
        
        _iconfontView = collectionView;
    }
    
    return _iconfontView;
}

- (NSMutableArray<HZFontelloGlyphModel *> *)glyphs {
    if (!_glyphs) {
        HZFontelloModel *model = [HZIconfont modelWithConfigJsonName:@"fontelloConfig.json"]; // 解析 config.json
        if (model) {
            _glyphs = [NSMutableArray arrayWithArray:model.glyphs];
        } else {
            _glyphs = [NSMutableArray array];
        }
    }
    
    return _glyphs;
}

- (NSArray<UIColor *> *)radomColors {
    if (!_radomColors) {
        _radomColors = @[
                         [UIColor blackColor],
                         [UIColor redColor],
                         [UIColor greenColor],
                         [UIColor blueColor],
                         [UIColor orangeColor],
                         [UIColor yellowColor]
                         ];
    }
    
    return _radomColors;
}

@end
