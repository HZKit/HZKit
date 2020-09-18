//
//  HZCustomControlModel.m
//  HZKit
//
//  Created by Hertz Wang on 2018/7/28.
//  Copyright © 2018 Hertz Wang. All rights reserved.
//

#import "HZCustomControlModel.h"

@implementation HZCustomControlModel

+ (instancetype)modelWithIcon:(NSString *)icon action:(NSString *)action {
    HZCustomControlModel *model = [[HZCustomControlModel alloc] init];
    model.icon = icon;
    model.action = action;
    
    return model;
}

@end
