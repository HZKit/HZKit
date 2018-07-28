//
//  HZBaseModule.h
//  HZKit
//
//  Created by HertzWang on 2018/6/12.
//  Copyright © 2018年 Hertz Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class HZBaseRouter;

extern NSString *const HZModuleNameShow;
extern NSString *const HZModuleNameAbout;
extern NSString *const HZModuleNameDevice;
extern NSString *const HZModuleNameCustomControl;

@interface HZBaseModule : NSObject

@property (nonatomic, copy, readonly) NSString *name; // 模块名称，默认为类名
@property (nonatomic, copy, readonly) NSString *groupName; // 模块组名，默认为 "common"
@property (nonatomic, strong, readonly) NSString *tabBarControllerClassName; // 显示在tabBar上的控制器类名，默认为nil
@property (nonatomic, strong, readonly) UITabBarItem *tabBarItem; // 默认为nil
@property (nonatomic, assign, readonly) BOOL hasNavigationBar; // 是否为导航栏，默认是NO
@property (nonatomic, assign, readonly) BOOL navigationBarHidden; // 是否隐藏导航栏，默认是NO
@property (nonatomic, assign, readonly) NSInteger tabBarIndex; // 显示顺序，默认为-1
@property (nonatomic, strong, readonly) HZBaseRouter *router; // 路由，用于界面切换，默认为nil

/**
 初始化后操作
 */
- (void)afterStartup;

@end
