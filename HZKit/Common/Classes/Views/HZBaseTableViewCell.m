//
//  HZBaseTableViewCell.m
//  HZKit
//
//  Created by HertzWang on 2018/9/29.
//  Copyright © 2018年 Hertz Wang. All rights reserved.
//

#import "HZBaseTableViewCell.h"

@implementation HZBaseTableViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView {
    
}

- (void)setModel:(HZBaseModel *)model {
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
