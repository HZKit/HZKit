//
//  HZAboutRouter.m
//  HZKit
//
//  Created by HertzWang on 2018/8/3.
//  Copyright © 2018年 Hertz Wang. All rights reserved.
//

#import "HZAboutRouter.h"
#import "HZAboutViewController.h"
#import "HZSettingViewController.h"

@implementation HZAboutRouter

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.mapping = @{
                         HZ_NUM(HZAboutRouterMain): NSStringFromClass([HZAboutRouter class]),
                         HZ_NUM(HZAboutRouterSetting): NSStringFromClass([HZSettingViewController class])
                         };
    }
    return self;
}

@end
