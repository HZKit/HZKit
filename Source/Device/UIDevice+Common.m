//
//  UIDevice+Common.m
//  HZKit
//
//  Created by Hertz Wang on 2018/6/26.
//  Copyright © 2018 Hertz Wang. All rights reserved.
//

#import "UIDevice+Common.h"
#import <Security/Security.h>

@implementation UIDevice (Common)

- (NSString *)hz_deviceIdentifier {
    NSString *deviceIdentifier = nil;
    // 1. keychina 中查询
    // TODO: 完善
    
    // 2. ADFA
    
    // 3.
    UIDevice *device = [UIDevice currentDevice];
    
    deviceIdentifier = device.identifierForVendor.UUIDString;
    
    
    return deviceIdentifier;
}

@end
