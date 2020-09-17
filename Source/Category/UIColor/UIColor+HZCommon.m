//
//  UIColor+HZCommon.m
//  HZKit
//
//  Created by HertzWang on 2018/11/6.
//  Copyright © 2018年 Hertz Wang. All rights reserved.
//

#import "UIColor+HZCommon.h"

@implementation UIColor (HZCommon)

#pragma mark - Hex
+ (instancetype)hz_colorWithHex:(NSString *)hexString {
    return [self hz_colorWithHex:hexString alpha:1.0];
}

+ (instancetype)hz_colorWithHex:(NSString *)hexString alpha:(CGFloat)alpha {
    if (alpha < 0.0 || alpha > 1.0) {
        alpha = 1.0;
    }
    
    float red, green, blue;
    float max = 255.0f;
    NSRange range = NSMakeRange(1, 2);
    
    // red
    [[NSScanner scannerWithString:[hexString substringWithRange:range]] scanHexFloat:&red];
    // green
    range.location += range.length; // (3,2)
    [[NSScanner scannerWithString:[hexString substringWithRange:range]] scanHexFloat:&green];
    // blue
    range.location += range.length; // (5,2)
    [[NSScanner scannerWithString:[hexString substringWithRange:range]] scanHexFloat:&blue];
    
    return [UIColor colorWithRed:(red/max) green:(green/max) blue:(blue/max) alpha:alpha];
}

@end
