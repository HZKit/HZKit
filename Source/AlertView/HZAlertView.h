//
//  HZAlertView.h
//  HZKit
//
//  Created by Hertz Wang on 2018/7/29.
//  Copyright © 2018 Hertz Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HZAlertView : UIView

/**
 Touch dismiss, default NO
 */
@property (nonatomic, assign) BOOL tapDismiss;

+ (instancetype)alertWithView:(UIView *)view;

/**
 show
 */
- (void)show;

/**
 hide
 */
- (void)dismiss;

@end

#pragma mark - HZAlertWindow
@interface HZAlertWindow : UIWindow

@property (nonatomic, assign) BOOL tapDismiss;

@end
