//
//  HZBaseRouter.h
//  HZKit
//
//  Created by HertzWang on 2018/6/12.
//  Copyright © 2018年 Hertz Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define HZ_NUM(num) @(num)

// 添加Router后需要更新
typedef NS_ENUM(NSUInteger, HZRouterType) {
    HZRouterShow = 1000,
    HZRouterAbout = 2000,
    // next router
};

@interface HZBaseRouter : NSObject

@property (nonatomic, strong) NSDictionary<NSNumber *, NSString *> *mapping;
@property (nonatomic, strong) UINavigationController *navigationController;
@property (nonatomic, strong) NSString *moduleName;
@property (nonatomic, assign) BOOL shouldPush;

- (void)show:(NSUInteger)controllerId
      fromModule:(NSString *)moduleName
        withArgs:(NSDictionary *)args
      hideTabBar:(BOOL)hideTabBar;

@end
