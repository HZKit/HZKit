//
//  HZBaseRouter.m
//  HZKit
//
//  Created by HertzWang on 2018/6/12.
//  Copyright © 2018年 Hertz Wang. All rights reserved.
//

#import "HZBaseRouter.h"
#import "HZBaseViewController.h"

@implementation HZBaseRouter

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.shouldPush = YES;
    }
    return self;
}

- (void)show:(NSUInteger)controllerId
      fromModule:(NSString *)moduleName
        withArgs:(NSDictionary *)args
      hideTabBar:(BOOL)hideTabBar  {
    
    if (self.shouldPush) {
        self.shouldPush = NO;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.shouldPush = YES;
        });
        
        if (moduleName == nil || [_moduleName compare:moduleName] == NSOrderedSame) {
            NSString *className = [self.mapping objectForKey:HZ_NUM(controllerId)];
            if (className) {
                Class ctrlClasss= NSClassFromString(className);
                if (ctrlClasss) {
                    HZBaseViewController *viewController = [(HZBaseViewController *)[ctrlClasss alloc] initWithArgs:args];
                    
                    if (hideTabBar) {
                        viewController.hidesBottomBarWhenPushed = YES;
                    }
                    
                    if (_navigationController) {
                        [_navigationController pushViewController:viewController animated:YES];
                    }
                }
            }
        }
    }
}

@end
