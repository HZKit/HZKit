//
//  HZShowModel.m
//  HZKit
//
//  Created by HertzWang on 2018/7/25.
//  Copyright © 2018年 Hertz Wang. All rights reserved.
//

#import "HZShowModel.h"

@implementation HZShowModel

+ (instancetype)modelWithGroupName:(NSString *)groupName
                             title:(NSString *)title
                          subtitle:(NSString *)subtitle {
    
    HZShowModel *model = [[HZShowModel alloc] init];
    model.groupName = groupName;
    model.title = title;
    model.subtitle = subtitle;
    
    return model;
}

@end
