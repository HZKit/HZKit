//
//  HZIconfont.m
//  HZKit
//
//  Created by HertzWang on 2018/8/1.
//  Copyright © 2018年 Hertz Wang. All rights reserved.
//

#import "HZIconfont.h"

@implementation HZIconfont

+ (instancetype)shared {
    static HZIconfont *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[HZIconfont alloc] init];
        instance.iconStringMapping = [NSMutableDictionary dictionary];
    });
    
    return instance;
}

+ (NSString *)iconStringWithName:(NSString *)name {
    NSString *iconString = [HZIconfont shared].iconStringMapping[name];

    return (iconString ? iconString : @"\U0000e0000");
}

@end
