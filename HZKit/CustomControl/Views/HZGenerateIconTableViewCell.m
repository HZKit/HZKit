//
//  HZGenerateIconTableViewCell.m
//  HZKit
//
//  Created by HertzWang on 2018/11/29.
//  Copyright © 2018 Hertz Wang. All rights reserved.
//

#import "HZGenerateIconTableViewCell.h"
#import "HZGenerateIconModel.h"

@interface HZGenerateIconTableViewCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UISlider *slider;
@property (nonatomic, assign) SEL action;

@end

@implementation HZGenerateIconTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.textLabel.textColor = [UIColor blackColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _slider = [[UISlider alloc] init];
        [self.contentView addSubview:_slider];
        
        _titleLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_titleLabel];
    }
    
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews {
    CGFloat padding = 20;
    __weak UIView *superview = self.contentView;
    [self.slider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-padding);
        make.centerY.mas_equalTo(superview.mas_centerY);
        make.width.mas_equalTo(superview.mas_width).multipliedBy(0.7);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(padding);
        make.centerY.mas_equalTo(superview.mas_centerY);
        make.width.mas_equalTo(superview.mas_width).multipliedBy(0.3);
    }];
}

- (void)setModel:(HZGenerateIconModel *)model target:(id)target {
    self.slider.minimumValue = model.minValue;
    self.slider.maximumValue = model.maxValue;
    
    if (self.action) {
        [self.slider removeTarget:self action:self.action forControlEvents:UIControlEventValueChanged];
    }
    self.action = NSSelectorFromString(model.action);
    [self.slider addTarget:target action:self.action forControlEvents:UIControlEventValueChanged];
    self.slider.tag = model.modelTag;
    
    
    self.titleLabel.text = model.title;
}

@end
