//
//  HZMainRouter.m
//  HZKit
//
//  Created by HertzWang on 2018/7/25.
//  Copyright © 2018年 Hertz Wang. All rights reserved.
//

#import "HZMainRouter.h"

@implementation HZMainRouter

+ (instancetype)shared {
    
    static HZMainRouter *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[HZMainRouter alloc] init];
    });
    
    return instance;
}

- (void)pushWith:(NSUInteger)controllerId
      fromModule:(NSString *)moduleName
            args:(NSDictionary *)args
      hideTabBar:(BOOL)isHideTabBar {
    
    UINavigationController *navigationController = [_moduleMapping objectForKey:moduleName];
    if (navigationController) {
        UIViewController *selViewController = _mainViewController.selectedViewController;
        if (selViewController != navigationController) {
            [_mainViewController setSelectedViewController:navigationController];
        }
        
        HZBaseRouter *router = [_moduleRouterMapping objectForKey:moduleName];
        if (router) {
            if (router.navigationController == nil) {
                router.navigationController = navigationController;
            }
            
            [router show:controllerId fromModule:moduleName withArgs:args hideTabBar:isHideTabBar];
        }
    }
}

- (UIViewController *)currentViewController {
    UINavigationController *sel = _mainViewController.selectedViewController;
    return sel.visibleViewController;
}

@end
