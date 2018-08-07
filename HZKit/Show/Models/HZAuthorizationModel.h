//
//  HZAuthorizationModel.h
//  HZKit
//
//  Created by HertzWang on 2018/8/7.
//  Copyright © 2018年 Hertz Wang. All rights reserved.
//

#import "HZBaseModel.h"

@interface HZAuthorizationModel : HZBaseModel

@property (nonatomic, assign) BOOL clicked;

+ (instancetype)modelWithTitle:(NSString *)title subtitle:(NSString *)subtitle action:(NSString *)action;

@end
