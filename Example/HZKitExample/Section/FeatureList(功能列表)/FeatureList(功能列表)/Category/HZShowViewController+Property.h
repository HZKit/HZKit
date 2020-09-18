//
//  HZShowViewController+Property.h
//  HZKit
//
//  Created by Wang, Haizhou on 2020/9/17.
//  Copyright © 2020 Hertz Wang. All rights reserved.
//

#import "HZShowViewController.h"

#import "HZDeviceViewController.h"
#import "HZAauthorizationViewController.h"
#import "HZNetworkViewController.h"
#import "HZShowDetailViewController.h"
#import "HZShowIconfontViewController.h"
#import "HZShowModel.h"

#import <StoreKit/StoreKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HZShowViewController ()

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<NSArray<HZShowModel *> *> *dataArray;

@end

NS_ASSUME_NONNULL_END
