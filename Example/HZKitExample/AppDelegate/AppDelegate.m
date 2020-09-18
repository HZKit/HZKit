//
//  AppDelegate.m
//  HZKit
//
//  Created by HertzWang on 2018/6/11.
//  Copyright © 2018年 Hertz Wang. All rights reserved.
//

#import "AppDelegate.h"

#import "HZShowViewController.h"
#import "HZCustomControlViewController.h"
#import "HZAboutViewController.h"

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = [self _rootViewController];
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

- (UITabBarController *)_rootViewController {
    UITabBarController *tabbar = [[UITabBarController alloc] init];
    tabbar.viewControllers = @[
        [self _viewControllerWithClass:HZShowViewController.class tabbarItemTitle:@"功能列表" image:@"TabBarShow" selectedImage:@"TabBarShowSelected"],
        [self _viewControllerWithClass:HZCustomControlViewController.class tabbarItemTitle:@"轮子" image:@"TabBarCustomControl" selectedImage:@"TabBarCustomControlSelected"],
        [self _viewControllerWithClass:HZAboutViewController.class tabbarItemTitle:@"关于" image:@"TabBarAbout" selectedImage:@"TabBarAboutSelected"]
    ];
    
    return tabbar;
}

- (UIViewController *)_viewControllerWithClass:(Class)vcClass tabbarItemTitle:(NSString *)title image:(NSString *)imageName selectedImage:(NSString *)selectedImageName {
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[(UIViewController *)[vcClass alloc] init]];
    nav.tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:[UIImage imageNamed:imageName] selectedImage:[UIImage imageNamed:selectedImageName]];
    
    return nav;
}

@end
