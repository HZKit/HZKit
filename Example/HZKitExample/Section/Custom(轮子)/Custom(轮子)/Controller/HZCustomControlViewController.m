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
#import "HZGenerateIconViewController.h"
#import "HZBankModel.h"
#import "HZImagePicker.h"

NSString *cellIdentifier = @"HZCustomControlCell";

@interface HZCustomControlViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, HZScanViewControllerDelegate, HZImagePickerDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) HZImagePicker *imagePicker;

@end

@implementation HZCustomControlViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"轮子";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
}


#pragma mark - Private

/// 扫描二维码
- (void)_scanQRCodeAction {
    if (![UIImagePickerController availableCaptureModesForCameraDevice:UIImagePickerControllerCameraDeviceRear]) {
        HZShowHUD(@"设备不支持");
        return;
    }
    
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

/// 生成银行卡发卡行数据库
- (void)_generateBankDB {
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

/// 生成Icon
- (void)_generateIconAction {
    HZGenerateIconViewController *vc = [[HZGenerateIconViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)_imagePickerAction {
    [self.imagePicker show];
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
            ((void (*)(id, SEL))objc_msgSend)(self, selector);
        }
        
        return;
    }
}

#pragma mark - HZImagePickerDelegate

- (void)imagePicker:(HZImagePicker *)picker didFinishPicking:(NSArray<UIImage *> *)results videoPath:(NSString *)videoPath {
    
}

- (void)imagePickerDidCancel:(HZImagePicker *)picker {
    
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

- (HZImagePicker *)imagePicker {
    if (_imagePicker == nil) {
        _imagePicker = [[HZImagePicker alloc] init];
        _imagePicker.delegate = self;
    }
    return _imagePicker;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray arrayWithObjects:
                      [HZCustomControlModel modelWithIcon:@"扫一扫" action:@"_scanQRCodeAction"],
                      [HZCustomControlModel modelWithIcon:@"生成银行卡发卡行数据库" action:@"_generateBankDB"],
                      [HZCustomControlModel modelWithIcon:@"生成 Icon" action:@"_generateIconAction"],
                      [HZCustomControlModel modelWithIcon:@"图片选择" action:@"_imagePickerAction"],
                      nil];
    }
    
    return _dataArray;
}

@end
