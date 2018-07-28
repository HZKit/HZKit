//
//  HZAboutModule.m
//  HZKit
//
//  Created by HertzWang on 2018/7/25.
//  Copyright © 2018年 Hertz Wang. All rights reserved.
//

#import "HZAboutModule.h"
#import "HZAboutViewController.h"

@implementation HZAboutModule

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
    return [[UITabBarItem alloc] initWithTitle:@"关于"
                                         image:[UIImage imageNamed:@"TabBarAbout"]
                                 selectedImage:[UIImage imageNamed:@"TabBarAboutSelected"]];
}

@end
