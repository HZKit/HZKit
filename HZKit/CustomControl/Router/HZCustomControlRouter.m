//
//  HZCustomControlRouter.m
//  HZKit
//
//  Created by Hertz Wang on 2018/7/28.
//  Copyright © 2018 Hertz Wang. All rights reserved.
//

#import "HZCustomControlRouter.h"
#import "HZCustomControlViewController.h"

@implementation HZCustomControlRouter

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.mapping = @{
                         HZ_NUM(HZCustomControlRouterMain): NSStringFromClass([HZCustomControlViewController class])
                         
                         };
    }
    return self;
}

@end
