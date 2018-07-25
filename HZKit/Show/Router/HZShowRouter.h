//
//  HZShowRouter.h
//  HZKit
//
//  Created by HertzWang on 2018/7/25.
//  Copyright © 2018年 Hertz Wang. All rights reserved.
//

#import "HZBaseRouter.h"

typedef NS_ENUM(NSUInteger, HZShowRouterId) {
    HZShowRouterMain = HZRouterShow,
    HZShowRouterDetail,
    // next controller
};

@interface HZShowRouter : HZBaseRouter

+ (instancetype)shared;

@end
