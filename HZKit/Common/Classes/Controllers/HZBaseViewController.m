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

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    HLog(@"%@ viewDidAppear", NSStringFromClass(self.class));
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    HLog(@"%@ viewDidDisappear", NSStringFromClass(self.class));
}

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
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Common
- (void)alertTitle:(NSString *)title message:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - Dealloc
- (void)dealloc {
    HLog(@"%@ dealloc", NSStringFromClass([self class]));
}

@end
