//
//  HZShowRouter.m
//  HZKit
//
//  Created by HertzWang on 2018/7/25.
//  Copyright © 2018年 Hertz Wang. All rights reserved.
//
//  功能说明：配置 router

#import "HZShowRouter.h"
#import "HZShowViewController.h"
#import "HZShowIconfontViewController.h"
#import "HZShowDetailViewController.h"

@implementation HZShowRouter

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.mapping = @{
                         HZ_NUM(HZShowRouterMain): NSStringFromClass([HZShowViewController class]),
                         HZ_NUM(HZShowRouterIconfont): NSStringFromClass([HZShowIconfontViewController class]),
                         HZ_NUM(HZShowRouterDetail): NSStringFromClass([HZShowDetailViewController class])
                         };
    }
    return self;
}

@end
