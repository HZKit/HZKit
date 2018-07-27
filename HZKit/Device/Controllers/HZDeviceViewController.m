//
//  HZDeviceViewController.m
//  HZKit
//
//  Created by HertzWang on 2018/7/27.
//  Copyright © 2018年 Hertz Wang. All rights reserved.
//

#import "HZDeviceViewController.h"
#import "HZShowModel.h"
#import <objc/message.h>

@interface HZDeviceViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<HZShowModel *> *dataArray;

@end

@implementation HZDeviceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"功能列表";
    [self.view addSubview:self.tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action
/**
 显示设备唯一标识符
 */
- (void)showDeviceIdentifierAction {
    NSString *deviceId = [UIDevice hz_deviceUDID];
    
    [self alertTitle:@"设备标识" message:deviceId];
}

/**
 显示设备名称
 */
- (void)showDeviceNameAction {
    NSString *deviceName = [UIDevice hz_deviceGeneration];
    
    [self alertTitle:@"设备名称" message:deviceName];
}

#pragma mark - Table

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"HZShowCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    HZShowModel *model = self.dataArray[indexPath.row];
    if (model.title) {
        cell.textLabel.text = model.title;
    }
    
    if (model.subtitle) {
        cell.detailTextLabel.text = model.subtitle;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    HZShowModel *model = self.dataArray[indexPath.row];
    if (model.action) {
        
        SEL selector = NSSelectorFromString(model.action);
        
        if ([self respondsToSelector:selector]) {
            objc_msgSend(self, selector);
        }
    }
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

- (NSMutableArray<HZShowModel *> *)dataArray {
    if (!_dataArray) {
        
        HZShowModel *deviceIdentifier = [HZShowModel modelWithGroupName:@"常用工具"
                                                                  title:@"设备唯一标识符"
                                                               subtitle:@"使用 KeyChain，需要 import <Security/Security.h>"
                                                                 action:@"showDeviceIdentifierAction"];
        HZShowModel *deviceName = [HZShowModel modelWithGroupName:@"常用工具"
                                                            title:@"设备名称"
                                                         subtitle:@"需要 import <sys/utsname.h>"
                                                           action:@"showDeviceNameAction"];
        
        
        _dataArray = [NSMutableArray arrayWithObjects:deviceIdentifier, deviceName, nil];
    }
    
    return _dataArray;
}

@end