//
//  HZDeviceRouter.m
//  HZKit
//
//  Created by HertzWang on 2018/7/27.
//  Copyright © 2018年 Hertz Wang. All rights reserved.
//

#import "HZDeviceRouter.h"
#import "HZDeviceViewController.h"

@implementation HZDeviceRouter

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.mapping = @{
                         HZ_NUM(HZDeviceRouterMain): NSStringFromClass([HZDeviceViewController class])
                         };
    }
    return self;
}

@end
