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

@interface HZShowViewController ()<UITableViewDataSource, UITableViewDelegate, SKStoreProductViewControllerDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<NSArray<HZShowModel *> *> *dataArray;

@end

@implementation HZShowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.title = HZShowLocalizedString("title");
    [self.view addSubview:self.tableView];

    if (isDebug) {
        HLog(@"%@", self.view);
        UIView *copyView = [self.view hz_copy];
        HLog(@"copy:%@", copyView);
    }
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
            
            HLog(@"info:\n%@", info);
            // 发现新版本处理
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:HZAlertLocalizedString("findNewVersion")
                                                                           message:nil
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:HZAlertLocalizedString("cancel")
                                                                   style:UIAlertActionStyleCancel
                                                                 handler:nil];
            UIAlertAction *updateAction = [UIAlertAction actionWithTitle:HZAlertLocalizedString("upgrade")
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

/**
 进入设备模块界面
 */
- (void)pushDeviceAction {
    [[HZMainRouter shared] pushWith:HZDeviceRouterMain
                         fromModule:HZModuleNameDevice
                               args:nil
                         hideTabBar:YES];
}

/**
 进入授权界面
 */
- (void)pushAuthorizationAction {
    [[HZMainRouter shared] pushWith:HZShowRouterAuthorization fromModule:HZModuleNameShow];
}

/**
 进入网络请求界面
 */
- (void)pushNetworkAction {
    [[HZMainRouter shared] pushWith:HZShowRouterNetwork
                         fromModule:HZModuleNameShow
                               args:nil
                         hideTabBar:YES];
}

/**
 显示使用 Iconfont 效果
 */
- (void)pushIconfontAction {
    [[HZMainRouter shared] pushWith:HZShowRouterIconfont
                         fromModule:HZModuleNameShow
                               args:nil
                         hideTabBar:YES];
}

- (void)pushDetailAction {
    [[HZMainRouter shared] pushWith:HZShowRouterDetail
                         fromModule:HZModuleNameShow
                               args:nil
                         hideTabBar:YES];
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

#pragma mark - Lazy load
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
        HZShowModel *checkUpdate = [HZShowModel modelWithGroupName:HZShowLocalizedString("toolsSectionTitle")
                                                             title:HZShowLocalizedString("checkAppUpdateTitle")
                                                          subtitle:HZShowLocalizedString("checkAppUpdateDesc")
                                                            action:@"checkUpdateAction"];
        
        HZShowModel *device = [HZShowModel modelWithGroupName:nil
                                                        title:HZShowLocalizedString("deviceTitle")
                                                     subtitle:HZShowLocalizedString("deviceDesc")
                                                       action:@"pushDeviceAction"];
        
        HZShowModel *authorization = [HZShowModel modelWithGroupName:nil
                                                        title:HZShowLocalizedString("authorizationTitle")
                                                     subtitle:HZShowLocalizedString("authorizationDesc")
                                                       action:@"pushAuthorizationAction"];
        
        HZShowModel *network = [HZShowModel modelWithGroupName:nil
                                                               title:HZShowLocalizedString("networkTitle")
                                                            subtitle:HZShowLocalizedString("networkDesc")
                                                              action:@"pushNetworkAction"];

        NSArray *toolArray = @[checkUpdate, device, authorization, network];
        [_dataArray addObject:toolArray];
        
        // ViewController
        HZShowModel *viewController = [HZShowModel modelWithGroupName:HZShowLocalizedString("viewControllerSectionTitle")
                                                                title:HZShowLocalizedString("viewControllerTitle")
                                                             subtitle:HZShowLocalizedString("viewControllerDesc")
                                                               action:@"pushDetailAction"];
        NSArray *viewControllerArray = @[viewController];
        [_dataArray addObject:viewControllerArray];
        
        // Iconfont
        HZShowModel *iconfont = [HZShowModel modelWithGroupName:HZShowLocalizedString("iconfontSectionTitle")
                                                          title:HZShowLocalizedString("iconfontTitle")
                                                       subtitle:HZShowLocalizedString("iconfontDesc")
                                                         action:@"pushIconfontAction"];
        [_dataArray addObject:@[iconfont]];
    }
    
    return _dataArray;
}

@end
