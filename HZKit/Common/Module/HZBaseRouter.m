//
//  HZBaseRouter.m
//  HZKit
//
//  Created by HertzWang on 2018/6/12.
//  Copyright © 2018年 Hertz Wang. All rights reserved.
//

#import "HZBaseRouter.h"
#import "HZBaseViewController.h"

@interface HZBaseRouter ()

@property (nonatomic, strong) NSMutableDictionary<NSString *, HZBaseRouter *> *sharedMapping;

@end

@implementation HZBaseRouter

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.shouldPush = YES;
    }
    return self;
}

+ (instancetype)shared {
    static HZBaseRouter *baseRouter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        baseRouter = [[HZBaseRouter alloc] init];
        baseRouter.sharedMapping = [NSMutableDictionary dictionary];
    });
    
    NSString *className = NSStringFromClass([self class]);
    
    if ([className isEqualToString:NSStringFromClass([HZBaseRouter class])]) {
        return baseRouter;
    } else if (baseRouter.sharedMapping[className]) {
        return baseRouter.sharedMapping[className];
    }
    
    HZBaseRouter *instance = [[NSClassFromString(className) alloc] init];
    [baseRouter.sharedMapping setObject:instance forKey:className];
    
    return instance;
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
                    UIViewController *viewController;
                    if ([ctrlClasss isKindOfClass:[HZBaseViewController class]]) {
                        viewController = [(HZBaseViewController *)[ctrlClasss alloc] initWithArgs:args];
                    } else {
                        viewController = [(UIViewController *)[ctrlClasss alloc] init];
                    }
                    
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
