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
- (void)scanViewController:(HZScanViewController *_Nonnull)scanViewController stringValue:(NSString *_Nonnull)stringValue;

@end


#pragma mark - HZScanViewController

typedef void(^HZScanViewStringValueBlock)(NSString * _Nonnull stringValue);

/**
 // TODO: 编写扫一扫Readme文档，设计和使用
 */
@interface HZScanViewController : UIViewController

@property (nonatomic, weak, nullable) id <HZScanViewControllerDelegate> delegate;
@property (nonatomic, copy) HZScanViewStringValueBlock _Nonnull stringValueBlock;

+ (instancetype _Nonnull )scanViewWithArea:(CGRect)scanArea completion:(nullable HZScanViewStringValueBlock)stringValueBlock;

// TODO: 封装使用，如：设置光柱颜色、设置角标颜色等

@end

@interface HZScanViewController (Image)

- (NSString *_Nonnull)stringValueFromImage:(UIImage *_Nonnull)image;

@end


#pragma mark - HZScanMaskView
@interface HZScanMaskView : UIView

+ (instancetype _Nonnull )maskViewWithFrame:(CGRect)frame transparentFrame:(CGRect)transparentFrame;

@end
