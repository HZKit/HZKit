//
//  HZShowModule.m
//  HZKit
//
//  Created by HertzWang on 2018/7/25.
//  Copyright © 2018年 Hertz Wang. All rights reserved.
//

#import "HZShowModule.h"
#import "HZShowViewController.h"

@implementation HZShowModule

- (NSString *)name {
    return HZModuleNameShow;
}

// tabBar上显示
- (NSString *)tabBarControllerClassName {
    return NSStringFromClass([HZShowViewController class]);
}

// TabBar显示位置
- (NSInteger)tabBarIndex {
    return 1;
}

// TabBarItem
- (UITabBarItem *)tabBarItem {
    return [[UITabBarItem alloc] initWithTitle:@"展示"
                                         image:[UIImage imageNamed:@"TabBarShow"]
                                 selectedImage:[UIImage imageNamed:@"TabBarShowSelected"]];
}

// 添加导航栏
- (BOOL)hasNavigationBar {
    return YES;
}

// router
- (HZBaseRouter *)router {
    return [HZShowRouter shared];
}

@end
