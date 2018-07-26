//
//  HZShowViewController.m
//  HZKit
//
//  Created by HertzWang on 2018/7/25.
//  Copyright © 2018年 Hertz Wang. All rights reserved.
//

#import "HZShowViewController.h"
#import "HZShowModel.h"
#import <StoreKit/StoreKit.h>
#import <objc/message.h>

@interface HZShowViewController ()<UITableViewDataSource, UITableViewDelegate, SKStoreProductViewControllerDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<NSArray<HZShowModel *> *> *dataArray;

@end

@implementation HZShowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"功能列表";
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:self.tableView];
    
#if DEBUG
    NSLog(@"%@", self.view);
    UIView *copyView = [self.view hzCopy];
    NSLog(@"copy:%@", copyView);
    
    NSString *deviceId = [[UIDevice currentDevice] hz_deviceIdentifier];
    NSLog(@"device id:%@", deviceId);
#endif
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action

/**
 校验应用版本：使用 HZKit 的 HZVersionManager
 */
- (void)checkUpdateAction {
    
    NSString *appId = @"414478124"; // 使用时修改App Id
    [HZVersionManager checkAppUpdateWithAppId:appId complete:^(BOOL isFindNew, id info) {
        if (isFindNew) {
            if (DEBUG) {
                NSLog(@"info:\n%@", info);
            }
            // 发现新版本处理
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"发现新版本"
                                                                           message:nil
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消"
                                                                   style:UIAlertActionStyleCancel
                                                                 handler:nil];
            UIAlertAction *updateAction = [UIAlertAction actionWithTitle:@"更新"
                                                                   style:UIAlertActionStyleDefault
                                                                 handler:^(UIAlertAction * _Nonnull action) {
                                                                     
                                                                     // 方式一
                                                                     NSURL *itmsAppsURL = [NSURL URLWithString:[NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@",appId]];
                                                                     
                                                                     if ([[UIApplication sharedApplication] canOpenURL:itmsAppsURL]) {
                                                                         if (@available(iOS 10.0, *)) {
                                                                             [[UIApplication sharedApplication] openURL:itmsAppsURL
                                                                                                                options:@{}
                                                                                                      completionHandler:nil];
                                                                         } else {
                                                                             // Fallback on earlier versions
                                                                             [[UIApplication sharedApplication] openURL:itmsAppsURL];
                                                                         }
                                                                         
                                                                         return;
                                                                     }
                                                                     
                                                                     // 方式二
                                                                     NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://itunes.apple.com/in/app/id%@",appId]];
                                                                     
                                                                     if ([[UIApplication sharedApplication] canOpenURL:url]) {
                                                                         if (@available(iOS 10.0, *)) {
                                                                             [[UIApplication sharedApplication] openURL:url
                                                                                                                options:@{}
                                                                                                      completionHandler:nil];
                                                                         } else {
                                                                             // Fallback on earlier versions
                                                                             [[UIApplication sharedApplication] openURL:url];
                                                                         }
                                                                         
                                                                         return;
                                                                     }
                                                                     
                                                                     // 方式三：需要 import SKStore，并遵守 SKStoreProductViewControllerDelegate
//                                                                     SKStoreProductViewController


            }];
            
            [alert addAction:cancelAction];
            [alert addAction:updateAction];
            
            [self presentViewController:alert animated:YES completion:nil];
        }
    }];
}

#pragma mark - Table

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray[section].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"HZShowCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    HZShowModel *model = self.dataArray[indexPath.section][indexPath.row];
    if (model.title) {
        cell.textLabel.text = model.title;
    }
    
    if (model.subtitle) {
        cell.detailTextLabel.text = model.subtitle;
    }

    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    static NSString *headerIdentifier = @"HZShowHeaderIdenfitier";
    UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerIdentifier];
    
    if (!headerView) {
        headerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:headerIdentifier];
    }
    
    HZShowModel *model = self.dataArray[section].firstObject;
    if (model.groupName) {
        headerView.textLabel.text = model.groupName;
    }
    
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    HZShowModel *model = self.dataArray[indexPath.section][indexPath.row];
    if (model.action) {
        
        SEL selector = NSSelectorFromString(model.action);
        // 方式一：warn PerformSelector may cause a leak because its selector is unknown
//        if ([self respondsToSelector:selector]) {
//            [self performSelector:selector];
//        }
        
        // 方式二
        if ([self respondsToSelector:selector]) {
            objc_msgSend(self, selector);
        }
        
        // 方式三
//        IMP imp = [self methodForSelector:selector];
//        void (*func)(id, SEL) = (void *)imp;
//        func(self, selector);
    }
    
//    [[HZMainRouter shared] pushWith:HZShowRouterDetail fromModule:HZModuleNameShow args:nil hideTabBar:YES];
}

#pragma mark - Navigation
- (UITableView *)tableView {
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
        tableView.dataSource = self;
        tableView.delegate = self;
        
        _tableView = tableView;
    }
    
    return _tableView;
}

- (NSMutableArray<NSArray<HZShowModel *> *> *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
        // Category、常用工具、自定义控件
        HZShowModel *checkUpdate = [HZShowModel modelWithGroupName:@"常用工具" title:@"校验应用版本" subtitle:@"使用时需要修改App id" action:@"checkUpdateAction"];
        NSArray *toolArray = @[checkUpdate];
        [_dataArray addObject:toolArray];
    }
    
    return _dataArray;
}

@end
