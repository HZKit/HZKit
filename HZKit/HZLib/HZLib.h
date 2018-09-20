//
//  HZLib.h
//  HZKit
//
//  Created by HertzWang on 2018/9/19.
//  Copyright © 2018年 Hertz Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HZBaseModule, HZMainViewController;

NS_ASSUME_NONNULL_BEGIN

@interface HZLib : NSObject

+ (instancetype)shared;

@property (nonatomic, strong) HZMainViewController *mainViewController;

- (HZMainViewController *)mainViewControllerWithModules:(NSArray<HZBaseModule *> *)modules;

@end

FOUNDATION_EXPORT void HZLibInitRootViewControllerWithModules(NSArray<HZBaseModule *> *modules);
FOUNDATION_EXPORT void HZLibInitRootViewControllerWithModuleNames(NSArray<NSString *> *moduleNames);

NS_ASSUME_NONNULL_END
