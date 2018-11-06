//
//  UIView+HZKitCommon.m
//  HZKit
//
//  Created by HertzWang on 2018/6/12.
//  Copyright © 2018年 Hertz Wang. All rights reserved.
//

#import "UIView+HZKitCommon.h"

@implementation UIView (HZKitCommon)

#pragma mark - Rect
- (CGPoint)hz_origin {
    return self.frame.origin;
}

- (CGSize)hz_size {
    return self.bounds.size;
}

- (CGFloat)hz_x {
    return self.hz_origin.x;
}

- (CGFloat)hz_y {
    return self.hz_origin.y;
}

- (CGFloat)hz_width {
    return CGRectGetWidth(self.bounds);
}

- (CGFloat)hz_height {
    return CGRectGetHeight(self.bounds);
}

- (CGFloat)hz_minX {
    return CGRectGetMinX(self.frame);
}

- (CGFloat)hz_midX {
    return CGRectGetMidX(self.frame);
}

- (CGFloat)hz_maxX {
    return CGRectGetMaxX(self.frame);
}

- (CGFloat)hz_minY {
    return CGRectGetMinY(self.frame);
}

- (CGFloat)hz_midY {
    return CGRectGetMidY(self.frame);
}

- (CGFloat)hz_maxY {
    return CGRectGetMaxY(self.frame);
}

#pragma mark - Image
- (UIImage *)hz_generateImage {
    UIImage *image = nil;
    
    CALayer *viewLayer = self.layer;
    CGSize areaSize = self.frame.size;
    
    if ([self isKindOfClass:[UIScrollView class]]) {
        // UIScrollView and subview UICollectionView UITableView UITextView
        UIScrollView *scrollView = (UIScrollView *)[self hz_copy];
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        
        CGPoint origin = scrollView.frame.origin;
        CGSize size = scrollView.contentSize;
        CGFloat contentInsetTop = scrollView.contentInset.top;
        if (@available(iOS 11.0, *)) {
            contentInsetTop = scrollView.adjustedContentInset.top;
        }
        
        // Reset scrollView
        if (scrollView.contentOffset.y > 0) {
            CGPoint offset = CGPointZero;
            offset.y -= contentInsetTop;
            scrollView.contentOffset = offset;
        }
        
        scrollView.frame = CGRectMake(origin.x, origin.y, size.width, size.height);
        
        
        areaSize = size;
        areaSize.height -= contentInsetTop;
        
        viewLayer = scrollView.layer;
        
        // release
//        scrollView = nil;
    }
    
    // Generate image
    UIGraphicsBeginImageContextWithOptions(areaSize, NO, [[UIScreen mainScreen] scale]);
    [viewLayer renderInContext:UIGraphicsGetCurrentContext()];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

#pragma mark - Copy
- (instancetype)hz_copy {
    // 使用序列化
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self];
    return (typeof(self))[NSKeyedUnarchiver unarchiveObjectWithData:data];
}

@end
