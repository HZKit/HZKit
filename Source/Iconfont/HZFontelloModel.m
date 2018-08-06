//
//  HZFontelloModel.m
//  HZKit
//
//  Created by HertzWang on 2018/8/1.
//  Copyright © 2018年 Hertz Wang. All rights reserved.
//

#import "HZFontelloModel.h"

NSString *kNameKey = @"name";
NSString *kPrefixTextKey = @"css_prefix_text";
NSString *kGlyphsKey = @"glyphs";

@implementation HZFontelloModel

+ (instancetype)modelWithJson:(NSString *)json {
    
    NSData *data = [json dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    
    HZFontelloModel *model = [[HZFontelloModel alloc] init];
    
    if (dict) {
        NSString *prefixText = dict[kPrefixTextKey];
        if (prefixText) {
            model.prefixText = prefixText;
        }
        
        NSMutableArray<HZFontelloGlyphModel *> *tempArray = [NSMutableArray array];
        if (dict[kGlyphsKey]) {
            NSArray *glyphs = (NSArray *)dict[kGlyphsKey];
            for (NSDictionary *glyph in glyphs) {
                HZFontelloGlyphModel *glyphModel = [HZFontelloGlyphModel modelWithJson:glyph prefixText:prefixText];
                [tempArray addObject:glyphModel];
            }
        }
        model.glyphs = [NSArray arrayWithArray:tempArray];
    }
    
    return model;
}

@end

NSString *kUIDKey = @"uid";
NSString *kCSSKey = @"css";
NSString *kCodeKey = @"code";
NSString *kSrcKey = @"src";

@implementation HZFontelloGlyphModel

- (NSString *)iconString {
    NSString *hexString = [NSString stringWithFormat:@"0x%1lx", (unsigned long)self.code];
    unichar iconChar = strtoul([hexString UTF8String], 0, 16);
    NSString *iconString = [NSString stringWithCharacters:&iconChar length:1];
    
    return iconString;
}

+ (instancetype)modelWithJson:(NSDictionary *)json prefixText:(NSString *)prefixText {
    HZFontelloGlyphModel *model = [[HZFontelloGlyphModel alloc] init];
    
    NSString *value = json[kUIDKey];
    if (value) {
        model.uid = value;
    }
    
    value = json[kCSSKey];
    if (value) {
        model.css = value;
    }
    
    value = json[kCodeKey];
    if (value) {
        model.code = [value integerValue];
    }
    
    value = json[kSrcKey];
    if (value) {
        model.src = value;
    }
    
    model.name = [NSString stringWithFormat:@"%@%@",prefixText, model.css];
    
    [[HZIconfont shared].iconStringMapping setObject:model.iconString forKey:model.name];
    
    return model;
}

@end
