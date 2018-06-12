//
//  HZBaseModule.m
//  HZKit
//
//  Created by HertzWang on 2018/6/12.
//  Copyright © 2018年 Hertz Wang. All rights reserved.
//

#import "HZBaseModule.h"

NSString *const kHZDefaultGroupName = @"common";

@implementation HZBaseModule

- (NSString *)name {
    return self.description;
}

- (NSString *)groupName {
    return kHZDefaultGroupName;
}

- (NSString *)tabBarControllerClassName {
    return nil;
}

- (BOOL)hasNavigationBar {
    return YES;
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
