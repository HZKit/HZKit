//
//  HZShowModel.h
//  HZKit
//
//  Created by HertzWang on 2018/7/25.
//  Copyright © 2018年 Hertz Wang. All rights reserved.
//

#import "HZBaseModel.h"

@interface HZShowModel : HZBaseModel

@property (nonatomic, copy) NSString *groupName;

+ (instancetype)modelWithGroupName:(NSString *)groupName
                             title:(NSString *)title
                          subtitle:(NSString *)subtitle;

@end
