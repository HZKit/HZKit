//
//  HZGenerateIconModel.h
//  HZKit
//
//  Created by HertzWang on 2018/11/29.
//  Copyright © 2018 Hertz Wang. All rights reserved.
//

#import "HZBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, HZGenerateIconModelTag) {
    HZGenerateIconModelCornerRadius = 1000,
    HZGenerateIconModelBackgroundColorR,
    HZGenerateIconModelBackgroundColorG,
    HZGenerateIconModelBackgroundColorB,
    
};

@interface HZGenerateIconModel : HZBaseModel

@property (nonatomic, assign) CGFloat minValue;
@property (nonatomic, assign) CGFloat maxValue;
@property (nonatomic, assign) NSUInteger modelTag;

+ (instancetype)modelWithTitle:(NSString *)title
                        action:(NSString *)action
                      minValue:(CGFloat)minValue
                      maxValue:(CGFloat)maxValue
                          tag:(HZGenerateIconModelTag)tag;

@end

NS_ASSUME_NONNULL_END
