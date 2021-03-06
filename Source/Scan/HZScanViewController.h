//
//  HZScanViewController.h
//  HZKit
//
//  Created by HertzWang on 2018/8/10.
//  Copyright © 2018年 Hertz Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HZScanViewController;

#pragma mark - HZScanViewControllerDelegate
@protocol HZScanViewControllerDelegate <NSObject>

@optional
- (void)scanViewController:(HZScanViewController *)scanViewController stringValue:(NSString *)stringValue;

@end


#pragma mark - HZScanViewController

typedef void(^HZScanViewStringValueBlock)(NSString *stringValue);

/**
 // TODO: 编写扫一扫Readme文档，设计和使用
 */
@interface HZScanViewController : UIViewController

@property (nonatomic, weak, nullable) id <HZScanViewControllerDelegate> delegate;
@property (nonatomic, copy) HZScanViewStringValueBlock stringValueBlock;

+ (instancetype)scanViewWithArea:(CGRect)scanArea completion:(nullable HZScanViewStringValueBlock)stringValueBlock;

// TODO: 封装使用，如：设置光柱颜色、设置角标颜色等

@end

@interface HZScanViewController (Image)

- (NSString *)stringValueFromImage:(UIImage *)image;

@end


#pragma mark - HZScanMaskView
@interface HZScanMaskView : UIView

+ (instancetype)maskViewWithFrame:(CGRect)frame transparentFrame:(CGRect)transparentFrame;

@end
