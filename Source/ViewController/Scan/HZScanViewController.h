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

extern NSString *const HZScanViewStringValueBlockKey;

typedef void(^HZScanViewStringValueBlock)(NSString *stringValue);

@interface HZScanViewController : UIViewController

@property (nonatomic, weak, nullable) id <HZScanViewControllerDelegate> delegate;
@property (nonatomic, copy) HZScanViewStringValueBlock stringValueBlock;

- (instancetype)initWithArgs:(NSDictionary *)args;

// TODO: 封装使用，如：设置扫描区域范围、设置光柱颜色、设置角标颜色等

@end

@interface HZScanViewController (Image)

- (NSString *)stringValueFromImage:(UIImage *)image;

@end


#pragma mark - HZScanMaskView
@interface HZScanMaskView : UIView

+ (instancetype)maskViewWithFrame:(CGRect)frame transparentFrame:(CGRect)transparentFrame;

@end
