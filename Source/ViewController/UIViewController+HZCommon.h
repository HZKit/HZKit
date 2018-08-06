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

@end
