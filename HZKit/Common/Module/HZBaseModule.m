//
//  HZBaseModule.m
//  HZKit
//
//  Created by HertzWang on 2018/6/12.
//  Copyright © 2018年 Hertz Wang. All rights reserved.
//

#import "HZBaseModule.h"

NSString *const kHZDefaultGroupName = @"common";
NSString *const HZModuleNameShow = @"HZShowModule";
NSString *const HZModuleNameAbout = @"HZModuleAbout";
NSString *const HZModuleNameDevice = @"HZModuleDevice";

@implementation HZBaseModule

- (NSString *)name {
    return NSStringFromClass([self class]);
}

- (NSString *)groupName {
    return kHZDefaultGroupName;
}

- (NSString *)tabBarControllerClassName {
    return nil;
}

- (UITabBarItem *)tabBarItem {
    return nil;
}

- (BOOL)hasNavigationBar {
    return NO;
}

- (BOOL)navigationBarHidden {
    return NO;
}

- (NSInteger)tabBarIndex {
    return -1;
}

- (HZBaseRouter *)router {
    return nil;
}

- (void)afterStartup {
    
}

@end
