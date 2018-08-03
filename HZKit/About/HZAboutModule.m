//
//  HZAboutModule.m
//  HZKit
//
//  Created by HertzWang on 2018/7/25.
//  Copyright © 2018年 Hertz Wang. All rights reserved.
//

#import "HZAboutModule.h"
#import "HZAboutViewController.h"
#import "HZAboutRouter.h"

@implementation HZAboutModule

- (NSString *)groupName {
    return HZModuleNameAbout;
}

- (NSString *)name {
    return HZModuleNameAbout;
}

// tabBar上显示
- (NSString *)tabBarControllerClassName {
    return NSStringFromClass([HZAboutViewController class]);
}

// TabBar显示位置
- (NSInteger)tabBarIndex {
    return 30;
}

// TabBarItem
- (UITabBarItem *)tabBarItem {
    return [[UITabBarItem alloc] initWithTitle:HZAboutLocalizedString("tabBarTitle")
                                         image:[UIImage imageNamed:@"TabBarAbout"]
                                 selectedImage:[UIImage imageNamed:@"TabBarAboutSelected"]];
}

- (BOOL)hasNavigationBar {
    return YES;
}

- (HZBaseRouter *)router {
    return [HZAboutRouter shared];
}

@end
