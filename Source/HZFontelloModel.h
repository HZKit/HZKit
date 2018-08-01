//
//  HZFontelloModel.h
//  HZKit
//
//  Created by HertzWang on 2018/8/1.
//  Copyright © 2018年 Hertz Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HZFontelloGlyphModel;

@interface HZFontelloModel : NSObject

@property (nonatomic, copy) NSString *prefixText;
@property (nonatomic, copy) NSArray<HZFontelloGlyphModel *> *glyphs;

+ (instancetype)modelWithJson:(NSString *)json;

@end

@interface HZFontelloGlyphModel : NSObject

@property (nonatomic, copy, readonly) NSString *iconString;

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *css;
@property (nonatomic, copy) NSString *src;
@property (nonatomic, assign) NSUInteger code;

+ (instancetype)modelWithJson:(NSDictionary *)json prefixText:(NSString *)prefixText;

@end
