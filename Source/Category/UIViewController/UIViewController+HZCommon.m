//
//  UIViewController+HZCommon.m
//  HZKit
//
//  Created by HertzWang on 2018/7/27.
//  Copyright © 2018年 Hertz Wang. All rights reserved.
//

#import "UIViewController+HZCommon.h"

@implementation UIViewController (HZCommon)

#pragma mark - Navigation
- (void)hz_setNavigationBackground:(UIColor *)color {
    if (!self.navigationController) {
        return;
    }
    
    CGRect navigationBarFrame = self.navigationController.navigationBar.frame;
    CGRect rect = CGRectMake(0, 0, CGRectGetWidth(navigationBarFrame), CGRectGetMaxY(navigationBarFrame));
    
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *bgImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [self.navigationController.navigationBar setBackgroundImage:bgImage forBarMetrics:UIBarMetricsDefault];
}

- (void)hz_setNavigationTitleColor:(UIColor *)color {
    if (!self.navigationController) {
        return;
    }
    
    self.navigationController.navigationBar.tintColor = color;
}

#pragma mark - Gesture

- (void)popGestureRecognizer:(BOOL)enable {
    if (!self.navigationController) {
        return;
    }
    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = enable;
    }
}

- (void)disablePopGesture {
    if (!self.navigationController) {
        return;
    }
    
    id traget = self.navigationController.interactivePopGestureRecognizer.delegate;
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc] initWithTarget:traget action:nil];
    [self.view addGestureRecognizer:pan];
}

@end
