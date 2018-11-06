//
//  UIImage+HZCommon.h
//  HZKit
//
//  Created by HertzWang on 2018/11/6.
//  Copyright © 2018年 Hertz Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 // TODO: UIImage Category 文档
 */
@interface UIImage (HZCommon)

+ (instancetype)hz_imageWithColor:(UIColor *)color; // Pending test

/**
 模糊

 @param amount 0~1
 @return image
 */
- (instancetype)hz_blurWithAmount:(CGFloat)amount; // Pending test

@end

NS_ASSUME_NONNULL_END
