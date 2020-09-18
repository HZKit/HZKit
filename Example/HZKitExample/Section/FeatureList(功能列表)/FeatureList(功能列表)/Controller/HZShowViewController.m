//
//  HZShowViewController.m
//  HZKit
//
//  Created by HertzWang on 2018/7/25.
//  Copyright © 2018年 Hertz Wang. All rights reserved.
//

#import "HZShowViewController.h"

#import "HZShowViewController+Property.h"
#import "HZShowViewController+Delegate.h"

@implementation HZShowViewController

@synthesize tableView = _tableView;
@synthesize dataArray = _dataArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"功能列表";
    [self.view addSubview:self.tableView];
}

#pragma mark - Private

/// 校验应用版本：使用 HZKit 的 HZVersionManager
- (void)_checkUpdateAction {
    NSString *appId = @"414478124"; // 使用时修改App Id
    [HZVersionManager checkAppUpdateWithAppId:appId complete:^(BOOL isFindNew, id info) {
        if (isFindNew) {
            
            HLog(@"info:\n%@", info);
            // 发现新版本处理
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"发现新版本"
                                                                           message:nil
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消"
                                                                   style:UIAlertActionStyleCancel
                                                                 handler:nil];
            UIAlertAction *updateAction = [UIAlertAction actionWithTitle:@"升级"
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

/// 进入设备模块界面
- (void)_pushDeviceAction {
    [self _pushViewController:HZDeviceViewController.class];
}

/// 进入授权界面
- (void)_pushAuthorizationAction {
    [self _pushViewController:HZAauthorizationViewController.class];
}

/// 进入网络请求界面
- (void)_pushNetworkAction {
    [self _pushViewController:HZNetworkViewController.class];
}

/// ViewController 相关
- (void)_pushDetailAction {
    [self _pushViewController:HZShowDetailViewController.class];
}

/// 显示使用 Iconfont 效果
- (void)_pushIconfontAction {
    [self _pushViewController:HZShowIconfontViewController.class];
}

- (void)_pushViewController:(Class)vcClass {
    UIViewController *vc = [(UIViewController *)[vcClass alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
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
        HZShowModel *checkUpdate = [HZShowModel modelWithGroupName:@"常用工具"
                                                             title:@"校验应用版本"
                                                          subtitle:@"使用时需要修改 App id"
                                                            action:@"_checkUpdateAction"];
        
        HZShowModel *device = [HZShowModel modelWithGroupName:nil
                                                        title:@"设备相关"
                                                     subtitle:@"更多设备信息"
                                                       action:@"_pushDeviceAction"];
        
        HZShowModel *authorization = [HZShowModel modelWithGroupName:nil
                                                        title:@"应用授权"
                                                     subtitle:@"检查应用授权状态"
                                                       action:@"_pushAuthorizationAction"];
        
        HZShowModel *network = [HZShowModel modelWithGroupName:nil
                                                               title:@"网络"
                                                            subtitle:@"网络请求封装"
                                                              action:@"_pushNetworkAction"];

        NSArray *toolArray = @[checkUpdate, device, authorization, network];
        [_dataArray addObject:toolArray];
        
        // ViewController
        HZShowModel *viewController = [HZShowModel modelWithGroupName:@"ViewController"
                                                                title:@"ViewController 相关"
                                                             subtitle:@"ViewController 类别使用"
                                                               action:@"_pushDetailAction"];
        NSArray *viewControllerArray = @[viewController];
        [_dataArray addObject:viewControllerArray];
        
        // Iconfont
        HZShowModel *iconfont = [HZShowModel modelWithGroupName:@"Iconfont"
                                                          title:@"Iconfont"
                                                       subtitle:@"Iconfont 的使用"
                                                         action:@"_pushIconfontAction"];
        [_dataArray addObject:@[iconfont]];
    }
    
    return _dataArray;
}

@end
