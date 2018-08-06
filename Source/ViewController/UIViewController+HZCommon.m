//
//  UIViewController+HZCommon.m
//  HZKit
//
//  Created by HertzWang on 2018/7/27.
//  Copyright © 2018年 Hertz Wang. All rights reserved.
//

#import "UIViewController+HZCommon.h"

@implementation UIViewController (HZCommon)

#pragma mark - Size
- (CGFloat)hz_width {
    return CGRectGetWidth(self.view.bounds);
}

- (CGFloat)hz_height {
   return CGRectGetHeight(self.view.bounds);
}

#pragma mark - Navigation
- (void)navigationBackground:(UIColor *)color {
    if (self.navigationController) {
        CGRect navigationBarFrame = self.navigationController.navigationBar.frame;
        CGRect rect = CGRectMake(0, 0, CGRectGetWidth(navigationBarFrame), CGRectGetMaxY(navigationBarFrame));
        UIGraphicsBeginImageContext(rect.size);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, color.CGColor);
        CGContextFillRect(context, rect);
        UIImage *bgImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        [self.navigationController.navigationBar setBackgroundImage:bgImage forBarMetrics:UIBarMetricsDefault];
    }
}

- (void)navigationTitleColor:(UIColor *)color {
    if (self.navigationController) {
        self.navigationController.navigationBar.tintColor = color;
    }
}

@end
