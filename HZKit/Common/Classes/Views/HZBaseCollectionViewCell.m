//
//  HZBaseCollectionViewCell.m
//  HZKit
//
//  Created by Hertz Wang on 2018/7/28.
//  Copyright © 2018 Hertz Wang. All rights reserved.
//

#import "HZBaseCollectionViewCell.h"
#import "HZBaseModel.h"

@implementation HZBaseCollectionViewCell

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

@end
