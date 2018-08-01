//
//  HZShowIconfontCell.h
//  HZKit
//
//  Created by HertzWang on 2018/8/1.
//  Copyright © 2018年 Hertz Wang. All rights reserved.
//

#import "HZBaseCollectionViewCell.h"

@interface HZShowIconfontCell : HZBaseCollectionViewCell

- (void)setModel:(HZFontelloGlyphModel *)model;
- (void)updateIconColor:(UIColor *)color;

@end
