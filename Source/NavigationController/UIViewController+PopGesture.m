//
//  UIViewController+PopGesture.m
//  HZKit
//
//  Created by Hertz Wang on 2020/9/25.
//

#import "UIViewController+PopGesture.h"
#import <objc/runtime.h>

@implementation UIViewController (PopGesture)

- (void)setDisablePopGesture:(BOOL)disablePopGesture {
    objc_setAssociatedObject(self, @selector(disablePopGesture), @(disablePopGesture), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)disablePopGesture {
    return [objc_getAssociatedObject(self, @selector(disablePopGesture)) boolValue];
}

@end
