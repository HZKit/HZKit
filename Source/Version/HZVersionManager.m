//
//  HZVersionManager.m
//  HZKit
//
//  Created by HertzWang on 2018/6/11.
//  Copyright © 2018年 Hertz Wang. All rights reserved.
//

#import "HZVersionManager.h"

NSString *const kVersionKey = @"CFBundleShortVersionString";

NSString *(^HZVersionManagerFilePath)(NSString *appId) = ^(NSString *appId) {
    NSString *filePath = [NSString stringWithFormat:@"https://itunes.apple.com/lookup?id=%@", appId];
    return filePath;
};

@implementation HZVersionManager

+ (NSString *)appVersion {
    return [[[[NSBundle mainBundle] infoDictionary] objectForKey:kVersionKey] mutableCopy];
}

+ (void)checkAppUpdateWithAppId:(NSString *)appId complete:(HZVersionManagerBlock)block {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSString *localVersion = [HZVersionManager appVersion];
        NSString *publishVersion = nil;
        NSDictionary *info = nil;
        
        NSURL *url = [NSURL URLWithString:HZVersionManagerFilePath(appId)];
        NSData *data = [NSData dataWithContentsOfURL:url];
        if (data) {
            info = [NSJSONSerialization JSONObjectWithData:data
                                                   options:NSJSONReadingMutableContainers
                                                     error:nil];
            if (info && info[@"results"]) {
                publishVersion = info[@"results"][0][@"version"];
            }
        }
        
        if (block) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (localVersion && publishVersion && [publishVersion compare:localVersion] == NSOrderedDescending) {
                    block(YES, info);
                } else {
                    block(NO, nil);
                }
            });
        }
    });
}

@end
