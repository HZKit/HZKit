//
//  HZCustomControlCell.m
//  HZKit
//
//  Created by Hertz Wang on 2018/7/28.
//  Copyright © 2018 Hertz Wang. All rights reserved.
//

#import "HZCustomControlCell.h"
#import "HZCustomControlModel.h"

@interface HZCustomControlCell ()

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation HZCustomControlCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView {
    self.backgroundColor = nil;
    self.layer.borderColor = [UIColor blackColor].CGColor;
    self.layer.borderWidth = 1;
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.textColor = [UIColor blackColor];
    _titleLabel.font = [UIFont boldSystemFontOfSize:18];
    
    [self.contentView addSubview:_titleLabel];
}

- (void)layoutSubviews {
    self.titleLabel.frame = self.bounds;
}

- (void)setModel:(HZCustomControlModel *)model {
    _model = model;
    
    self.titleLabel.text = _model.title ?: model.icon;
}

@end
