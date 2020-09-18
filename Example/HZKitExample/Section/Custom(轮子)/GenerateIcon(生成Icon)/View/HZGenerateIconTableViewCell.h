//
//  HZGenerateIconTableViewCell.h
//  HZKit
//
//  Created by HertzWang on 2018/11/29.
//  Copyright © 2018 Hertz Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HZGenerateIconModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HZGenerateIconTableViewCell : UITableViewCell

- (void)setModel:(HZGenerateIconModel *)model target:(id)target;

@end

NS_ASSUME_NONNULL_END
