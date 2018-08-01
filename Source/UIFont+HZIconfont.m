//
//  UIFont+HZIconfont.m
//  HZKit
//
//  Created by HertzWang on 2018/8/1.
//  Copyright © 2018年 Hertz Wang. All rights reserved.
//

#import "UIFont+HZIconfont.h"
#import "HZIconfont.h"

@implementation UIFont (HZIconfont)

+ (instancetype)hz_iconfontOfSize:(CGFloat)size {
    return [UIFont fontWithName:kHZIcontfontName size:size];
}

@end
