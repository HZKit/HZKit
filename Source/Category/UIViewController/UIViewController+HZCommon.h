//
//  UIViewController+HZCommon.h
//  HZKit
//
//  Created by HertzWang on 2018/7/27.
//  Copyright © 2018年 Hertz Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (HZCommon)

#pragma mark - Navigation
- (void)hz_setNavigationBackground:(UIColor *)color;
- (void)hz_setNavigationTitleColor:(UIColor *)color;

#pragma mark - Gesture

/**
 Disable sliding back
 
 Invoke in viewDidAppear: or viewWillDisappear:

 @param enable YES-Available NO-Unavailable
 */
- (void)popGestureRecognizer:(BOOL)enable;

/**
 Disable sliding back, irreversible
 */
- (void)disablePopGesture;

@end
