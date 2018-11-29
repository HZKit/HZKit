//
//  HZGenerateIconModel.m
//  HZKit
//
//  Created by HertzWang on 2018/11/29.
//  Copyright © 2018 Hertz Wang. All rights reserved.
//

#import "HZGenerateIconModel.h"

@implementation HZGenerateIconModel

+ (instancetype)modelWithTitle:(NSString *)title
                        action:(NSString *)action
                      minValue:(CGFloat)minValue
                      maxValue:(CGFloat)maxValue
                          tag:(HZGenerateIconModelTag)tag {
    
    HZGenerateIconModel *model = [[HZGenerateIconModel alloc] init];
    model.title = title;
    model.action = action;
    model.minValue = minValue;
    model.maxValue = maxValue;
    model.modelTag = tag;
    
    return model;
}

@end
