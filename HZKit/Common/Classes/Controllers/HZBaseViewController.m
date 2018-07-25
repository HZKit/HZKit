//
//  HZBaseViewController.m
//  HZKit
//
//  Created by HertzWang on 2018/6/12.
//  Copyright © 2018年 Hertz Wang. All rights reserved.
//

#import "HZBaseViewController.h"

const NSString *HZ_HIDDEN_TABBAR_KEY = @"hiddenTabBar";

@interface HZBaseViewController ()

@end

@implementation HZBaseViewController

- (instancetype)initWithArgs:(NSDictionary *)args {
    self = [super init];
    if (self) {
        _hiddenTabBar = [args[HZ_HIDDEN_TABBAR_KEY] boolValue];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
