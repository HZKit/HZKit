//
//  HZAboutRouter.h
//  HZKit
//
//  Created by HertzWang on 2018/8/3.
//  Copyright © 2018年 Hertz Wang. All rights reserved.
//

#import "HZBaseRouter.h"

typedef NS_ENUM(NSUInteger, HZAboutRouterId) {
    HZAboutRouterMain = HZRouterAbout,
    HZAboutRouterSetting,
    // ...
};

@interface HZAboutRouter : HZBaseRouter

@end
