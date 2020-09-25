//
//  HZNavigationScreenshot.m
//  HZKit
//
//  Created by Hertz Wang on 2020/9/25.
//

#import "HZNavigationScreenshot.h"

@interface HZNavigationScreenshot ()

@property (nonatomic, strong) UIImageView *screenshotImageView;
@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, assign) CGFloat screenWidth;
@property (nonatomic, assign) CGFloat screenHeight;

@end

@implementation HZNavigationScreenshot

#pragma mark - Public

+ (instancetype)shared {
    static HZNavigationScreenshot *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[HZNavigationScreenshot alloc] init];
        instance.screenWidth = [[UIScreen mainScreen] bounds].size.width;
        instance.screenHeight = [[UIScreen mainScreen] bounds].size.height;
    });
    
    return instance;
}

- (void)showEffectChange:(CGPoint)pt {
    if (self.screenshotImageView.hidden) {
        self.screenshotImageView.hidden = NO;
    }
    if (pt.x > 0) {
        self.maskView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:(0.4 - pt.x / self.screenWidth * 0.4)];
        self.screenshotImageView.transform = CGAffineTransformMakeTranslation((pt.x - self.screenWidth) * 0.5, 0);
        self.maskView.alpha = (1.0f - pt.x / self.screenWidth);
    }
}

- (void)restore {
    if (_maskView && _screenshotImageView) {
        self.maskView.alpha = 1.0f;
        self.screenshotImageView.transform = CGAffineTransformMakeTranslation(-self.screenWidth * 0.5, 0);
    }
}

- (void)finish {
    if (_maskView && _screenshotImageView) {
        self.maskView.alpha = 0.0f;
        self.screenshotImageView.transform = CGAffineTransformMakeTranslation(0, 0);
    }
}

- (UIImage *)screenShot {
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(self.screenWidth, self.screenHeight), YES, 0);
    [[self _keyWindow].layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.screenshotImageView.image = viewImage;
    return viewImage;
}

- (void)updateScreenShotImage:(UIImage *)image {
    self.screenshotImageView.image = image;
}

- (void)hidden:(BOOL)hide {
    self.screenshotImageView.hidden = hide;
}

#pragma mark - Private

- (UIWindow * _Nullable)_keyWindow {
    UIWindow *window = nil;
    if (@available(iOS 13, *)) {
        for (UIWindowScene *windowScene in [UIApplication sharedApplication].connectedScenes) {
            if (windowScene.activationState == UISceneActivationStateForegroundActive) {
                window = windowScene.windows.firstObject;
                break;
            }
        }
    } else {
        window = [UIApplication sharedApplication].keyWindow;
    }
    return window;
}

#pragma mark - Lazyload

- (UIImageView *)screenshotImageView {
    if (_screenshotImageView == nil) {
        _screenshotImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.screenWidth, self.screenHeight)];
        _screenshotImageView.backgroundColor = [UIColor blackColor];
        UIWindow *keyWindow = [self _keyWindow];
        if (keyWindow) {
            [keyWindow insertSubview:_screenshotImageView atIndex:0];
        }
        _screenshotImageView.hidden = YES;
    }
    return _screenshotImageView;
}

- (UIView *)maskView {
    if (_maskView == nil) {
        _maskView = [[UIView alloc] initWithFrame:self.screenshotImageView.bounds];
        _maskView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        [self.screenshotImageView addSubview:_maskView];
    }
    return _maskView;
}

@end
