//
//  AppDelegate.h
//  HZKit
//
//  Created by HertzWang on 2018/6/11.
//  Copyright © 2018年 Hertz Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HZBaseModule;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSArray<HZBaseModule *> *modules;

@end

