//
//  AppDelegate.m
//  HZKit
//
//  Created by HertzWang on 2018/6/11.
//  Copyright © 2018年 Hertz Wang. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "HZBaseModule.h"
#import "HZBaseViewController.h"
#import "HZBaseNavigationController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [self.window makeKeyAndVisible];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Private
- (UIViewController *)rootViewControllerWithModuleNames:(NSArray *)moduleNames {
    // 生成module
    NSMutableArray *modules = [NSMutableArray arrayWithCapacity:moduleNames.count];
    for (NSString *moduleName in moduleNames) {
        HZBaseModule *module = (HZBaseModule *)[NSClassFromString(moduleName) new];
        [modules addObject:module];
    }
    
    //
    NSMutableArray *viewControllers = [NSMutableArray array];
    NSMutableArray *indexes = [NSMutableArray array];
    
    for (HZBaseModule *module in modules) {
        NSString *tabBarClassName = module.tabBarControllerClassName;
        if (tabBarClassName) {
            Class tabBarClass = NSClassFromString(tabBarClassName);
            if (tabBarClass) {
                HZBaseViewController *baseViewController = [(HZBaseViewController *)[tabBarClass alloc] init];
                id viewController = baseViewController;
                if (module.hasNavigationBar) {
                    HZBaseNavigationController *baseNavigationController = [[HZBaseNavigationController alloc] initWithRootViewController:baseViewController];
                    baseNavigationController.navigationBarHidden = module.navigationBarHidden;
                    
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
                    }
                }
                
                if (isInserted == NO) {
                    [indexes addObject:@(currindex)];
                    [viewControllers addObject:viewController];
                }
            }
        }
    }
    
    // TODO: UITabBarControllr
    
    return [ViewController new];
}

#pragma mark - Lazy load
- (UIWindow *)window {
    if (!_window) {
        CGRect frame = [UIScreen mainScreen].bounds;
        UIWindow *keyWindow = [[UIWindow alloc] initWithFrame:frame];
        
        ViewController *rootViewController = [ViewController new];
        keyWindow.rootViewController = rootViewController;
        
        _window = keyWindow;
    }
    
    return _window;
}

@end
