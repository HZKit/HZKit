//
//  HZIconfont.h
//  HZKit
//
//  Created by HertzWang on 2018/8/1.
//  Copyright © 2018年 Hertz Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kHZIcontfontName (@"fontello")

/**
 // TODO: 编写Iconfont Readme文档，包含设计和使用
 */
@interface HZIconfont : NSObject

+ (instancetype)shared;
+ (NSString *)iconStringWithName:(NSString *)name;

@property (nonatomic, strong) NSMutableDictionary *iconStringMapping;

@end
