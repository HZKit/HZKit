//
//  HZAboutViewController.m
//  HZKit
//
//  Created by HertzWang on 2018/7/25.
//  Copyright © 2018年 Hertz Wang. All rights reserved.
//

#import "HZAboutViewController.h"

#import <AuthenticationServices/AuthenticationServices.h>

@interface HZAboutViewController () <ASAuthorizationControllerDelegate>

@property (nonatomic, strong) ASAuthorizationAppleIDButton *appleIDButton;

@end

@implementation HZAboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self _initView];
}

#pragma mark - Private

- (void)_initView {
    self.title = @"关于";
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    CGFloat screenWidth = self.view.bounds.size.width;
    CGFloat screenHeight = self.view.bounds.size.height;
    
    // icon
    NSDictionary *infoPlist = [[NSBundle mainBundle] infoDictionary];
    NSString *iconName = [[infoPlist valueForKeyPath:@"CFBundleIcons.CFBundlePrimaryIcon.CFBundleIconFiles"] lastObject];
    
    UIImageView *icon = [[UIImageView alloc] init];
    icon.image = [UIImage imageNamed:iconName];
    CGFloat iconWidth = icon.image.size.width;
    CGFloat iconHeight = icon.image.size.height;
    icon.frame = CGRectMake((screenWidth - iconWidth) * 0.5,
                            (screenHeight - iconHeight) * 0.5 - iconHeight,
                            iconWidth, iconHeight);
    icon.layer.cornerRadius = iconHeight * 0.5;
    icon.layer.masksToBounds = YES;
    [self.view addSubview:icon];
    
    // Version
    UILabel *version = [[UILabel alloc] init];
    version.frame = CGRectMake(0, CGRectGetMaxY(icon.frame), screenWidth, iconHeight);
    version.font = [UIFont systemFontOfSize:12];
    version.text = [NSString stringWithFormat:@"当前版本 %@", [HZVersionManager appVersion]];
    version.textAlignment = NSTextAlignmentCenter;
    version.textColor = [UIColor grayColor];
    [self.view addSubview:version];
    
    // 通过Apple登录 https://developer.apple.com/design/human-interface-guidelines/sign-in-with-apple/overview/buttons/
    if (@available(iOS 13.0, *)) {
        self.appleIDButton.frame = CGRectMake((screenWidth - 140) * 0.5, screenHeight - 60 - self.tabBarController.tabBar.bounds.size.height, 140, 30);
        [self.view addSubview:self.appleIDButton];
    }
}

/// 通过Apple登录
- (void)_appleIdSignAction API_AVAILABLE(ios(13.0)) {
    ASAuthorizationAppleIDProvider *provider = [[ASAuthorizationAppleIDProvider alloc] init];
    ASAuthorizationAppleIDRequest *request = provider.createRequest;
    request.requestedScopes = @[ASAuthorizationScopeEmail, ASAuthorizationScopeFullName];
    ASAuthorizationController *controller = [[ASAuthorizationController alloc] initWithAuthorizationRequests:@[request]];
    controller.delegate = self;
    [controller performRequests];
}

#pragma mark - ASAuthorizationControllerDelegate

- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithAuthorization:(ASAuthorization *)authorization API_AVAILABLE(ios(13.0)){
#warning 待验证
    NSString *userName = nil;
    if ([authorization.credential isKindOfClass:[ASAuthorizationAppleIDCredential class]]) {
        ASAuthorizationAppleIDCredential *credential = (ASAuthorizationAppleIDCredential *)authorization.credential;
        userName = credential.email;
    } else if ([authorization.credential isKindOfClass:[ASPasswordCredential class]]) {
        ASPasswordCredential *credential = (ASPasswordCredential *)authorization.credential;
        userName = credential.user;
    }
    self.appleIDButton.hidden = (userName != nil);
}

/// 取消
- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithError:(NSError *)error API_AVAILABLE(ios(13.0)) {
    NSLog(@"");
}

#pragma mark - Lazy load

- (ASAuthorizationAppleIDButton *)appleIDButton API_AVAILABLE(ios(13.0)) {
    if (_appleIDButton == nil) {
        _appleIDButton = [ASAuthorizationAppleIDButton buttonWithType:ASAuthorizationAppleIDButtonTypeSignIn style:ASAuthorizationAppleIDButtonStyleBlack];
        [_appleIDButton addTarget:self action:@selector(_appleIdSignAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _appleIDButton;
}

@end
