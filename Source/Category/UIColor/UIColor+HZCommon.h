//
//  UIColor+HZCommon.h
//  HZKit
//
//  Created by HertzWang on 2018/11/6.
//  Copyright © 2018年 Hertz Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 // TODO: 编写 UIColor Category 文档
 */
@interface UIColor (HZCommon)

#pragma mark - Hex // Pending test
+ (instancetype)hz_colorWithHex:(NSString *)hexString;
+ (instancetype)hz_colorWithHex:(NSString *)hexString alpha:(CGFloat)alpha;

@end

NS_ASSUME_NONNULL_END
