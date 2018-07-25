//
//  HZBaseViewController.h
//  HZKit
//
//  Created by HertzWang on 2018/6/12.
//  Copyright © 2018年 Hertz Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *HZ_HIDDEN_TABBAR_KEY;

@interface HZBaseViewController : UIViewController

@property (nonatomic, assign) BOOL hiddenTabBar;

- (instancetype)initWithArgs:(NSDictionary *)args;

@end
