//
//  HZBaseCollectionViewCell.h
//  HZKit
//
//  Created by Hertz Wang on 2018/7/28.
//  Copyright © 2018 Hertz Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HZBaseModel;

@interface HZBaseCollectionViewCell : UICollectionViewCell

- (void)initView;
- (void)setModel:(HZBaseModel *)model;

@end
