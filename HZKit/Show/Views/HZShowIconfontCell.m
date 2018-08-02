//
//  HZShowIconfontCell.m
//  HZKit
//
//  Created by HertzWang on 2018/8/1.
//  Copyright © 2018年 Hertz Wang. All rights reserved.
//

#import "HZShowIconfontCell.h"

@interface HZShowIconfontCell ()

@property (nonatomic, strong) UILabel *iconLabel;

@end

@implementation HZShowIconfontCell

- (void)initView {
    
    _iconLabel = [[UILabel alloc] init];
    _iconLabel.textAlignment = NSTextAlignmentCenter;
    _iconLabel.textColor = [UIColor grayColor];
    
    [self.contentView addSubview:_iconLabel];
}

- (void)layoutSubviews {
    self.iconLabel.frame = self.bounds;
    _iconLabel.font = [UIFont hz_iconfontOfSize:(CGRectGetHeight(self.bounds) * 3 / 5)];
}

- (void)setModel:(HZFontelloGlyphModel *)model {
    self.iconLabel.text = model.iconString;
    if (model.textColor) {
        self.iconLabel.textColor = model.textColor;
    }
}

@end
