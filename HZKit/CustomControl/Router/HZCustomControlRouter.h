//
//  HZCustomControlRouter.h
//  HZKit
//
//  Created by Hertz Wang on 2018/7/28.
//  Copyright © 2018 Hertz Wang. All rights reserved.
//

#import "HZBaseRouter.h"

typedef NS_ENUM(NSUInteger, HZCustomControlModuleId) {
    HZCustomControlRouterMain = HZRouterCustomControl,
    // ...
};

@interface HZCustomControlRouter : HZBaseRouter

@end
