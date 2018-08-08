//
//  HZMainRouter.h
//  HZKit
//
//  Created by HertzWang on 2018/7/25.
//  Copyright © 2018年 Hertz Wang. All rights reserved.
//

#import "HZBaseRouter.h"

@class HZMainViewController;

@interface HZMainRouter : HZBaseRouter

@property (nonatomic, strong) NSDictionary *moduleMapping;
@property (nonatomic, strong) NSDictionary *moduleRouterMapping;
@property (nonatomic, weak) UITabBarController *mainViewController;

- (void)pushWith:(NSUInteger)controllerId fromModule:(NSString *)moduleName;

- (void)pushWith:(NSUInteger)controllerId
      fromModule:(NSString *)moduleName
            args:(NSDictionary *)args
      hideTabBar:(BOOL)isHideTabBar;

- (UIViewController *)currentViewController;

@end
