//
//  UIView+HZKitCommon.m
//  HZKit
//
//  Created by HertzWang on 2018/6/12.
//  Copyright © 2018年 Hertz Wang. All rights reserved.
//

#import "UIView+HZKitCommon.h"

@implementation UIView (HZKitCommon)

- (instancetype)hzCopy {
    // 使用序列化
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self];
    return (typeof(self))[NSKeyedUnarchiver unarchiveObjectWithData:data];
}

@end
