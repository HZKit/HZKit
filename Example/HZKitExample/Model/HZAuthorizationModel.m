//
//  HZAuthorizationModel.m
//  HZKit
//
//  Created by HertzWang on 2018/8/7.
//  Copyright © 2018年 Hertz Wang. All rights reserved.
//

#import "HZAuthorizationModel.h"

@implementation HZAuthorizationModel

+ (instancetype)modelWithTitle:(NSString *)title subtitle:(NSString *)subtitle action:(NSString *)action {
    HZAuthorizationModel *model = [[HZAuthorizationModel alloc] init];
    model.title = title;
    model.subtitle = subtitle;
    model.action = action;
    model.clicked = NO;
    
    return model;
}

@end
