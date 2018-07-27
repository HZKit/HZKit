//
//  HZDeviceRouter.h
//  HZKit
//
//  Created by HertzWang on 2018/7/27.
//  Copyright © 2018年 Hertz Wang. All rights reserved.
//

#import "HZBaseRouter.h"

typedef NS_ENUM(NSUInteger, HZDeviceRouterId) {
    HZDeviceRouterMain = HZRouterDevice,
    // ...
};

@interface HZDeviceRouter : HZBaseRouter

@end
