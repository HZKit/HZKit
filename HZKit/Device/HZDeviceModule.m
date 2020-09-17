//
//  HZDeviceModule.m
//  HZKit
//
//  Created by HertzWang on 2018/7/27.
//  Copyright © 2018年 Hertz Wang. All rights reserved.
//

#import "HZDeviceModule.h"

@implementation HZDeviceModule

- (NSString *)groupName {
    return HZModuleNameShow;
}

- (NSString *)name {
    return HZModuleNameDevice;
}

- (HZBaseRouter *)router {
    return [HZDeviceRouter shared];
}

@end
