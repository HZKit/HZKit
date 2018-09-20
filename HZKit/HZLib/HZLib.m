//
//  HZLib.m
//  HZKit
//
//  Created by HertzWang on 2018/9/19.
//  Copyright © 2018年 Hertz Wang. All rights reserved.
//

#import "HZLib.h"
#import "HZBaseModule.h"
#import "HZMainViewController.h"
#import "HZBaseNavigationController.h"
#import "HZBaseViewController.h"

@interface HZLib ()

@end

@implementation HZLib

+ (instancetype)shared {
    static HZLib *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[HZLib alloc] init];
    });
    
    return instance;
}

- (UIViewController *)mainViewControllerWithModules:(NSArray<HZBaseModule *> *)modules {
    
    NSMutableArray *viewControllers = [NSMutableArray array];
    NSMutableArray *indexes = [NSMutableArray array];
    NSMutableDictionary *moduleMapping = [NSMutableDictionary dictionaryWithCapacity:modules.count];
    NSMutableDictionary *moduleRouterMapping = [NSMutableDictionary dictionaryWithCapacity:modules.count];
    
    for (HZBaseModule *module in modules) {
        NSString *tabBarClassName = module.tabBarControllerClassName;
        if (tabBarClassName) {
            Class tabBarClass = NSClassFromString(tabBarClassName);
            if (tabBarClass) {
                HZBaseViewController *baseViewController = [(HZBaseViewController *)[tabBarClass alloc] init];
                UITabBarItem *tabBarItem = [module tabBarItem];
                if (tabBarItem) {
                    baseViewController.tabBarItem = tabBarItem;
                }
                
                id viewController = baseViewController;
                if (module.hasNavigationBar) {
                    HZBaseNavigationController *baseNavigationController = [[HZBaseNavigationController alloc] initWithRootViewController:baseViewController];
                    baseNavigationController.navigationBarHidden = module.navigationBarHidden;
                    [moduleMapping setObject:baseNavigationController forKey:module.name];
                    
                    viewController = baseNavigationController;
                }
                
                BOOL isInserted = NO;
                NSInteger currindex = module.tabBarIndex;
                for (int i = 0; i < indexes.count; i++) {
                    NSInteger index = [indexes[i] integerValue];
                    if (currindex < index) {
                        isInserted = YES;
                        [indexes insertObject:@(currindex) atIndex:i];
                        [viewControllers insertObject:viewController atIndex:i];
                        
                        break;
                    }
                }
                
                if (isInserted == NO) {
                    [indexes addObject:@(currindex)];
                    [viewControllers addObject:viewController];
                }
            }
        }
        
        HZBaseRouter *router = [module router];
        if (router) {
            [moduleRouterMapping setObject:router forKey:module.name];
        }
    }

    
    // 添加非 TabBar 上的模块
    for (HZBaseModule *module in modules) {
        NSString *groupName = module.groupName;
        if (groupName && [module tabBarControllerClassName] == nil) {
            id navigationController = [moduleMapping objectForKey:groupName];
            if (navigationController) {
                [moduleMapping setObject:navigationController forKey:module.name];
            }
        }
    }
    
    // MainViewController
    _mainViewController = [[HZMainViewController alloc] init];
    _mainViewController.viewControllers = viewControllers;
    
    // 设置 MainRouter
    HZMainRouter *router = [HZMainRouter shared];
    router.mainViewController = _mainViewController;
    router.moduleMapping = moduleMapping;
    router.moduleRouterMapping = moduleRouterMapping;
    
    return _mainViewController;
}

@end

void HZLibInitRootViewControllerWithModules(NSArray<HZBaseModule *> *modules) {
    
    UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    window.backgroundColor = [UIColor whiteColor];
    
    window.rootViewController = [[HZLib shared] mainViewControllerWithModules:modules];
    

    [UIApplication sharedApplication].delegate.window = window;
    [window makeKeyAndVisible];
}

void HZLibInitRootViewControllerWithModuleNames(NSArray<NSString *> *moduleNames) {
    NSMutableArray *modules = [NSMutableArray arrayWithCapacity:moduleNames.count];
    for (NSString *modelName in moduleNames) {
        HZBaseModule *module = [(HZBaseModule *)[NSClassFromString(modelName) alloc] init];
        [modules addObject:module];
    }
    
    HZLibInitRootViewControllerWithModules(modules);
}
