//
//  HZCustomControlModule.m
//  HZKit
//
//  Created by Hertz Wang on 2018/7/28.
//  Copyright © 2018 Hertz Wang. All rights reserved.
//

#import "HZCustomControlModule.h"
#import "HZCustomControlViewController.h"

@implementation HZCustomControlModule

- (NSString *)groupName {
    return HZModuleNameCustomControl;
}

- (NSString *)name {
    return HZModuleNameCustomControl;
}

- (NSString *)tabBarControllerClassName {
    return NSStringFromClass([HZCustomControlViewController class]);
}

- (NSInteger)tabBarIndex {
    return 20;
}

- (UITabBarItem *)tabBarItem {
    return [[UITabBarItem alloc] initWithTitle:@"轮子"
                                         image:[UIImage imageNamed:@"TabBarCustomControl"]
                                 selectedImage:[UIImage imageNamed:@"TabBarCustomControlSelected"]];
}

- (BOOL)hasNavigationBar {
    return YES;
}

- (HZBaseRouter *)router {
    return nil;
}

@end
