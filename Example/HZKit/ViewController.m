//
//  ViewController.m
//  HZKit
//
//  Created by HertzWang on 2018/6/11.
//  Copyright © 2018年 Hertz Wang. All rights reserved.
//

#import "ViewController.h"
#import "HZVersionManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [HZVersionManager checkAppUpdateWithAppId:@"414478124" complete:^(BOOL isFindNew, id info) {
        if (isFindNew) {
            // TODO: 提示升级
            if (DEBUG) {
                NSLog(@"INFO:\n%@", info);
            }
        }
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
