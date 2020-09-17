//
//  UIView+HZKitCommon.h
//  HZKit
//
//  Created by HertzWang on 2018/6/12.
//  Copyright © 2018年 Hertz Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (HZKitCommon)

#pragma mark - Rect
- (CGPoint)hz_origin;
- (CGSize)hz_size;
- (CGFloat)hz_x;
- (CGFloat)hz_y;
- (CGFloat)hz_width;
- (CGFloat)hz_height;
- (CGFloat)hz_minX;
- (CGFloat)hz_midX;
- (CGFloat)hz_maxX;
- (CGFloat)hz_minY;
- (CGFloat)hz_midY;
- (CGFloat)hz_maxY;

#pragma mark - Image
- (UIImage *)hz_generateImage; // Pending test

#pragma mark - Copy
/**
 Copy view

 @return New view
 */
- (instancetype)hz_copy;

@end
