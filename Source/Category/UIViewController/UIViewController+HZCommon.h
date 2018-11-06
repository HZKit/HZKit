//
//  UIViewController+HZCommon.h
//  HZKit
//
//  Created by HertzWang on 2018/7/27.
//  Copyright © 2018年 Hertz Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (HZCommon)

#pragma mark - Size

/**
 Current view width

 @return view width
 */
- (CGFloat)hz_width;

/**
 Current view height

 @return view height
 */
- (CGFloat)hz_height;

#pragma mark - Navigation
- (void)navigationBackground:(UIColor *)color;
- (void)navigationTitleColor:(UIColor *)color;

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
