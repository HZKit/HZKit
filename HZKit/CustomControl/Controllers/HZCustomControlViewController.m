//
//  HZCustomControlViewController.m
//  HZKit
//
//  Created by Hertz Wang on 2018/7/28.
//  Copyright © 2018 Hertz Wang. All rights reserved.
//

#import "HZCustomControlViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "HZCustomControlModel.h"
#import "HZCustomControlCell.h"
#import "HZScanViewController.h"
#import "HZBankModel.h"

NSString *cellIdentifier = @"HZCustomControlCell";

@interface HZCustomControlViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, HZScanViewControllerDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation HZCustomControlViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = HZCCLocalizedString("title");
    [self.view addSubview:self.collectionView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action
- (void)scanQRCodeAction {

    CGPoint origin = self.view.center;
    CGFloat areaWidth = 200;
    CGFloat areaHeight = 200;
    
    CGRect scanArea = CGRectMake(origin.x - areaWidth * 0.5,
                           origin.y - areaHeight * 0.5,
                           areaWidth, areaHeight);
    
    HZScanViewController *scanVC = [HZScanViewController scanViewWithArea:scanArea completion:^(NSString *stringValue) {
        HLog(@"stringValueBlock: %@", stringValue);
    }];
    scanVC.delegate = self;
    
    [self.navigationController pushViewController:scanVC animated:YES];
}

- (void)generateBankDB {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"bank" ofType:@"plist"];
    if (!path) {
        return;
    }
    
    NSArray *bankArray = [NSArray arrayWithContentsOfFile:path];
    for (NSDictionary *bank in bankArray) {
        HZBankModel *model = [[HZBankModel alloc] initWithDictionary:bank];
//        [model insertData:[model toDictionary] atTable:@"bank"];
        [model insert];
    }
}

#pragma mark - HZScanViewControllerDelegate
- (void)scanViewController:(HZScanViewController *)scanViewController stringValue:(NSString *)stringValue {
    HLog(@"delegate: %@", stringValue);
    HZShowHUD(stringValue);
    
    [scanViewController.navigationController popViewControllerAnimated:YES];
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
        
        return;
    }
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    view.backgroundColor = [UIColor blueColor];
    
    HZAlertView *alert = [HZAlertView alertWithView:view];
    alert.tapDismiss = YES;
    [alert show];
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
                      [HZCustomControlModel modelWithIcon:@"Scan QRCode" action:@"scanQRCodeAction"],
                      [HZCustomControlModel modelWithIcon:@"generateBankDB" action:@"generateBankDB"],
                      [HZCustomControlModel modelWithIcon:@"Placeholder" action:nil],
                      [HZCustomControlModel modelWithIcon:@"Placeholder" action:nil],
                      nil];
        
        
    }
    
    return _dataArray;
}

@end
