//
//  HZAboutViewController.m
//  HZKit
//
//  Created by HertzWang on 2018/7/25.
//  Copyright © 2018年 Hertz Wang. All rights reserved.
//

#import "HZAboutViewController.h"

@interface HZAboutViewController ()

@end

@implementation HZAboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initView];
}

- (void)initView {
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
    version.text = [NSString stringWithFormat:@"Version %@", [HZVersionManager appVersion]];
    version.textAlignment = NSTextAlignmentCenter;
    version.textColor = [UIColor grayColor];
    [self.view addSubview:version];
}

@end
