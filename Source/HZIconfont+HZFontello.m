//
//  HZIconfont+HZFontello.m
//  HZKit
//
//  Created by HertzWang on 2018/8/1.
//  Copyright © 2018年 Hertz Wang. All rights reserved.
//

#import "HZIconfont+HZFontello.h"

@implementation HZIconfont (HZFontello)

+ (NSString *)jsonWithConfigJsonName:(NSString *)name {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:name ofType:nil];
    if (filePath) {
        NSString *json = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
        if (json) {
            return json;
        }
    }
    
    
    return nil;
}

+ (HZFontelloModel *)modelWithConfigJsonName:(NSString *)name {
    NSString *json = [HZIconfont jsonWithConfigJsonName:name];
    HZFontelloModel *model = [HZFontelloModel modelWithJson:json];
    
    return model;
}

@end
