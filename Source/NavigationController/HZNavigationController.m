//
//  HZNavigationController.m
//  HZKit
//
//  Created by Hertz Wang on 2020/9/25.
//

#import "HZNavigationController.h"
#import "UIViewController+PopGesture.h"
#import "HZNavigationScreenshot.h"

@interface HZNavigationController () <UINavigationBarDelegate, UIGestureRecognizerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIPanGestureRecognizer *popPanGestureRecognizer;
@property (nonatomic, strong) NSMutableArray *screenshotArray; ///< 快照数组
@property (nonatomic, assign) CGFloat screenWidth;
@property (nonatomic, assign) CGFloat screenHeight;

@end

@implementation HZNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.popOffsetX = 80;
    self.screenshotArray = @[].mutableCopy;
    self.screenWidth = [[UIScreen mainScreen] bounds].size.width;
    self.screenHeight = [[UIScreen mainScreen] bounds].size.height;
    self.modalPresentationStyle = UIModalPresentationFullScreen;
    self.interactivePopGestureRecognizer.enabled = NO;
    [self.view addGestureRecognizer:self.popPanGestureRecognizer];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = (self.viewControllers.count == 1);
        [self.screenshotArray addObject:[[HZNavigationScreenshot shared] screenShot]]; // 设置并缓存快照
    }
    [super pushViewController:viewController animated:YES];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    [self.screenshotArray removeLastObject];
    [[HZNavigationScreenshot shared] updateScreenShotImage:[self.screenshotArray lastObject]];
    UIViewController *viewController = [super popViewControllerAnimated:animated];
    return viewController;
}

- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated {
    if (self.screenshotArray.count > 2) {
        [self.screenshotArray removeObjectsInRange:NSMakeRange(1, self.screenshotArray.count - 1)];
    }
    [[HZNavigationScreenshot shared] updateScreenShotImage:[self.screenshotArray lastObject]];
    return [super popToRootViewControllerAnimated:animated];
}

#pragma mark - Private

- (void)_handlePopPanGestureRecognizer:(UIPanGestureRecognizer *)panGesture {
    if (self.viewControllers.count == 1) {
        return;
    }
    UIViewController *rootVC = [[UIApplication sharedApplication] delegate].window.rootViewController;
    UIViewController *presentedVC = rootVC.presentedViewController;
    switch (panGesture.state) {
        case UIGestureRecognizerStateBegan: {
            [[HZNavigationScreenshot shared] restore];
            [[HZNavigationScreenshot shared] hidden:NO];
            [self.viewControllers.lastObject.view endEditing:YES];
            break;
        }
            
        case UIGestureRecognizerStateChanged: {
            CGFloat offsetX = [panGesture translationInView:self.view].x;
            if (offsetX >= 10) {
                offsetX -= 10; // 减去
                rootVC.view.transform = CGAffineTransformMakeTranslation(offsetX, 0);
                presentedVC.view.transform = CGAffineTransformMakeTranslation(offsetX, 0);
                [[HZNavigationScreenshot shared] showEffectChange:CGPointMake(offsetX, 0)]; // 返回效果
            }
            break;
        }
            
        case UIGestureRecognizerStateEnded: {
            CGFloat offsetX = [panGesture translationInView:self.view].x;
            if (offsetX >= self.popOffsetX) {
                [UIView animateWithDuration:0.25 animations:^{
                    rootVC.view.transform = CGAffineTransformMakeTranslation(self.screenWidth, 0);
                    presentedVC.view.transform = CGAffineTransformMakeTranslation(self.screenWidth, 0);
                    [[HZNavigationScreenshot shared] finish];
                } completion:^(BOOL finished) {
                    [self popViewControllerAnimated:NO]; // 无动画pop
                    rootVC.view.transform = CGAffineTransformIdentity;
                    presentedVC.view.transform = CGAffineTransformIdentity;
                    [[HZNavigationScreenshot shared] hidden:YES];
                }];
            } else {
                [UIView animateWithDuration:0.25 animations:^{
                    rootVC.view.transform = CGAffineTransformIdentity;
                    presentedVC.view.transform = CGAffineTransformIdentity;
                    [[HZNavigationScreenshot shared] restore];
                } completion:^(BOOL finished) {
                    [[HZNavigationScreenshot shared] hidden:YES];
                }];
            }
            break;
        }
            
        default:
            break;
    }
}

#pragma mark - Lazyload

- (UIPanGestureRecognizer *)popPanGestureRecognizer {
    if (_popPanGestureRecognizer == nil) {
        _popPanGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(_handlePopPanGestureRecognizer:)];
        _popPanGestureRecognizer.delegate = self;
    }
    return _popPanGestureRecognizer;
}

@end
