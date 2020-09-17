//
//  HZIconfont+HZFontello.h
//  HZKit
//
//  Created by HertzWang on 2018/8/1.
//  Copyright © 2018年 Hertz Wang. All rights reserved.
//

#import "HZIconfont.h"
#import "HZFontelloModel.h"

@interface HZIconfont (HZFontello)

+ (NSString *)jsonWithConfigJsonName:(NSString *)name;
+ (HZFontelloModel *)modelWithConfigJsonName:(NSString *)name;

@end
