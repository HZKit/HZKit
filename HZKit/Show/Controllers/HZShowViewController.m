//
//  HZShowViewController.m
//  HZKit
//
//  Created by HertzWang on 2018/7/25.
//  Copyright © 2018年 Hertz Wang. All rights reserved.
//

#import "HZShowViewController.h"
#import "HZShowModel.h"

@interface HZShowViewController ()<UITableViewDataSource, UITableViewDelegate>

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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    [[HZMainRouter shared] pushWith:HZShowRouterDetail fromModule:HZModuleNameShow args:nil hideTabBar:YES];
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
        
        for (int i = 0; i < 3; i++) {
            NSArray *array = @[[HZShowModel modelWithGroupName:[NSString stringWithFormat:@"第%d组", (i + 1)]
                                                         title:[NSString stringWithFormat:@"标题%d", (i + 1)]
                                                      subtitle:@"描述"]];
            [_dataArray addObject:array];
        }
    }
    
    return _dataArray;
}

@end
