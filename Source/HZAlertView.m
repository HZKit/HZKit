//
//  HZAlertView.m
//  HZKit
//
//  Created by Hertz Wang on 2018/7/29.
//  Copyright © 2018 Hertz Wang. All rights reserved.
//

#import "HZAlertView.h"

@interface HZAlertView ()

@property (nonatomic, strong) HZAlertWindow *alertWindow;

@end

@implementation HZAlertView

#pragma mark - Public
+ (instancetype)alertWithView:(UIView *)view {
    HZAlertView *alert = [[HZAlertView alloc] init];
    alert.frame = view.bounds;
    [alert addSubview:view];
    
    [alert.alertWindow addSubview:alert];
    alert.center = alert.window.center;
    
    return alert;
}

- (void)setTapDismiss:(BOOL)tapDismiss {
    _tapDismiss = tapDismiss;
    self.alertWindow.tapDismiss = _tapDismiss;
}

#pragma mark - Public
- (void)show {
    [self.alertWindow makeKeyAndVisible];
}

- (void)dismiss {
    [self.alertWindow resignKeyWindow];
    
    for (UIView *subview in self.subviews) {
        [subview removeFromSuperview];
    }
    
    [self removeFromSuperview];
    
    _alertWindow = nil;
}

#pragma mark - Lazy load
- (HZAlertWindow *)alertWindow {
    if (!_alertWindow) {
        _alertWindow = [[HZAlertWindow alloc] init];
    }
    
    return _alertWindow;
}

#pragma mark - Dealloc
- (void)dealloc {
    if (_alertWindow) {
        _alertWindow.hidden = YES;
        _alertWindow = nil;
    }
}

@end

#pragma mark - HZAlertWindow
@implementation HZAlertWindow

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.frame = [UIScreen mainScreen].bounds;
        self.windowLevel = UIWindowLevelAlert;
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.35];
    }
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (_tapDismiss && event) {
        for (UIView *subview in self.subviews) {
            if ([subview isKindOfClass:[HZAlertView class]]) {
                HZAlertView *alertView = (HZAlertView *)subview;
                [alertView dismiss];
                break;
            }
        }
    } else {
        [self endEditing:YES];
    }
}

@end
