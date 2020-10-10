//
//  HZShowViewController+Delegate.m
//  HZKit
//
//  Created by Wang, Haizhou on 2020/9/17.
//  Copyright © 2020 Hertz Wang. All rights reserved.
//

#import "HZShowViewController+Delegate.h"

@implementation HZShowViewController (Delegate)

#pragma mark - UITableViewDataSource

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

#pragma mark - UITableViewDelegate

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
            ((void (*)(id, SEL))objc_msgSend)(self, selector);
        }
        
        // 方式三
//        IMP imp = [self methodForSelector:selector];
//        void (*func)(id, SEL) = (void *)imp;
//        func(self, selector);
    }
    
//    [[HZMainRouter shared] pushWith:HZShowRouterDetail fromModule:HZModuleNameShow args:nil hideTabBar:YES];
}

@end
