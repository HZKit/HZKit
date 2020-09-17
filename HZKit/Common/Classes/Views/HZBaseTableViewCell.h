//
//  HZBaseTableViewCell.h
//  HZKit
//
//  Created by HertzWang on 2018/9/29.
//  Copyright © 2018年 Hertz Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HZBaseModel;

NS_ASSUME_NONNULL_BEGIN

@interface HZBaseTableViewCell : UITableViewCell

- (void)initView;
- (void)setModel:(HZBaseModel *)model;

@end

NS_ASSUME_NONNULL_END
